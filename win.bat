@echo off
:: 调用 PowerShell 弹出文件选择窗口，并将结果存入变量
for /f "delims=" %%F in ('powershell -NoProfile -ExecutionPolicy Bypass -File "select-file.ps1"') do set "CSV_PATH=%%F"

:: 如果没有选择，退出
if "%CSV_PATH%"=="" (
    echo 未选择文件，不比较,直接捕获,请按任意键继续
    pause
	powershell -NoProfile -ExecutionPolicy Bypass -File "FolderSnapshotTool.ps1"
	pause
	exit
)

    echo 对比...
	:: 把 CSV 路径传给 ps1 脚本
	powershell -NoProfile -ExecutionPolicy Bypass -File "FolderSnapshotTool.ps1" -Old "%CSV_PATH%"



pause

