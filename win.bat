@echo off
:: ���� PowerShell �����ļ�ѡ�񴰿ڣ���������������
for /f "delims=" %%F in ('powershell -NoProfile -ExecutionPolicy Bypass -File "select-file.ps1"') do set "CSV_PATH=%%F"

:: ���û��ѡ���˳�
if "%CSV_PATH%"=="" (
    echo δѡ���ļ������Ƚ�,ֱ�Ӳ���,�밴���������
    pause
	powershell -NoProfile -ExecutionPolicy Bypass -File "FolderSnapshotTool.ps1"
	pause
	exit
)

    echo �Ա�...
	:: �� CSV ·������ ps1 �ű�
	powershell -NoProfile -ExecutionPolicy Bypass -File "FolderSnapshotTool.ps1" -Old "%CSV_PATH%"



pause

