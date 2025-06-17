# FolderSnapshotTool
用于比较磁盘目录更改的工具

很多时候，我们并不知道在操作或运行某个软件时会对磁盘进行哪些更改。这个脚本可以帮助我们记录这些情况。

# 运行环境：
当前运行于 Windows+PowerShell

# 脚本描述：
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
记录需要捕获的目录和排除的目录。注意：仅捕获目录的一级子目录

# 操作步骤：
1 SHIFT+右键执行 Powershell
2 输入 .\FolderSnapshotTool.ps1 运行
3 如果提示“无法加载文件 E:\APath_1_Info\FolderSnapshotTool.ps1，因为此系统禁止脚本运行”。则执行：
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
然后输入 Y
4 再次输入 .\FolderSnapshotTool.ps1 运行
5 比较：使用比较工具更合适。如果需要比较，请输入 .\FolderSnapshotTool.ps1 -OldFile "旧捕获文件.csv"