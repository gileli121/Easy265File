#include-once
;#include <ArrayExtra.au3>



Global Const $WIN_STATE_MAXIMIZED = 32, $WIN_STATE_MINIMIZED = 16







Func GUIDisable($hGUI)
	GUISetState(@SW_DISABLE,$hGUI)
EndFunc

Func GUIEnable($hGUI)
	GUISetState(@SW_ENABLE,$hGUI)
	WinActivate($hGUI)
EndFunc


Func ByteSuffix($iBytes)
	Local $iIndex = 0
	Local Static $aArray = [' bytes', ' KB', ' MB', ' GB', ' TB', ' PB', ' EB', ' ZB', ' YB']
	While $iBytes > 1023
		$iIndex += 1
		$iBytes /= 1024
	WEnd
	Return Round($iBytes) & $aArray[$iIndex]
EndFunc   ;==>ByteSuffix

Func ReplaceEntersInString($String,$RepString = '')
	If StringInStr($String,@CRLF) Or StringInStr($String,@LF) Then
		$String = StringReplace($String,@CRLF,$RepString)
		$String = StringReplace($String,@LF,$RepString)
	EndIf
	Return $String
EndFunc


Func GetSet($Sec,$Key,$Def)
	$tmp = IniRead($ini,$Sec,$Key,$Def)
	If Not $tmp Then $tmp = $Def
	Return $tmp
EndFunc


Func GetFileNumeFromPath($sPath)
	Local $sFileName = StringSplit($sPath, '\', 1)
	Return $sFileName[$sFileName[0]]
EndFunc   ;==>GetFileNumeFromPath

Func GetDirFromFilePath($sPath)
	Return StringTrimRight($sPath,StringLen(GetFileNumeFromPath($sPath)))
EndFunc



Func RemoveFileExt($sFile)
	$tmp = GetFileExtFromStr($sFile)
	If Not $tmp Then Return $sFile
	Return StringTrimRight($sFile,StringLen($tmp)+1)
EndFunc


Func ReplaceFileExts($sFile, $sNewExt)
	Local $sFileExt = GetFileExtFromStr($sFile)
	If Not $sFileExt Then
		Return $sFile & '.' & $sNewExt
	Else
		If $sFileExt = $sNewExt Then Return $sFile
		Local $sTmp = StringTrimRight($sFile, StringLen($sFileExt))
		Return $sTmp & $sNewExt
	EndIf
EndFunc   ;==>ReplaceFileExts


Func GetFileExtFromStr($sFilePath)
	Local $aTmp = StringSplit($sFilePath, '\', 1)
	Local $sFile = $aTmp[$aTmp[0]]
	$aTmp = StringSplit($sFile, '.', 1)
	If $aTmp[0] < 2 Then Return ''
	Return $aTmp[$aTmp[0]]
EndFunc   ;==>GetFileExtFromStr


Func ReduceStringSize($sString, $iSize)
	If StringLen($sString) <= $iSize Then Return $sString
	Return '...' & StringRight($sString, $iSize)
EndFunc   ;==>ReduceStringSize



Func Sec2Time($Sec_In)
   Local $Hour, $Min, $Sec
   $Hour = Int($Sec_In / 3600)
   $Min = Int(($Sec_In - $Hour * 3600) / 60)
   $Sec = $Sec_In - $Hour * 3600 - $Min * 60
   Return StringFormat('%02d:%02d:%02d', $Hour, $Min, $Sec)
EndFunc   ;==>Sec2Time

Func TimeHMS_to_TimeS($sTimeHMS)
	$tmp = StringSplit($sTimeHMS, ':', 1)
	If $tmp[0] <> 3 Then Return SetError(1, 0, 0)
	Return ($tmp[1] * 3600) + ($tmp[2] * 60) + $tmp[3]
EndFunc   ;==>TimeHMS_to_TimeS



Func DirForseExists(ByRef $sDirPath)
	If Not FileExists($sDirPath) Then DirCreate($sDirPath)
EndFunc   ;==>DirForseExists








Func CreateIDFromString($String)
	Local Const $iHashLength = 8
	Local $ID = _WinAPI_HashString($String,True,$iHashLength)
	If @error Then Return SetError(1)
	Return StringTrimLeft($ID,2)
EndFunc




#Region GetScreenWorkArea*
	Func GetScreenWorkArea()
		Local $aOutput = GetScreenWorkArea_ByWinAPI()
		If Not @error Then Return $aOutput
		Return GetScreenWorkArea_ByGuessing()
	EndFunc

	Func GetScreenWorkArea_ByWinAPI()
		Local $tPos = _WinAPI_GetMousePos()
		If @error Then Return SetError(1)
		Local $hMonitor = _WinAPI_MonitorFromPoint($tPos)
		If @error Then Return SetError(2)
		Local $aData = _WinAPI_GetMonitorInfo($hMonitor)
		If Not IsArray($aData) Then Return SetError(3)
		Local $aOutput[2] = [DllStructGetData($aData[1], 3),DllStructGetData($aData[1], 4)]
		Return $aOutput
	EndFunc

	Func GetScreenWorkArea_ByGuessing()
		Local $aOutput[2] = [@DesktopWidth,@DesktopHeight-30]
		Return $aOutput
	EndFunc
#EndRegion



Func Arrays1DIsEqual(ByRef $aArray1, ByRef $aArray2)
	Local $aArray1_size = UBound($aArray1)-1, $aArray2_size = UBound($aArray2)-1
	If $aArray1_size <> $aArray2_size Then Return False
	For $a = 0 To $aArray1_size
		If $aArray1[$a] <> $aArray2[$a] Then Return False
	Next
	Return True
EndFunc


Func StrWriteChar($cChar, $iTimes)
	Local $sTmp
	For $a = 1 To $iTimes
		$sTmp &= $cChar
	Next
	Return $sTmp
EndFunc   ;==>StrWriteChar


Func ToolTip_Off()
	ToolTip(Null)
	AdlibUnRegister(ToolTip_Off)
EndFunc


Func TooTip_ShowMassageAboveCtrl($hGUI, $hCtrl, $sMassage, $msShowTime = 5000)
	Local $iX = Default, $iY = Default
	; Init $iX and $iY
		Local $aGUIPos = WinGetPos($hGUI) ; Get the pos of the window
		If IsArray($aGUIPos) Then
			Local $aGUIClient = WinGetClientSize($hGUI)
			If IsArray($aGUIClient) Then
				Local $aCtrlPos = ControlGetPos($hGUI,Null,$hCtrl) ; Get the pos of the control
				If IsArray($aCtrlPos) Then
					$iX = ($aGUIPos[2]-$aGUIClient[0])+$aGUIPos[0]+$aCtrlPos[0]
					$iY = ($aGUIPos[3]-$aGUIClient[1])+$aGUIPos[1]+$aCtrlPos[1]+$aCtrlPos[3]
				EndIf
			EndIf
		EndIf

	; Show the massage in tooltip
		ToolTip($sMassage,$iX,$iY)

	; Set that after $iShowTime, the tooltip will close
		AdlibRegister(ToolTip_Off,$msShowTime)


EndFunc



#Region String processing

	Func RemovePercentageMark($sNumber)
		$tmp = StringSplit($sNumber,'%',1)
		If $tmp[0] <> 2 Or $tmp[2] Then Return 0
		Return Number($tmp[1])
	EndFunc
#EndRegion


#Region String processing for console outputs

	Func Encoder_PrepareTextForConsole(ByRef $sText, $iEnters = 1, $iOffest = 0)
		If $iOffest Then $sText = StrWriteChar(' ',$iOffest*5)&$sText
		For $a = 1 To $iEnters
			$sText &= @CRLF
		Next
	EndFunc

#EndRegion


#Region ffmpeg.exe string processing

	Func ffmpeg_state_Get($sFFmpegState, $sState_key)
		$tmp = StringSplit($sFFmpegState,$sState_key,1) ; Separate the string by $sState_key
		If $tmp[0] < 2 Then Return SetError(1,0,'error') ; if the size of the array is smaller then 2 than the key is't found so we return error
		$tmp = StringSplit($tmp[2],'=',1) ; in this case, the value must be inside index 2. in index 2 we separate by the char '='
		If $tmp[0] < 2 Then Return SetError(2,0,'error') ; if the size of the array is smaller then 2 then the char '=' does not exist - shuld not happen so we return @error 2
		$tmp = StringStripWS($tmp[2],3) ; in this case, the value must be inside index 2. we create stripped version of the value.
		$tmp2 = StringSplit($tmp,' ',1) ; split by the char ' '
		If $tmp2[0] < 2 Then Return $tmp ;in this case, there is no space at all so we return the previously created stripped version of the value
		Return StringStripWS(StringTrimRight($tmp,StringLen($tmp2[$tmp2[0]])),3) ; in this case, there is spaces so we remove the last word and strip it
	EndFunc




#EndRegion


Func FilePathIsEqual($sPath1,$sPath2)
	If StringRight($sPath1,1) <> '\' Then $sPath1 &= '\'
	If StringRight($sPath2,1) <> '\' Then $sPath2 &= '\'
	If $sPath1 = $sPath2 Then Return True
	Return False
EndFunc


Func GUIGetXYtoOpenOnCenter($hPerentGUI, ByRef $xPos, ByRef $yPos, $xSize, $ySize)
	Local $aPerentPos = WinGetPos($hPerentGUI)
	If Not IsArray($aPerentPos) Then Return
	$xPos = $aPerentPos[0] + Round( $aPerentPos[2]/2 - $xSize/2 )
	$yPos = $aPerentPos[1] + Round( $aPerentPos[3]/2 - $ySize/2 )
EndFunc


