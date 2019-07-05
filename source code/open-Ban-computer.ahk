#SingleInstance, ignore
#NoTrayIcon
SetWorkingDir %A_ScriptDir% 

IniWrite, 1, Ban-computer.ini, intercept, start ; 写入常规启动模式
Run, Ban-computer.ahk
ExitApp