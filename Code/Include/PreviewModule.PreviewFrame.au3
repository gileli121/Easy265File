Func PrMo_Frame_Create($hPerent,$iXpos,$iYpos,$iXsize,$iYsize)
	Local $aOut[$PrMo_Frame_C_idxmax]

	$aOut[$PrMo_Frame_C_idx_hGUI] = GUICreate('',$iXsize,$iYsize,$iXpos,$iYpos,0x40000000,0,$hPerent)
	GUISetBkColor($COLOR_BLACK,$aOut[$PrMo_Frame_C_idx_hGUI])
	$aOut[$PrMo_Frame_C_idx_hTextFrame] = GUICtrlCreateLabel('Preview',$iXpos,$iYpos,$iXsize,$iYsize,$SS_CENTER+$SS_CENTERIMAGE)
	GUICtrlSetFont(-1, 30, 400, 0, "Tahoma")
	GUICtrlSetBkColor(-1,$COLOR_BLACK)
	GUICtrlSetColor(-1, $COLOR_RED)

	GUISetState(@SW_SHOW,$aOut[$PrMo_Frame_C_idx_hGUI])


	PrMo_Frame_Switch($aOut)
	Return $aOut

EndFunc
Func PrMo_Frame_Switch(ByRef $aPreviewFrame)
	$PrMo_Frame_hGUI = $aPreviewFrame[$PrMo_Frame_C_idx_hGUI]
	$PrMo_Frame_hTextFrame = $aPreviewFrame[$PrMo_Frame_C_idx_hTextFrame]
	_GDIDrawImage_InitializeGUI($PrMo_Frame_hGUI)
EndFunc
Func PrMo_Frame_SetImageFromFile($sImageFilePath)
	_GDIDrawImage_SetImageFromFile($sImageFilePath)
	$PrMo_Frame_iImageScaleFit = _GDIDrawImage_GetFitScaleFactorFromImage()
	$PrMo_Frame_iImageScale = $PrMo_Frame_iImageScaleFit
	_GDIDrawImage_DrawImage($PrMo_Frame_iImageScale)
	AdlibRegister('PrMo_Frame_HandleMovingImageEvent')
EndFunc
Func PrMo_Frame_CleanPreviewImage()
	_GDIDrawImage_UnSetImage()
	_WinAPI_InvalidateRect($PrMo_Frame_hGUI)
	AdlibUnRegister('PrMo_Frame_HandleMovingImageEvent')
EndFunc
Func PrMo_Frame_SetText($sText = '')
	GUISwitch($PrMo_Frame_hGUI)
	GUICtrlSetData($PrMo_Frame_hTextFrame,$sText)
	GUICtrlSetTip($PrMo_Frame_hTextFrame,$sText)
	GUISwitch($MainGUI_hGUI)
EndFunc
Func PrMo_Frame_HandleMovingImageEvent()

	$tmp = GUIGetCursorInfo($PrMo_Frame_hGUI)
	If $PrMo_Frame_iImageScale <= $PrMo_Frame_iImageScaleFit Or $tmp[4] <> $PrMo_Frame_hTextFrame Then Return

	;$tmp[2]

	If Not $tmp[2] Then
		If $PrMo_Frame_hmie_MouseXpos <> -1 Then
			$PrMo_Frame_hmie_MouseXpos = -1
			$PrMo_Frame_hmie_MouseYpos = -1
		EndIf

		Return
	EndIf


	If $PrMo_Frame_hmie_MouseXpos = -1 Then
		$PrMo_Frame_hmie_MouseXpos = $tmp[0]
		$PrMo_Frame_hmie_MouseYpos = $tmp[1]
		Return
	EndIf

	If $PrMo_Frame_hmie_MouseXpos = $tmp[0] Then Return


	$_gdi_Image_Xpos_iChange += $tmp[0]-$PrMo_Frame_hmie_MouseXpos
	$_gdi_Image_Ypos_iChange += $tmp[1]-$PrMo_Frame_hmie_MouseYpos

	_GDIDrawImage_ReDrawImage()

	$PrMo_Frame_hmie_MouseXpos = $tmp[0]
	$PrMo_Frame_hmie_MouseYpos = $tmp[1]


EndFunc
Func PrMo_Frame_Update()
	;PrMo_Frame_SetImageFromFile(@ScriptDir&'\test.png')
	MsgBox(0,'','')

EndFunc


;~ Func PrMo_Frame_Update_ProcessJob()
;~
;~
;~
;~ EndFunc




#cs			DISABLED CODE

Func PrMo_Frame_ReturnActive()
	Local $aOut[$PrMo_Frame_C_idxmax]
	$aOut[$PrMo_Frame_C_idx_hGUI] = $PrMo_Frame_hGUI
	$aOut[$PrMo_Frame_C_idx_hTextFrame] = $PrMo_Frame_hTextFrame
	Return $aOut
EndFunc




#ce
