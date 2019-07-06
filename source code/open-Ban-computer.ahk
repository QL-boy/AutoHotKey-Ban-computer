#SingleInstance, ignore
#NoTrayIcon
SetWorkingDir %A_ScriptDir% 

FileGetShortcut, C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\Ban-computer.lnk
IniWrite, %ErrorLevel%, Ban-computer.ini, intercept, AUTOBOOT ; 写入自启状态
IniWrite, 1, Ban-computer.ini, intercept, start ; 写入常规启动模式
Run, Ban-computer.ahk
ExitApp
