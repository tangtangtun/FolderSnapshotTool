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
