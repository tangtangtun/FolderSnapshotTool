# FolderSnapshotTool
Tool for comparing disk directory changes


Many times, we don't know what changes will be made to the disk when operating or running a certain software. This script can help us record the situation.

# Running environment:
Currently running on windows+powershell

# Script description:
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
Record the directories to be captured and excluded directories. Note: only the first-level subdirectories of the directory are captured

# Operation steps:
1 SHIFT+right click to execute Powershell
2 Enter .\FolderSnapshotTool.ps1 to run
3 If it prompts that the file E:\APath_1_Info\FolderSnapshotTool.ps1 cannot be loaded because scripts are prohibited on this system. Then execute:
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Then enter Y
4 Enter .\FolderSnapshotTool.ps1 again to run
5 Compare: It is more appropriate to use a comparison tool. If you want to compare, enter .\FolderSnapshotTool.ps1 -OldFile "Old capture file.csv"


很多时候，我们不知道操作或者运行某软件，会导致磁盘改变了什么，这个脚本可以帮助我们记录状况

# 运行环境：
目前运行于windows+powershell

# 脚本说明:
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
记录了需要捕获的目录和排除目录，注意：只捕获目录的一级子目录

# 操作步骤：
1 SHIFT+右键 执行Powershell
2 输入 .\FolderSnapshotTool.ps1 运行
3 如果提示 无法加载文件 E:\APath_1_Info\FolderSnapshotTool.ps1，因为在此系统上禁止运行脚本。则执行：
	Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   然后输入 Y
4 再次输入 .\FolderSnapshotTool.ps1 运行
5 比较：用比较工具更合适。如果要比较输入 .\FolderSnapshotTool.ps1 -OldFile "旧的捕获文件.csv"