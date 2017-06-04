#include <..\[Includes]\_Circles.au3>
; ===============================================================================================================================
; <CircleGUIsExample.au3>
;
;	Example usage of _Circles.au3.  (Goofy)
;
; Author: Ascend4nt
; ===============================================================================================================================

; ==========================================================================================================================
;	- TEST -
; ==========================================================================================================================

Local $iCircles=22,$aCircles[$iCircles],$hBounceCircle,$iTimer,$iRand,$iMoveX=15,$iMoveY=10,$aPos,$aRet
For $i=0 To $iCircles-1
	$aCircles[$i]=_CircleGUICreate(Random(0,@DesktopWidth-20,1),Random(0,@DesktopHeight-20,1),Random(12,100,1),Default,Random(0x111111,0xFFFFFF,1))
	GUISetState(@SW_SHOWNOACTIVATE,$aCircles[$i])
	WinSetTrans($aCircles[$i],"",Random(50,255,1))
Next
$hBounceCircle=_CircleGUICreate(Random(0,@DesktopWidth-20,1),Random(0,@DesktopHeight-20,1),Random(12,100,1),Default,Random(0x111111,0xFFFFFF,1))
GUISetState(@SW_SHOWNOACTIVATE,$hBounceCircle)
WinSetTrans($hBounceCircle,"",Random(50,255,1))
$aPos=WinGetPos($hBounceCircle)
$iTimer=TimerInit()
While 1
	$aRet=DllCall('user32.dll',"short","GetAsyncKeyState","int",0x1B)	; Exit on 'ESC' keypress
	If @error Or BitAND($aRet[0],0x8000) Then ExitLoop					; only if in 'down' state
	Sleep(10)
	If TimerDiff($iTimer)>=500 Then
		$iRand=Random(0,$iCircles-1,1)
		WinSetOnTop($aCircles[$iRand],"",1)
		WinSetOnTop($hBounceCircle,"",1)
		WinMove($aCircles[$iRand],"",Random(0,@DesktopWidth-20,1),Random(0,@DesktopHeight-20,1),Default,Default,2)
		$iTimer=TimerInit()
	EndIf
	; Bouncing ball. (Movement only smooth until the above WinMove(), due to the delay in its movement [2])
	If ($iMoveX>0 And $aPos[0]>@DesktopWidth-$aPos[2]) Or ($iMoveX<0 And $aPos[0]+$iMoveX<0) Then $iMoveX=-$iMoveX
	If ($iMoveY>0 And $aPos[1]>@DesktopHeight-$aPos[3]) Or ($iMoveY<0 And $aPos[1]+$iMoveY<0) Then $iMoveY=-$iMoveY
	$aPos[0]+=$iMoveX
	$aPos[1]+=$iMoveY
	WinMove($hBounceCircle,"",$aPos[0],$aPos[1])
WEnd