
#Region aVids array
	Func aVids_AddRow()
		;$aVids_nRows += 1
		$aVids[0][0] += 1
		ReDim $aVids[$aVids[0][0]+1][$C_aVids_idxmax2]
	EndFunc

	Func aVids_RemoveRow($iRow)
		$aVids[0][0] -= 1
		Return _ArrayDelete($aVids,$iRow)
	EndFunc


	Func aVids_ReadSet($iDx,$iDx2)
		If $iDx > $aVids[0][0] Then Return SetError(1)
		If Not $aVids[$iDx][$iDx2] Then Return $aVids[0][$iDx2]
		Return $aVids[$iDx][$iDx2]
	EndFunc

	#cs
	Global Const $C_aVids_idx2_InputPath = 0
	Global Const $C_aVids_idx2_InputName = 1
	Global Const $C_aVids_idx2_OutputPath = 2
	Global Const $C_aVids_idx2_OutputFolder = 3
	Global Const $C_aVids_idx2_OutputName = 4
	Global Const $C_aVids_idx2_OriginalSize = 5
	Global Const $C_aVids_idx2_ProfileID = 6
	Global Const $C_aVids_idx2_Command = 7
	Global Const $C_aVids_idx2_OutContainer = 8
	Global Const $C_aVids_idx2_Duration_s = 9
	Global Const $C_aVids_idx2_Duration_hms = 10
	Global Const $C_aVids_idxmax2 = 11
	Global $aVids[1][$C_aVids_idxmax2], $aVids_nRows = 0


	#ce




	#cs
		Only add the video and init basic stuff (video name, size, len
	#ce
	Func aVids_AddVideo($VideoPath, $iDuration = Default)
		; Check if we dealing with a file. if not return erro
			Local $iVideoSize = FileGetSize($VideoPath)
			If Not $iVideoSize Then Return SetError(1)
		; In case the video is alredy in the aVids array we don't need to add it again so the code stop and return error 1
			If $aVids[0][0] And _ArraySearch($aVids,$VideoPath,1,$aVids[0][0],0,0,1,$C_aVids_idx2_InputPath) <> -1 Then Return SetError(2) ; Error 2

		; Add the video in aVids
			aVids_AddRow()
			$aVids[$aVids[0][0]][$C_aVids_idx2_InputPath] = $VideoPath
			$aVids[$aVids[0][0]][$C_aVids_idx2_OriginalSize] = $iVideoSize
			If @error Then $aVids[$aVids[0][0]][$C_aVids_idx2_OriginalSize] = -1
			$aVids[$aVids[0][0]][$C_aVids_idx2_InputName] = GetFileNumeFromPath($VideoPath)
			$aVids[$aVids[0][0]][$C_aVids_idx2_PrMo_Input_ID] = CreateIDFromString($VideoPath)

			;Return
		; Create processor that will get some info about the video such as the video len and more
		If $iDuration = Default Then
			VideoInfo_InitializeRequest($aVids[0][0], _			; $aVids_iDx1
			$C_PraiortyLevel_VideoInfo_Receive)					; $l_Commander_iPraiortyLevel
		Else
			$aVids[$aVids[0][0]][$C_aVids_idx2_Duration_s] = $iDuration
		EndIf

	EndFunc



	Func aVids_GenerateRealFilename($aVids_iDx,$sOutputName = Default,$sOutContainer = Default)
		If $aVids_iDx > $aVids[0][0] Then Return SetError(1)
		If $sOutputName = Default Then $sOutputName = $aVids[$aVids_iDx][$C_aVids_idx2_OutputName]
		If $sOutContainer = Default Then $sOutContainer = $aVids[$aVids_iDx][$C_aVids_idx2_OutContainer]
		Local $sFileExt = GetFileExtFromStr($aVids[$aVids_iDx][$C_aVids_idx2_InputName])
		Local $sFileNameOnly = StringTrimRight($aVids[$aVids_iDx][$C_aVids_idx2_InputName],StringLen($sFileExt)+1)
		;Local $sOutputName = $aVids[$aVids_iDx][$C_aVids_idx2_OutputName]
		If Not $sOutputName Then $sOutputName = $aVids[0][$C_aVids_idx2_OutputName]
		Local $sName = StringReplace($sOutputName,$C_sVideoNameMark,$sFileNameOnly,1)
		;Local $sOutContainer = $aVids[$aVids_iDx][$C_aVids_idx2_OutContainer]
		If Not $sOutContainer Then $sOutContainer = $aVids[0][$C_aVids_idx2_OutContainer]
		If Not $sOutContainer Then $sOutContainer = '.'&$sFileExt
		Return $sName&$sOutContainer
	EndFunc


	Func aVids_GenerateRealFolderPath($aVids_iDx,$sOutputFolder = Default)
		If $aVids_iDx > $aVids[0][0] Then Return SetError(1)
		; Get the output folder set
		If $sOutputFolder = Default Then $sOutputFolder = $aVids[$aVids_iDx][$C_aVids_idx2_OutputFolder]
		;Local $sOutputFolder = $aVids[$aVids_iDx][$C_aVids_idx2_OutputFolder]
		If Not $sOutputFolder Then $sOutputFolder = $aVids[0][$C_aVids_idx2_OutputFolder]
		Local $sFullFilePath = $aVids[$aVids_iDx][$C_aVids_idx2_InputPath]
		;If Not $sFullFilePath Then $sFullFilePath = $aVids[0][$C_aVids_idx2_InputPath]

		; Replace the ? mark with the base path
		$sOutputFolder = StringReplace($sOutputFolder,$C_sRootFolderPath,$aVids_InputCommonPath,1)

		; Replace the * mark with the path after base..
		Local $sPathAfterBase
		If StringLeft($sFullFilePath,StringLen($aVids_InputCommonPath)) = $aVids_InputCommonPath Then
			$sPathAfterBase = StringTrimRight($sFullFilePath,StringLen($aVids[$aVids_iDx][$C_aVids_idx2_InputName])+1)
			$sPathAfterBase = StringTrimLeft($sPathAfterBase,StringLen($aVids_InputCommonPath)+1)
		Else
			$tmp = StringSplit($sFullFilePath,':\',1)
			If $tmp[0] = 2 Then
				$sPathAfterBase = StringTrimRight($tmp[2],StringLen($aVids[$aVids_iDx][$C_aVids_idx2_InputName])+1)
			Else
				$sPathAfterBase = $C_OutputFolderName
			EndIf
		EndIf
		$sOutputFolder = StringReplace($sOutputFolder,$C_sNotFullPath,$sPathAfterBase,1)
		Return $sOutputFolder
	EndFunc


	Func aVids_GenerateRealFullFilePath($aVids_iDx)
		If $aVids_iDx > $aVids[0][0] Then Return SetError(1)
		$tmp = aVids_GenerateRealFolderPath($aVids_iDx)
		If StringRight($tmp,1) <> '\' Then $tmp &= '\'
		Return $tmp&aVids_GenerateRealFilename($aVids_iDx)
	EndFunc


	Func aVids_GenerateRealFullCommand($aVids_iDx1)
		If $aVids_iDx1 > $aVids[0][0] Then Return SetError(1)
		Local $sCommand = $aVids[$aVids_iDx1][$C_aVids_idx2_Command]
		If Not $sCommand Then $sCommand = $aVids[0][$C_aVids_idx2_Command]

		Local $sOutPath = aVids_GenerateRealFullFilePath($aVids_iDx1)

		$sCommand = StringReplace($sCommand,'<input>','"'&$aVids[$aVids_iDx1][$C_aVids_idx2_InputPath]&'"',1)
		$sCommand = StringReplace($sCommand,'<output>','"'&$sOutPath&'"',1)

		Return $sCommand
	EndFunc

	#Region aVids_UpdateCommonPath
		Func aVids_UpdateCommonPath()

			Local $sCommonPath_old = $aVids_InputCommonPath

			$aVids_InputCommonPath = ''

			If $aVids[0][0] Then
				; Get the path from the first video
				Local $aCommonPath = StringSplit($aVids[1][$C_aVids_idx2_InputPath],'\',1)
				ReDim $aCommonPath[$aCommonPath[0]]
				$aCommonPath[0] -= 1

				Local $aPath



				; From the second video and so on..
				For $a = 2 To $aVids[0][0]

					#cs
						Remove uncommon strings from $aCommonPath
					#ce

					; Get the path from the video
					$aPath = StringSplit($aVids[$a][$C_aVids_idx2_InputPath],'\',1)
					$aPath[0] -= 1


					If $aPath[0] <> $aCommonPath[0] Then
						If $aPath[0] > $aCommonPath[0] Then
							$aPath[0] = $aCommonPath[0]
						Else ; $aPath[0] < $aCommonPath[0]
							$aCommonPath[0] = $aPath[0]
						EndIf
					EndIf


					For $a2 = $aPath[0] To 2 Step -1
						If $aPath[$a2] <> $aCommonPath[$a2] Then $aCommonPath[0] = $a2-1
					Next


				Next


				If $aCommonPath[0] Then
					If $aCommonPath[0] = 1 Then
						$aVids_InputCommonPath = $aCommonPath[1]&'\'&$C_OutputFolderName
					Else
						For $a = 1 To $aCommonPath[0]
							$aVids_InputCommonPath &= $aCommonPath[$a]
							If $a < $aCommonPath[0] Then $aVids_InputCommonPath &= '\'
						Next
					EndIf
				Else
					$aVids_InputCommonPath = 'C:\'&$C_OutputFolderName
					SetError(1)
				EndIf

			Else
				$aVids_InputCommonPath = 'C:\'&$C_OutputFolderName
			EndIf

;~ 			If Not $sCommonPath_old Then Return True

			If $sCommonPath_old <> $aVids_InputCommonPath Then
;~ 				If Not aV_UpCoPa_NextOutputFilesWillNotSavedAt($aVids_InputCommonPath) Then
;~ 					$aVids_InputCommonPath = $sCommonPath_old
;~ 					Return False
;~ 				Else
					Return True
;~ 				EndIf
			Else
				Return False
			EndIf
		EndFunc

		Func aV_UpCoPa_NextOutputFilesWillNotSavedAt($sNewFilder)
			Local Static $bDontShowAgain = False, $PreviousReturn
			If $bDontShowAgain Then Return $PreviousReturn


			Local Const $C_xSize = 397, $C_ySize = 131
			Local $xPos = -1, $yPos = -1
			GUIGetXYtoOpenOnCenter($MainGUI_hGUI,$xPos,$yPos, $C_xSize, $C_ySize)
			Local $hGUI = GUICreate("", $C_xSize, $C_ySize,$xPos,$yPos)
			GUICtrlCreateLabel("Next output files will be saved at folder:", 8, 8, 286, 23)
			GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
			GUICtrlCreateInput($sNewFilder, 8, 40, 377, 21)
			GUICtrlCreateLabel("Do you agree?", 8, 64, 107, 23)
			GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
			Local $Yes_Button = GUICtrlCreateButton("Yes", 8, 96, 73, 25)
			Local $No_Button = GUICtrlCreateButton("No", 95, 96, 73, 25)
			Local $NoAskAgain_Checkbox = GUICtrlCreateCheckbox("Do not ask me again", 184, 96, 177, 25)
			GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")

			GUISetState(@SW_SHOW)

			While 1

				If $MainGUI_hGUI <> -1 Then
					SOFTWARE_MAIN_LOOP()
				Else
					$GUI_MSG = GUIGetMsg(1) ; Update the main massage varible
				EndIf


;~ 				If $GUI_MSG[$C_GUIMsg_idx1_hGUI] <> $hGUI Then ContinueLoop

				Switch GUIGetMsg()
					Case $Yes_Button
						$PreviousReturn = True
						ExitLoop
					Case $No_Button
						$PreviousReturn = False
						ExitLoop
					Case $GUI_EVENT_CLOSE
						GUIDelete($hGUI)
						Return False
				EndSwitch
			WEnd

			If GUICtrlGetState($NoAskAgain_Checkbox) = $GUI_CHECKED Then $bDontShowAgain = True
			Return $PreviousReturn

		EndFunc
	#EndRegion

#EndRegion






#Region aVids_aActiveIdxs array
	Func aVids_aActiveIdxs_Add($Idx)
		_ArrayAdd($aVids_aActiveIdxs,$Idx)
		$aVids_aActiveIdxs[0] += 1
	EndFunc

	Func aVids_aActiveIdxs_Delete($Idx)
		_ArrayDelete($aVids_aActiveIdxs,$Idx)
		$aVids_aActiveIdxs[0] -= 1
	EndFunc

	Func aVids_aActiveIdxs_ActiveAll()
		ReDim $aVids_aActiveIdxs[$aVids[0][0]+1]
		$aVids_aActiveIdxs[0] = $aVids[0][0]
		For $a = 1 To $aVids_aActiveIdxs[0]
			$aVids_aActiveIdxs[$a] = $a
		Next
	EndFunc

	Func aVids_aActiveIdxs_UnActiveAll()
		ReDim $aVids_aActiveIdxs[1]
		$aVids_aActiveIdxs[0] = 0
	EndFunc
#EndRegion


