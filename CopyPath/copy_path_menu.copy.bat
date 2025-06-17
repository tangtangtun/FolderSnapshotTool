
@echo off
set dst_dir=C:\MyService\CopyPath

if not exist "%dst_dir%" (
    mkdir "%dst_dir%"
)

copy "%~dp0param_copyto_clip.cmd" "%dst_dir%"
copy "%~dp0run_cmd.vbs" "%dst_dir%"
