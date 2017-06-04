#Region Code for creating the settings gui

	Func SettingsGUI_Create($hParent,$width,$height, $left , $top)

		$SettingsGUI_hParent = $hParent

		; לתקן באג שהחלון לא נפתח בדיוק במקום הנכון
		$SettingsGUI_hGUI = GUICreate('Settings',$width, $height, $left, $top, $WS_CHILD, $WS_EX_CLIENTEDGE, $SettingsGUI_hParent)
		WinMove($SettingsGUI_hGUI,'',$left, $top,$width, $height)
		$tmp = WinGetClientSize($SettingsGUI_hGUI)
		If IsArray($tmp) Then
			$width = $tmp[0]
			$height = $tmp[1]
		EndIf


		;GUISetBkColor(0xA6CAF0)



		SettingsGUI_DrawControls(True,$width,$height)


		GUISetState(@SW_SHOW)





		GUISwitch($SettingsGUI_hParent)


	EndFunc


	Func SettingsGUI_DrawControls($bDraw,$width,$height)
	#cs
		calculate pos for each control
	#ce

		Local Const $C_Combo_ySize = 30, $C_LowerArea_ySize = 30


		Local $Tab_ySize = $height-$C_Combo_ySize-$C_LowerArea_ySize

		$SettingsGUI_Tab_xSize = $width-($C_SettingsGUI_xySpace*2)


		Local Const $C_TabSheet_Video_FFEdit_yPos = 75
		Local $TabSheet_Video_FFEdit_ySize = $height-$C_TabSheet_Video_FFEdit_yPos-$C_LowerArea_ySize-$C_SettingsGUI_xySpace



		; Calculate the y pos of the controls in the low area
			Local $LowArea_yPos = $height-$C_LowerArea_ySize

		; X & Y of the donate button control
			; X pos & size
				Local Const $C_DoanteButton_xSize = 109
				Local $DoanteButton_xPos = $width-$C_DoanteButton_xSize
			; Y pos & size
				Local Const $C_DoanteButton_ySize = 30
				;Local $DoanteButton_yPos = $LowArea_yPos

		; X of the the other controls
			Local Const $C_Buttons_xSpace = 5
			Local Const $C_Buttons_xSize = $C_LowerArea_ySize
			Local Const $C_Buttons_ySize = $C_LowerArea_ySize

			Local Const $C_SaveToDefaults_Button_xPos = $C_Buttons_xSpace
			Local Const $C_SaveToSelected_Button_xPos = $C_SaveToDefaults_Button_xPos+$C_Buttons_xSize+$C_Buttons_xSpace
			Local Const $C_ClearSettings_Button_xPos = $C_SaveToSelected_Button_xPos+$C_Buttons_xSize+$C_Buttons_xSpace









		If $bDraw Then

			#Region Combo title
				SettingsGUI_ComboTitle_InitComboStrings()
				$SettingsGUI_ComboTitle = GUICtrlCreateCombo('',0,1,$width,$height,BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
				GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
				GUICtrlSetResizing(-1,$GUI_DOCKALL)
			#EndRegion

			#Region Low area

				; Create the donate button
				$SettingsGUI_DoanteButton_Pic = GUICtrlCreatePic('', $DoanteButton_xPos, $LowArea_yPos, $C_DoanteButton_xSize, $C_LowerArea_ySize)
				GUICtrlSetResizing(-1,$GUI_DOCKALL)
				GUICtrlSetCursor(-1, 0)

				_ResourceSetImageToCtrl($SettingsGUI_DoanteButton_Pic, 'Image_DonateButton')


				; Create the save to defaults button
				$SettingsGUI_SaveToDefaults_Button = GUICtrlCreateButton('',$C_SaveToDefaults_Button_xPos,$LowArea_yPos,$C_Buttons_xSize,$C_Buttons_ySize)
				GUICtrlSetResizing(-1,$GUI_DOCKALL)
				GUICtrlSetTip(-1, _
				'So these settings will be active for any video without profile', _
				'Save settings to default')

				_ResourceSetImageToCtrl($SettingsGUI_SaveToDefaults_Button, 'Image_SaveButton')



				$SettingsGUI_SaveToSelected_Button = GUICtrlCreateButton('',$C_SaveToSelected_Button_xPos,$LowArea_yPos,$C_Buttons_xSize,$C_Buttons_ySize)
				GUICtrlSetResizing(-1,$GUI_DOCKALL)
				GUICtrlSetTip(-1, _
					'It will create new profile with these settings for the selected videos.'&@CRLF& _
					'(The settings will be active only on the selected videos)', _
				'Save settings to selected videos')
				_ResourceSetImageToCtrl($SettingsGUI_SaveToSelected_Button, 'Image_SaveToSelected')




				$SettingsGUI_ClearSettings_Button = GUICtrlCreateButton('',$C_ClearSettings_Button_xPos,$LowArea_yPos,$C_Buttons_xSize,$C_Buttons_ySize)
				GUICtrlSetResizing(-1,$GUI_DOCKALL)
				GUICtrlSetTip(-1, _
					'If no video was selected then this button will reset the default settings.'&@CRLF& _
					'Otherwise it will remove the settings of the selected videos.', _
				'Reset default settings / Clear settings of the selected videos')
				_ResourceSetImageToCtrl($SettingsGUI_ClearSettings_Button, 'Image_DeleteSettings')









			#EndRegion


			#Region Main tab
				$SettingsGUI_Tab = GUICtrlCreateTab(1, $C_Combo_ySize, $width, $Tab_ySize)
				GUICtrlSetResizing(-1,$GUI_DOCKALL)

				#Region Command tab
					$SettingsGUI_Command_TabSheet = GUICtrlCreateTabItem('Command')

					GUICtrlCreateLabel('FFmpeg command:',$C_SettingsGUI_xySpace, 53, $SettingsGUI_Tab_xSize, $C_iDyTextSize,$SS_CENTERIMAGE)
					GUICtrlSetResizing(-1,$GUI_DOCKALL)
					GUICtrlSetFont(-1, 10, 400, 4, "Tahoma")
					GUICtrlSetColor(-1, 0x0066CC)


					$SettingsGUI_FFmpegCommand_Edit = GUICtrlCreateEdit('', $C_SettingsGUI_xySpace, $C_TabSheet_Video_FFEdit_yPos, $SettingsGUI_Tab_xSize, $TabSheet_Video_FFEdit_ySize)
					GUICtrlSetResizing(-1,$GUI_DOCKALL)
					GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")

				#EndRegion


				#Region Output tab
					$SettingsGUI_Output_TabSheet = GUICtrlCreateTabItem('Output')


					SettingsGUI_DrawControls_OutputControls($bDraw) ; Draw the controls inside the tab sheet


				#EndRegion



			#EndRegion












		Else
			GUISwitch($SettingsGUI_hGUI)


			#Region Combo title
				GUICtrlSetPos($SettingsGUI_ComboTitle,0,0,$width,$height)
			#EndRegion


			#Region Low area
				; Repos the donate button
				GUICtrlSetPos($SettingsGUI_DoanteButton_Pic,$DoanteButton_xPos, $LowArea_yPos, $C_DoanteButton_xSize, $C_LowerArea_ySize)

				; Repos the other buttons
				GUICtrlSetPos($SettingsGUI_SaveToDefaults_Button,$C_SaveToDefaults_Button_xPos,$LowArea_yPos,$C_Buttons_xSize,$C_Buttons_ySize)
				GUICtrlSetPos($SettingsGUI_SaveToSelected_Button,$C_SaveToSelected_Button_xPos,$LowArea_yPos,$C_Buttons_xSize,$C_Buttons_ySize)
				GUICtrlSetPos($SettingsGUI_ClearSettings_Button,$C_ClearSettings_Button_xPos,$LowArea_yPos,$C_Buttons_xSize,$C_Buttons_ySize)

			#EndRegion


			#Region Main tab

				#Region Output tab
					; Resize & Move the video* ..
					SettingsGUI_DrawControls_OutputControls($bDraw)
				#EndRegion


				#Region Command tab
					; Resize & Move the main TAB
					GUICtrlSetPos($SettingsGUI_Tab,1, $C_Combo_ySize, $width, $Tab_ySize)

					; Resize & Move the ffmpeg command edit input in the "Video" tab
					GUICtrlSetPos($SettingsGUI_FFmpegCommand_Edit,$C_SettingsGUI_xySpace, $C_TabSheet_Video_FFEdit_yPos, $SettingsGUI_Tab_xSize, $TabSheet_Video_FFEdit_ySize)

				#EndRegion

			#EndRegion




			GUISwitch($SettingsGUI_hParent)
		EndIf




	EndFunc



	Func SettingsGUI_DrawControls_OutputControls($bDraw)

		Local Const $C_MarksColor = 0x0066CC, $C_PreviewColor = 0x0000FF, $C_SectionColor = 0x3f5f91

		Local $iLevel2Xpos = $C_SettingsGUI_xySpace+15 ; The x pos of everything unther "Variables" title

		Local Const $C_ySpace = 22, $C_ySpace2 = 17


	;~ 	If Not $bDraw Then
	;~ 		;$SettingsGUI_VideoPathText = ''
	;~ 		$SettingsGUI_VideoNameText = ''
	;~ 	EndIf


		Local Static $VideoNameMarks_Label, $VideoSavePath_Label, $VideoSavePathMarks_Label

		; Calculate the y & x pos of the video name controls

			; Calculate global x pos & size
				Local $iLevel3Xpos = $iLevel2Xpos+10
				Local $Level3Xsize = $SettingsGUI_Tab_xSize-$iLevel3Xpos-$C_SettingsGUI_xySpace


			; Calculate the x pos & size
				Local Const $C_iVideoNameTextSize = 75 ; The x size of the video name label
				Local $iVideoNameInputXpos = $iLevel2Xpos+$C_iVideoNameTextSize+5
				Local $iVideoNameInputXsize = $SettingsGUI_Tab_xSize-$iVideoNameInputXpos-$C_SettingsGUI_xySpace




			; Calculate the y pos & size
				Local Const $C_VariablesTitleYpos = 88 ; The y pos of the "Variables" title
				Local Const $C_VideoNameMarksYpos = 97 ; The y pos of the text above the video name input. the text will show the macros keys

				Local Const $C_iVideoNameYpos = 114 ; The y pos of the <video name line> that contain: the video name input, video name label

				Local $iVideoNamePreviewYpos = $C_iVideoNameYpos; The y pos of the preview text that will show the preview name name
				If $SettingsGUI_bShowPreviewInfo Then $iVideoNamePreviewYpos += $C_ySpace


		; Calculate the y pos of the video path controls

			; Calculate the x pos & size
				Local Const $C_VideoPathTextSize = 50
				Local $VideoPathInputXpos = $iLevel2Xpos+$C_VideoPathTextSize+5

				Local Const $C_VideoPathButtonXsize = 30


				Local $VideoPathMarksXsize = $SettingsGUI_Tab_xSize-$VideoPathInputXpos-$C_SettingsGUI_xySpace+20
				Local $VideoPathMarksXpos = $VideoPathInputXpos-20

				Local $VideoPathInputXsize = $SettingsGUI_Tab_xSize-$VideoPathInputXpos-$C_SettingsGUI_xySpace-$C_VideoPathButtonXsize-5

				Local $VideoPathButtonXpos = $VideoPathInputXpos+$VideoPathInputXsize+5


				Local $FullSavePathTitleXsize = 100
				Local $FullSavePathInputXpos = $C_SettingsGUI_xySpace+$FullSavePathTitleXsize
				Local $FullSavePathInputXsize = $SettingsGUI_Tab_xSize-$FullSavePathInputXpos-$C_SettingsGUI_xySpace


			; Calculate the y pos & size
				Local $VideoPathMarksYpos = $iVideoNamePreviewYpos+$C_ySpace2+6
				Local $VideoPathYpos = $VideoPathMarksYpos+$C_ySpace

				Local $VideoPathPreviewYpos = $VideoPathYpos
				If $SettingsGUI_bShowPreviewInfo Then $VideoPathPreviewYpos += $C_ySpace


				Local $FullSavePathYpos = $VideoPathPreviewYpos+$C_ySpace+7








		If $bDraw Then

			; The video container section

				; Calculate the x & y pos of the output container

					; Calculate the x pos & size
						Local Const $C_OutputContainerTextXsize = 115
						Local $OutputContainerInputXpos = $C_OutputContainerTextXsize+$C_SettingsGUI_xySpace
						Local Const $C_OutputContainerInputXsize = 90

					; Calculate the y pos & size
						Local Const $C_OutputContainerYpos = 58


				; Create the output container combo & label
					GUICtrlCreateLabel('Output container:',$C_SettingsGUI_xySpace,$C_OutputContainerYpos,$C_OutputContainerTextXsize)
					GUICtrlSetResizing(-1,$GUI_DOCKALL)
					GUICtrlSetFont(-1, 10, 400, 4, "Tahoma")
					GUICtrlSetColor(-1, $C_SectionColor)

					$SettingsGUI_OutputContainer_Combo = _
					GUICtrlCreateCombo($SettingsGUI_OutputContainerText,$OutputContainerInputXpos,$C_OutputContainerYpos,$C_OutputContainerInputXsize,Default,BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
					GUICtrlSetResizing(-1,$GUI_DOCKALL)
					GUICtrlSetData(-1,$C_OutputConteiners_ComboList)





			; The Variables section

				; Create the "Variables" title
					GUICtrlCreateLabel('Variables:',$C_SettingsGUI_xySpace, $C_VariablesTitleYpos, $SettingsGUI_Tab_xSize, Default,$SS_CENTERIMAGE)
					GUICtrlSetResizing(-1,$GUI_DOCKALL)
					GUICtrlSetFont(-1, 10, 400, 4, "Tahoma")
					GUICtrlSetColor(-1, $C_SectionColor)


				; Create the controls of <Video name>
					GUICtrlCreateLabel('Video name:',$iLevel2Xpos, $C_iVideoNameYpos, $C_iVideoNameTextSize, Default,$SS_CENTERIMAGE)
					GUICtrlSetResizing(-1,$GUI_DOCKALL)
					GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

					$VideoNameMarks_Label = GUICtrlCreateLabel($C_sVideoNameMark&' = Input',$iVideoNameInputXpos,$C_VideoNameMarksYpos,$iVideoNameInputXsize,Default,$SS_CENTER)
					GUICtrlSetResizing(-1,$GUI_DOCKALL)
					GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
					GUICtrlSetColor(-1, $C_MarksColor)


					$SettingsGUI_VideoName_Input = GUICtrlCreateInput($SettingsGUI_VideoNameText,$iVideoNameInputXpos,$C_iVideoNameYpos,$iVideoNameInputXsize,Default)
					GUICtrlSetResizing(-1,$GUI_DOCKALL)


					$SettingsGUI_VideoNamePreview_Label = GUICtrlCreateLabel('',$iLevel3Xpos,$iVideoNamePreviewYpos,$Level3Xsize,$C_iDyTextSize)
					If Not $SettingsGUI_bShowPreviewInfo Then GUICtrlSetState(-1,$GUI_HIDE)
					GUICtrlSetResizing(-1,$GUI_DOCKALL)
					GUICtrlSetFont(-1, 10, 800, 0, "Tahoma")
					GUICtrlSetColor(-1, $C_PreviewColor)

				; Create the controls of <Video path>
					$VideoSavePath_Label = GUICtrlCreateLabel('Folder:',$iLevel2Xpos,$VideoPathYpos,$C_VideoPathTextSize)
					GUICtrlSetResizing(-1,$GUI_DOCKALL)
					GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")



					$VideoSavePathMarks_Label = GUICtrlCreateLabel($C_sRootFolderPath&' = Common path, '&$C_sNotFullPath&' = Path after '&$C_sRootFolderPath, _
					$VideoPathMarksXpos,$VideoPathMarksYpos,$VideoPathMarksXsize,Default,$SS_CENTER)
					GUICtrlSetResizing(-1,$GUI_DOCKALL)
					GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
					GUICtrlSetColor(-1, $C_MarksColor)

					$SettingsGUI_OutputFolder_Input = GUICtrlCreateInput($SettingsGUI_OutputFolderText,$VideoPathInputXpos,$VideoPathYpos,$VideoPathInputXsize,$C_iDyTextSize)
					GUICtrlSetResizing(-1,$GUI_DOCKALL)

					$SettingsGUI_OutputFolder_Button = GUICtrlCreateButton('...',$VideoPathButtonXpos,$VideoPathYpos,$C_VideoPathButtonXsize,$C_iDyTextSize)
					GUICtrlSetResizing(-1,$GUI_DOCKALL)

					$SettingsGUI_OutputFolderPreview_Label = GUICtrlCreateLabel('',$iLevel3Xpos,$VideoPathPreviewYpos,$Level3Xsize,$C_iDyTextSize)
					If Not $SettingsGUI_bShowPreviewInfo Then GUICtrlSetState(-1,$GUI_HIDE)
					GUICtrlSetResizing(-1,$GUI_DOCKALL)
					GUICtrlSetFont(-1, 10, 800, 0, "Tahoma")
					GUICtrlSetColor(-1, $C_PreviewColor)

			; Variables result section
				$SettingsGUI_FullSavePath_Label = GUICtrlCreateLabel('Full save path:',$C_SettingsGUI_xySpace,$FullSavePathYpos,$FullSavePathTitleXsize)
				If Not $SettingsGUI_bShowPreviewInfo Then GUICtrlSetState(-1,$GUI_HIDE)
				GUICtrlSetResizing(-1,$GUI_DOCKALL)
				GUICtrlSetFont(-1, 10, 400, 4, "Tahoma")

				$SettingsGUI_FullSavePath_Input = GUICtrlCreateInput('',$FullSavePathInputXpos,$FullSavePathYpos,$FullSavePathInputXsize,Default,BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
				GUICtrlSetResizing(-1,$GUI_DOCKALL)
				GUICtrlSetFont(-1, 10, 800, 0, "Tahoma")
				GUICtrlSetColor(-1,$C_PreviewColor)

				If Not $SettingsGUI_bShowPreviewInfo Then GUICtrlSetState(-1,$GUI_HIDE)



		Else



			; No need to GUISwitch to $SettingsGUI_hGUI because we handle this outside this function

			GUICtrlSetPos($VideoNameMarks_Label,$iVideoNameInputXpos,$C_VideoNameMarksYpos,$iVideoNameInputXsize)
			GUICtrlSetPos($SettingsGUI_VideoName_Input,$iVideoNameInputXpos,$C_iVideoNameYpos,$iVideoNameInputXsize)
			GUICtrlSetPos($SettingsGUI_VideoNamePreview_Label,$iLevel3Xpos,$iVideoNamePreviewYpos,$Level3Xsize,$C_iDyTextSize)
			GUICtrlSetPos($VideoSavePath_Label,$iLevel2Xpos,$VideoPathYpos,$C_VideoPathTextSize)
			GUICtrlSetPos($VideoSavePathMarks_Label,$VideoPathMarksXpos,$VideoPathMarksYpos,$VideoPathMarksXsize)
			GUICtrlSetPos($SettingsGUI_OutputFolder_Input,$VideoPathInputXpos,$VideoPathYpos,$VideoPathInputXsize,$C_iDyTextSize)
			GUICtrlSetPos($SettingsGUI_OutputFolder_Button,$VideoPathButtonXpos,$VideoPathYpos,$C_VideoPathButtonXsize,$C_iDyTextSize)
			GUICtrlSetPos($SettingsGUI_OutputFolderPreview_Label,$iLevel3Xpos,$VideoPathPreviewYpos,$Level3Xsize,$C_iDyTextSize)
			GUICtrlSetPos($SettingsGUI_FullSavePath_Label,$C_SettingsGUI_xySpace,$FullSavePathYpos,$FullSavePathTitleXsize)
			GUICtrlSetPos($SettingsGUI_FullSavePath_Input,$FullSavePathInputXpos,$FullSavePathYpos,$FullSavePathInputXsize)

		EndIf

	EndFunc



	Func SettingsGUI_PreviewInfoCtrlsSetSate($State)
		GUICtrlSetState($SettingsGUI_VideoNamePreview_Label,$State)
		GUICtrlSetState($SettingsGUI_OutputFolderPreview_Label,$State)
		GUICtrlSetState($SettingsGUI_FullSavePath_Label,$State)
		GUICtrlSetState($SettingsGUI_FullSavePath_Input,$State)
	EndFunc



	Func SettingsGUI_RePos($xPos,$yPos,$xSize,$ySize)
		WinMove($SettingsGUI_hGUI,'',$xPos,$yPos,$xSize,$ySize)
		Local $cSize = WinGetClientSize($SettingsGUI_hGUI)
		If Not @error Then
			$xSize = $cSize[0]
			$ySize = $cSize[1]
		EndIf
		SettingsGUI_DrawControls(False,$xSize,$ySize)
	EndFunc

#EndRegion

#Region Code to DRAW the settings of the selected files

	Func SettingsGUI_DrawCommonSettings($bReDrawComboTitle = False,$bDrawSettings = True)
		#cs
			Function to draw the common settings..
			when the user select multiple videos, there is need to draw only the common settings
			of the selected videos. if there is set with more then one option then we draw "*" on this set
		#ce

		GUISwitch($SettingsGUI_hGUI)

		Local $FFmpegCommand, $OutputName, $OutContainer, $OutputFolder, $Profile




		#cs
			We need to get what setting to draw on each field
		#ce

		If $aVids_aActiveIdxs[0] Then ; If there are some active videos
			; then we draw the settings of these active videos only



			#cs
				The following code will get the common fields of any active video and any field that have more
				then one setting will shown as '*'
			#ce


			Local $ProfileChanged = False

			; Load the settings of the first active video



			$Profile = aVids_ReadSet($aVids_aActiveIdxs[1],$C_aVids_idx2_ProfileID)


			$FFmpegCommand = aVids_ReadSet($aVids_aActiveIdxs[1],$C_aVids_idx2_Command)
			$OutputName = aVids_ReadSet($aVids_aActiveIdxs[1],$C_aVids_idx2_OutputName)
			$OutContainer = aVids_ReadSet($aVids_aActiveIdxs[1],$C_aVids_idx2_OutContainer)
			$OutputFolder = aVids_ReadSet($aVids_aActiveIdxs[1],$C_aVids_idx2_OutputFolder)



			; From the second video and so on...
			For $a = 2 To $aVids_aActiveIdxs[0]
				; Check for any chages in the settings.

				; First check if the profile changed. if not then skip cheking on this video


				If  $Profile = aVids_ReadSet($aVids_aActiveIdxs[$a],$C_aVids_idx2_ProfileID) Then ContinueLoop


				If Not $ProfileChanged Then $ProfileChanged = True

				#cs
					one of the settings must be not the same so we look for every set in the video if it was changed
					then we set it to '*'
				#ce


				If $FFmpegCommand <> '*' And $FFmpegCommand <> aVids_ReadSet($aVids_aActiveIdxs[$a],$C_aVids_idx2_Command) Then $FFmpegCommand = '*'
				If $OutputName <> '*' And $OutputName <> aVids_ReadSet($aVids_aActiveIdxs[$a],$C_aVids_idx2_OutputName) Then $OutputName = '*'
				If $OutContainer <> '*' And $OutContainer <> aVids_ReadSet($aVids_aActiveIdxs[$a],$C_aVids_idx2_OutContainer) Then $OutContainer = '*'
				If $OutputFolder <> '*' And $OutputFolder <> aVids_ReadSet($aVids_aActiveIdxs[$a],$C_aVids_idx2_OutputFolder) Then $OutputFolder = '*'



			Next ; End of chaking the settings


			If $ProfileChanged Then $Profile = '*'



			#cs
				Here we done to init the data we need to draw on the fields
			#ce






			If $bReDrawComboTitle Then






				; Case: we need to draw the text on the combo



				; Draw text on the combo:
				If $aVids_aActiveIdxs[0] <> 1 Then
					; Selected video count is bigger then 1 -> draw the text <number of the selected videos> <Profile ID>
					$SettingsGUI_ComboTitle_SelectedStringText = SettingsGUI_ComboTitle_GetTextItemForCombo($aVids_aActiveIdxs[0],$Profile)
				Else

					; Selected video count is 1
					If $Profile Then
						; draw the text <video filename> <Profile ID>
						$SettingsGUI_ComboTitle_SelectedStringText = $aVids[$aVids_aActiveIdxs[1]][$C_aVids_idx2_InputName]&' [Profile '&$Profile&']'
					Else
						; draw the text <number of the selected videos> "No Profile"
						$SettingsGUI_ComboTitle_SelectedStringText = $aVids[$aVids_aActiveIdxs[1]][$C_aVids_idx2_InputName]&' [No Profile]'
					EndIf
				EndIf


				SettingsGUI_ComboTitle_ReDraw()



			EndIf


		Else ; If there are no active videos
			; then we draw the default settings of all videos

			$Profile = ''

			$SettingsGUI_ComboTitle_SelectedStringText = $C_SettingsGUI_ComTitle_EditDefaultSettingsText

			$FFmpegCommand = $aVids[0][$C_aVids_idx2_Command]
			$OutputName = $aVids[0][$C_aVids_idx2_OutputName]
			$OutContainer = $aVids[0][$C_aVids_idx2_OutContainer]
			$OutputFolder = $aVids[0][$C_aVids_idx2_OutputFolder]


			If $bReDrawComboTitle Then
				;$SettingsGUI_ComboTitle_aActiveItems = $aVids_aActiveItems
				SettingsGUI_ComboTitle_ReDraw()

			EndIf
		EndIf

		#cs
			We need to get what setting to draw on each field - DONE
		#ce



		#cs
			Next, we draw what we got on the GUI
		#ce








		If $bDrawSettings Then

			; Few settings are need to be converted to gui format
			$SettingsGUI_FFmpegCommandText = SettingsGUI_ConvertFFmpegCommandToGuiFormat($FFmpegCommand)
			$SettingsGUI_OutputContainerText = $OutContainer
			$SettingsGUI_VideoNameText = $OutputName
			$SettingsGUI_OutputFolderText = $OutputFolder

			; Draw the data on the settings

			SettingsGUI_CtrlSetData($SettingsGUI_FFmpegCommand_Edit,$SettingsGUI_FFmpegCommandText,$SettingsGUI_FFmpegCommand_EditColor)
			SettingsGUI_CtrlSetData($SettingsGUI_OutputContainer_Combo,$SettingsGUI_OutputContainerText,$SettingsGUI_OutputContainer_ComboColor,True)
			SettingsGUI_CtrlSetData($SettingsGUI_VideoName_Input,$SettingsGUI_VideoNameText,$SettingsGUI_VideoName_InputColor)
			SettingsGUI_CtrlSetData($SettingsGUI_OutputFolder_Input,$SettingsGUI_OutputFolderText,$SettingsGUI_OutputFolder_InputColor)





			; Redraw the output controls in case we need to
			If $aVids_aActiveIdxs[0] = 1 Then
				#cs
					Case: one file selected (And we are not in default settings mode)
				#ce
				; Draw preview strings
				SettingsGUI_ReDrawFilePathPreviewStrings()
				#cs
					SettingsGUI_ReDrawFilenamePreview() ; Draw the preview of the full name of the file
					SettingsGUI_ReDrawFolderPreview() ; Draw the preview of the full folder path
				#ce

				If Not $SettingsGUI_bShowPreviewInfo Then
					$SettingsGUI_bShowPreviewInfo = True
					SettingsGUI_DrawControls_OutputControls(False)
					SettingsGUI_PreviewInfoCtrlsSetSate($GUI_SHOW)
				EndIf
			Else
				If $SettingsGUI_bShowPreviewInfo Then
					$SettingsGUI_bShowPreviewInfo = False
					SettingsGUI_PreviewInfoCtrlsSetSate($GUI_HIDE)
					SettingsGUI_DrawControls_OutputControls(False)

				EndIf
			EndIf


			; Enable/disable the "Save to selected videos" button
			If $aVids_aActiveIdxs[0] >= 1 Then
				If $SettingsGUI_SaveToSelected_ButtonState <> $GUI_ENABLE Then
					GUICtrlSetState($SettingsGUI_SaveToSelected_Button,$GUI_ENABLE)
					$SettingsGUI_SaveToSelected_ButtonState = $GUI_ENABLE
				EndIf
			Else
				If $SettingsGUI_SaveToSelected_ButtonState <> $GUI_DISABLE Then
					GUICtrlSetState($SettingsGUI_SaveToSelected_Button,$GUI_DISABLE)
					$SettingsGUI_SaveToSelected_ButtonState = $GUI_DISABLE
				EndIf

			EndIf

			; Enable/disable the "Save to default" button
			If $Profile <> '*' Then
				If $SettingsGUI_SaveToDefaults_ButtonState <> $GUI_ENABLE Then
					GUICtrlSetState($SettingsGUI_SaveToDefaults_Button,$GUI_ENABLE)
					$SettingsGUI_SaveToDefaults_ButtonState = $GUI_ENABLE
				EndIf
			Else
				If $SettingsGUI_SaveToDefaults_ButtonState <> $GUI_DISABLE Then
					GUICtrlSetState($SettingsGUI_SaveToDefaults_Button,$GUI_DISABLE)
					$SettingsGUI_SaveToDefaults_ButtonState = $GUI_DISABLE
				EndIf
			EndIf


		EndIf



		GUISwitch($SettingsGUI_hParent)



		Return $Profile


	EndFunc

	; Need GUISwitch($SettingsGUI_hGUI) before and only if $aVids_aActiveIdxs[0] = 1
	Func SettingsGUI_ReDrawFilePathPreviewStrings()
		; Get the file name
		Local $sFileName = aVids_GenerateRealFilename($aVids_aActiveIdxs[1],$SettingsGUI_VideoNameText,$SettingsGUI_OutputContainerText)


		; Draw the file name
		GUICtrlSetData($SettingsGUI_VideoNamePreview_Label,$sFileName)
		GUICtrlSetTip($SettingsGUI_VideoNamePreview_Label,$sFileName,'File name preview:')

		; Get the save folder path
		Local $sSaveFolder = aVids_GenerateRealFolderPath($aVids_aActiveIdxs[1],$SettingsGUI_OutputFolderText)

		; Draw the save folder path
		GUICtrlSetData($SettingsGUI_OutputFolderPreview_Label,$sSaveFolder)
		GUICtrlSetTip($SettingsGUI_OutputFolderPreview_Label,$sSaveFolder,'Save folder preview:')


		; Get the full file path
		If StringRight($sSaveFolder,1) <> '\' Then $sSaveFolder &= '\'
		Local $sFullSavePath = $sSaveFolder&$sFileName

		; Draw the full file path
		GUICtrlSetData($SettingsGUI_FullSavePath_Input,$sFullSavePath)
		GUICtrlSetTip($SettingsGUI_FullSavePath_Input,$sFullSavePath,'File path preview:')


	EndFunc


	#Region _ComboTitle_*
		Func SettingsGUI_ComboTitle_GetTextItemForCombo($iVideoCount,$Profile = Null)
			If Not $Profile Then
				$Profile = '[No Profile]'
			Else
				$Profile = '[Profile '&$Profile&']'
			EndIf
			Return $iVideoCount&' Videos '&$Profile
		EndFunc



		Func SettingsGUI_ComboTitle_ReDraw()
			#cs
				Inputs:
					$SettingsGUI_ComboTitle_SelectedStringText - the active text to sho
					$SettingsGUI_ComboTitle_Strings - all other options

				Outputs:
					Action: Redraw the options on the combo

			#ce

			$tmp = StringSplit($SettingsGUI_ComboTitle_Strings,'|',1)
			If _ArraySearch($tmp,$SettingsGUI_ComboTitle_SelectedStringText,1,$tmp[0]) <= 0 Then
				$tmp = $SettingsGUI_ComboTitle_Strings&'|'&$SettingsGUI_ComboTitle_SelectedStringText
			Else
				$tmp = $SettingsGUI_ComboTitle_Strings
			EndIf


			GUISwitch($SettingsGUI_hGUI)
			GUICtrlSetData($SettingsGUI_ComboTitle,'')
			GUICtrlSetData($SettingsGUI_ComboTitle,$tmp,$SettingsGUI_ComboTitle_SelectedStringText)
			GUICtrlSetTip($SettingsGUI_ComboTitle,$SettingsGUI_ComboTitle_SelectedStringText)
			GUISwitch($SettingsGUI_hParent)


		EndFunc



		Func SettingsGUI_ComboTitle_InitComboStrings($bResetSelected = False)
			#cs
				Inputs:
					$aProfiles array
					$aVids array

				Outputs:
					$SettingsGUI_ComboTitle_Strings - all the options to show on the combo
			#ce


			If $bResetSelected Then
				$SettingsGUI_ComboTitle_SelectedStringText = $C_SettingsGUI_ComTitle_EditDefaultSettingsText
				aProfiles_ReInitialize()
			EndIf
			; Count any video that have no profile
			Local $nVidCount = 0, $iDxTmp
			For $a = 1 To $aVids[0][0]
				If Not $aVids[$a][$C_aVids_idx2_ProfileID] Then
					$nVidCount += 1
					$iDxTmp = $a
				EndIf
			Next



			$SettingsGUI_ComboTitle_Strings = $C_SettingsGUI_ComTitle_EditDefaultSettingsText
			If $nVidCount Then
				If $nVidCount > 1 Then
					$SettingsGUI_ComboTitle_Strings &= '|'&$nVidCount&' Videos [No Profile]'
				Else
					$SettingsGUI_ComboTitle_Strings &= '|'&$aVids[$iDxTmp][$C_aVids_idx2_InputName]&' [No Profile]'
				EndIf
			EndIf

			; If there are no profiles or all profile have 0 videos then return


			If Not $aProfiles[0][0] Or Not $aProfiles[1][$C_aProfiles_idx2_VidCount] Then Return



			;$SettingsGUI_ComboTitle_Strings &= '|'




			For $a = 1 To $aProfiles[0][0]
				If Not $aProfiles[$a][$C_aProfiles_idx2_VidCount] Then ExitLoop


				If $aProfiles[$a][$C_aProfiles_idx2_VidCount] <> 1 Then
					$SettingsGUI_ComboTitle_Strings &= _
					'|'&$aProfiles[$a][$C_aProfiles_idx2_VidCount]&' Videos [Profile '&$aProfiles[$a][$C_aProfiles_idx2_nID]&']'
				Else
					$tmp = _ArraySearch($aVids,$aProfiles[$a][$C_aProfiles_idx2_nID],1,$aVids[0][0],0,0,1,$C_aVids_idx2_ProfileID)
					If $tmp > 0 Then
						$SettingsGUI_ComboTitle_Strings &= _
						'|'&$aVids[$tmp][$C_aVids_idx2_InputName]&' [Profile '&$aProfiles[$a][$C_aProfiles_idx2_nID]&']'
					Else
						$SettingsGUI_ComboTitle_Strings &= _
						'|'&$aProfiles[$a][$C_aProfiles_idx2_VidCount]&' Videos [Profile '&$aProfiles[$a][$C_aProfiles_idx2_nID]&']'
					EndIf
				EndIf
				;If $a < $aProfiles[0][0] Then $SettingsGUI_ComboTitle_Strings &= '|'
			Next


		EndFunc



	#EndRegion


#EndRegion

#Region Code to WRITE the settings for the selected files / default settings




	Func SettingsGUI_WriteSettingsToDefault()



		; Create the command with format-string for the aVids array and the listview-gui

		; Write the command
			$tmp = ReplaceEntersInString($SettingsGUI_FFmpegCommandText,'  ')
			If $tmp <> $aVids[0][$C_aVids_idx2_Command] Then $aVids[0][$C_aVids_idx2_Command] = $tmp

		; Write the container
			If $SettingsGUI_OutputContainerText <> $aVids[0][$C_aVids_idx2_OutContainer] Then _
			$aVids[0][$C_aVids_idx2_OutContainer] = $SettingsGUI_OutputContainerText

		; Write the output name
			If $SettingsGUI_VideoNameText <> $aVids[0][$C_aVids_idx2_OutputName] Then _
			$aVids[0][$C_aVids_idx2_OutputName] = $SettingsGUI_VideoNameText

		; Write the output path
			If $SettingsGUI_OutputFolderText <> $aVids[0][$C_aVids_idx2_OutputFolder] Then _
			$aVids[0][$C_aVids_idx2_OutputFolder] = $SettingsGUI_OutputFolderText


		; Redraw the defaults (only videos without profile)
			VideoList_ListView_ReDrawDefaults()

		; In case there is some video that encoding now, suggest to restart encoding
			Encoder_GUI_MSG_CurrentlyEncoding()

	EndFunc


	Func SettingsGUI_WriteSettingsToSelectedVideos()

		; Go on every selected video
		For $a = 1 To $aVids_aActiveIdxs[0]



			; Write the command
			SettingsGUI_WriteSettingsToSelectedVideos_Writer(SettingsGUI_GetCleanCommand(),$aVids_aActiveIdxs[$a],$C_aVids_idx2_Command)

			; Write the container
			SettingsGUI_WriteSettingsToSelectedVideos_Writer($SettingsGUI_OutputContainerText,$aVids_aActiveIdxs[$a],$C_aVids_idx2_OutContainer)

			; Write the output name
			SettingsGUI_WriteSettingsToSelectedVideos_Writer($SettingsGUI_VideoNameText,$aVids_aActiveIdxs[$a],$C_aVids_idx2_OutputName)

			; Write the output path
			SettingsGUI_WriteSettingsToSelectedVideos_Writer($SettingsGUI_OutputFolderText,$aVids_aActiveIdxs[$a],$C_aVids_idx2_OutputFolder)


			; In case there is some video that encoding now, suggest to restart encoding
				Encoder_GUI_MSG_CurrentlyEncoding($aVids_aActiveIdxs[$a])

		Next

		; Generate profiles IDs and save them
			SettingsGUI_InitializeProfilesForActiveVideos()

	EndFunc

	Func SettingsGUI_WriteSettingsToSelectedVideos_Writer($sNewSet,$aVids_idx1,$aVids_idx2)
		If $sNewSet <> '*' Then
			If $aVids[$aVids_idx1][$aVids_idx2] And $sNewSet = $aVids[$aVids_idx1][$aVids_idx2] Then Return
			$aVids[$aVids_idx1][$aVids_idx2] = $sNewSet
		Else
			If $aVids[$aVids_idx1][$aVids_idx2] Then Return
			$sNewSet = $aVids[0][$aVids_idx2]
			$aVids[$aVids_idx1][$aVids_idx2] = $sNewSet
		EndIf

		VideoList_ListView_DrawVidInfoFromaVidsIndexToListViewRaw($aVids_idx1,$aVids_idx2)

	EndFunc



	Func SettingsGUI_InitializeProfilesForActiveVideos()


		#cs
			הקוד הזה רץ כאשר המשתמש כבר סימן איזה סרטון ברשימה, ולאחר מכן שינה את הבחירה
			במקרה הזה יש צורך לקבוע את מזהה ההגדרות שהוגדרו לסרטונים שהמשתמש בחר לפני כן

			בהנחה שהמשתמש הגדיר הגדרות כלשהם לסרטונים שבחר, הקוד צריך לסווג אותם עם מזהה הגדרות

		#ce

		Local $bProfileChanged = False

		If $aVids_aActiveIdxs[0] Then


			Local  $NewProfile


			; On every previos active video ...
			For $a = 1 To $aVids_aActiveIdxs[0]

				#cs
					Look for fit profile id that we have. if we didn't found fit profile, we create new profile id for the video
					and draw it


				#ce





				$NewProfile = 0

				For $a2 = 1 To $aProfiles[0][0]

					; Look for profile that fit to the settings of this video
					If $aVids[$aVids_aActiveIdxs[$a]][$C_aVids_idx2_Command] <> $aProfiles[$a2][$C_aProfiles_idx2_Command] Then ContinueLoop
					If $aVids[$aVids_aActiveIdxs[$a]][$C_aVids_idx2_OutputName] <> $aProfiles[$a2][$C_aProfiles_idx2_OutputName] Then ContinueLoop
					If $aVids[$aVids_aActiveIdxs[$a]][$C_aVids_idx2_OutputFolder] <> $aProfiles[$a2][$C_aProfiles_idx2_OutputFolder] Then ContinueLoop
					If $aVids[$aVids_aActiveIdxs[$a]][$C_aVids_idx2_OutContainer] <> $aProfiles[$a2][$C_aProfiles_idx2_OutContainer] Then ContinueLoop


					; We found such profile
					$NewProfile = $aProfiles[$a2][$C_aProfiles_idx2_nID]
					If $aVids[$aVids_aActiveIdxs[$a]][$C_aVids_idx2_ProfileID] = $NewProfile Then ContinueLoop 2

					$aProfiles[$a2][$C_aProfiles_idx2_VidCount] += 1
					ExitLoop

				Next

				If Not $bProfileChanged Then $bProfileChanged = True

				If $aVids[$aVids_aActiveIdxs[$a]][$C_aVids_idx2_ProfileID] Then aProfiles_Remove($aVids[$aVids_aActiveIdxs[$a]][$C_aVids_idx2_ProfileID])

				If Not $NewProfile Then
					$aProfiles_iLastID += 1
					$NewProfile = $aProfiles_iLastID
					aProfiles_Add($NewProfile,$aVids_aActiveIdxs[$a])
				EndIf

				_ArraySort($aProfiles,1,1,$aProfiles[0][0],$C_aProfiles_idx2_VidCount)


				$aVids[$aVids_aActiveIdxs[$a]][$C_aVids_idx2_ProfileID] = $NewProfile

				If $VideoList_ListView Then
					_GUICtrlListView_SetItemText( _
					$VideoList_ListView, _ 								; $hWnd
					$aVids_aActiveIdxs[$a]-1, _ 									; $iIndex
					$aVids[$aVids_aActiveIdxs[$a]][$C_aVids_idx2_ProfileID], _ 	; $sText
					$C_VideoList_ListView_colidx_Profile) 				; $iSubItem
				EndIf


			Next

			If $aProfiles[0][0] Then _
			_GUICtrlListView_SetColumnWidth($VideoList_ListView,$C_VideoList_ListView_colidx_Profile,$LVSCW_AUTOSIZE_USEHEADER)

			SettingsGUI_ComboTitle_InitComboStrings()

		EndIf

		;$aVids_aActiveIdxs_old = $aVids_aActiveIdxs
		Return $bProfileChanged
	EndFunc




#EndRegion

#Region Process massages



	Func SettingsGUI_ProcessLoop()


	#cs
		Monitor changes section
	#ce


		#Region the user changed the item in the combo-title
		$tmp = GUICtrlRead($SettingsGUI_ComboTitle)
		If $tmp <> $SettingsGUI_ComboTitle_SelectedStringText Then
			; Case: the user changed the item in the combo-title

			$SettingsGUI_ComboTitle_SelectedStringText = $tmp

			GUICtrlSetTip($SettingsGUI_ComboTitle,$SettingsGUI_ComboTitle_SelectedStringText)



			aVids_aActiveIdxs_UnActiveAll() ; Reset the array of the selected items


			#cs
				The user NOT changed the settings mode to default settings editor
			#ce
			If $SettingsGUI_ComboTitle_SelectedStringText <> $C_SettingsGUI_ComTitle_EditDefaultSettingsText Then
				; The user selected something else that is not $C_SettingsGUI_ComTitle_EditDefaultSettingsText

				#cs
					we extract the following valus from the text in the combo that the user selected:
					Is the there is video filename or the count of videos?
					If there is filenmae then we deal with one file.
					If there is numbers then we deal with more then one file.
				#ce


				Local $Profile, $sTextBefore


				; We get the the Answer to this question here
				$tmp = _StringBetween($SettingsGUI_ComboTitle_SelectedStringText,' [',']')
				If IsArray($tmp) Then ; no error

					; Here we extract the profile string from the text
					$Profile = $tmp[UBound($tmp)-1]

					; Here we extract the answer to our question
					$sTextBefore = StringStripWS(StringTrimRight($SettingsGUI_ComboTitle_SelectedStringText,StringLen($Profile)+2),3)



					#cs
						Now we can check with what we deal with.
						If we have "videos" then we deal with more then one file.
						If not then we deal with one file
					#ce


					; Convert profile-id variable to the format of $aVids array
					If $Profile = 'No Profile' Then
						$Profile = ''
					Else
						$Profile = StringStripWS(StringTrimLeft($Profile,StringLen('Profile')),3)
					EndIf



					$tmp = StringSplit($sTextBefore,' ',1)
					If $tmp[0] = 2 And $tmp[2] = 'Videos' Then
						; So more then one files should be selected.

						#cs
							$tmp[1] = the number of the videos
						#ce


						#cs
							The following code will select in the listview any video file that it's profile id is our
							profile Id we found on the text


							We our new items list that should  be selected.
							only items with profile id that is the profile id found in the text will be in the list
						#ce


						;_ArrayDisplay($aVids_aActiveIdxs_old)


						If $Profile = $SettingsGUI_ComboTitle_CostumeSelectionProfile And $tmp[1] = $SettingsGUI_ComboTitle_CostumeSelectionActiveIdxs[0] Then
							$aVids_aActiveIdxs = $SettingsGUI_ComboTitle_CostumeSelectionActiveIdxs
						Else
							For $a = 1 To $aVids[0][0]
								If $aVids[$a][$C_aVids_idx2_ProfileID] = $Profile Then
									aVids_aActiveIdxs_Add($a)
								EndIf
							Next
						EndIf




					Else ; We deal with one file. $sTextBefore = some filename
						#cs
							We need to add only one item to the $aVids_aActiveItems array.
							We Identified where the item should be exists according to it's filename and profile id
						#ce

						Local $iStart = 1
						$tmp = _ArraySearch($aVids,$sTextBefore,$iStart,$aVids[0][0],0,0,1,$C_aVids_idx2_InputName) ; $tmp is the index of where the video exists
						If $tmp > 0 Then
							While $aVids[$tmp][$C_aVids_idx2_ProfileID] <> $Profile
								$tmp = -1
								$iStart += 1
								If $iStart > $aVids[0][0] Then ExitLoop
								$tmp = _ArraySearch($aVids,$sTextBefore,$iStart,$aVids[0][0],0,0,1,$C_aVids_idx2_OutputName)
								If $tmp < 1 Then ExitLoop
							WEnd
						EndIf

						If $tmp > 0 Then
							aVids_aActiveIdxs_Add($tmp)
						EndIf

					EndIf

				EndIf




			EndIf





			;If SettingsGUI_SaveProfiles() Then SettingsGUI_ComboTitle_ReDraw()


			; If the listview gui was created

			If $VideoList_ListView Then

				; First we need to unregister the function that process the massages for the list view in order to prevent conflicts
				GUIRegisterMsg($WM_NOTIFY, '')


				; Here we go on evry item in the listview and unselect it
				For $a = 1 To $aVids[0][0]
					_GUICtrlListView_SetItemSelected($VideoList_ListView, $a-1, False,True)
				Next

				; Now we select evry item that shuld be selected
				For $a = 1 To $aVids_aActiveIdxs[0]
					_GUICtrlListView_SetItemSelected($VideoList_ListView, $aVids_aActiveIdxs[$a]-1, True, True)
				Next



				; Register again the function that process the massages for the list view
				GUIRegisterMsg($WM_NOTIFY, VideoList_WM_NOTIFY)
			EndIf


			; Update the settings that should shown in the settings gui
			SettingsGUI_DrawCommonSettings(False)

			PrMo_Frame_Update()


			VideoList_ItemsChangedEvent_SetRemoveButtonState()

			$aVids_aActiveIdxs_old = $aVids_aActiveIdxs ; <-------------------------------  לוודא שהשורה הזו לא דופקת את התוכנה




			Return
		EndIf

		#EndRegion


		#Region the command for the ffmpeg was changed in the gui settings
		$tmp = StringStripWS(GUICtrlRead($SettingsGUI_FFmpegCommand_Edit),3)
		If $tmp <> $SettingsGUI_FFmpegCommandText Then ; The commad changed
			$SettingsGUI_FFmpegCommandText = $tmp
			SettingsGUI_ChangeColor($SettingsGUI_FFmpegCommand_Edit,$SettingsGUI_FFmpegCommand_EditColor,$C_BKColor_SetUnChanged)

			PrMo_Frame_Update()

			Return
		EndIf
		#EndRegion


		#Region the user changed the output container
		$tmp = StringStripWS(GUICtrlRead($SettingsGUI_OutputContainer_Combo),3)
		If $tmp <> $SettingsGUI_OutputContainerText Then
			$SettingsGUI_OutputContainerText = $tmp

			If $aVids_aActiveIdxs[0] = 1 Then SettingsGUI_ReDrawFilePathPreviewStrings()

			SettingsGUI_ChangeColor($SettingsGUI_OutputContainer_Combo,$SettingsGUI_OutputContainer_ComboColor,$C_BKColor_SetUnChanged,True)

		EndIf
		#EndRegion


		#Region the user changed the output name
		$tmp = StringStripWS(GUICtrlRead($SettingsGUI_VideoName_Input),3)
		If $tmp <> $SettingsGUI_VideoNameText Then
			$SettingsGUI_VideoNameText = $tmp
			If $aVids_aActiveIdxs[0] = 1 Then SettingsGUI_ReDrawFilePathPreviewStrings()
			SettingsGUI_ChangeColor($SettingsGUI_VideoName_Input,$SettingsGUI_VideoName_InputColor,$C_BKColor_SetUnChanged,True)
		EndIf
		#EndRegion


		#Region the user changed the output folder
		$tmp = StringStripWS(GUICtrlRead($SettingsGUI_OutputFolder_Input),3)
		If $tmp <> $SettingsGUI_OutputFolderText Then
			$SettingsGUI_OutputFolderText = $tmp
			If $aVids_aActiveIdxs[0] = 1 Then SettingsGUI_ReDrawFilePathPreviewStrings()
			SettingsGUI_ChangeColor($SettingsGUI_OutputFolder_Input,$SettingsGUI_OutputFolder_InputColor,$C_BKColor_SetUnChanged,True)
		EndIf
		#EndRegion



	EndFunc







#EndRegion

#Region Codes that run on events





	Func SettingsGUI_ProcessMsg()
		;Return
		GUISwitch($SettingsGUI_hGUI)





		Switch $GUI_MSG[$C_GUIMsg_idx1_ControlID]

			#cs
				Buttons inside the tabs
			#ce
			Case $SettingsGUI_OutputFolder_Button
				;Commander_SuspendOrResumeExeProcess(True,$C_PraiortyLevelMax-1)
				Local $sDir = FileSelectFolder('Select output folder', $LastDir,0,Null,$MainGUI_hGUI)
				;Commander_SuspendOrResumeExeProcess(False,$C_PraiortyLevelMax-1)
				If $sDir Then
					If StringRight($sDir,1) <> '\' Then $sDir &= '\'
					GUICtrlSetData($SettingsGUI_OutputFolder_Input,$sDir&$C_sNotFullPath)
					$LastDir = $sDir
				EndIf







			#cs
				Main buttons
			#ce
			Case $SettingsGUI_SaveToDefaults_Button

				SettingsGUI_WriteSettingsToDefault()

				SettingsGUI_ComboTitle_InitComboStrings()
				SettingsGUI_DrawCommonSettings(True,False)


			Case $SettingsGUI_SaveToSelected_Button
				SettingsGUI_WriteSettingsToSelectedVideos()

				SettingsGUI_ComboTitle_InitComboStrings(True)
				SettingsGUI_DrawCommonSettings(True,False)

			Case $SettingsGUI_ClearSettings_Button

				If Not $aVids_aActiveIdxs[0] Then
					$aVids[0][$C_aVids_idx2_OutputFolder] = $ini_C_def_OutputFolder
					$aVids[0][$C_aVids_idx2_OutputName] = $ini_C_def_OutFilename
					$aVids[0][$C_aVids_idx2_Command] = $ini_C_def_FFmpegCommand
					$aVids[0][$C_aVids_idx2_OutContainer] = $ini_C_def_OutContainer

					VideoList_ListView_ReDrawDefaults()
					Encoder_GUI_MSG_CurrentlyEncoding()

				Else

					For $a = 1 To $aVids_aActiveIdxs[0]
						If Not $aVids[$aVids_aActiveIdxs[$a]][$C_aVids_idx2_ProfileID] Then ContinueLoop
						aProfiles_Remove($aVids[$aVids_aActiveIdxs[$a]][$C_aVids_idx2_ProfileID])

						$aVids[$aVids_aActiveIdxs[$a]][$C_aVids_idx2_ProfileID] = ''

						If $VideoList_ListView Then
							_GUICtrlListView_SetItemText( _
							$VideoList_ListView, _ 									; $hWnd
							$aVids_aActiveIdxs[$a]-1, _ 								; $iIndex
							'', _ 													; $sText
							$C_VideoList_ListView_colidx_Profile) 					; $iSubItem
						EndIf



						For $a2 = $C_aVids_idx2_SharedSetStart To $C_aVids_idx2_SharedSetEnd
							$aVids[$aVids_aActiveIdxs[$a]][$a2] = ''
						Next

						If $VideoList_ListView Then VideoList_ListView_ReDrawDefaults_iDx($aVids_aActiveIdxs[$a])

						Encoder_GUI_MSG_CurrentlyEncoding($aVids_aActiveIdxs[$a])


					Next

					_ArraySort($aProfiles,1,1,$aProfiles[0][0],$C_aProfiles_idx2_VidCount)
					SettingsGUI_ComboTitle_InitComboStrings()
;~ 					SettingsGUI_ComboTitle_ReDraw()

				EndIf


				;If SettingsGUI_InitializeProfilesForActiveVideos() Then SettingsGUI_ComboTitle_ReDraw()

				SettingsGUI_DrawCommonSettings(True,True)





			#cs
			Case $SettingsGUI_Browse_Button


				GUIDisable($SettingsGUI_hParent)



				$tmp = FileSelectFolder('Select the folder where the converted video(s) will be saved',$ini_LastDir)
				If $tmp Then
					$ini_LastDir = $tmp
					IniWrite($ini,'MainGUI','LastDir',$ini_LastDir)
					$OutFolderPath = $tmp
					GUICtrlSetData($SettingsGUI_FolderPath_Input,$OutFolderPath)
				EndIf




				;GuiDisableEnable($SettingsGUI_hParent, 1)
				GUIEnable($SettingsGUI_hParent)
			#ce

			Case $SettingsGUI_DoanteButton_Pic
				ShellExecute($C_DonationLink)

		EndSwitch

		GUISwitch($SettingsGUI_hParent)
	EndFunc







#EndRegion

#Region string processing
	Func SettingsGUI_GetCleanCommand()
		Return ReplaceEntersInString(StringStripWS($SettingsGUI_FFmpegCommandText,3),'  ')
	EndFunc

	Func SettingsGUI_ConvertFFmpegCommandToGuiFormat( $FFmpegCommand)
		Return StringReplace($FFmpegCommand,'  ',@CRLF)
	EndFunc

#EndRegion

#Region Low level functions

	Func SettingsGUI_CtrlSetData($CtrlID, $sData, ByRef $CtrlColor,$bCombo = False);,$SetChangedString = '*')



		$sRead = GUICtrlRead($CtrlID)
		If $sRead = $sData Then Return



		Local $NewCtrlColor

		If $sData = '*' Then
			$NewCtrlColor = $C_BKColor_SetChanged
		Else
			$NewCtrlColor = $C_BKColor_SetUnChanged
		EndIf

		If $NewCtrlColor <> $CtrlColor Then
			GUICtrlSetBkColor($CtrlID,$NewCtrlColor)
			$CtrlColor = $NewCtrlColor
		EndIf


		If Not $bCombo Then
			GUICtrlSetData($CtrlID,$sData)
		Else
			GUICtrlSetData($CtrlID,$sData,$sData)
			GUICtrlSetState($CtrlID,$GUI_SHOW)
		EndIf


	EndFunc

	Func SettingsGUI_ChangeColor($hCtrl, ByRef $CurrentColor, $NewColor, $bCombo = False)
		If $CurrentColor = $NewColor Then Return
		GUICtrlSetBkColor($hCtrl,$NewColor)
		If $bCombo Then GUICtrlSetState($hCtrl,$GUI_SHOW)
	EndFunc


#EndRegion








#cs
Func SettingsGUI_ProcessLoop_WriteSettingsForVideos_I1($aVidsIndex,$aVids_idx2,$Data)
	Local $bVideoList_DrawOutputPath = False

	; On every shared set
	For $a = $C_aVids_idx2_SharedSettingsStart To $C_aVids_idx2_SharedSettingsEnd
		If $a = $aVids_idx2 Then


			If $VideoList_ListView And _
			Not $bVideoList_DrawOutputPath And _
			($a = $C_aVids_idx2_OutputFolder Or _
			$a = $C_aVids_idx2_OutputName Or _
			$a = $C_aVids_idx2_OutContainer) Then $bVideoList_DrawOutputPath = True

			$aVids[$aVidsIndex][$a] = $Data
		Else

			If $VideoList_ListView And _
			Not $bVideoList_DrawOutputPath And _
			($a = $C_aVids_idx2_OutputFolder Or _
			$a = $C_aVids_idx2_OutputName Or _
			$a = $C_aVids_idx2_OutContainer) And _
			$aVids[$aVidsIndex][$a] <> $aVids[0][$a] Then $bVideoList_DrawOutputPath = True

			If Not $aVids[$aVidsIndex][$a] Then $aVids[$aVidsIndex][$a] = $aVids[0][$a]
		EndIf

	Next

	If Not $VideoList_ListView Then Return

	If $bVideoList_DrawOutputPath Then
		; TODO: Code that will update the path in the listview-gui


	EndIf


EndFunc
#ce
#cs
Func SettingsGUI_UpdateSettings_FFmpegmpegCommand()
	;$tmp = ControlGetText($SettingsGUI_hGUI,'',$SettingsGUI_FFmpegmpegCommand_Edit)
	$tmp = GUICtrlRead($SettingsGUI_FFmpegCommand_Edit)
	If $tmp <> $FFmpegCommand Then

		$tmp = ReplaceEntersInString(StringStripWS($tmp,3),'  ')
		If $tmp <> $FFmpegCommand Then
			$FFmpegCommand = $tmp
			Return 1
		EndIf
	EndIf
EndFunc
#ce

;~ Func SettingsGUI_SaveSettings()

;~ 	Local $FFmpegCommand = SettingsGUI_ConvertFFmpegCommandToLineFormat($SettingsGUI_FFmpegCommandText)


;~ 	If $FFmpegCommand = '*' Then Return

;~ 	If Not $aVids_aActiveItems[0] Then
;~ 		$aVids[0][$C_aVids_idx2_Command] = $FFmpegCommand
;~ 		If $VideoList_ListView Then VideoList_ListView_UpdateFFmpegCommand(0)
;~ 	Else
;~ 		For $a = 1 To $aVids_aActiveItems[0]
;~ 			$aVids[$VideoList_aSelectedItems[$a]+1][$C_aVids_idx2_Command] = $FFmpegCommand
;~ 			If $VideoList_ListView Then VideoList_ListView_UpdateFFmpegCommand($VideoList_aSelectedItems[$a]+1)
;~ 		Next
;~ 	EndIf

;~ EndFunc


#cs
Func SettingsGUI_UpdateSettings()

	GUISwitch($SettingsGUI_hGUI)

	; Update the value of $FFCommand
	SettingsGUI_UpdateSettings_FFmpegmpegCommand()

	; Update the value of $OutContainer
	SettingsGUI_UpdateSettings_OutContainer()

	; Update the name preview
	SettingsGUI_UpdateSettings_OutputName()


	; Update $OutFolderPath
	SettingsGUI_UpdateSettings_FolderPath()

	GUISwitch($SettingsGUI_hParent)


EndFunc





Func SettingsGUI_UpdateSettings_OutputName()
	$tmp = StringStripWS(GUICtrlRead($SettingsGUI_Tab_Sheet_Filename_Input),3)
	If $tmp <> $FileName_Out Then
		$FileName_Out = $tmp
		ToolTip($FileName_Out)

		SettingsGUI_DrawOutFilenamePreview()

	EndIf
EndFunc



Func SettingsGUI_UpdateSettings_OutContainer()
	;$tmp = ControlGetText($SettingsGUI_hGUI,'',$SettingsGUI_Tab_Sheet_OutputFile_Container_Combo)
	$tmp = GUICtrlRead($SettingsGUI_Tab_Sheet_OutputFile_Container_Combo)
	If $tmp <> $OutContainer Then
		$tmp = StringStripWS($tmp,3)
		If $tmp <> $SettingsGUI_c_NO_CHANGE Then
			If StringLeft($tmp,1) <> '.' Then $tmp = '.'&$tmp
			If $tmp <> $OutContainer Then
				$OutContainer = $tmp
			EndIf
		Else
			$OutContainer = ''
		EndIf
		GUISwitch($SettingsGUI_hGUI)
		SettingsGUI_DrawOutFilenamePreview()
		GUISwitch($SettingsGUI_hParent)
	EndIf
EndFunc


Func SettingsGUI_UpdateSettings_FolderPath()
	;$tmp = StringStripWS(ControlGetText($SettingsGUI_hGUI,'',$SettingsGUI_FolderPath_Input),3)
	$tmp = StringStripWS(GUICtrlRead($SettingsGUI_FolderPath_Input),3)
	If $tmp <> $OutFolderPath Then
		$OutFolderPath = $tmp
		ToolTip($OutFolderPath)
	EndIf
EndFunc



Func SettingsGUI_CloseEvent()



EndFunc


#ce

;~ Func SettingsGUI_UpdateSettings_






