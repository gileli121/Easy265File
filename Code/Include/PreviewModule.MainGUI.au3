


#cs
		Global $FFCommand
		Global $PreviewSettings_

		Global $OutContainer
		Global $OutFolderPath
		Global $InVideoFilePath
		Global $FileName_In
		Global $FileName_Out

		Global $VideoDuration_s
		Global $VideoDuration_hms


#ce






#cs
Func PreviewModule_MainGUI_Create_old($hPerentGUI,$width,$height,$left,$top)

	$PrMo_MainGUI_hPerentGUI = $hPerentGUI


	;_GDIDrawImage_InitializeGUI($MainGUI_hGUI)





	PrMo_MainGUI_CreateControls(True,$width,$height,$left,$top)


	GUISwitch($hPerentGUI)


EndFunc
#ce





Func PreviewModule_MainGUI_Create($xSize,$ySize,$xPos,$yPos,$hPerentGUI = Null)


	;Local Const $C_PControllerHeight = 30

	Local Const $C_FullScreenButton_ySize = 24, $C_FullScreenButton_yRoom = 26, $C_FullScreenButton_ySpace = 1


	Local $GuiYsize = $ySize-$C_FullScreenButton_yRoom
	Local $FullScreenButton_yPos = $yPos+$GuiYsize+$C_FullScreenButton_ySpace



	If $hPerentGUI Then

		$PrMo_MainGUI_hPerentGUI = $hPerentGUI

		$PrMo_MainGUI_hGUI = GUICreate('',$xSize, $GuiYsize, $xPos, $yPos, $WS_CHILD, $WS_EX_CLIENTEDGE, $hPerentGUI)
		;GUISetBkColor($COLOR_RED)
		WinMove($PrMo_MainGUI_hGUI,'',$xPos, $yPos,$xSize, $GuiYsize)
		$tmp = WinGetClientSize($PrMo_MainGUI_hGUI)
		If IsArray($tmp) Then
			$xSize = $tmp[0]
			$GuiYsize = $tmp[1]
		EndIf

		GUISetState(@SW_SHOW)

		PreviewModule_MainGUI_Create_DrawCtrlsInChildGUI(True,$xSize,$GuiYsize)




		GUISwitch($PrMo_MainGUI_hPerentGUI)

		$PrMo_MainGUI_FullScreenButton = GUICtrlCreateButton('Open Image',$xPos,$FullScreenButton_yPos,$xSize,$C_FullScreenButton_ySize)
		GUICtrlSetResizing(-1,$GUI_DOCKALL)
		GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")



	Else

		WinMove($PrMo_MainGUI_hGUI,'',$xPos,$yPos,$xSize,$GuiYsize)
		$tmp = WinGetClientSize($PrMo_MainGUI_hGUI)
		If IsArray($tmp) Then
			$xSize = $tmp[0]
			$GuiYsize = $tmp[1]
		EndIf

		PreviewModule_MainGUI_Create_DrawCtrlsInChildGUI(False,$xSize,$GuiYsize)

		GUISwitch($PrMo_MainGUI_hPerentGUI)
		GUICtrlSetPos($PrMo_MainGUI_FullScreenButton,$xPos,$FullScreenButton_yPos,$xSize,$C_FullScreenButton_ySize)






	EndIf



EndFunc


Func PreviewModule_MainGUI_Create_DrawCtrlsInChildGUI($bDraw,$xSize,$ySize)

	Local Const $C_FrameBorderSize = 6



	Local Const $C_LowerArea_ySize = 26

	; Show-mode combo
	Local Const $C_ShowModeCombo_xSize = 60
	Local Const $C_ShowModeCombo_ySize = 25



	; Time Slider
	Local $TimeSlider_xSize = $xSize-$C_ShowModeCombo_xSize
	Local Const $C_TimeSlider_ySize = $C_LowerArea_ySize
	Local $TimeSlider_yPos = $ySize-$C_TimeSlider_ySize

	; Show-mode combo
	Local $ShowModeCombo_yPos = $TimeSlider_yPos+2



	; Preview frame
	Local Const $C_Frame_xPos = $C_FrameBorderSize/2
	Local Const $C_Frame_yPos = $C_FrameBorderSize/2
	Local $Frame_xSize = $xSize-$C_FrameBorderSize
	Local $Frame_ySize = $ySize-$C_FrameBorderSize-$C_LowerArea_ySize




	If $bDraw Then

		; Time Slider
		$PrMo_MainGUI_Slider = GUICtrlCreateSlider(0, $TimeSlider_yPos, $TimeSlider_xSize, $C_TimeSlider_ySize, BitOR($GUI_SS_DEFAULT_SLIDER,$TBS_BOTH,$TBS_NOTICKS))
		GUICtrlSetLimit(-1,$PrMo_GUI_C_SliderMaxValue,0)
		GUICtrlSetData(-1,$PrMo_PreviewTimeSlider) ;
		GUICtrlSetResizing(-1,$GUI_DOCKALL)

		; Show-mode combo
		$PrMo_MainGUI_ShowModeCombo = GUICtrlCreateCombo('', $TimeSlider_xSize, $ShowModeCombo_yPos,$C_ShowModeCombo_xSize,$C_ShowModeCombo_ySize,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1,$C_PrMo_MainGUI_ShowModeCombo_OptionListText)
		Switch $PrMo_PreviewMode
			Case $C_PrMo_PreviewMode_INPUT
				$PrMo_MainGUI_ShowModeCombo_ActiveText = $C_PrMo_MainGUI_ShowModeCombo_InputText
			Case $C_PrMo_PreviewMode_OUTPUT
				$PrMo_MainGUI_ShowModeCombo_ActiveText = $C_PrMo_MainGUI_ShowModeCombo_OutputText
			Case $C_PrMo_PreviewMode_BOTH
				$PrMo_MainGUI_ShowModeCombo_ActiveText = $C_PrMo_MainGUI_ShowModeCombo_BothText
		EndSwitch
		GUICtrlSetData(-1,$PrMo_MainGUI_ShowModeCombo_ActiveText)
		GUICtrlSetResizing(-1,$GUI_DOCKALL)


		PrMo_Frame_Create($PrMo_MainGUI_hGUI,$C_Frame_xPos,$C_Frame_yPos,$Frame_xSize,$Frame_ySize)

	Else

		GUICtrlSetPos($PrMo_MainGUI_Slider,0, $TimeSlider_yPos, $TimeSlider_xSize, $C_TimeSlider_ySize)

		GUICtrlSetPos($PrMo_MainGUI_ShowModeCombo,$TimeSlider_xSize, $ShowModeCombo_yPos,$C_ShowModeCombo_xSize,$C_ShowModeCombo_ySize)

		PrMo_Frame_RePos($C_Frame_xPos,$C_Frame_yPos,$Frame_xSize,$Frame_ySize)




	EndIf







EndFunc


#cs
Func PrMo_MainGUI_CreateControls_old()


	GUISwitch($PrMo_MainGUI_hGUI)

	PrMo_MainGUI_UpdateWindowSize()



	Local $iW, $iH

	; Create the preview frame
	$iW = $PrMo_MainGUI_width-$PrMo_MainGUI_CPrMo_FrameBorderSize
	$iH = $PrMo_MainGUI_height-$PrMo_MainGUI_CPrMo_FrameBorderSize-$PrMo_MainGUI_C_PControllerHeight

	$tmp = $PrMo_MainGUI_CPrMo_FrameBorderSize/2
	PrMo_Frame_Create($PrMo_MainGUI_hGUI,$tmp,$tmp,$iW,$iH)
	GUISwitch($PrMo_MainGUI_hGUI)



	; Create the video time slider
	$PrMo_MainGUI_Slider = GUICtrlCreateSlider(0, _ ; Left
	$PrMo_MainGUI_height-$PrMo_MainGUI_C_PController_SliderHeight, _ ; Top
	$PrMo_MainGUI_width-$PrMo_MainGUI_C_PController_PreviewMode_ComboWidth, _ ; Width
	$PrMo_MainGUI_C_PController_SliderHeight, _ ; Height
	BitOR($GUI_SS_DEFAULT_SLIDER,$TBS_BOTH,$TBS_NOTICKS)) ; Style
	GUICtrlSetLimit(-1,$PrMo_GUI_C_SliderMaxValue,0)
	GUICtrlSetData(-1,$PrMo_PreviewTimeSlider)
	GUICtrlSetResizing(-1,$GUI_DOCKALL)




	; Create the show-mode combo
	$PrMo_MainGUI_ShowModeCombo = GUICtrlCreateCombo("", _ ; Text
	$PrMo_MainGUI_width-$PrMo_MainGUI_C_PController_PreviewMode_ComboWidth, _ ; Left
	$PrMo_MainGUI_height-$PrMo_MainGUI_C_PController_SliderHeight, _ ; Top
	$PrMo_MainGUI_C_PController_PreviewMode_ComboWidth, _ ; Width
	$PrMo_MainGUI_C_PController_PreviewMode_ComboHeight, _ ; Height
	BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL)) ; Style
	GUICtrlSetData(-1,'Input|Output|Both')
	GUICtrlSetData(-1,$PrMo_PreviewMode)



	GUICtrlSetResizing(-1,$GUI_DOCKALL)



	GUISwitch($MainGUI_hGUI)

EndFunc
#ce


Func PrMo_MainGUI_ProcessLoop()
	;GUISwitch($PrMo_MainGUI_hGUI) ; Switch to the preview sub window

	; Check if the user chaged the preview mode
	$tmp = GUICtrlRead($PrMo_MainGUI_ShowModeCombo)

	If $tmp <> $PrMo_MainGUI_ShowModeCombo_ActiveText Then ; the preview mode changed


		; Remember the change
			$PrMo_MainGUI_ShowModeCombo_ActiveText = $tmp


		; Update $PrMo_PreviewMode according to the change
			Switch $PrMo_MainGUI_ShowModeCombo_ActiveText
				Case $C_PrMo_MainGUI_ShowModeCombo_InputText
					$PrMo_PreviewMode = $C_PrMo_PreviewMode_INPUT
				Case $C_PrMo_MainGUI_ShowModeCombo_OutputText
					$PrMo_PreviewMode = $C_PrMo_PreviewMode_OUTPUT
				Case $C_PrMo_MainGUI_ShowModeCombo_BothText
					$PrMo_PreviewMode = $C_PrMo_PreviewMode_BOTH
			EndSwitch

		; Update the preview frame

			PrMo_Frame_Update()


		Return
	EndIf

	; Check if the user changed the time of the preview
	$tmp = GUICtrlRead($PrMo_MainGUI_Slider)
	If $tmp <> $PrMo_PreviewTimeSlider Then
		; Case: the user chaged the time of the preview
		$PrMo_PreviewTimeSlider = $tmp
		AdlibRegister(PrMo_MainGUI_ProcessLoop_UpdateFrame_Adlib,100)
	EndIf


	;GUISwitch($MainGUI_hGUI) ; Switch back to the main window
EndFunc


Func PrMo_MainGUI_ProcessMsg()

;~ 	If Not $GUI_MSG[1] Or $GUI_MSG[1] <> $PrMo_MainGUI_hPerentGUI Then Return



	Switch $GUI_MSG[$C_GUIMsg_idx1_ControlID]

		Case $PrMo_MainGUI_FullScreenButton
			If Not $PrMo_Frame_sImagePath Then
				ToolTip('No preview was loaded')
				AdlibRegister(ToolTip_Off,1000)
				Return
			EndIf
			ShellExecute($PrMo_Frame_sImagePath)
	EndSwitch


EndFunc


Func PrMo_MainGUI_ProcessLoop_UpdateFrame_Adlib()
	PrMo_Frame_Update()
	AdlibUnRegister(PrMo_MainGUI_ProcessLoop_UpdateFrame_Adlib)
EndFunc




#cs
	Func PrMo_MainGUI_ReadSettings()
		GUISwitch($PrMo_MainGUI_hGUI)
		$PrMo_PreviewTimeSlider = GUICtrlRead($PrMo_MainGUI_Slider)
		$PrMo_PreviewMode = GUICtrlRead($PrMo_MainGUI_ShowModeCombo)
		GUISwitch($MainGUI_hGUI)
	EndFunc
#ce




;$PrMo_PreviewTimeSlider


#cs				DELETED CODE

Func PrMo_MainGUI_SetLoadingState()
	PrMo_Frame_CleanPreviewImage()
	PrMo_Frame_SetText('Loading')

	GUISwitch($PrMo_MainGUI_hGUI)
	GUICtrlSetState($PrMo_MainGUIPController_Slider,$GUI_DISABLE)
	GUISwitch($MainGUI_hGUI)




EndFunc
#ce


