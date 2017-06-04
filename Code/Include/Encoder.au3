
#include 'Encoder_GUI.au3'


#Region Low-Level functions
	Func Encoder_cout($sText,$iEnter = 1,$iOffest = 0, $bWrite2EncoderGUIConsole = True)

		; Add " " before each line if we need to
			If $iOffest Then
				Local $aText = StringSplit($sText,@CRLF,1)
				If $aText[0] = 1 Then
					$sText = StrWriteChar(' ',$iOffest*5)&$sText
				Else
					$sText = ''
					For $a = 1 To $aText[0]
						$sText &= StrWriteChar(' ',$iOffest*5)&$aText[$a]
						If $a < $aText[0] Then $sText &= @CRLF
					Next
				EndIf
			EndIf

		; Add enters after $sText X times
			For $a = 1 To $iEnter
				$sText &= @CRLF
			Next


		; Print the data on the gui-encoder console
			If Not $bWrite2EncoderGUIConsole Then Return $sText ; But only if we need to
			Local $iEnd = StringLen(GUICtrlRead($Encoder_GUI_ffmpegOutput_Edit))
			_GUICtrlEdit_SetSel($Encoder_GUI_ffmpegOutput_Edit, $iEnd, $iEnd)
			_GUICtrlEdit_Scroll($Encoder_GUI_ffmpegOutput_Edit, $SB_SCROLLCARET)
			GUICtrlSetData($Encoder_GUI_ffmpegOutput_Edit,$sText,$iEnd)

		; We also return the text that we printed before
		Return $sText
	EndFunc


	Func Encoder_Job_Restart($bRestartOnly)


		Commander_TerminateAndDeleteJob($C_Encoder_JobID)
		Sleep(500)

		If FileDelete($Encoder_ActiveVid_sOutFilePath) Then

			Encoder_cout('restart encoding "'&$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_InputName]&'"',2)

			$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_EncoderStatus] = Null
			VideoList_ListView_UpdateEncodedStatus($Encoder_iActiveVidIndex)

			Encoder_Job_Step0($bRestartOnly)

		Else
			Encoder_cout(@CRLF&@CRLF&'ERROR: could not delete the video -> skipping to next video.',2)
			Encoder_Job_Step0()
		EndIf



	EndFunc

#EndRegion

#cs
	Getting files list in "D:\My Developments\Programs\Simple x265 Encoder\test sampels\source" ...
	X files found.
	Starting...

#ce


Func Encoder_Job_Start()

	; Reset some main values
		$Encoder_iEncodedFilesCount = 0
		$Encoder_bSuspended = False

	; Manage GUIs

		Encoder_GUI_Create() ; Create the encoder GUI


	; Cout to consoles
		Encoder_cout( _
			'Start encoding '&$aVids[0][0]&' videos'&@CRLF& _
			' (The number of videos can change if you add/delete videos during encoding)' _
		, 2)





		Local $bOverWriteMassage = True ; to show the massage only once
		$Encoder_iOverWriteFile = $C_Encoder_iOverWriteFile_Unseted

		For $a = 1 To $aVids[0][0] ; On every file

		; Reset the encoding status of any video and redraw it on the listview
			If $aVids[$a][$C_aVids_idx2_EncoderStatus] Then
				$aVids[$a][$C_aVids_idx2_EncoderStatus] = Null
				VideoList_ListView_UpdateEncodedStatus($a)
			EndIf

		; Set overwrite option
			If $bOverWriteMassage Then
				$tmp = aVids_GenerateRealFullFilePath($a)
				If FileExists($tmp) Then
					GUIDisable($MainGUI_hGUI)

					If MsgBox($MB_YESNO,'Message','Some files already exist.'&@CRLF&'Do you want to overwite them?',0,$Encoder_GUI_h) = $IDYES Then
						$Encoder_iOverWriteFile = $C_Encoder_iOverWriteFile_True
					Else
						$Encoder_iOverWriteFile = $C_Encoder_iOverWriteFile_False
					EndIf

					GUIEnable($MainGUI_hGUI)
					WinActivate($Encoder_GUI_h)

					$bOverWriteMassage = False
				EndIf
			EndIf

		Next


	;Return
	; Call to the function that will start the Job (Job in Commander)
	Encoder_Job_Step0()

EndFunc


Func Encoder_Job_End()


	; Close and delete the job from commander
		Commander_TerminateAndDeleteJob($C_Encoder_JobID)
		;Commander_TerminateAndDeleteActiveJob()

	; Disable some buttons on the encoder GUI and change them
		GUICtrlSetState($Encoder_GUI_SkipVideo_Button,$GUI_DISABLE)
		GUICtrlSetState($Encoder_GUI_SuspendResume_Button,$GUI_DISABLE)
		GUICtrlSetData($Encoder_GUI_Abort_Button,'Close')


	; Set the title of the encoder window to "Done"
		WinSetTitle($Encoder_GUI_h,Null,'Done')

	; Write a summary of the processing
		; TODO



	; Remember that we encode nothing
		Encoder_ReAllocate_ActiveVid()



	Return $C_Commander_Return
EndFunc




Func Encoder_Job_Step0($bJustRestart = False,$iCommanderPraiortyLevel = $C_PraiortyLevel_Encoder)

#Region comments
	#cs
		הכן את הפקודה לשלוח ל
		Commander
		ולבסוף הוסף את הגוב ל Commander
	#ce

	; Look for the video that we need to encode now

		#cs
			בנקודה זו הקוד צריך לבדוק אם יש לו עוד קובץ
			במידה וכן, זה ימשיך את העיבוד
			במידה ולא, זה יקרא ל FINISH
		#ce
#EndRegion

	; Set the title of the GUI
		WinSetTitle($Encoder_GUI_h,Null,'Encoding ...')




	If Not $bJustRestart Then

	; Reset vars about the active video that encoding
		Encoder_ReAllocate_ActiveVid()

	; Set $Encoder_sActiveVid and $Encoder_iActiveVidIndex
		For $a = 1 To $aVids[0][0]
			; look for the first file that the encoder did not touch
			If $aVids[$a][$C_aVids_idx2_EncoderStatus] Then ContinueLoop
			; we found some file so we go to work on this file
			$Encoder_iActiveVidIndex = $a
			ExitLoop
		Next

		 ; we did not found any file that the encoder did not touch. -> Encoder_Job_End ()
		If Not $Encoder_iActiveVidIndex Then Return Encoder_Job_End()

		$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_EncoderStatus] = '?'
		 VideoList_ListView_UpdateEncodedStatus($Encoder_iActiveVidIndex)

		#cs
			The software need to know what video is under encoding in case the user try to chage settings
			of video that is encoding at the moment
		#ce

		$Encoder_sActiveVid = $aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_InputPath]

	; Get the folder path of where the video will be saved
		Local $sOutFolderPath = aVids_GenerateRealFolderPath($Encoder_iActiveVidIndex)

	; Make sure that this foldor is exists. if not then create the folder now
		DirForseExists($sOutFolderPath)

	; Get the name of the output file
		$Encoder_ActiveVid_sOutFileName = aVids_GenerateRealFilename($Encoder_iActiveVidIndex)

	; Filepath of the output
		If StringRight($sOutFolderPath,1) <> '\' Then $sOutFolderPath &= '\'
		$Encoder_ActiveVid_sOutFilePath = $sOutFolderPath&$Encoder_ActiveVid_sOutFileName

	; Check if the input path is the same as the output path
		If FilePathIsEqual($Encoder_sActiveVid,$Encoder_ActiveVid_sOutFilePath) Then
			Encoder_cout("Error: input path can't be the same as the output path -> skipping video (encoding failed)",2,1)
			$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_EncoderStatus] = 'Error - skipped'
			VideoList_ListView_UpdateEncodedStatus($Encoder_iActiveVidIndex)
			Return Encoder_Job_Step0();Encoder_Job_SkipVideo($Encoder_iActiveVidIndex)
		EndIf

	; Print the file that begins to be processed
		Encoder_cout('File: '&$Encoder_ActiveVid_sOutFileName&' (output name)',2,0)

	; Check if the file is exists
		If FileExists($Encoder_ActiveVid_sOutFilePath) Then

			Local $bDeleteVideo

			Switch $Encoder_iOverWriteFile
				Case $C_Encoder_iOverWriteFile_True
					$bDeleteVideo = True
				Case $C_Encoder_iOverWriteFile_Unseted
					GUIDisable($MainGUI_hGUI)
					If 	MsgBox($MB_YESNO,'Message','Overwrite file:'&@CRLF&$Encoder_ActiveVid_sOutFilePath&@CRLF&'?'&@CRLF& _
						'(Message will close in 10 seconds with the answer "NO")',10) = $IDYES _
							Then $bDeleteVideo = True
					GUIEnable($MainGUI_hGUI)
					WinActivate($Encoder_GUI_h)

				Case $C_Encoder_iOverWriteFile_False
					$bDeleteVideo = False
			EndSwitch

			If $bDeleteVideo Then
				If Not FileDelete($Encoder_ActiveVid_sOutFilePath) Then
					Encoder_cout('Error: could not delete the file. skipping video (encoding failed)',2,1)
					$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_EncoderStatus] = 'Error - skipped'
					VideoList_ListView_UpdateEncodedStatus($Encoder_iActiveVidIndex)
					Return Encoder_Job_Step0();Encoder_Job_SkipVideo($Encoder_iActiveVidIndex)
				EndIf
			Else
				$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_EncoderStatus] = 'Skipped'
				VideoList_ListView_UpdateEncodedStatus($Encoder_iActiveVidIndex)
				Encoder_cout('Video file already exists -> skipped.',2,1)
				Return Encoder_Job_Step0();Encoder_Job_SkipVideo($Encoder_iActiveVidIndex)
			EndIf
		EndIf

	EndIf


	GUICtrlSetData($Encoder_GUI_SubProgress_Progress,0)


	; Get the command for this video. create the actual command for ffmpeg to encode the video
		Local $sCommand = $aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_Command]
		If Not $sCommand Then $sCommand = $aVids[0][$C_aVids_idx2_Command]

		#cs not optimized
		$sCommand = StringReplace($sCommand,'<input>','"'&$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath]&'"',1)
		$sCommand = StringReplace($sCommand,'<output>','"'&$sFolderPath&$sFile&'"',1)
		#ce


		; optimized
		$sCommand = StringReplace(StringReplace($sCommand,'<input>','"'&$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_InputPath] _
					&'"',1),'<output>','"'&$Encoder_ActiveVid_sOutFilePath&'"',1)

	;



	; Build the final JOB for commander.au4





		Commander_AddJob( _
				$FFmpegPath										, _ ; $ExeFile
				$sCommand											, _ ; $sCommand
				$C_Encoder_JobID										, _	; $JobID = Null
				$iCommanderPraiortyLevel							, _	; $iPraiortyLevel
				$Commander_C_MaxWaitTime_NoLimit						, _	; $iMaxWaitTime = Default
				False												, _	; $bTerminateOnMaxWaitTime = Default
				Encoder_Job_Step1									, _ ; $sStep1Func = Null
				$sCommand											, _ ; $aStep1Func_Args = Default
				Encoder_Job_Step2									, _ ; $sStep2Func = Null
				Default											, _ ; $aStep2Func_Args = Default
				Encoder_Job_Step3									, _ ; $sStep3Func = Null
				Default											, _ ; $aStep3Func_Args = Default
				Encoder_Job_Step4									, _; $sStep4Func = Null
				Default)											; $aStep4Func_Args = Default



EndFunc

#Region Actual functions that run with Commander.au3
	Func Encoder_Job_Step1($sCommand)


		; Update the position of the video in the array (in case it changed)
			Update_aVidsIdx1Var($Encoder_iActiveVidIndex,$Encoder_sActiveVid)
			If @error Then Return Encoder_Job_Step0() ; The video is no longer in the table


		Local Static $iGetDurationAttempts

		; Print the data of the video that began to be processed


			#cs
				First check if we have the duration of the video

				if not then we try to get the duartion $C_iMaxAttempts times

				if we succeeded we print the size, if not we try again and again until we reach $C_iMaxAttempts

			#ce

			Local Const $C_iMaxAttempts = 10

			If $aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_Duration_s] <= 0 Then


				; We try to get the size here. we count the attempts number
				$iGetDurationAttempts += 1

				If $iGetDurationAttempts <= $C_iMaxAttempts Then
					Encoder_cout('Getting duration (Attempt '&$iGetDurationAttempts&' of '&$C_iMaxAttempts&')',1,1) ; Print the attempt number

					#cs
						Add request (to commander.au3) to get the duration with praiorty level that is bigger then the
						praiorty level of this job. this is in order to place the job of the request before this job
						so the job of the request will run first and then this job will run again.
					#ce
					VideoInfo_InitializeRequest($Encoder_iActiveVidIndex,$Commander_aJobList[0][$C_Commander_idx_iPraiortyLevel])
					;_ArrayDisplay($Commander_aJobList)
				Else



					Encoder_cout('Error getting the video duration skipping video (encoding failed)',1,1)

					Encoder_Job_Step0();Encoder_Job_SkipVideo($r[$aVids_iDx1])

					$iGetDurationAttempts = 0
				EndIf

				Return $C_Commander_Return
			EndIf

			; In case we tried before to get the duration, we need to reset the attempts here
				$iGetDurationAttempts = 0



			Encoder_cout('Command: "'&$sCommand&'"',1,1)
			Encoder_cout('Input file: "'&$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_InputPath]&'"',1,1)
			Encoder_cout('Size: '&ByteSuffix($aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_OriginalSize]),1,2)
			Encoder_cout('Duration: '&Sec2Time($aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_Duration_s]),1,2)
			Encoder_cout('Output file: "'&$Encoder_ActiveVid_sOutFileName&'"',2,1)

			Encoder_cout('Running ffmpeg:',2,0)

		#cs
			At this point, after the return the Commander will call to Encoder_Job_Step2()
		#ce
	EndFunc


	Func Encoder_Job_Step2(ByRef $aComIn);, ByRef $r) ; r = array of parameters
		#cs
			Actions immediately after call to ffmpeg
		#ce
		; Update the position of the video in the array (in case it changed)
		Update_aVidsIdx1Var($Encoder_iActiveVidIndex,$Encoder_sActiveVid)
		If @error Then
			Encoder_Job_Step0()
			Return $C_Commander_Return
		EndIf


		If $aComIn[$Commander_C_output_idx_IsError] Then
			Encoder_cout('Error',2,1)
			Commander_TerminateAndDeleteActiveJob()
			Return $C_Commander_Return
		EndIf

		;Encoder_cout('ffmpeg output:',1,2)

		GUICtrlSetState($Encoder_GUI_SkipVideo_Button,$GUI_ENABLE)


		; Save the text of the console
		$Encoder_ConsoleSavedText = GUICtrlRead($Encoder_GUI_ffmpegOutput_Edit)
		$Encoder_ConsoleSavedText_Len = StringLen($Encoder_ConsoleSavedText)

		$Encoder_iWaitForFfmpegTimer = TimerInit()


	EndFunc

	Func Encoder_Job_Step3(ByRef $stdRead) ; r = array of parameters
		;ConsoleWrite('Encoder_Job_Step3' &' (L: '&@ScriptLineNumber&')'&@CRLF)
		#cs
			ביצוע פעולות בזמן הרצת הפקודה
		#ce


		If Not $stdRead Then
			If Not $Encoder_bSuspended Then
				If TimerDiff($Encoder_iWaitForFfmpegTimer) > 3600000 Then
					$Encoder_iCommanderErrorCount += 1
					Encoder_cout('Error: could not get output from ffmpeg for more than 1 minute -> attempt number '&$Encoder_iCommanderErrorCount&' of 3',0,1)
					If $Encoder_iCommanderErrorCount <= 3 Then
						Encoder_cout('attempt number '&$Encoder_iCommanderErrorCount&' of 3: ',0,1)
						Return Encoder_Job_Restart(True)
					Else
						Update_aVidsIdx1Var($Encoder_iActiveVidIndex,$Encoder_sActiveVid)
						If Not @error Then
							Encoder_cout(@CRLF&'too many attempts -> skipping video (failed to encode video)',1,1)
							$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_EncoderStatus] &= ' (skipped)'
							$aVids[0][$C_aVids_idx2_0_EncoderStatusExists] = Null
							VideoList_ListView_UpdateEncodedStatus($Encoder_iActiveVidIndex)
							Encoder_Job_Step0()
						EndIf
						Return $C_Commander_Return
					EndIf
				EndIf
			EndIf
			Return
		Else
			If $Encoder_bSuspended Then Commander_SuspendOrResumeExeProcess($Encoder_bSuspended,$C_PraiortyLevel_Encoder+1)
		EndIf

		$Encoder_iWaitForFfmpegTimer = TimerInit()



		; Update the position of the video in the array (in case it changed)
		Update_aVidsIdx1Var($Encoder_iActiveVidIndex,$Encoder_sActiveVid)
		If @error Then
			Encoder_Job_Step0()
			Return $C_Commander_Return
		EndIf

		$tmp = ffmpeg_state_Get($stdRead, 'time')
		If Not @error Then
			$tmp = TimeHMS_to_TimeS($tmp)
			If Not @error Then
				; Show the progress in the listview
				$tmp2 = Round(($tmp/$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_Duration_s])*100,3)&'%'
				If $tmp2 <> $aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_EncoderStatus] Then
					; Set the progress bar in the list view
						$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_EncoderStatus] = $tmp2
						VideoList_ListView_UpdateEncodedStatus($Encoder_iActiveVidIndex)
					; Set the title of the GUI with the progress bar
						WinSetTitle($Encoder_GUI_h,Null, _
						$tmp2&' , File '&$Encoder_iEncodedFilesCount+1&'/'&$aVids[0][0]&' , "'&$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_InputName]&'"')
				EndIf

				; Set the sub-progress bar, the progress bar of the current video that encoding
				GUICtrlSetData($Encoder_GUI_SubProgress_Progress,($tmp/$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_Duration_s])*100)

			EndIf
		EndIf


		; Print the ffmpeg output on the consoles
			; Print on the main console
				$tmp = Encoder_cout($stdRead,1,3,False)

			; Print on the encoder console
				GUICtrlSetData($Encoder_GUI_ffmpegOutput_Edit,$Encoder_ConsoleSavedText&$tmp)
				_GUICtrlEdit_SetSel($Encoder_GUI_ffmpegOutput_Edit, $Encoder_ConsoleSavedText_Len, $Encoder_ConsoleSavedText_Len)
				_GUICtrlEdit_Scroll($Encoder_GUI_ffmpegOutput_Edit, $SB_SCROLLCARET)




	EndFunc

	Func Encoder_Job_Step4(ByRef $aComIn) ; r = array of parameters

		; Update the position of the video in the array (in case it changed)
		Update_aVidsIdx1Var($Encoder_iActiveVidIndex,$Encoder_sActiveVid)
		If @error Then
			Encoder_Job_Step0()
			Return $C_Commander_Return
		EndIf

		; Fix the 99.9..% bug.. chage it to 100%
			If RemovePercentageMark($aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_EncoderStatus]) >= 99 Then
				$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_EncoderStatus] = '100%'
				VideoList_ListView_UpdateEncodedStatus($Encoder_iActiveVidIndex)
			EndIf



		; Update the main progress bar, the progress bar of all videos in the encoder
			$Encoder_iEncodedFilesCount += 1 ; We finished to encode the video so we count it here
			GUICtrlSetData($Encoder_GUI_TotalProgress_Progress,($Encoder_iEncodedFilesCount/$aVids[0][0])*100) ; reset it to 0

		; Update the sub-progress bar to 100%
			GUICtrlSetData($Encoder_GUI_SubProgress_Progress,100)


		; Write the encoding summary of this file
			Encoder_cout( _
			'Size: '&ByteSuffix($aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_OriginalSize])&' - > '&ByteSuffix(FileGetSize($Encoder_ActiveVid_sOutFilePath)), _
			2,1)


		; Restart the job
			Encoder_Job_Step0()


	EndFunc



#EndRegion


#cs
Func Encoder_Job_SkipVideo()
	$Encoder_iActiveVidIndex += 1
	If $Encoder_iActiveVidIndex <= $aVids[0][0] Then
		Encoder_cout(Null,3)
		Encoder_Job_Step0($Encoder_iActiveVidIndex)
	Else
		Encoder_Job_End()
	EndIf
EndFunc
#ce