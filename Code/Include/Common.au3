



#Region Load/Save Main Settings

	Func LoadMainSettings()
		#cs
			This function load the settings from the ini to the aVids table
		#ce

		;

			$ini_FFmpegFolder = GetSet('Main','FFmpegBinFolder',$ini_def_FFmpegFolder)
			If StringRight($ini_FFmpegFolder,1) <> '\' Then $ini_FFmpegFolder &= '\'

			$FFmpegPath = $ini_FFmpegFolder&'ffmpeg.exe'
			$FFprobePath = $ini_FFmpegFolder&'ffprobe.exe'

			$TmpFolder = GetSet('Main','TempDir',$TmpFolder_def)
			$TmpFolder = StringReplace($TmpFolder,$C_TempDirMark,@ScriptDir,1)
			If StringRight($TmpFolder,1) <> '\' Then $TmpFolder &= '\'
			If $TmpFolder = @ScriptDir&'\' Then $TmpFolder = $TmpFolder_def

			$ini_LastDir = GetSet('Main','LastDir',@ScriptDir)
			$LastDir = $ini_LastDir

			$ini_InputFileTypes = GetSet('Main','InputFileTypes',$ini_C_def_InputFileTypes)
			$InputFileTypes = $ini_InputFileTypes



		; Load defaults settings
			$ini_FFmpegCommand = GetSet('Main','FFmpegCommand',$ini_C_def_FFmpegCommand)
			$aVids[0][$C_aVids_idx2_Command] = $ini_FFmpegCommand

			$ini_OutContainer = GetSet('Main','Container',$ini_C_def_OutContainer)
			$aVids[0][$C_aVids_idx2_OutContainer] = $ini_OutContainer

			$ini_OutFilename =  GetSet('Main','OutFilename',$ini_C_def_OutFilename)
			$aVids[0][$C_aVids_idx2_OutputName] = $ini_OutFilename

			$ini_OutputFolder = GetSet('Main','OutputFolder',$ini_C_def_OutputFolder)
			$aVids[0][$C_aVids_idx2_OutputFolder] = $ini_OutputFolder


		; Load license agreement

			$ini_LicenseAgreement = Number(GetSet('Main','AgreLicense',0))





	EndFunc

	Func SaveMainSettings()



		; Write the ffmpeg command if there is new one
		If $aVids[0][$C_aVids_idx2_Command] <> $ini_FFmpegCommand Then _
		IniWrite($ini,'Main','FFmpegCommand',$aVids[0][$C_aVids_idx2_Command])


		; Write the container set
		If $aVids[0][$C_aVids_idx2_OutContainer] <> $ini_OutContainer Then _
		IniWrite($ini,'Main','Container',$aVids[0][$C_aVids_idx2_OutContainer])


		; Write the out filename set
		If $aVids[0][$C_aVids_idx2_OutputName] <> $ini_OutFilename Then _
		IniWrite($ini,'Main','OutFilename',$aVids[0][$C_aVids_idx2_OutputName])

		; Write the outputfolder
		If $aVids[0][$C_aVids_idx2_OutputFolder] <> $ini_OutputFolder Then _
		IniWrite($ini,'Main','OutputFolder',$aVids[0][$C_aVids_idx2_OutputFolder])


		; Write the input file types
		If $InputFileTypes <> $ini_InputFileTypes Then _
		IniWrite($ini,'Main','InputFileTypes',$InputFileTypes)


		If $LastDir <> $ini_LastDir Then IniWrite($ini,'Main','LastDir',$LastDir)

	EndFunc


#EndRegion

#Region FFmpeg video input processors
	Global Enum $C_VideoInfo_Receive_idx_aVids_iDx1, $C_VideoInfo_Receive_idx_InputPath, $C_VideoInfo_Receive_idxmax

	Func VideoInfo_InitializeRequest($aVids_iDx1,$l_Commander_iPraiortyLevel)


		#cs
		Commander_AddJob($ini_FFprobePath, _													; $ExeFile
					'-v error -show_format -show_streams "'&$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath]&'"', _				; $Command
					$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath], _															; $JobID = Null
					$l_Commander_iPraiortyLevel, _											; $iPraiortyLevel = 0
					'VideoInfo_Receive', _														; $sFunction = Null
					Default, _
					Default, _
					$aVids_iDx1 , _																; $Arg1 = Null
					$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath])															; $Arg2 = Null
		#ce

			Local $aVideoInfoReceive_aArgs[$C_VideoInfo_Receive_idxmax]
			$aVideoInfoReceive_aArgs[$C_VideoInfo_Receive_idx_aVids_iDx1] = $aVids_iDx1
			$aVideoInfoReceive_aArgs[$C_VideoInfo_Receive_idx_InputPath] = $aVids[$aVids_iDx1][$C_aVids_idx2_InputPath]

			Commander_AddJob( _
								$FFprobePath	, _; $ExeFile
								'-v error -show_format -show_streams "'&$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath]&'"'	, _; $sCommand
								$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath]	, _; $JobID = Null
								$l_Commander_iPraiortyLevel	, _; $iPraiortyLevel
								Default	, _; $iMaxWaitTime = Default
								False	, _; $bTerminateOnMaxWaitTime = Default
								Null	, _; $sStep1Func = Null
								Default	, _; $aStep1Func_Args = Default
								Null	, _; $sStep2Func = Null
								Default	, _; $aStep2Func_Args = Default
								Null	, _; $sStep3Func = Null
								Default	, _; $aStep3Func_Args = Default
								VideoInfo_Receive	, _; $sStep4Func = Null
								$aVideoInfoReceive_aArgs); $aStep4Func_Args = Default


	EndFunc



	Func VideoInfo_Receive($aComIn, ByRef $aVideoInfoReceive_aArgs)
		;Return
		; Update the position of the video in the array (in case it changed)
			Local $aVids_iDx1 = $aVideoInfoReceive_aArgs[$C_VideoInfo_Receive_idx_aVids_iDx1]
			Local $InputPath = $aVideoInfoReceive_aArgs[$C_VideoInfo_Receive_idx_InputPath]



			Update_aVidsIdx1Var($aVids_iDx1,$InputPath)
			If @error Then Return ; The video is no longer in the table


		; Get some info and write it in the aVids array

			StrDB_Load($aComIn[$Commander_C_output_idx_CmdRead]) ; Load the Ini object

			$tmp = StrDB_ini_GetSectionLine('FORMAT') ; tmp = the "FORMAT" section line
			$aVids[$aVids_iDx1][$C_aVids_idx2_Duration_s] = StrDB_Ini_Read(Null,'duration',-1,$tmp)

;~ 			If $aVids[$aVids_iDx1][$C_aVids_idx2_Duration_s] = -1 Then
;~ 				ConsoleWrite($aComIn[$Commander_C_output_idx_CmdRead] &' (L: '&@ScriptLineNumber&')'&@CRLF)
;~ 				Exit
;~ 			EndIf

			#cs	 code to get the codec name - not needed now becouse we don't have where to store in show this data
				$tmp = Str_Ini_GetSectionLine('STREAM','codec_type','video') ; tmp = the "STREAM" secion line where "codec_type" = "video"
				$l_VideoCodec_ShortName = Str_Ini_Read(Null,'codec_name',-1,$tmp)
			#ce
			StrDB_UnLoad() ; Unload the Ini object



		If $VideoList_ListView Then ; If the listview created
			; Draw on the list-view the following info about the video
				VideoList_ListView_UpdateTime($aVids_iDx1) ; The time
		EndIf



		If $aVids_aActiveIdxs[0] And $aVids_aActiveIdxs[1] = $aVids_iDx1 Then
			;We got info about the video that we need to show its preview frame

			PrMo_Frame_Update_ProcessJob()

		EndIf

	EndFunc

#EndRegion



#Region WM HANDLERS

	Func WM_SIZE($hWnd, $iMsg, $wParam, $lParam)
		#forceref $iMsg, $wParam
		Switch $hWnd
			Case $MainGUI_hGUI
				MainGUI_SizingEvent($hWnd, $iMsg, $wParam, $lParam)

			;Case $SettingsGUI_hGUI
		EndSwitch


		Return $GUI_RUNDEFMSG
	EndFunc   ;==>WM_SIZE


	Func WM_GETMINMAXINFO($hWnd, $iMsg, $wParam, $lParam)

		Switch $hWnd
			Case $MainGUI_hGUI
				Return MainGUI_EnforceMinSize($hWnd, $iMsg, $wParam, $lParam)
			;Case $SettingsGUI_hGUI

		EndSwitch

		Return 0
	EndFunc



	Func WM_DROPFILES_FUNC($hWnd, $msgID, $wParam, $lParam)

		GUIRegisterMsg($WM_DROPFILES, Null)

		If $VideoList_ListView Then
			GUIRegisterMsg($WM_NOTIFY, '')
			aVids_aActiveIdxs_UnActiveAll()
			For $a = 1 To $aVids[0][0]
				_GUICtrlListView_SetItemSelected($VideoList_ListView, $a-1, False,True)
			Next
		EndIf

		Local $nSize, $pFileName, $sFilePath, $sFileExtension;, $iVideoIndex;, $aDropFiles[0]
		Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
		For $i = 0 To $nAmt[0] - 1
			$nSize = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
			$nSize = $nSize[0] + 1
			$pFileName = DllStructCreate("char[" & $nSize & "]")
			DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", DllStructGetPtr($pFileName), "int", $nSize)

;VideoList_AddVideosFromFolder_GUI($p_sFolder = Null)

			; Get the file path
				$sFilePath = DllStructGetData($pFileName, 1)
				$pFileName = 0 ; Reset in to null
			; Check if the path is valid and if not then continue
				If Not FileExists($sFilePath) Then ContinueLoop

			If FileGetSize($sFilePath) Then ; If the file is a file
			; Get the extension of the file and check if we the program support the extension. only then, try to add it
				$sFileExtension = GetFileExtFromStr($sFilePath)
				If Not $sFileExtension Or Not StringInStr($ini_C_def_InputFileTypes,$sFileExtension) Then ContinueLoop
			; Add the video to aVids
				aVids_AddVideo($sFilePath) ; (It will add the video only if the video does not exists)
			;
				If @error Then ContinueLoop
			; Select this video in the list view
				$aVids_aActiveIdxs[0] += 1
				ReDim $aVids_aActiveIdxs[$aVids_aActiveIdxs[0]+1]
				$aVids_aActiveIdxs[$aVids_aActiveIdxs[0]] = $aVids[0][0]

				If Not $VideoList_ListView Then ContinueLoop
			; Draw the new video on the listview
				VideoList_ListView_AddNewVideo($aVids[0][0])

				_GUICtrlListView_SetItemSelected($VideoList_ListView, $aVids[0][0]-1, True, True)

			Else ; If the file is a folder
;~ 				GUIDisable($MainGUI_hGUI)
;~ 				Commander_SuspendOrResumeExeProcess(True,$C_PraiortyLevelMax-1)
				VideoList_AddVideosFromFolder_GUI($sFilePath,False)
				Do
					SOFTWARE_MAIN_LOOP()
				Until VideoList_AddVideosFromFolder_ProcessMsg()
;~ 				GUIEnable($MainGUI_hGUI)
;~ 				Commander_SuspendOrResumeExeProcess(False,$C_PraiortyLevelMax-1)

			; Select the last video in the list view
				$aVids_aActiveIdxs[0] += 1
				ReDim $aVids_aActiveIdxs[$aVids_aActiveIdxs[0]+1]
				$aVids_aActiveIdxs[$aVids_aActiveIdxs[0]] = $aVids[0][0]
				If $VideoList_ListView Then _
					_GUICtrlListView_SetItemSelected($VideoList_ListView, $aVids[0][0]-1, True, True)
			EndIf


		Next

		; Update the common path
			Local $tmp = aVids_UpdateCommonPath()

		; If there is listview then
			If $VideoList_ListView Then
				If $tmp Then VideoList_ListView_ReDrawFullOutputPathForAllVids()
				VideoList_ListView_ResizeColumns1()

				GUIRegisterMsg($WM_NOTIFY, VideoList_WM_NOTIFY)
			EndIf

		VideoList_ItemsChangedEvent()

		; ReInit and Redraw the combotitle in GUISettings
			SettingsGUI_ComboTitle_InitComboStrings()
			SettingsGUI_ComboTitle_ReDraw()

		GUIRegisterMsg($WM_DROPFILES, WM_DROPFILES_FUNC)

	EndFunc



#EndRegion


Func LoadFilesOnStartUp()
	If Not $CmdLine[0] Then Return

	For $a = 1 To $CmdLine[0]
		aVids_AddVideo($CmdLine[$a])
	Next

	aVids_UpdateCommonPath()
EndFunc





Func Update_aVidsIdx1Var(ByRef $aVids_iDx1, $sInputFilePath)
	$iSize = UBound($aVids)-1
	If $iSize <> $aVids[0][0] Then
		$aVids[0][0] = $iSize
	EndIf
	If Not $iSize Then Return SetError(1)
	If $aVids_iDx1 <= $iSize And $aVids[$aVids_iDx1][$C_aVids_idx2_InputPath] = $sInputFilePath Then Return
	For $a = 1 To $iSize
		If $aVids[$a][$C_aVids_idx2_InputPath] = $sInputFilePath Then
			$aVids_iDx1 = $a
			Return
		EndIf
	Next
	Return SetError(1)
EndFunc



Func DeleteSupTempsFolders()
	DirRemove($PrMo_TmpFolder,1)


EndFunc






