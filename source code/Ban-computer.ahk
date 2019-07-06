/*
变量声明:
	(%timeh%) 时数据
	(%timem%) 分数据
	(%times%) 秒数据
	(%mode%) 隔离模式
	(%timing%) 计时方法
	(%myTime%) 设定时间总
	(%ATime%) 系统时间总
	(%th%) 时迁移
	(%tm%) 分迁移
	(%ts%) 秒迁移
	(%ban%) 锁定状态
	(%ttime%) 剩余时间
	(%start%) 启动模式
	(%AUTOBOOT%) 自启状态
标签声明:
	(Button我要隔离:) 程序主要执行部分
	(ban:) 隔离锁定操作
	(free:) 隔离解锁操作
*/

Process, Priority, , High  ; 脚本运行优先级为高
#NoEnv ; 不检查空变量是否为环境变量
#NoTrayIcon ; 取消托盘图标
#SingleInstance, ignore ; 当脚本已经运行时忽略新的实例
SetBatchLines -1 ; 脚本全速运行
ListLines Off ; 在历史中略去后续执行的行
SetWorkingDir %A_ScriptDir% ; 脚本当前工作目录

IniRead, ban, Ban-computer.ini, intercept, ban, 0 ; 读取脚本完成状态
If ban = 1
{
	MsgBox, 4145, 即将隔离, 检测到上次隔离被中断，即将重启隔离, 2 ; 重启隔离提示，可以取消，但是反应时间很短
	IfMsgBox, Cancel
	{
		ExitApp
	}
	IniRead, myTime, Ban-computer.ini, intercept, myTime, 0 ; 读取未完成剩余时间
	IniRead, mode, Ban-computer.ini, intercept, mode, 0 ; 读取被中断的隔离模式
	IniWrite, 2, Ban-computer.ini, intercept, start ; 设定中断启动模式
	Goto, resumeban
}
IniRead, start, Ban-computer.ini, intercept, start, 0 
If start = 0
{
	ExitApp
}

full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}

IniRead, AUTOBOOT, Ban-computer.ini, intercept, AUTOBOOT, 0 
If AUTOBOOT = 1
{
	Loop, Files, Ban-computer.ahk
	Loop, Files, %A_LoopFileLongPath%
	FileCreateShortcut,  %A_LoopFileLongPath%, C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\Ban-computer.lnk, %A_LoopFileDir%
}

Gui, -Border +Owner
Gui Color, White

Gui Font, s15, Microsoft YaHei
Gui Add, Radio, Checked 0x1000 Vmode x15 y15 w270 h50, 强隔离模式
Gui Add, Radio, 0x1000 x15 y75 w270 h50, 弱隔离模式

Gui Add, Radio, Group Checked 0x1000 Vtiming x15 y145 w270 h50, 倒数计数方法
Gui Add, Radio, 0x1000 x15 y205 w270 h50, 预设时间方法

Gui Font, s15, Microsoft YaHei
Gui Add, DropDownList, Vtimeh x15 y265 w80 r5 hwndhcbx, 0||1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23
PostMessage, 0x153, -1, 30,, ahk_id %hcbx%
Gui Add, DropDownList, Vtimem x110 y265 w80 r5 hwndhcbx, 0||1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59
PostMessage, 0x153, -1, 30,, ahk_id %hcbx%
Gui Add, DropDownList, Vtimes x205 y265 w80 r5 hwndhcbx, 0||1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59
PostMessage, 0x153, -1, 30,, ahk_id %hcbx%

Gui Font, s15, Microsoft YaHei
Gui Add, Button, GGuiClose x15 y310 w130 h50, 我反悔了
Gui Add, Button, x155 y310 w130 h50, 我要隔离
Gui Show, w300 h375, 隔离电脑
IniWrite, 0, Ban-computer.ini, intercept, start ; 复位启动模式
Return


Button我要隔离:
	Gui, Submit ; 写入变量并隐藏程序窗口

	If timing = 1 ; 倒数计数法
	{
		timeh := % timeh*3600000
		timem := % timem*60000
		times := % times*1000
		myTime := % timeh+timem+times
	}
	Else If timing = 2 ; 预设时间法
	{
		th := % timeh*3600000
		tm := % timem*60000
		ts := % times*1000
		myTime := % th+tm+ts
		th := % A_Hour*3600000
		tm := % A_Min*60000
		ts := % A_Sec*1000
		ATime := % th+tm+ts
		If myTime > ATime
		{
			myTime := % myTime-ATime
		}
		Else If myTime < ATime
		{
			timeh := % (24-A_Hour+timeh)*3600000
			timem := % (timem-A_Min)*60000
			times := % (times-A_Sec)*1000
			myTime := % timeh+timem+times
		}
	}
	If myTime = 0
	{
		MsgBox, 你还没有设定时间！
		WinShow, 隔离电脑 ahk_class AutoHotkeyGUI ; 显示程序窗口
		Return
	}
	resumeban: ; 继续上次隔离
	ttime := myTime
	SoundSet, +1, , mute ; 静音或取消静音
	SetTimer, free, -%myTime% ; 开始计时
	IniWrite, 1, Ban-computer.ini, intercept, ban ; 设定隔离状态未完成
	IniWrite, %mode%, Ban-computer.ini, intercept, mode ; 设定隔离当前隔离模式
	If mode = 1 ; 强隔离模式
	{
		Loop
		{
			Sleep, 500
			BlockInput, On ; 禁用键鼠
			Run rundll32.exe user32.dll`,LockWorkStation ; 锁屏
			SendMessage, 0x112, 0xF170, 2,, Program Manager ; 关闭显示器
			ttime := % ttime-500
			IniWrite, %ttime%, Ban-computer.ini, intercept, myTime ; 记录次剩余时间
		}
		Until myTime = 0
		Return
	}
	Else If mode = 2 ; 弱隔离模式
	{
		BlockInput, On ; 禁用键鼠
		Run rundll32.exe user32.dll`,LockWorkStation ; 锁屏
		Return
	}
	free:
	myTime := 0
	Sleep, 1000
	BlockInput, Off ; 启用键鼠
	Send, {Volume_Mute} ; 静音或取消静音
	IniWrite, 0, Ban-computer.ini, intercept, myTime ; 剩余时间归零
	IniWrite, 0, Ban-computer.ini, intercept, ban ; 设定隔离状态已完成
	IniWrite, 0, Ban-computer.ini, intercept, mode ; 消除隔离模式
	IniRead, start, Ban-computer.ini, intercept, start, 0 ; 读取启动方式
	If start = 2
	{
		ExitApp
	}
	WinShow, 隔离电脑 ahk_class AutoHotkeyGUI ; 显示程序窗口
	Return
GuiEscape:
GuiClose:
	MsgBox, 262196, 这样不妥, 最讨厌出尔反尔的人了！再给你一次机会挽回，依然要反悔么？
	IfMsgBox, No
	{
		Return
	}
	ExitApp