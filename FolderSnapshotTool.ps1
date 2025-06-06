

param (
    [Parameter(Mandatory=$false)]
    [string]$Old = ""
)

# [object[]]$Paths = @(
	# @("C:\","Windows","Users","Program Files","Program Files (x86)","ProgramData"),
	# @("C:\Windows\",""),
	# @("C:\Program Files\",""),
	# @("C:\Program Files (x86)\",""),
	# @("C:\ProgramData\",""),
	# @(($env:USERPROFILE),"AppData"),
	# @((Join-Path $env:USERPROFILE "AppData\Local\"),""),
	# @((Join-Path $env:USERPROFILE "AppData\LocalLow\"),""),
	# @((Join-Path $env:USERPROFILE "AppData\Roaming\"),"")
# )

[object[]]$Paths = @(
	@("E:\python-proj\","ssssss"),
	@("")
)

# Write-Host (Split-Path -Path $env:USERPROFILE -Leaf)
# Write-Host (Join-Path $env:USERPROFILE "AppData\")
function Take-Snapshot {
    $results = @()

    # foreach ($base in $TargetPaths) {
	for ($i = 0; $i -lt $Paths.Count; $i++) {
		$base = $Paths[$i][0]
        if ( [string]::IsNullOrWhiteSpace($base) -or -not (Test-Path $base)) {
            Write-Warning "·��������: $base"
            continue
        }
		if ($Paths[$i].Count -gt 1) {
			$excludes = $Paths[$i][1..($Paths[$i].Count - 1)]
		} else {
			$excludes = @()  # ���ֻ��һ��Ԫ�أ��ų��б�Ϊ��
		}
		# $excludes = $ExcludeDirs[$i]
		Write-Host "��ʼ�����Ŀ¼: $base���ų��б�: $($excludes -join ', ')" -ForegroundColor Cyan
        Get-ChildItem -Path $base -Directory -Force | Where-Object {
			-not ($excludes -contains $_.Name)
		} | ForEach-Object {
			Write-Host "  ����һ����Ŀ¼: $($_.FullName)" -ForegroundColor Yellow  # B λ�ô�ӡ��Ŀ¼
            $folderPath = $_.FullName
            $files = Get-ChildItem -Path $folderPath -Recurse -Force -File -ErrorAction SilentlyContinue
            $size = ($files | Measure-Object -Property Length -Sum).Sum
            $count = $files.Count
            $lastModified = ($files | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime

            $results += [PSCustomObject]@{
                BasePath      = $base
                Folder        = $_.FullName
                SizeMB        = [Math]::Round($size / 1MB, 2)
                FileCount     = $count
                LastModified  = $lastModified
            }
        }
    }

    return $results
}

function Compare-Snapshot {
    param (
        [object[]]$NewData
    )

    $oldinfo = Import-Csv $Old | Group-Object Folder -AsHashTable -AsString
		
	$changed = @()
	$added = @()
	$removed = @()
    
    # ���������ݣ��ҳ��޸ĺ�����
    foreach ($entry in $NewData) {
        $folder = $entry.Folder
        $newSize = [double]$entry.SizeMB
        $newCount = [int]$entry.FileCount
        $newMod = $entry.LastModified

        if ($oldinfo.ContainsKey($folder)) {
            $oldEntry = $oldinfo[$folder]
            $oldSize = [double]$oldEntry.SizeMB
            $oldCount = [int]$oldEntry.FileCount

            $deltaSize = [Math]::Round($newSize - $oldSize, 2)
            $deltaCount = $newCount - $oldCount

            if ($deltaSize -ne 0 -or $deltaCount -ne 0) {
                $changed += [PSCustomObject]@{
                    Folder        = $folder
                    OldSizeMB     = $oldSize
                    SizeMB     = $newSize
                    OldFileCount  = $oldCount
                    FileCount  = $newCount
                    LastModified  = $newMod
                }
            }
            # �ѶԱȹ���Ŀ¼�Ƴ���ʣ�µľ���ɾ����
            $oldinfo.Remove($folder)
        } else {
            # ����Ŀ¼
            $added += [PSCustomObject]@{
                Folder       = $folder
                SizeMB    = $newSize
                FileCount = $newCount
                LastModified = $newMod
            }
        }
    }

    # ʣ���� $old �еľ����ѱ�ɾ����Ŀ¼
    foreach ($entry in $oldinfo.Values) {
        $removed += [PSCustomObject]@{
            Folder       = $entry.Folder
            OldSizeMB    = [double]$entry.SizeMB
            OldFileCount = [int]$entry.FileCount
        }
    }
	
	# ���շ��ذ������н���Ķ���
    return [PSCustomObject]@{
        Changed = $changed
        Added   = $added
        Removed = $removed
    }
}

# ===== Main Logic =====
Write-Host "Ŀ��·���б�"

# �����ų�Ŀ¼������
# for ($i = $ExcludeDirs.Count; $i -lt $Paths.Count; $i++) {
    # $ExcludeDirs += ,@()
# }
# $Paths | ForEach-Object { Write-Host " - $_" }
# for ($i = 0; $i -lt $ExcludeDirs.Count; $i++) {
    # Write-Host "�ų���[$i]:"
    # $ExcludeDirs[$i] | ForEach-Object {
        # Write-Host "  - $_"
    # }
# }

for ($i = 0; $i -lt $Paths.Count; $i++) {
    $line = $Paths[$i]
    # ƴ���ַ�������һ����ð�ţ����涼ֱ��ƴ��
    $result = $line[0] + " [" + ($line[1..($line.Count - 1)] -join ",") + "]"
    Write-Host $result
}

$data = Take-Snapshot

# ����ģʽ��Ĭ�ϣ�
if (-not $Old) {
	$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
	$OutFile = ".\snapshot-$timestamp.csv"

    $data | Export-Csv -Path $OutFile -NoTypeInformation -Encoding UTF8
	Write-Host ""
    Write-Host " �����ѱ��浽 $OutFile" -ForegroundColor Green
	Write-Host ""
}
else {
	Write-Host ""
    Write-Host "������ļ���$Old �Ƚ�..." -ForegroundColor Yellow
    $result = Compare-Snapshot -NewData $data
    
	# ����Ķ���
	Write-Host ""
	Write-Host ""
	Write-Host "�Ķ�����: $($result.Changed.Count)"
	$result.Changed | Format-Table -AutoSize
	Write-Host ""

	# �������Ŀ¼
	Write-Host ""
	Write-Host ""
	Write-Host "��������: $($result.Added.Count)"
	$result.Added | Format-Table -AutoSize
	Write-Host ""

	# ���ɾ����Ŀ¼
	Write-Host ""
	Write-Host ""
	Write-Host "ɾ������: $($result.Removed.Count)"
	$result.Removed | Format-Table -AutoSize
	Write-Host ""
}
