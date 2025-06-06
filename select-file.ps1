Add-Type -AssemblyName System.Windows.Forms
$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.Filter = "CSV Files (*.csv)|*.csv"
if ($dialog.ShowDialog() -eq 'OK') {
    Write-Output $dialog.FileName
}
