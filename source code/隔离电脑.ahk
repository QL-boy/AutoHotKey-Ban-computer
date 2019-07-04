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
标签声明:
	(Button我要隔离:) 程序主要执行部分
*/

Process, Priority, , High  ; 脚本运行优先级为高
#NoEnv ; 不检查空变量是否为环境变量
#NoTrayIcon ; 取消托盘图标
#SingleInstance, ignore ; 当脚本已经运行时重新开启新实例
#InstallKeybdHook ; 强制安装键盘钩子
#InstallMouseHook ; 强制安装鼠标钩子
SetBatchLines -1 ; 脚本全速运行
ListLines Off ; 在历史中略去后续执行的行
SetWorkingDir %A_ScriptDir% ; 脚本当前工作目录

{
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
	Return
}

Button我要隔离:
	Send {Volume_Mute} ; 静音或取消静音
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
		}
		If myTime < ATime
		{
			timeh := % (24-A_Hour+timeh)*3600000
			timem := %
			times := %
			myTime := % timeh+timem+times
		}
	}
	If myTime = 0
	{
		MsgBox, 你还没有设定时间！
		WinShow, 隔离电脑 ahk_class AutoHotkeyGUI ; 显示程序窗口
		Return
	}
	SetTimer, ban, -%myTime% ; 开始计时
		Run rundll32.exe user32.dll`,LockWorkStation ; 启动锁屏备选方案
		SendMessage, 0x112, 0xF170, 2,, Program Manager ; 关闭显示器
		;Run, LockWorkStation.bat, , Hide, ; 隐藏启动锁屏 bat 命令
		BlockInput, On ; 禁用键鼠
	Return
ban:
	Send {Volume_Mute} ; 静音或取消静音
	WinShow, 隔离电脑 ahk_class AutoHotkeyGUI ; 显示程序窗口
	; SendMessage, 0x112, 0xF170, -1,, Program Manager ; 点亮屏幕
	BlockInput, Off ; 启用键鼠
	Return

GuiEscape:
GuiClose:
	MsgBox, 262196, 这样不妥, 最讨厌出尔反尔的人了！再给你一次机会挽回，依然要反悔么？
	IfMsgBox, No
	{
		Return
	}
	ExitApp
