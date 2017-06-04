#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 455, 249, 376, 231)
$Label1 = GUICtrlCreateLabel("Full save path:", 16, 120, 73, 17)
$Input1 = GUICtrlCreateInput("*|?", 96, 120, 329, 21)
$Label2 = GUICtrlCreateLabel("Output folder:", 32, 24, 68, 17)
$Label3 = GUICtrlCreateLabel("Preview:", 16, 144, 45, 17)
$Edit1 = GUICtrlCreateEdit("", 96, 152, 329, 57, BitOR($ES_WANTRETURN,$WS_HSCROLL,$WS_VSCROLL))
GUICtrlSetData(-1, "Edit1")
$Input2 = GUICtrlCreateInput("Input2", 112, 24, 257, 21)
$Label4 = GUICtrlCreateLabel("(Output folder = * , Common folder = | , video name = ?)", 96, 96, 281, 17)
GUICtrlSetFont(-1, 8, 400, 0, "Tahoma")
$Label5 = GUICtrlCreateLabel("Video name:", 32, 56, 63, 17)
$Input3 = GUICtrlCreateInput("Input2", 112, 56, 257, 21)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
