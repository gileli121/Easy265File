#include-once

#include 'PreviewModule.Frame.au3'
#include 'PreviewModule.MainGUI.au3'



Func PreviewModule_LoadSettings()

	$PrMo_ini_PreviewMode = Number(GetSet('Preview','Mode',$C_PrMo_ini_PreviewMode_def))

	Switch $PrMo_ini_PreviewMode
		Case $C_PrMo_PreviewMode_INPUT, $C_PrMo_PreviewMode_OUTPUT, $C_PrMo_PreviewMode_BOTH
			$PrMo_PreviewMode = $PrMo_ini_PreviewMode
		Case Else
			$PrMo_PreviewMode = $C_PrMo_ini_PreviewMode_def
	EndSwitch

	$PrMo_ini_PreviewTimeSlider = Number(GetSet('Preview','TimeSlider',$PrMo_ini_PreviewTimeSlider_C_def))
	$PrMo_PreviewTimeSlider = $PrMo_ini_PreviewTimeSlider

	$PrMo_ini_ProcessBefore = Number(GetSet('Preview','ProcessBefore',$PrMo_ini_ProcessBefore_C_def))
	$PrMo_ini_ProcessAfter = Number(GetSet('Preview','ProcessAfter',$PrMo_ini_ProcessAfter_C_def))

	PreviewModule_InitializeTempFolder()

EndFunc


Func PreviewModule_InitializeTempFolder()
	$PrMo_TmpFolder = $TmpFolder
	If StringRight($PrMo_TmpFolder,1) <> '\' Then $PrMo_TmpFolder &= '\'
	$PrMo_TmpFolder &= 'preview\'
EndFunc



Func PreviewModule_SaveSettings()

	If $PrMo_PreviewMode <> $PrMo_ini_PreviewMode Then IniWrite($ini,'Preview','Mode',$PrMo_PreviewMode)
	If $PrMo_PreviewTimeSlider <> $PrMo_ini_PreviewTimeSlider Then IniWrite($ini,'Preview','TimeSlider',$PrMo_PreviewTimeSlider)

	#cs
		NOTE: Some settings it will not write because they are update in other scoops
	#ce

EndFunc


Func PrMo_ADLIB_Trigger_Frame_Update()
	PrMo_Frame_Update()
	AdlibUnRegister('PrMo_ADLIB_Trigger_Frame_Update')
EndFunc
