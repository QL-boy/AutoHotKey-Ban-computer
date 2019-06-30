/*
变量声明:
	(%timeh%) 时数据
	(%timem%) 分数据
	(%times%) 秒数据
	(%mode%) 隔离模式
	(%timing%) 计时方法
标签声明:
	(Button我要隔离:) 程序主要执行部分
*/

Process, Priority, , High  ; 脚本运行优先级为高
#NoEnv ; 不检查空变量是否为环境变量
#NoTrayIcon ; 取消托盘图标
#SingleInstance, ignore ; 当脚本已经运行时重新开启新实例
SetBatchLines -1 ; 脚本全速运行
ListLines Off ; 在历史中略去后续执行的行
SetWorkingDir %A_ScriptDir% ; 脚本当前工作目录

;GUI
{
	Gui, -Border +Owner 
	Gui Color, White

	Gui Font, s15, Microsoft YaHei
	Gui Add, Radio, Checked 0x1000 Vmode x15 y15 w270 h50, 强隔离模式
	Gui Add, Radio, 0x1000 x15 y75 w270 h50, 弱隔离模式

	Gui Add, Radio, Group Checked 0x1000 Vtiming x15 y145 w270 h50, 倒数计数方法
	Gui Add, Radio, 0x1000 x15 y205 w270 h50, 预设时间方法

	Gui Font, s15, Microsoft YaHei
	Gui Add, ComboBox, Vtimeh x15 y265 w80 r5 hwndhcbx, 0||1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23
	PostMessage, 0x153, -1, 30,, ahk_id %hcbx%
	Gui Add, ComboBox, Vtimem x110 y265 w80 r5 hwndhcbx, 0||1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59
	PostMessage, 0x153, -1, 30,, ahk_id %hcbx%
	Gui Add, ComboBox, Vtimes x205 y265 w80 r5 hwndhcbx, 0||1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59
	PostMessage, 0x153, -1, 30,, ahk_id %hcbx%

	Gui Font, s15, Microsoft YaHei

	Gui Add, Button, GGuiClose x15 y310 w130 h50, 我反悔了
	Gui Add, Button, x155 y310 w130 h50, 我要隔离
	Gui Show, w300 h375, 隔离电脑

	Return
}

Button我要隔离:
	Gui, Submit
	Loop,20
	{
		;Run rundll32.exe user32.dll`,LockWorkStation
		SendMessage, 0x112, 0xF170, 2,, Program Manager
		Run, LockWorkStation.bat, , Hide,
		BlockInput, On
		Sleep, 100
	}
	SendMessage, 0x112, 0xF170, -1,, Program Manager
	BlockInput, Off
	Return

GuiEscape:
GuiClose:
	MsgBox, 262196, 这样不妥, 最讨厌出尔反尔的人了！再给你一次机会挽回，依然要反悔么？
	IfMsgBox, No
	{
		Return
	}
	ExitApp
/*
~LButton::
	IfWinActive, 隔离电脑 ahk_class AutoHotkeyGUI
	{
		MsgBox, 123
	}
*/
Return

gui, add, button, , 一个按钮
gui, show
