

param (
    [Parameter(Mandatory=$false)]
    [string]$OldFile = ""
)

[object[]]$Paths = @(
	@("C:\","Windows","Users","Program Files","Program Files (x86)","ProgramData"),
	@("C:\Windows\",""),
	@("C:\Program Files\",""),
	@("C:\Program Files (x86)\",""),
	@("C:\ProgramData\",""),
	@(($env:USERPROFILE),"AppData"),
	@((Join-Path $env:USERPROFILE "AppData\Local\"),""),
	@((Join-Path $env:USERPROFILE "AppData\LocalLow\"),""),
	@((Join-Path $env:USERPROFILE "AppData\Roaming\"),"")
)
# Write-Host (Split-Path -Path $env:USERPROFILE -Leaf)
# Write-Host (Join-Path $env:USERPROFILE "AppData\")
function Take-Snapshot {
    $results = @()

    # foreach ($base in $TargetPaths) {
	for ($i = 0; $i -lt $Paths.Count; $i++) {
		$base = $Paths[$i][0]
        if (-not (Test-Path $base)) {
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

    $old = Import-Csv $OldFile | Group-Object Folder -AsHashTable -AsString
    $result = @()

    foreach ($entry in $NewData) {
        $folder = $entry.Folder
        $newSize = [double]$entry.SizeMB
        $newCount = [int]$entry.FileCount
        $newMod = $entry.LastModified

        if ($old.ContainsKey($folder)) {
            $oldEntry = $old[$folder]
            $oldSize = [double]$oldEntry.SizeMB
            $oldCount = [int]$oldEntry.FileCount

            $deltaSize = [Math]::Round($newSize - $oldSize, 2)
            $deltaCount = $newCount - $oldCount

            if ($deltaSize -ne 0 -or $deltaCount -ne 0) {
                $result += [PSCustomObject]@{
                    Folder        = $folder
                    OldSizeMB     = $oldSize
                    NewSizeMB     = $newSize
                    DeltaMB       = $deltaSize
                    OldFileCount  = $oldCount
                    NewFileCount  = $newCount
                    DeltaFiles    = $deltaCount
                    LastModified  = $newMod
                }
            }
        }
    }

    return $result
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
if (-not $OldFile) {
	$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
	$OutFile = ".\snapshot-$timestamp.csv"

    $data | Export-Csv -Path $OutFile -NoTypeInformation -Encoding UTF8
    Write-Host "? �����ѱ��浽 $OutFile" -ForegroundColor Green
}
else {
    Write-Host "?? ���ڱȽϿ����ļ���$Snapshot ..." -ForegroundColor Yellow
    $diff = Compare-Snapshot -NewData $data
    if ($diff.Count -eq 0) {
        Write-Host "? û�з��ֱ䶯��" -ForegroundColor Green
    }
    else {
        $diff | Sort-Object DeltaMB -Descending | Format-Table -AutoSize
    }
}
