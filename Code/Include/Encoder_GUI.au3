
Func Encoder_GUI_Create()

	GUICtrlSetState($MainGUI_StartEncude_Button,$GUI_DISABLE) ; Disable the start encode button in the main GUI



	#cs
		Function to create the Encoder GUI
	#ce

	; Create the GUI
		$Encoder_GUI_h = GUICreate(Null, 588, 368,-1,-1,-1,-1);,$MainGUI_hGUI)
		GUISetBkColor(0xdae8ed,$Encoder_GUI_h)
		;_WinAPI_SetWindowLong($Encoder_GUI_h, $GWL_STYLE, BitXOr(_WinAPI_GetWindowLong($Encoder_GUI_h, $GWL_STYLE), $WS_SYSMENU))

	; Show the total progress bar
		$Encoder_GUI_TotalProgress_Progress = GUICtrlCreateProgress(8, 32, 577, 25)
		GUICtrlCreateLabel('Total progress:', 8, 14, 570, 17)

	; Show the sub progress bar
		$Encoder_GUI_SubProgress_Progress = GUICtrlCreateProgress(8, 58, 577, 14)
	; Show the ffmpeg output
		$Encoder_GUI_ffmpegOutput_Edit = GUICtrlCreateEdit('', 8, 104, 577, 217,BitOR($GUI_SS_DEFAULT_EDIT,$ES_READONLY))
		GUICtrlSendMsg($Encoder_GUI_ffmpegOutput_Edit, $EM_LIMITTEXT, -1, 0)
		GUICtrlSetBkColor(-1,0xc6ea77)
		;GUICtrlSetColor(-1,0x150b2d)
		GUICtrlCreateLabel("ffmpeg basic output:", 8, 80, 208, 17)
	; Show the abort button
		$Encoder_GUI_Abort_Button = GUICtrlCreateButton("Abort", 8, 328, 409, 33)
	; Show the Suspend/Resume button
		$Encoder_GUI_SuspendResume_Button = GUICtrlCreateButton($C_Encoder_GUI_SuspendText, 424, 328, 75, 33)
		GUICtrlSetTip(-1,'Experimental, do not use!','Warning!')
;~ 		GUICtrlSetState(-1,$GUI_DISABLE)
	; Show the skip button
		$Encoder_GUI_SkipVideo_Button = GUICtrlCreateButton("Skip this video", 504, 328, 78, 33)
		GUICtrlSetState(-1,$GUI_DISABLE)

	; Show the GUI
		GUISetState(@SW_SHOW,$Encoder_GUI_h)

	$Encoder_GUI_isActive = True

EndFunc

Func Encoder_GUI_Delete()
	GUIDelete($Encoder_GUI_h)
	$Encoder_GUI_h = -1

	GUICtrlSetState($MainGUI_StartEncude_Button,$GUI_ENABLE) ; Enable the start encode button in the main GUI

EndFunc


Func Encoder_GUI_ProcessMsg()

	#cs
		Function to process the messages to the GUI
	#ce

	Switch $GUI_MSG[0]

		Case $Encoder_GUI_Abort_Button, $GUI_EVENT_CLOSE ; User click on X / close button
			If Not $Encoder_iActiveVidIndex Then
				Commander_TerminateAndDeleteJob($C_Encoder_JobID)
				Encoder_GUI_Delete()

			Else

				GUIDisable($MainGUI_hGUI)

				If MsgBox($MB_YESNO,'Still encoding', _
							'I still encoding the video'&@CRLF&$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_InputName]&@CRLF& _
							'Are you sure you wand to cancel the encoding ?', _
						0,$Encoder_GUI_h) = $IDYES Then

					Encoder_GUI_Delete()

					Commander_TerminateAndDeleteJob($C_Encoder_JobID)


					Encoder_cout(@CRLF&@CRLF&'Encoding canceled',2,0,False)

					$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_EncoderStatus] &= ' (Canceled)'
					$aVids[0][$C_aVids_idx2_0_EncoderStatusExists] = Null
					VideoList_ListView_UpdateEncodedStatus($Encoder_iActiveVidIndex)

					$Encoder_iActiveVidIndex = Null
					$Encoder_sActiveVid = Null

				EndIf

				GUIEnable($MainGUI_hGUI)
				WinActivate($Encoder_GUI_h)


			EndIf

		Case $Encoder_GUI_SkipVideo_Button ; User click on the skip button

			GUIDisable($MainGUI_hGUI)

			If MsgBox($MB_YESNO,'Are you sure?', _
							'Are you sure you want to skip encoding'&@CRLF&$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_InputName]&@CRLF& _
							'?', _
						0,$Encoder_GUI_h) = $IDYES Then

				Encoder_cout(@CRLF&@CRLF&'Skipping video "'&$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_InputName]&'"',2)

				$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_EncoderStatus] &= ' (Skipped)'
				$aVids[0][$C_aVids_idx2_0_EncoderStatusExists] = Null
				VideoList_ListView_UpdateEncodedStatus($Encoder_iActiveVidIndex)

				Encoder_Job_Step0()
			EndIf

			GUIEnable($MainGUI_hGUI)
			WinActivate($Encoder_GUI_h)



		Case $Encoder_GUI_SuspendResume_Button ; User click on the pause button



			If Not $Encoder_bSuspended Then ; the user didnt suspeded yet the process
				Commander_SuspendOrResumeExeProcess(True,$C_PraiortyLevel_Encoder+1)
				If @error Then Return
				GUICtrlSetData($Encoder_GUI_SuspendResume_Button,$C_Encoder_GUI_ResumeText)
				$Encoder_bSuspended = True
				;AdlibRegister(Encoder_GUI_KeepSuspendOrResume,60000)
			Else ; the user suspended the process and want to resume
				Commander_SuspendOrResumeExeProcess(False,$C_PraiortyLevel_Encoder+1)
				If @error Then Return
				GUICtrlSetData($Encoder_GUI_SuspendResume_Button,$C_Encoder_GUI_SuspendText)
				$Encoder_bSuspended = False
				;AdlibUnRegister(Encoder_GUI_KeepSuspendOrResume)
			EndIf


	EndSwitch







	; User click on the terminate button

	; User unchecked the "Open console" option


EndFunc

;~ Func Encoder_GUI_KeepSuspendOrResume()
;~ 	Commander_SuspendOrResumeExeProcess($Encoder_bSuspended,$C_PraiortyLevel_Encoder+1)


;~ EndFunc



#Region messages of the Encoder
	Func Encoder_GUI_MSG_CurrentlyEncoding($aVids_iDx1 = $Encoder_iActiveVidIndex)
		If Not $Encoder_iActiveVidIndex Then Return

		If $Encoder_iActiveVidIndex <> $aVids_iDx1 Then Return ; אין צורך לעשות אף בדיקה אם אנו לא מקודדים וידאו כלשהו

		GUIDisable($MainGUI_hGUI)

		If MsgBox($MB_YESNO,'Message - "'&$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_InputName]&'"', _
							'If you changed the encoding settings to video - "'&$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_InputName]&'"'&@CRLF&@CRLF& _
							$aVids[$Encoder_iActiveVidIndex][$C_aVids_idx2_InputPath]&@CRLF&@CRLF& _
							'You need to restart the encoding process of this video.'&@CRLF&@CRLF& _
							'Do you want to restart the encoding?', _
						0,$Encoder_GUI_h) = $IDYES Then

				Encoder_cout(Null,2)

				Encoder_Job_Restart(False)

		EndIf


		GUIEnable($MainGUI_hGUI)
		WinActivate($Encoder_GUI_h)

		#cs 			TODO
			Check if video is under encoding and if so, show the user
			הודעה שאומרת לו שהוידאו הספציפי הזה נמצא תחת קידוד
			ושאם הוא שינה את ההגדרות לוידאו זה, עליו לאתחל את הקידוד על
			מנת שההגדרות יכנסו לתוקף

			הצג למשתמש אפשרויות הבאות:
			* אל תשמור הגדרות
			* שמור הגדרות ואתחל קידוד מחדש
			* שמור הגדרות בלבד

			אם המשתמש בחר שלא לשמור הגדרות, הפונקציה תחזיר TRUE

			פונקציה זו משתמשת במשתנה $Encoder_sActiveVid
			כדי לדעת אם הוידאו הספציפי הזה נמצא בתהליך עיבוד
			במידה ו $aVids_iDx1
			שווה -1, פונקציה זו תדלג על הבדיקה הראשונית.
			בכל מקרה פונקציה זו לא תפעל במידה ומשתנה $Encoder_sActiveVid
			הוא משתנה ריק
			כיוון שמצב זה אומר שהתוכנה לא מקודדת כלום.
		#ce
	EndFunc




#EndRegion
