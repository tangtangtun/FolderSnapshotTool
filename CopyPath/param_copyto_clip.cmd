@echo off
setlocal enabledelayedexpansion
set arg=%~1
set arg=!arg:\=/!
powershell -command "Set-Clipboard -Value '!arg!'"
