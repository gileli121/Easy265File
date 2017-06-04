#include-once
;~ #include <GDIPlus.au3>
#include 'PreviewModule.PreviewFrame.GDIDrawImage.au3'



#Region Frame - Low level code


	Func PrMo_Frame_Create($hPerent,$iXpos,$iYpos,$iXsize,$iYsize)
		; Create the sub gui (frame) inside the perent GUI
			$PrMo_Frame_hGUI = GUICreate('',$iXsize,$iYsize,$iXpos,$iYpos,0x40000000,0,$hPerent)
			GUISetBkColor($COLOR_BLACK)
			$PrMo_Frame_hTextFrame = GUICtrlCreateLabel($C_PrMo_Frame_DefaultText,$iXpos,$iYpos,$iXsize,$iYsize,$SS_CENTER+$SS_CENTERIMAGE)
			GUICtrlSetFont(-1, 30, 400, 0, "Tahoma")
			GUICtrlSetBkColor(-1,$COLOR_BLACK)
			GUICtrlSetColor(-1, $COLOR_RED)
			GUISetState(@SW_SHOW,$PrMo_Frame_hGUI)

		; Initialize the sub-gui for GDI ..
			PrMo_Fr_GDIDrawImage_InitializeGUI($PrMo_Frame_hGUI)
			If Not @error Then $PrMo_Frame_bGUIErrorCase = False

		#cs
		; Update globals
			$PrMo_Frame_hPerentGUI = $hPerent
		#ce
	EndFunc


	Func PrMo_Frame_RePos($xPos,$yPos,$xSize,$ySize)
		WinMove($PrMo_Frame_hGUI,'',$xPos,$yPos,$xSize,$ySize)
	EndFunc


	Func PrMo_Frame_SetImageFromFile($sImageFilePath)

		If $PrMo_Frame_bGUIErrorCase Then Return


		PrMo_Fr_GDIDrawImage_UnSetImage()
		PrMo_Fr_GDIDrawImage_SetImageFromFile($sImageFilePath)
		If @error Then
			#cs
				Error showing the image
			#ce
			Return SetError(@error)
		EndIf
		$PrMo_Frame_sImagePath = $sImageFilePath
		$PrMo_Frame_iImageScaleFit = PrMo_Fr_GDIDrawImage_GetFitScaleFactorFromImage()
		If Not @error Then
			$PrMo_Frame_iImageScale = $PrMo_Frame_iImageScaleFit
		Else
			$PrMo_Frame_iImageScale = 1
		EndIf
		PrMo_Fr_GDIDrawImage_DrawImage($PrMo_Frame_iImageScale)
		;AdlibRegister('PrMo_Frame_HandleMovingImageEvent')
	EndFunc

	Func PrMo_Frame_SetShowText($sText = $C_PrMo_Frame_DefaultText)
		_WinAPI_InvalidateRect($PreMo_Frame_gdi_hGUI)
		ControlSetText($PrMo_Frame_hGUI,Null,$PrMo_Frame_hTextFrame,$sText)
		Sleep(25)
	EndFunc

	Func PrMo_Frame_UnSetImage()
		$PrMo_Frame_sImagePath = Null
		Return PrMo_Fr_GDIDrawImage_UnSetImage()
	EndFunc


	Func PrMo_Frame_ReDrawImageAfterSizeChange()

		#cs
			This function will redraw the image according to the new size of the frame
		#ce

		$PreMo_Frame_gdi_aGUIClientSize = WinGetClientSize($PreMo_Frame_gdi_hGUI)
		If @error Then Return SetError(1)



		If $PreMo_Frame_gdi_hGraphic Then _GDIPlus_GraphicsDispose($PreMo_Frame_gdi_hGraphic)
		$PreMo_Frame_gdi_hGraphic = _GDIPlus_GraphicsCreateFromHWND($PreMo_Frame_gdi_hGUI)
		If @error Then Return SetError(1,0,PrMo_Fr_GDIDrawImage_UnInitializeGUI())

		If Not $PreMo_Frame_gdi_hImage Or Not $PrMo_Frame_sImagePath Then Return


		; Update the fit scale factor
			$PrMo_Frame_iImageScaleFit = PrMo_Fr_GDIDrawImage_GetFitScaleFactorFromImage()
			If Not @error Then
				$PrMo_Frame_iImageScale = $PrMo_Frame_iImageScaleFit
			Else
				$PrMo_Frame_iImageScale = 1
			EndIf

		; Redraw according to the new scale factor
			PrMo_Fr_GDIDrawImage_DrawImage($PrMo_Frame_iImageScale)




	EndFunc

	Func PrMo_Frame_ReDrawImageAfterSizeChange_Adlib()
		PrMo_Frame_ReDrawImageAfterSizeChange()
		AdlibUnRegister(PrMo_Frame_ReDrawImageAfterSizeChange_Adlib)
	EndFunc



	Func PrMo_Frame_HandleMovingImageEvent()


		If $PrMo_Frame_iImageScale <= $PrMo_Frame_iImageScaleFit Then Return

		$tmp = GUIGetCursorInfo($PrMo_Frame_hGUI)
		If @error Or $tmp[4] <> $PrMo_Frame_hTextFrame Then Return



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


		$PreMo_Frame_gdi_Image_Xpos_iChange += $tmp[0]-$PrMo_Frame_hmie_MouseXpos
		$PreMo_Frame_gdi_Image_Ypos_iChange += $tmp[1]-$PrMo_Frame_hmie_MouseYpos

		PrMo_Fr_GDIDrawImage_ReDrawImage()

		$PrMo_Frame_hmie_MouseXpos = $tmp[0]
		$PrMo_Frame_hmie_MouseYpos = $tmp[1]


	EndFunc





#EndRegion






#Region Frame - med level code

	Func PrMo_Frame_CleanTemp()
		PrMo_Frame_UnSetImage()
		PrMo_Frame_SetShowText()
		DirRemove($PrMo_TmpFolder,1)
		For $a = 1 To $aVids[0][0]
			$aVids[$a][$C_aVids_idx2_aOutPre] = Null
		Next

	EndFunc


#EndRegion


#Region Code to show selected frime in the display (the frame)


	Func PrMo_Frame_Update()
		If Not $aVids_aActiveIdxs[0] Or $aVids_aActiveIdxs[0] > 1 Then
			; TODO
			#cs
				Code to write here massage asking to select some video file
			#ce
			PrMo_Frame_UnSetImage()
			PrMo_Frame_SetShowText()


			Return
		EndIf




		; ( $aVids_aActiveIdxs[0] = 1 )


		#cs
			Area where one file selected ( $aVids_aActiveIdxs[0] = 1 )


			In this case we try to show the preview of the file.

			before we go any further, first we need to know some basic info about the selected video.
			In some case, that basic info is already exists, In other cases no. in the case the info is
			not exists, we need to ask for the info. we do that using ffprobe.exe -
			by build command for ffprobe.exe, designed to ask for basic information from ffprobe.exe
			and wait for the input to receive.

			The specific info that is needed for this process is the length of the video.
			But we don't make a request only for this specific info because every request to ffprobe.exe
			Takes some load time. so we use the opportunity to get other info, not needed by this process
			in oreder to save time in other scenarios.

			The request itself force some wait time. In order to aboid that the software will not respond
			while waiting for the info, the request itself will done through the Module Commander.au3

		#ce


		If Not Arrays1DIsEqual($aVids_aActiveIdxs,$aVids_aActiveIdxs_old) Then $PrMo_Frame_sImagePath = Null
;~ 			PrMo_Frame_UnSetImage()
;~ 			PrMo_Frame_SetShowText($C_PrMo_Frame_LoadingText)
;~ 		EndIf


		If $aVids[$aVids_aActiveIdxs[1]][$C_aVids_idx2_Duration_s] <= 0 Then
			#cs
				Create/change ... to with *high* praiorty level
			#ce

			#cs
				אפשר לומר שאין באמת צורך לבצע קריאה נוספת לפונקציה זו
				מכיוון שבכל מקרה יתבצע התהליך שאמור להתבצע.
				ובכל זאת הסיבה למה אנו קוראים שוב לפונקציה הזאת היא משום הפרמטר של העדיפות שהוא 3
				יש צורך לבצע את הקריאה רק בשביל לתעדף את התהליך שאמור להתבצע כך שיתבצע בהקדם
				האפשרי.
				יש צורך שתהליך זה יתבצע בהקדם האפשרי מכיוון שפונקציה זו נקראת כאשר
				המשתמש בחר להציג את הפריים מהווידאו. בחירה של המשתמש מחייבת לתעדף את הפעולה
				לעדיפות הכי גבוהה כדי שהמשתמש ירגיש שהפריים מוצג מהר ושהתוכנה מגיבה לבקשותיו במהירות
				סבירה.

			#ce



			VideoInfo_InitializeRequest($aVids_aActiveIdxs[1],3) ; "This" function will call PrMo_Frame_Update_ProcessJob() when it finish
		Else
			PrMo_Frame_Update_ProcessJob()
		EndIf


	EndFunc




	Func PrMo_Frame_Update_ProcessJob()
		;ConsoleWrite('PrMo_Frame_Update_ProcessJob' &' (L: '&@ScriptLineNumber&')'&@CRLF)
		#cs
			NOTES:
				* This function called only when $aVids_aActiveIdxs[0] = 1.
				so no need to check it here
		#ce



		#cs
			Here we start to Build the previw to show to the user

			The code will decides what to show - Input preview OR Output preview, on the basis of what the user choosed
			on the GUI.


			In this scope we have the needed info about the video and the info about what the user selected

			Video info:
				$VideoDuration_s - The length of the video in seconds

			Preview settings info:
				$PrMo_PreviewMode - Input / Output preview
				$PrMo_PreviewTimeSlider - What time in the video the preview will show

			This function should start only if one file selected + the needed info about the video is exists
		#ce


		; Force the dir $PrMo_TmpFolder to be Exists - Create the folder in case that the folder does not exists
		Local Static $RunOnce = DirForseExists($PrMo_TmpFolder)



		;Here we decide what kind of preview we FIRST need to generate




		; Update the preview time - from what time we need to extract preview image
			$PrMo_PreviewTime = ($PrMo_PreviewTimeSlider/$PrMo_GUI_C_SliderMaxValue)*$aVids[$aVids_aActiveIdxs[1]][$C_aVids_idx2_Duration_s]
			If $PrMo_PreviewTime > $aVids[$aVids_aActiveIdxs[1]][$C_aVids_idx2_Duration_s]-1 Then $PrMo_PreviewTime = $aVids[$aVids_aActiveIdxs[1]][$C_aVids_idx2_Duration_s]-1



		Switch $PrMo_PreviewMode
			Case $C_PrMo_PreviewMode_INPUT
				;ConsoleWrite('INPUT' &' (L: '&@ScriptLineNumber&') -> ')

				PrMo_Frame_Update_ProcessJob_Input_Step1( _
				$aVids_aActiveIdxs[1] , _					;$aVids_iDx1
				Default)									;$CommanderPraiortyLevel = Default


			Case $C_PrMo_PreviewMode_OUTPUT
				;ConsoleWrite('OUTPUT' &' (L: '&@ScriptLineNumber&') -> ')

				PrMo_Frame_Update_ProcessJob_Output_Step1( _
				$aVids_aActiveIdxs[1], _						;$aVids_iDx1
				Default)									;$CommanderPraiortyLevel = Default


			;Case $C_PrMo_PreviewMode_BOTH

		EndSwitch

	EndFunc

	#Region Input preview code

		Func PrMo_Frame_Update_ProcessJob_Input_Step1($aVids_iDx1,$CommanderPraiortyLevel = Default)
			;ConsoleWrite('PrMo_Frame_Update_ProcessJob_Input_Step1' &' (L: '&@ScriptLineNumber&@CRLF)

			#cs
				Build the command to send to ffmpeg to get the preview image of the Input
			#ce


			; Init the path of the image-frame
			Local $OutImagePath = $PrMo_TmpFolder&$aVids[$aVids_iDx1][$C_aVids_idx2_PrMo_Input_ID]&'_IN_'&$PrMo_PreviewTime&'.png'

			Local $iError
			; Check if image-frame is already exists and if so then just show this file on the preview frame
			If FileExists($OutImagePath) Then

			#cs	OLD CODE
				; Check if this file should be displayed on the GUI. only if the file was selected then load the preview from it
				If $l_InVideoFilePath <> $InVideoFilePath Then Return ; The file was not selected so we only return
			#ce

				; ConsoleWrite('- The image is exists!' & @CRLF)
				; The file selected - Show it on the preview frame and finish the job (we don't need to call ffmpeg to get the preview image file)
				PrMo_Frame_SetImageFromFile($OutImagePath)
				$iError = @error
				If $iError <> 1 Then Return ; No error - we finish the process here
				; Error case of 1 = error: the tmp image file is corrupted. in this case we continue the process of this function to create new tmp image
			EndIf


			If Not Arrays1DIsEqual($aVids_aActiveIdxs,$aVids_aActiveIdxs_old) Or $iError = 1 Then PrMo_Frame_SetShowText($C_PrMo_Frame_LoadingText)

			; Build the command to send to ffmpeg
			Local $sCommand = '-ss '&$PrMo_PreviewTime&' -i "'&$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath]&'" -vframes 1 -y "'&$OutImagePath&'"'


			; Send the command to ffmpeg through Commander.au3
			If $CommanderPraiortyLevel = Default Then $CommanderPraiortyLevel = $C_PraiortyLevel_UpdatePreviewFrame

			#cs
			Commander_AddJob($ini_FFmpegPath, _										; $ExeFile
						$sCommand, _												; $Command
						$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath], _				; $JobID = Null
						$CommanderPraiortyLevel, _									; $iPraiortyLevel = 0
						'PrMo_Frame_Update_ProcessJob_ShowPreviewFromTmpImg', _		; $sFunction = Null
						Default, _													; $MaxWaitTime = Default
						Default, _													; $TerminateOnMaxWaitTime = Default
						$aVids_iDx1	, _												; $Arg1 = Null
						$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath], _ 				; $Arg2 = Null
						$OutImagePath)												; $Arg3 = Null
			#ce

			Local $aArgs[3] = [$aVids_iDx1,$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath],$OutImagePath]


			Commander_AddJob( _
					$FFmpegPath	, _; $ExeFile
					$sCommand, _; $sCommand
					$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath]	, _; $JobID = Null
					$CommanderPraiortyLevel	, _; $iPraiortyLevel
					Default	, _; $iMaxWaitTime = Default
					Default	, _; $bTerminateOnMaxWaitTime = Default
					Null	, _; $sStep1Func = Null
					Default	, _; $aStep1Func_Args = Default
					Null	, _; $sStep2Func = Null
					Default	, _; $aStep2Func_Args = Default
					Null	, _; $sStep3Func = Null
					Default	, _; $aStep3Func_Args = Default
					PrMo_Frame_Update_ProcessJob_ShowPreviewFromTmpImg	, _; $sStep4Func = Default
					$aArgs); $aStep4Func_Args = Null


			;_ArrayDisplay($Commander_aJobList)



		EndFunc



	#EndRegion

	#Region Output preview code






		Func PrMo_Frame_Update_ProcessJob_Output_Step1($aVids_iDx1,$CommanderPraiortyLevel = Default)
			;ConsoleWrite('PrMo_Frame_Update_ProcessJob_Output_Step1' &' (L: '&@ScriptLineNumber&')'&@CRLF)
			#cs
				Build the command to send to ffmpeg to get the preview image of the Input
			#ce

			; Set the parameters

				If $CommanderPraiortyLevel = Default Then $CommanderPraiortyLevel = $C_PraiortyLevel_UpdatePreviewFrame



			; Calculate the second of when to extract the frame from the mp4 sample that will be create later
				Local $ShowTimeInTmpVideo = $PrMo_ini_ProcessBefore
				Local $BeforePreviewTime = $PrMo_PreviewTime-$PrMo_ini_ProcessBefore
				If $BeforePreviewTime < 0 Then
					$ShowTimeInTmpVideo += $BeforePreviewTime
					$BeforePreviewTime = 0
				EndIf


			#cs
				Check if there is need to recreate the video sample.
				We recreate the video sample if one of the following conditions is True:
					1) the output settings changed
					2) out of the processed range and there is no processed video that filt to $PreviewTime
			#ce

			; TODO - dont check anyway now for test only




			; Generate id for the command (preview settings)
				$sID = CreateIDFromString($aVids[$aVids_iDx1][$C_aVids_idx2_PrMo_Input_ID]&SettingsGUI_GetCleanCommand())
				If @error Then
					; TODO - show error to the user that there is problem in showing the preview
					Return
				EndIf


			; Generate the path to the tmp preview image
				Local $TmpImagePath = PrMo_Fr_Up_PrJo_Out_GenerateOutputTmpImagePath($sID,$PrMo_PreviewTime)




			#cs
				Check if this preview was processed before
			#ce

			; Check if we have the preview as image file
				If FileExists($TmpImagePath) Then
					; we have the preview image file so we load it now to the preview frame and stop here
					PrMo_Frame_SetImageFromFile($TmpImagePath)
					Return
				EndIf


			;If Not Arrays1DIsEqual($aVids_aActiveIdxs,$aVids_aActiveIdxs_old) Then PrMo_Frame_SetShowText($C_PrMo_Frame_LoadingText)

			; בדיקה אם כבר התבצע עיבוד לתצורת ההגדרות הנוכחית שמכיל את הטווח פריימים המבוקש

;~ 			; Check if we have the preview as tmp video with the frame we need
				Local $iRangePos = _
				PrMo_Frame_Update_ProcessJob_Output_Step1_LookForSuitableSample( _
					$aVids[$aVids_iDx1][$C_aVids_idx2_aOutPre], _					; $aOutputData
					$sID, _															; $sID
					$PrMo_PreviewTime)													; $iTime

				If $iRangePos Then

					#cs
						בנקודה זו הקוד צריך לעבור על המערך ולחפש דוגמית שעונה לדרישות
						המטרה היא למנוע מצב שבו מבצעים קריאה נוספת ל ffmpeg
						כדי ליצור דוגמית חדשה.
						אולי נמצא בשלב זה דוגמית כלשהי שכבר יש לנו
						במידה ונמצאה כזו, יהיה צורך לחשב מחדש את הפרמטרים
						שעלפיהם הקוד יודע מאיזו נקודת זמן מתוך הדוגמית צריך להוציא
						את קובץ התמונה שיוצג בתצוגה מקדימה
					#ce


					Local Const $C_iActiveID = ($aVids[$aVids_iDx1][$C_aVids_idx2_aOutPre])[0][$C_PrMo_Fr_aOutData_idx2_0_ActiveID]
					Local Const $C_iMinTime = (($aVids[$aVids_iDx1][$C_aVids_idx2_aOutPre])[$C_iActiveID][$C_PrMo_Fr_aOutData_idx2_aRanges])[$iRangePos][$C_PrMo_Fr_aOutData_aRanges_idx2_Start]
					Local Const $C_iMaxTime = (($aVids[$aVids_iDx1][$C_aVids_idx2_aOutPre])[$C_iActiveID][$C_PrMo_Fr_aOutData_idx2_aRanges])[$iRangePos][$C_PrMo_Fr_aOutData_aRanges_idx2_End]

						; Extract the frame from the tmp video
						PrMo_Frame_Update_Output_ExtractFrameFromTmpVideo( _
						$aVids_iDx1, _																	; $aVids_iDx1
						PrMo_Fr_Up_PrJo_Out_GenerateOutputTmpVideoPath($sID,$C_iMinTime,$C_iMaxTime), _ 		; $TmpVideoFile
						$ShowTimeInTmpVideo+($PrMo_PreviewTime-$C_iMinTime), _									; $ShowTimeInTmpVideo
						$TmpImagePath, _																; $OutputTmpImagePath
						$CommanderPraiortyLevel)														; $CommanderPraiortyLevel

					Return
				EndIf





			#cs
				CREATE NEW SAMPLE -> LOAD FROM THE SAMPLE THE FRAME + SAVE THE SAMPLE IN SAMPLES LIST
			#ce

			PrMo_Frame_UnSetImage()
			PrMo_Frame_SetShowText($C_PrMo_Frame_LoadingText)



			;ConsoleWrite('Calling ffmpeg to create new sample' &' (L: '&@ScriptLineNumber&')'&@CRLF)


			; Init $iMinTime and $iMaxTime
				Local $iMinTime = $PrMo_PreviewTime, $iMaxTime = $PrMo_PreviewTime+$PrMo_ini_ProcessAfter

			; Create the name+path of the tmp mp4 sample
				Local $TmpVideoFile = PrMo_Fr_Up_PrJo_Out_GenerateOutputTmpVideoPath( _
					$sID, _;	ByRef $sID
					$iMinTime, _;	$iMinTime
					$iMaxTime);	$iMaxTime




			#cs

									-i <input>  -c:v libx265  <output>'
			-ss <BeforePreviewTime> -i <Input> <EncodeSettings> -t <ProcessAfter>+0.5 -y <Tmp.mp4>

			#ce

			; Build the command to send to ffmpeg
				; (not optimized  code) (doing the same thing)
				#cs
					Local $sCommand
					$sCommand = StringReplace(ReplaceEntersInString($SettingsGUI_FFmpegCommandText,'  '),'<input>',' "'&$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath]&'" ',1)
					$sCommand = StringReplace($sCommand,'<output>',' -t '&$PrMo_ini_ProcessBefore+$PrMo_ini_ProcessAfter+0.5&' -y "'&$TmpVideoFile&'"',-1)
					$sCommand = '-ss '&$BeforePreviewTime&' '&$sCommand
				#ce

				; (optimized  code)
				Local $sCommand = '-ss '&$BeforePreviewTime&' '& _
				StringReplace(StringReplace(ReplaceEntersInString($SettingsGUI_FFmpegCommandText,'  '),'<input>', _
				' "'&$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath]&'" ',1),'<output>', _
				' -t '&$PrMo_ini_ProcessBefore+$PrMo_ini_ProcessAfter+0.5&' -y "'&$TmpVideoFile&'"',-1)




			; Send the command to ffmpeg through Commander.au3



				Local $Step3FuncArgs = _
					[ _
						$aVids_iDx1, _
						$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath] _
					]

				Local $Step4FuncArgs = _
					[ _
						$aVids_iDx1, _
						$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath], _
						$TmpVideoFile, _
						$sID, _
						$iMinTime, _
						$iMaxTime, _
						$ShowTimeInTmpVideo, _
						$PrMo_PreviewTime, _
						$TmpImagePath, _
						$CommanderPraiortyLevel _
					]

				Commander_AddJob( _
						$FFmpegPath	, _; $ExeFile
						$sCommand, _; $sCommand
						$C_PrMo_Fr_OutputJobID	, _; $JobID = Null
						$CommanderPraiortyLevel	, _; $iPraiortyLevel
						Default	, _; $iMaxWaitTime = Default
						Default	, _; $bTerminateOnMaxWaitTime = Default
						Null	, _; $sStep1Func = Null
						Default	, _; $aStep1Func_Args = Default
						Null	, _; $sStep2Func = Null
						Default	, _; $aStep2Func_Args = Default
						PrMo_Frame_Update_ProcessJob_Output_Step1_StopInCaseTheVideoDeleted	, _; $sStep3Func = Null
						$Step3FuncArgs	, _; $aStep3Func_Args = Default
						PrMo_Frame_Update_ProcessJob_Output_Step2_ExtractFrameFromTmpVid, _; $sStep4Func = Default
						$Step4FuncArgs); $aStep4Func_Args = Null




		EndFunc


		Func PrMo_Frame_Update_ProcessJob_Output_Step1_StopInCaseTheVideoDeleted(ByRef $sStdRead, ByRef $r) ; r = array of parameters
			Local Enum $aVids_iDx1, $sVideoInputFilePath
			; In case the video deleted we stop the job and delete it
				Update_aVidsIdx1Var($r[$aVids_iDx1],$r[$sVideoInputFilePath])
				If @error Then Return $C_Commander_CalledFuncReturn_TerminateAndDeleteJob
		EndFunc



		Func PrMo_Frame_Update_ProcessJob_Output_Step1_LookForSuitableSample(ByRef $aOutputData,$sID,$iTime)
			#cs
				This function will look for the video sample that suitable...
				בנקודה זו הקוד צריך לעבור על המערך ולחפש דוגמית שעונה לדרישות
				המטרה היא למנוע מצב שבו מבצעים קריאה נוספת ל ffmpeg
				כדי ליצור דוגמית חדשה.
				אולי נמצא בשלב זה דוגמית כלשהי שכבר יש לנו
				במידה ונמצאה כזו, יהיה צורך לחשב מחדש את הפרמטרים
				שעלפיהם הקוד יודע מאיזו נקודת זמן מתוך הדוגמית צריך להוציא
				את קובץ התמונה שיוצג בתצוגה מקדימה

				הקוד יחזיר את הפוזיציה של הטווח .....
			#ce


#cs
	$aOutputData[0][$C_PrMo_Fr_aOutData_idx2_0_ActiveID] = the ID pos
	$aOutputData[$aOutputData[0][$C_PrMo_Fr_aOutData_idx2_0_ActiveID]][$C_PrMo_Fr_aOutData_idx2_ID] = the ID string


#ce
			; check if this is array
				If Not IsArray($aOutputData) Or Not $aOutputData[0][0] Then Return



			; look for the id
				; check if we are already in the id
				If $aOutputData[$aOutputData[0][$C_PrMo_Fr_aOutData_idx2_0_ActiveID]][$C_PrMo_Fr_aOutData_idx2_ID] <> $sID Then
					; We are not in the id so now we look for it and if we found it then we also update it.
					; if we don't found it then we return -1 since there is no need to look more for the
					; suitable sample
					Local $bFound = False
					For $a = 1 To $aOutputData[0][0]
						If $aOutputData[$a][$C_PrMo_Fr_aOutData_idx2_ID] = $sID Then
							; We found the pos of the id so we also update the pos here so next time we will not need to look
							; for the pos again. and we continue to lool for the suitable range
							$aOutputData[0][$C_PrMo_Fr_aOutData_idx2_0_ActiveID] = $a
							$bFound = True
						EndIf
					Next
					If Not $bFound Then Return
				EndIf


			#cs
				here we have our id pos stored in
				$aOutputData[0][$C_PrMo_Fr_aOutData_idx2_0_ActiveID]
				that is the id we are looking for

				so next we enter in to the aRanges array of the ID
				to look for suitable range that fit to $iTime

				the aRanges array is:
				$aOutputData[$aOutputData[0][$C_PrMo_Fr_aOutData_idx2_0_ActiveID]][$C_PrMo_Fr_aOutData_idx2_aRanges]


			#ce



			; look for the range that fit to $iTime
			For $a = 1 To ($aOutputData[$aOutputData[0][$C_PrMo_Fr_aOutData_idx2_0_ActiveID]][$C_PrMo_Fr_aOutData_idx2_aRanges])[0][0]
				If _
					$iTime _
					>= _
					($aOutputData[$aOutputData[0][$C_PrMo_Fr_aOutData_idx2_0_ActiveID]][$C_PrMo_Fr_aOutData_idx2_aRanges])[$a][$C_PrMo_Fr_aOutData_aRanges_idx2_Start] _
				And _
					$iTime _
					<= _
					($aOutputData[$aOutputData[0][$C_PrMo_Fr_aOutData_idx2_0_ActiveID]][$C_PrMo_Fr_aOutData_idx2_aRanges])[$a][$C_PrMo_Fr_aOutData_aRanges_idx2_End] _
				Then
					; We found here range (start , end) that fit to the $iTime
					Return $a
				EndIf
			Next

		EndFunc







		Func PrMo_Frame_Update_ProcessJob_Output_Step2_ExtractFrameFromTmpVid(ByRef $aCommanderInput, ByRef $r) ; $r is an array of parameters

			; **** parameters to $r , the indexes (integers) of the parameters inside the $r array:
			Local Enum $aVids_iDx1, $InVidPath, $TmpVidFile, $sPreviewID, $TmpVidFile_MinTime, $TmpVidFile_MaxTime, _
						$ShowTimeInTmpVideo, $PreviewTime, $OutTmpImagePath, $CommanderPraiortyLevel




			; Check if this file should be displayed on the GUI. only if the file was selected then load the preview from it
				If Not $aVids_aActiveIdxs[0] Or $aVids_aActiveIdxs[1] <> $r[$aVids_iDx1] Then Return

			; Update the position of the video in the array (in case it changed)
				Update_aVidsIdx1Var($r[$aVids_iDx1],$r[$InVidPath])
				If @error Then Return ; The video is no longer in the table



			#cs
				in this case the command for ffmpeg has been processed so now we continue
				the precess that need to be done to show the preview
			#ce


			#cs
				TODO: Show here the errors that may happan
			#ce

			; Check for erros before continue
				If $aCommanderInput[$Commander_C_output_idx_IsError] = $Commander_C_output_JobState_Error Then
					; Error case 1
					;ConsoleWrite('Error 1' &' (L: '&@ScriptLineNumber&')'&@CRLF)

					Return PrMo_Frame_SetShowText('Error EFFTV_1')
				EndIf

				If Not FileExists($r[$TmpVidFile]) Then
					; Error case 2
					;ConsoleWrite('Error 2' &' (L: '&@ScriptLineNumber&')'&@CRLF)
					;ConsoleWrite($aCommanderInput[$Commander_C_output_idx_CmdRead] &' (L: '&@ScriptLineNumber&')'&@CRLF)
					;ClipPut($aCommanderInput[$Commander_C_output_idx_CmdRead])

					Return PrMo_Frame_SetShowText('Error EFFTV_2')
				EndIf

				;ConsoleWrite('No Error' & @CRLF) ; No Error


			#cs
				In the case we have done to build the tmp video file.
				now we add the this as a new processed range so the next time, we may skip this step of creating tmp video file
			#ce


			; Add the new time-rage to the list of the id of the command...
				; TODO


				PrMo_Frame_Update_ProcessJob_Output_Step2_ExtractFrameFromTmpVid_AddTimeRange( _
					$aVids[$r[$aVids_iDx1]][$C_aVids_idx2_aOutPre], _					; ByRef $aOutputData
					$r[$sPreviewID], _													; $sPreviewID
					$r[$TmpVidFile_MinTime], _											; $iStartTime
					$r[$TmpVidFile_MaxTime])											; $iEndTime

				;_ArrayDisplay($aVids[$aVids_iDx1][$C_aVids_idx2_aOutPre],'$aVids[$aVids_iDx1][$C_aVids_idx2_aOutPre]')
				;_ArrayDisplay(($aVids[$aVids_iDx1][$C_aVids_idx2_aOutPre])[($aVids[$aVids_iDx1][$C_aVids_idx2_aOutPre])[0][$C_PrMo_Fr_aOutData_idx2_0_ActiveID]][$C_PrMo_Fr_aOutData_idx2_aRanges])




			; Extract the frame from the tmp video
				PrMo_Frame_Update_Output_ExtractFrameFromTmpVideo($r[$aVids_iDx1],$r[$TmpVidFile],$r[$ShowTimeInTmpVideo], _
																	$r[$OutTmpImagePath],$r[$CommanderPraiortyLevel])








		EndFunc


		#Region PrMo_Frame_Update_ProcessJob_Output_Step2_ExtractFrameFromTmpVid_AddTimeRange

			Func PrMo_Frame_Update_ProcessJob_Output_Step2_ExtractFrameFromTmpVid_AddTimeRange(ByRef $aOutputData,$sPreviewID,$iStartTime,$iEndTime)

				;Local $aOutputData_iDx1, $aRanges_iDx1
				; Create the array in case the is no array
					If Not IsArray($aOutputData) Then

						; Set the aOutputData array
							Local $tmp[2][$C_PrMo_Fr_aOutData_idx2max]
							$tmp[0][0] = 1
							$tmp[0][$C_PrMo_Fr_aOutData_idx2_0_ActiveID] = 1
							$tmp[1][$C_PrMo_Fr_aOutData_idx2_ID] = $sPreviewID
							$aOutputData = $tmp



						; Set aRanges array and save it in aOutputData array
							Local $tmp[2][$C_PrMo_Fr_aOutData_aRanges_idx2max]
							$tmp[0][0] = 1
							$tmp[1][$C_PrMo_Fr_aOutData_aRanges_idx2_Start] = $iStartTime
							$tmp[1][$C_PrMo_Fr_aOutData_aRanges_idx2_End] = $iEndTime
							$aOutputData[1][$C_PrMo_Fr_aOutData_idx2_aRanges] = $tmp

						Return

					EndIf


					; Load the active index of the preview id
					Local $aOutputData_iDx1 = $aOutputData[0][$C_PrMo_Fr_aOutData_idx2_0_ActiveID]

					#cs
						Check if this index pointing to the correct preview id. if not then
						Update this index by looking for the correct index and if it didn't found
						such index it will create new index at the end there will always be index that
						is point to the requested preview id
					#ce
					If $aOutputData[$aOutputData_iDx1][$C_PrMo_Fr_aOutData_idx2_ID] <> $sPreviewID Then
						Local $bFound = False
						For $a = 1 To $aOutputData[0][0]
							If $aOutputData[$a][$C_PrMo_Fr_aOutData_idx2_ID] = $sPreviewID Then
								$aOutputData_iDx1 = $a
								$bFound = True
								ExitLoop
							EndIf
						Next
						If Not $bFound Then
							$aOutputData[0][0] += 1
							ReDim $aOutputData[$aOutputData[0][0]+1][$C_PrMo_Fr_aOutData_idx2max]
							$aOutputData_iDx1 = $aOutputData[0][0]
							$aOutputData[$aOutputData_iDx1][$C_PrMo_Fr_aOutData_idx2_ID] = $sPreviewID
							Local $tmp[1][$C_PrMo_Fr_aOutData_aRanges_idx2max]
							$aOutputData[$aOutputData_iDx1][$C_PrMo_Fr_aOutData_idx2_aRanges] = $tmp
						EndIf

						$aOutputData[0][$C_PrMo_Fr_aOutData_idx2_0_ActiveID] = $aOutputData_iDx1
					EndIf

					PrMo_Fr_Up_PrJo_Ou_St2_ExFrFrTmpVid_AddTimeRange_AddRangeInRangeArray( _
						$aOutputData[$aOutputData_iDx1][$C_PrMo_Fr_aOutData_idx2_aRanges], _	; ByRef $aTimeRanges
						$iStartTime, _														; $iStartTime
						$iEndTime)															; $iEndTime

			EndFunc


			Func PrMo_Fr_Up_PrJo_Ou_St2_ExFrFrTmpVid_AddTimeRange_AddRangeInRangeArray(ByRef $aTimeRanges, $iStartTime, $iEndTime)
				$aTimeRanges[0][0] += 1
				ReDim $aTimeRanges[$aTimeRanges[0][0]+1][$C_PrMo_Fr_aOutData_aRanges_idx2max]
				$aTimeRanges[$aTimeRanges[0][0]][$C_PrMo_Fr_aOutData_aRanges_idx2_Start] = $iStartTime
				$aTimeRanges[$aTimeRanges[0][0]][$C_PrMo_Fr_aOutData_aRanges_idx2_End] = $iEndTime
			EndFunc
		#EndRegion


		Func PrMo_Frame_Update_Output_ExtractFrameFromTmpVideo($aVids_iDx1,$TmpVideoFile,$ShowTimeInTmpVideo, _
			$OutputTmpImagePath,$CommanderPraiortyLevel)

			; Check if this file should be displayed on the GUI. only if the file was selected then load the preview from it
				If Not $aVids_aActiveIdxs[0] Or $aVids_aActiveIdxs[1] <> $aVids_iDx1 Then Return

			#cs
				-ss <$PrMo_Fr_Up_Out_ExFr_ShowTime> -i <TmpMp4FilePath> -y <TmpPngFilePath>'
			#ce
			Local $sCommand = '-ss '&$ShowTimeInTmpVideo&' -i "'&$TmpVideoFile&'" -vframes 1 -y "'&$OutputTmpImagePath&'"'




			; Send the command to ffmpeg through Commander.au3

			#cs
			Commander_AddJob($ini_FFmpegPath, _										; $ExeFile
						$sCommand, _												; $Command
						$C_PrMo_Fr_OutputJobID, _									; $JobID = Null
						$CommanderPraiortyLevel, _									; $iPraiortyLevel = 0
						'PrMo_Frame_Update_ProcessJob_ShowPreviewFromTmpImg', _				; $sFunction = Null
						Default, _
						Default, _
						$aVids_iDx1, _ 												; $Arg1 = Null
						$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath], _				; $Arg2 = Null
						$OutputTmpImagePath)
			#ce


				Local $Step4FuncArgs[] = _
					[ _
						$aVids_iDx1, _
						$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath], _
						$OutputTmpImagePath _
					]

				Commander_AddJob( _
						$FFmpegPath	, _; $ExeFile
						$sCommand, _; $sCommand
						$C_PrMo_Fr_OutputJobID	, _; $JobID = Null
						$CommanderPraiortyLevel	, _; $iPraiortyLevel
						Default	, _; $iMaxWaitTime = Default
						Default	, _; $bTerminateOnMaxWaitTime = Default
						Null	, _; $sStep1Func = Null
						Default	, _; $aStep1Func_Args = Default
						Null	, _; $sStep2Func = Null
						Default	, _; $aStep2Func_Args = Default
						Null	, _; $sStep3Func = Null
						Default	, _; $aStep3Func_Args = Default
						PrMo_Frame_Update_ProcessJob_ShowPreviewFromTmpImg, _; $sStep4Func = Null
						$Step4FuncArgs); $aStep4Func_Args = Default





		;PrMo_Frame_Update_ProcessJob_ShowPreview($aCommanderInput,$aVids_iDx1,$InputVideoPath,$OutputTmpImagePath)
		EndFunc





		Func PrMo_Fr_Up_PrJo_Out_GenerateOutputTmpImagePath($sID,$PreviewTime)
			Return $PrMo_TmpFolder&$sID&'_OUT_'&$PreviewTime&'.png'
		EndFunc


		Func PrMo_Fr_Up_PrJo_Out_GenerateOutputTmpVideoPath($sID,$iMinTime,$iMaxTime)
			Return $PrMo_TmpFolder&$sID&'_OUT_'&$iMinTime&'-'&$iMaxTime&'.mp4'
		EndFunc

		;





	#EndRegion



	Func PrMo_Frame_Update_ProcessJob_ShowPreviewFromTmpImg(ByRef $aCommanderInput, ByRef $r) ; r = array of parameters

		; parameters indexes inside the $r array:
		Local Enum $aVids_iDx1, $sInputPath, $sOutImagePath


		;ConsoleWrite('PrMo_Frame_Update_ProcessJob_ShowPreviewFromTmpImg' &' (L: '&@ScriptLineNumber&')'&@CRLF)
		; Update the position of the video in the array (in case it changed)
			Update_aVidsIdx1Var($r[$aVids_iDx1],$r[$sInputPath])
			If @error Then Return ; The video is no longer in the table

		; Check if this file should be displayed on the GUI. only if the file was selected then load the preview from it
			If Not $aVids_aActiveIdxs[0] Or $aVids_aActiveIdxs[1] <> $r[$aVids_iDx1] Then Return



		#cs
			in this case the command for ffmpeg has been processed so now we continue
			the precess that need to be done to show the preview
		#ce

#cs
	TODO
	Show here the errors that may happan
#ce
		;ClipPut($aCommanderInput[$Commander_C_output_idx_CmdRead])

		; Check for errors
			If $aCommanderInput[$Commander_C_output_idx_IsError] = $Commander_C_output_JobState_Error Then Return PrMo_Frame_SetShowText('Error SPFTI_1');ConsoleWrite('Error 1' &' (L: '&@ScriptLineNumber&')'&@CRLF)
			If Not FileExists($r[$sOutImagePath]) Then Return PrMo_Frame_SetShowText('Error SPFTI_2')

		; No Error
		;ConsoleWrite('No Error' & @CRLF)

		#cs
			In this case we have everything we need to show the preview image!
			Now we only need to call to:
			PrMo_Frame_SetImageFromFile($sImageFilePath)
			Update the image on the preview frame!
		#ce

		; Update the preview frame with the new preview image

			PrMo_Frame_SetImageFromFile($r[$sOutImagePath])



	EndFunc





#EndRegion

