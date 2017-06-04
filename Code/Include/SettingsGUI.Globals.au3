
; Constants:
	; GUI Draws
		Global Const $C_SettingsGUI_xySpace = 5


Global $SettingsGUI_hParent ; the perent window of the settings window. the perent where the settings window will be created on
Global $SettingsGUI_hGUI = -1 ; The sub window handle

	Global $SettingsGUI_ComboTitle ; the title above the tab of the settings. the title that show all the video files + profiles...

		; Editable texts:
			Global $SettingsGUI_ComboTitle_SelectedStringText; = $C_SettingsGUI_ComTitle_EditDefaultSettingsText

		; Controls of the Editable texts:
			Global $SettingsGUI_ComboTitle_Strings

		; Other
			;Global $SettingsGUI_ComboTitle_aOldActiveIdx[1] = [0]
			;Global $SettingsGUI_bDefaultMode

			Global $SettingsGUI_ComboTitle_CostumeSelectionProfile
			Global $SettingsGUI_ComboTitle_CostumeSelectionActiveIdxs[1] = [0]


			Global Const $C_SettingsGUI_ComTitle_EditDefaultSettingsText = 'Edit default settings'
			Global Const $C_SettingsGUI_ComTitle_NoProfileVideoText = 'Videos without profile'




	Global $SettingsGUI_Tab ; handle to the tab in the window  --------------------------- SETTINGS TABS

		Global $SettingsGUI_Tab_xSize


		Global $SettingsGUI_Command_TabSheet ; command tab sheet

			; Editable texts:
				Global $SettingsGUI_FFmpegCommandText

			; Controls of the Editable texts:
				Global $SettingsGUI_FFmpegCommand_Edit ; the edit control that show the command
				Global $SettingsGUI_FFmpegCommand_EditColor = $C_BKColor_SetUnChanged



		Global $SettingsGUI_Output_TabSheet ; the output tab sheet


			; Editable texts:
				Global $SettingsGUI_OutputFolderText ; Display
				Global $SettingsGUI_VideoNameText ; Display
				Global $SettingsGUI_OutputContainerText ; The selected container in the list. (Display)

			; Other
				Global $SettingsGUI_bShowPreviewInfo




			; Controls of the Editable texts:
				Global $SettingsGUI_OutputContainer_Combo, _ ; The combo that list the containers options
						$SettingsGUI_OutputContainer_ComboColor = $C_BKColor_SetUnChanged
				Global $SettingsGUI_VideoName_Input, _ ; The input where the user type the name of the video
						$SettingsGUI_VideoName_InputColor = $C_BKColor_SetUnChanged
				Global $SettingsGUI_OutputFolder_Input, _
						$SettingsGUI_OutputFolder_InputColor = $C_BKColor_SetUnChanged
				Global $SettingsGUI_OutputFolder_Button
				Global $SettingsGUI_FullSavePath_Input



			; Labels:
				Global $SettingsGUI_VideoNamePreview_Label
				Global $SettingsGUI_OutputFolderPreview_Label
				Global $SettingsGUI_FullSavePath_Label


			; Other
				Global Const $C_SettingsGUI_PreviewString = 'Preview: '

	; Low area

		; Donate button
			Global $SettingsGUI_DoanteButton_Pic

			Global $SettingsGUI_SaveToDefaults_Button
				Global $SettingsGUI_SaveToDefaults_ButtonState = $GUI_ENABLE
			Global $SettingsGUI_SaveToSelected_Button
				Global $SettingsGUI_SaveToSelected_ButtonState = $GUI_ENABLE
			Global $SettingsGUI_ClearSettings_Button





