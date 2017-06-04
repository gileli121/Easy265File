

#Region functions to implement some features under the menu

	#Region SaveTasks
	Func SaveTasks($sOutputFilePath)
		; Create the string that is the file we going to save
			StrDB_UnLoad()

		; Create section of the default settings
			Local $iDefaultSecIndex = StrDB_Ini_WriteSection('DefaultSettings')
			StrDB_Ini_Write(Null, 'OutputFolder',$aVids[0][$C_aVids_idx2_OutputFolder],$iDefaultSecIndex)
			StrDB_Ini_Write(Null, 'OutputName',$aVids[0][$C_aVids_idx2_OutputName],$iDefaultSecIndex)
			StrDB_Ini_Write(Null, 'Command',$aVids[0][$C_aVids_idx2_Command],$iDefaultSecIndex)
			StrDB_Ini_Write(Null, 'OutContainer',$aVids[0][$C_aVids_idx2_OutContainer],$iDefaultSecIndex)

		; Create section with the profiles we we need to
			If $aProfiles[0][0] Then
				; Create the section of the profiles
				Local $iSecIndex = StrDB_Ini_WriteSection('Profiles')

				; Write the profiles in the section
				For $a = 1 To $aProfiles[0][0]
					StrDB_Ini_Write(Null, $aProfiles[$a][$C_aProfiles_idx2_nID], _
					SaveTasks_GenerateProfileSettingsString($a), _
					$iSecIndex)
				Next

			EndIf

		; Write the data of aVids
			If $aVids[0][0] Then
				; Create the array to write into the string
				Local $aVideosToSave[$aVids[0][0]]
				For $a = 0 To UBound($aVideosToSave)-1
					$aVideosToSave[$a] = SaveTasks_GenerateVideoSettingsString($a+1)
				Next

				$iVideosIndx = StrDB_Array_Create('Videos') ; Create the array of the videos
				StrDB_Array_WriteArray($iVideosIndx,$aVideosToSave, 0)
			EndIf

		; Get the text we need to write on the file
			Local $File_s = StrDB_GetFullString()

		; Clean the memory in StrDB
			StrDB_UnLoad()

		; Save the data in to the our file
			Local $File_h = FileOpen($sOutputFilePath,$FO_OVERWRITE+$FO_CREATEPATH)
			If $File_h = -1 Then Return SetError(1)
			If Not FileWrite($File_h,$File_s) Then SetError(2)
			FileClose($File_h)

	EndFunc

	Func SaveTasks_GenerateProfileSettingsString($Profile_iDx)

	#cs
		$C_aProfiles_idx2_VidCount, _
		$C_aProfiles_idx2_Command, _
		$C_aProfiles_idx2_OutputName, _
		$C_aProfiles_idx2_OutputFolder, _
		$C_aProfiles_idx2_OutContainer, _


	#ce

		Local $sOut
		$sOut &= 'VidCount='&$aProfiles[$Profile_iDx][$C_aProfiles_idx2_VidCount]
		$sOut &= '|@|Command='&$aProfiles[$Profile_iDx][$C_aProfiles_idx2_Command]
		$sOut &= '|@|OutputName='&$aProfiles[$Profile_iDx][$C_aProfiles_idx2_OutputName]
		$sOut &= '|@|OutputFolder='&$aProfiles[$Profile_iDx][$C_aProfiles_idx2_OutputFolder]
		$sOut &= '|@|OutContainer='&$aProfiles[$Profile_iDx][$C_aProfiles_idx2_OutContainer]


		Return $sOut




	EndFunc

	Func SaveTasks_GenerateVideoSettingsString($aVids_iDx)


		Local $sOut
		$sOut = 'Path='&$aVids[$aVids_iDx][$C_aVids_idx2_InputPath]
		If $aVids[$aVids_iDx][$C_aVids_idx2_ProfileID] Then _
		$sOut &= '|@|profile='&$aVids[$aVids_iDx][$C_aVids_idx2_ProfileID]
		If $aVids[$aVids_iDx][$C_aVids_idx2_Duration_s] Then _
		$sOut &= '|@|duration='&$aVids[$aVids_iDx][$C_aVids_idx2_Duration_s]
		If $aVids[$aVids_iDx][$C_aVids_idx2_EncoderStatus] Then _
		$sOut &= '|@|status='&$aVids[$aVids_iDx][$C_aVids_idx2_EncoderStatus]


		Return $sOut




	EndFunc

	#EndRegion



	#Region LoadTasks
	Func LoadTasks($TasksFile_Path)


		; Read the file of the tasks into the memory
			; Get the text of the file into $TasksFile_Text
			Local $TasksFile_Text = FileRead($TasksFile_Path)
			If @error Then Return SetError(1)
			; Load it into StrDB_*
			StrDB_Load($TasksFile_Text)


		; Delete all videos in case we have some
			If $aVids[0][0] Then VideoList_DeleteAll()


		; Load the default settings into $aVids
			; Get the index-line of the 'DefaultSettings' section
			$tmp = StrDB_ini_GetSectionLine('DefaultSettings')

			$aVids[0][$C_aVids_idx2_OutputFolder] = StrDB_Ini_Read(Null,'OutputFolder',$ini_C_def_OutputFolder,$tmp)
			$aVids[0][$C_aVids_idx2_OutputName] = StrDB_Ini_Read(Null,'OutputName',$ini_C_def_OutFilename,$tmp)
			$aVids[0][$C_aVids_idx2_Command] = StrDB_Ini_Read(Null,'Command',$ini_C_def_FFmpegCommand,$tmp)
			$aVids[0][$C_aVids_idx2_OutContainer] = StrDB_Ini_Read(Null,'OutContainer',$ini_C_def_OutContainer,$tmp)


		; Add all the videos into aVids
			; Reset $aProfiles
			If $aProfiles[0][0] Then
				$aProfiles[0][0] = 0
				ReDim $aProfiles[1][$C_aProfiles_idx2max]
			EndIf

			; Load the profiles from the file
			$tmp = StrDB_ini_GetSectionLine('Profiles')
			Local $TasksFile_aProfiles = StrDB_Ini_ReadSection($tmp)
			;_ArrayDisplay($TasksFile_aProfiles)


			; Load the array of the videos
			Local $Videos_ArrayIdx = StrDB_Array_GetIndex('Videos')
			If $Videos_ArrayIdx = -1 Then Return ; in case there are no videos we return here

			Local $Videos_aArray = StrDB_Array_Read($Videos_ArrayIdx)
			If Not $Videos_aArray[0] Then Return ; in case there are no videos we return here


			Local $iError, $sVideoPath, $iVideoDuration, $VideoProfile, $sEncodeStatus

			For $a = 1 To $Videos_aArray[0]
				; Load the line as standard ini string
					$tmp = StringReplace($Videos_aArray[$a],'|@|',@CRLF)
					StrDB_Load($tmp)

				; Read the data

					$sVideoPath = StrDB_Ini_Read(Null,'Path',Null,0)
					If Not $sVideoPath Then
						$iError = 2
						ContinueLoop
					EndIf

					$iVideoDuration = Number(StrDB_Ini_Read(Null,'duration',-1,0))
					If $iVideoDuration = -1 Then
						aVids_AddVideo($sVideoPath)
					Else
						aVids_AddVideo($sVideoPath,$iVideoDuration)
					EndIf
					If @error Then
						$iError = 2
						ContinueLoop
					EndIf


					$sEncodeStatus = StrDB_Ini_Read(Null,'status',Null,0)
					If $sEncodeStatus Then
						$aVids[$aVids[0][0]][$C_aVids_idx2_EncoderStatus] = $sEncodeStatus
						$aVids[0][$C_aVids_idx2_0_EncoderStatusExists] = True
					EndIf


					$VideoProfile = StrDB_Ini_Read(Null,'profile',Null,0)
					If Not $VideoProfile Then ContinueLoop

				; Set the profile to the video




					; Look for the profile in aProfiles and if we didnt found it, add it to the table
					Local $iProfileIdx = _ArraySearch($aProfiles,$VideoProfile,1,$aProfiles[0][0],0,0,1,$C_aProfiles_idx2_nID)
					If $iProfileIdx <= 0 Then

						$tmp = _ArraySearch($TasksFile_aProfiles,$VideoProfile,1,$TasksFile_aProfiles[0][0],0,0,1,0)
						If $tmp = -1 Then ContinueLoop ; Error - we didn't found the settings of the profile so we not load it in to the video
						$tmp2 = StringReplace($TasksFile_aProfiles[$tmp][1],'|@|',@CRLF)
						StrDB_Load($tmp2)

						$aProfiles[0][0] += 1
						ReDim $aProfiles[$aProfiles[0][0]+1][$C_aProfiles_idx2max]
						$iProfileIdx = $aProfiles[0][0]

						$aProfiles[$iProfileIdx][$C_aProfiles_idx2_nID] = $VideoProfile
						$aProfiles[$iProfileIdx][$C_aProfiles_idx2_VidCount] = StrDB_Ini_Read(Null,'VidCount',Null,0)
						$aProfiles[$iProfileIdx][$C_aProfiles_idx2_Command] = StrDB_Ini_Read(Null,'Command',Null,0)
						$aProfiles[$iProfileIdx][$C_aProfiles_idx2_OutputName] = StrDB_Ini_Read(Null,'OutputName',Null,0)
						$aProfiles[$iProfileIdx][$C_aProfiles_idx2_OutputFolder] = StrDB_Ini_Read(Null,'OutputFolder',Null,0)
						$aProfiles[$iProfileIdx][$C_aProfiles_idx2_OutContainer] = StrDB_Ini_Read(Null,'OutContainer',Null,0)


					EndIf

					$aVids[$aVids[0][0]][$C_aVids_idx2_ProfileID] = $VideoProfile

					$aVids[$aVids[0][0]][$C_aVids_idx2_Command] = $aProfiles[$iProfileIdx][$C_aProfiles_idx2_Command]
					$aVids[$aVids[0][0]][$C_aVids_idx2_OutputName] = $aProfiles[$iProfileIdx][$C_aProfiles_idx2_OutputName]
					$aVids[$aVids[0][0]][$C_aVids_idx2_OutputFolder] = $aProfiles[$iProfileIdx][$C_aProfiles_idx2_OutputFolder]
					$aVids[$aVids[0][0]][$C_aVids_idx2_OutContainer] = $aProfiles[$iProfileIdx][$C_aProfiles_idx2_OutContainer]


			Next

			aVids_UpdateCommonPath()

			; Draw all videos from aVids in the listview and show them correcty
			If $VideoList_ListView Then VideoList_ListView_AddVideosFromaVids()

			StrDB_UnLoad()

			SettingsGUI_ComboTitle_InitComboStrings(True)
			SettingsGUI_DrawCommonSettings(True)

			Return SetError($iError)



	EndFunc



	#EndRegion



	#Region Change FFmpeg folder
		Func SetFFmpegFolder_GUI()
			Local Enum $hGUI, $FFmpegPath_Input, $Done_Button, $Browse_Button, $p_max
			Local $p[$p_max]


			GUIDisable($MainGUI_hGUI)
			GUICtrlSetState($Menu_Options_FFmpegDir,$GUI_DISABLE)



			Local Const $C_xSize = 486, $C_ySize = 131
			Local $xPos = -1, $yPos = -1
			GUIGetXYtoOpenOnCenter($MainGUI_hGUI,$xPos,$yPos, $C_xSize, $C_ySize)
			$p[$hGUI] = GUICreate("Set the FFmpeg bin folder path",$C_xSize,$C_ySize, $xPos, $yPos,-1,-1,$MainGUI_hGUI)

			GUICtrlCreateLabel("Write here the path to where ffmpeg.exe and ffprobe.exe located:", 8, 16, 468, 23)
			GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
			$p[$FFmpegPath_Input] = GUICtrlCreateInput($ini_FFmpegFolder, 8, 48, 361, 21)
			$p[$Done_Button] = GUICtrlCreateButton("Done", 168, 88, 145, 33)
			GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
			$p[$Browse_Button] = GUICtrlCreateButton("Browse", 384, 47, 83, 25)

			GUISetState(@SW_SHOW)

			SetFFmpegFolder_GUI_ProcessMsg($p)
			aExtraFuncCalls_AddFunc(SetFFmpegFolder_GUI_ProcessMsg)




		EndFunc


		Func SetFFmpegFolder_GUI_ProcessMsg($p = Default)
			Local Enum $hGUI, $FFmpegPath_Input, $Done_Button, $Browse_Button, $p_max
			Local Static $ps
			If $p <> Default Then
				$ps = $p
				Return
			EndIf


			If $GUI_MSG[$C_GUIMsg_idx1_hGUI] <> $ps[$hGUI] Then Return

			Switch $GUI_MSG[$C_GUIMsg_idx1_ControlID]


				Case $ps[$Browse_Button]


					;Commander_SuspendOrResumeExeProcess(True,$C_PraiortyLevelMax-1)
					$tmp = FileSelectFolder('Select the folder where ffmpeg.exe and ffprobe.exe located',@ScriptDir)
					;Commander_SuspendOrResumeExeProcess(False,$C_PraiortyLevelMax-1)
					If Not $tmp Then Return
					GUICtrlSetData($ps[$FFmpegPath_Input],$tmp)

				Case $ps[$Done_Button]
					; Get the path string from the GUI
						$tmp = StringStripWS(GUICtrlRead($ps[$FFmpegPath_Input]),3)

					; Check for error before write the new path
						If Not $tmp Then _
						Return TooTip_ShowMassageAboveCtrl($ps[$hGUI], $ps[$FFmpegPath_Input], 'Error: Nothing written here')

						If StringRight($tmp,1) <> '\' Then $tmp &= '\'

						$tmp2 = $tmp&'ffmpeg.exe'
						If Not FileExists($tmp2) Then _
						Return TooTip_ShowMassageAboveCtrl($ps[$hGUI], $ps[$FFmpegPath_Input], 'Error: ffmpeg.exe not found in this folder')
						$FFmpegPath = $tmp2


						$tmp2 = $tmp&'ffprobe.exe'
						If Not FileExists($tmp2) Then _
						Return TooTip_ShowMassageAboveCtrl($ps[$hGUI], $ps[$FFmpegPath_Input], 'Error: ffmpeg.exe found, but not ffprobe.exe'&@CRLF&'You need also ffprobe.exe')
						$FFprobePath = $tmp2


					; Write and set the path
						$ini_FFmpegFolder = $tmp
						IniWrite($ini,'Main','FFmpegBinFolder',$ini_FFmpegFolder)

					; Continue to the next case - $GUI_EVENT_CLOSE
						ContinueCase
				Case $GUI_EVENT_CLOSE
					ToolTip_Off()
					GUIDelete($ps[$hGUI])
					GUICtrlSetState($Menu_Options_FFmpegDir,$GUI_ENABLE)
					$tmp = $ini_FFmpegFolder
					If StringRight($tmp,1) <> '\' Then $tmp &= '\'
					If Not FileExists($tmp&'ffmpeg.exe') Or Not FileExists($tmp&'ffprobe.exe') Then SOFTWARE_SHUTDOWN()


					;aExtraFuncCalls_RemoveFunc(SetFFmpegFolder_GUI_ProcessMsg)
					;$ps = Null

					GUIEnable($MainGUI_hGUI)

					Return True ; Return true to not call his function again from the main loop next time
			EndSwitch



		EndFunc


	#EndRegion



	#Region Change Temp folder
	Func ChangeTempFolder_GUI()
		Local Enum $hGUI, $TempFolder_Input, $Done_Button, $Browse_Button, $p_max
		Local $p[$p_max]

		GUICtrlSetState($Menu_Options_ChangeTMP,$GUI_DISABLE)

		Local Const $C_xSize = 486, $C_ySize = 131
		Local $xPos = -1, $yPos = -1
		GUIGetXYtoOpenOnCenter($MainGUI_hGUI,$xPos,$yPos, $C_xSize, $C_ySize)
		$p[$hGUI] = GUICreate("Set folder for temporary files", $C_xSize, $C_ySize, $xPos, $yPos,-1,-1,$MainGUI_hGUI)


		GUICtrlCreateLabel("Write here the path to where the temporary files will be stored", 8, 16, 445, 23)
		GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")



		$p[$TempFolder_Input] = GUICtrlCreateInput($TmpFolder, 8, 48, 361, 21)
		$p[$Done_Button] = GUICtrlCreateButton("Done", 168, 88, 145, 33)
		GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
		$p[$Browse_Button] = GUICtrlCreateButton("Browse", 384, 47, 83, 25)
		GUISetState(@SW_SHOW)

		ChangeTempFolder_GUI_ProcessMsg($p)
		aExtraFuncCalls_AddFunc(ChangeTempFolder_GUI_ProcessMsg)

	EndFunc

	Func ChangeTempFolder_GUI_ProcessMsg($p = Default)
		Local Enum $hGUI, $TempFolder_Input, $Done_Button, $Browse_Button, $p_max
		Local Static $ps
		If $p <> Default Then
			$ps = $p
			Return
		EndIf

		If $GUI_MSG[$C_GUIMsg_idx1_hGUI] <> $ps[$hGUI] Then Return

		Switch $GUI_MSG[$C_GUIMsg_idx1_ControlID]


			Case $ps[$Browse_Button]
				;Commander_SuspendOrResumeExeProcess(True,$C_PraiortyLevelMax-1)
				$tmp = FileSelectFolder('Select the folder where the temporary files will be stored',@ScriptDir)
				;Commander_SuspendOrResumeExeProcess(False,$C_PraiortyLevelMax-1)
				If Not $tmp Then Return
				GUICtrlSetData($ps[$TempFolder_Input],$tmp)

			Case $ps[$Done_Button]
				; Get the path string from the GUI
					$tmp = StringStripWS(GUICtrlRead($ps[$TempFolder_Input]),3)

				; Check for error before write the new path
					If Not $tmp Then _
					Return TooTip_ShowMassageAboveCtrl($ps[$hGUI], $ps[$TempFolder_Input], 'Error: Nothing written here')

;~ 					If Not FileExists($tmp) Then _
;~ 					Return TooTip_ShowMassageAboveCtrl($ps[$hGUI], $ps[$TempFolder_Input], 'Error: Folder does not exist')


				; Write and set the path

					$tmp = StringReplace($tmp,$C_TempDirMark,@ScriptDir,1)
					If StringRight($tmp,1) <> '\' Then $tmp &= '\'

					If $tmp = @ScriptDir&'\' Then _
					Return TooTip_ShowMassageAboveCtrl($ps[$hGUI], $ps[$TempFolder_Input], "Error: temp folder can't be the software folder")


					If $tmp <> $TmpFolder Then




						$TmpFolder = $tmp
						PrMo_Frame_CleanTemp()

						PreviewModule_InitializeTempFolder()

						DirForseExists($PrMo_TmpFolder)

						PrMo_Frame_Update()

						IniWrite($ini,'Main','TempDir',StringReplace($TmpFolder,@ScriptDir,$C_TempDirMark,1))
					EndIf

				; Continue to the next case - $GUI_EVENT_CLOSE
					ContinueCase
			Case $GUI_EVENT_CLOSE
				ToolTip_Off()
				GUIDelete($ps[$hGUI])
				GUICtrlSetState($Menu_Options_ChangeTMP,$GUI_ENABLE)

				;$ps = Null
				Return True ; Return true to not call his function again from the main loop next time
		EndSwitch

	EndFunc

	#EndRegion



	#Region Output preview - before & after the requested time - encode time settings
		Func OutputPreviewSetTimes_GUI()
			Local Enum $hGUI, $Before_Input, $After_Input, $Done_Button, $p_max
			Local $p[$p_max]

			GUICtrlSetState($Menu_Options_OutputPreview,$GUI_DISABLE)


			Local Const $C_xSize = 609, $C_ySize = 120
			Local $xPos = -1, $yPos = -1
			GUIGetXYtoOpenOnCenter($MainGUI_hGUI,$xPos,$yPos, $C_xSize, $C_ySize)
			$p[$hGUI] = GUICreate("Output preview settings", $C_xSize, $C_ySize, $xPos, $yPos,-1,-1,$MainGUI_hGUI)

			GUICtrlCreateLabel("Seconds to encode before the requested time:", 8, 16, 337, 23)
			GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
			GUICtrlCreateLabel("The bigger the number, the bigger accuracy of the preview (in case the video compression algorithm use motion)", 24, 44, 413, 36)
			GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
			GUICtrlSetColor(-1, 0x0066CC)
			$p[$Before_Input] = GUICtrlCreateInput($PrMo_ini_ProcessBefore, 352, 14, 89, 27, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
			GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
			GUICtrlCreateLabel("Seconds to encode after the requested time:", 8, 80, 316, 23)
			GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
			$p[$After_Input] = GUICtrlCreateInput($PrMo_ini_ProcessAfter, 352, 78, 89, 27, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
			GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
			$p[$Done_Button] = GUICtrlCreateButton("Done", 464, 12, 129, 97)
			GUICtrlSetFont(-1, 20, 400, 0, "Tahoma")
			GUISetState(@SW_SHOW)

			OutputPreviewSetTimes_GUI_ProcessMsg($p)
			aExtraFuncCalls_AddFunc(OutputPreviewSetTimes_GUI_ProcessMsg)

		EndFunc


		Func OutputPreviewSetTimes_GUI_ProcessMsg($p = Default)
			Local Enum $hGUI, $Before_Input, $After_Input, $Done_Button, $p_max
			Local Static $ps
			If $p <> Default Then
				$ps = $p
				Return
			EndIf

			If $GUI_MSG[$C_GUIMsg_idx1_hGUI] <> $ps[$hGUI] Then Return

			Switch $GUI_MSG[$C_GUIMsg_idx1_ControlID]

				Case $ps[$Done_Button]
					Local Const $sErrorMsg1 = "Error: can't be 0 or empty"

					Local $iBefore = Number(GUICtrlRead($ps[$Before_Input]))
					If Not $iBefore Then _
					Return TooTip_ShowMassageAboveCtrl($ps[$hGUI], $ps[$Before_Input],$sErrorMsg1)



;~ 					$tmp = Number(GUICtrlRead($ps[$After_Input]))
;~ 					If Not $tmp Then _
;~ 					Return TooTip_ShowMassageAboveCtrl($ps[$hGUI], $ps[$After_Input],$sErrorMsg1)
;~ 					$PrMo_ini_ProcessAfter = $tmp

					Local $iAfter = Number(GUICtrlRead($ps[$After_Input]))

					If $iBefore <> $PrMo_ini_ProcessBefore Or $iAfter <> $PrMo_ini_ProcessAfter Then

						PrMo_Frame_CleanTemp()
						DirForseExists($PrMo_TmpFolder)

						If $iBefore <> $PrMo_ini_ProcessBefore Then
							$PrMo_ini_ProcessBefore = $iBefore
							IniWrite($ini,'Preview','ProcessBefore',$iBefore)
						EndIf
						If $iAfter <> $PrMo_ini_ProcessAfter Then
							$PrMo_ini_ProcessAfter = $iAfter
							IniWrite($ini,'Preview','ProcessAfter',$iAfter)
						EndIf

					EndIf

					ContinueCase
				Case $GUI_EVENT_CLOSE
					ToolTip_Off()



					GUIDelete($ps[$hGUI])
					GUICtrlSetState($Menu_Options_OutputPreview,$GUI_ENABLE)
					;aExtraFuncCalls_RemoveFunc(OutputPreviewSetTimes_GUI_ProcessMsg)
					;$ps = Null
					Return True ; Return true to not call his function again from the main loop next time
			EndSwitch

		EndFunc
	#EndRegion




#EndRegion