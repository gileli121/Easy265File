
#Region Low-level code


#EndRegion


#Region Code for creating , redrewing the listview section


	Func VideoList_DrawCtrls($bDraw,$xStart,$xEnd,$yStart,$yEnd)

		Local $ListViewYendPos = $yEnd-30


		Local $ButtonsYpos = $ListViewYendPos+5
		Local Const $C_ButtonsYsize = 25
		Local Const $C_ButtonsXspace = 10
		Local Const $C_ButtonsXsize = 102

		Local $RemoveVideoXpos = ($C_ButtonsXspace*2)+$C_ButtonsXsize
		Local $RemoveAllVideosXpos = $RemoveVideoXpos+$C_ButtonsXsize+$C_ButtonsXspace




		If $bDraw Then

			; Create the list view
				$VideoList_ListView = GUICtrlCreateListView("", $xStart,$yStart,$xEnd-$xStart,$ListViewYendPos-$yStart, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS), BitOR($WS_EX_CLIENTEDGE, $LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
				GUICtrlSetResizing(-1,$GUI_DOCKALL)

				_GUICtrlListView_AddColumn($VideoList_ListView, "Source video")
				_GUICtrlListView_AddColumn($VideoList_ListView, "% Encoded",1)
				_GUICtrlListView_AddColumn($VideoList_ListView, "Duration")
				_GUICtrlListView_AddColumn($VideoList_ListView, "Size")
				_GUICtrlListView_AddColumn($VideoList_ListView, "Profile",1)
				_GUICtrlListView_AddColumn($VideoList_ListView, "Output path")
				_GUICtrlListView_AddColumn($VideoList_ListView, "Command")

				VideoList_ListView_ResizeColumns1()



			; Create the buttons
				$VideoList_AddVideoButton = GUICtrlCreateButton('Add videos',$C_ButtonsXspace,$ButtonsYpos,$C_ButtonsXsize,$C_ButtonsYsize)
				GUICtrlSetResizing(-1,$GUI_DOCKALL)

				$VideoList_RemoveVideoButton = GUICtrlCreateButton('Remove selected',$RemoveVideoXpos,$ButtonsYpos,$C_ButtonsXsize,$C_ButtonsYsize)
				GUICtrlSetResizing(-1,$GUI_DOCKALL)
				; Disable the button if no videos selected. otherwise leave it enabled
					If Not $aVids_aActiveIdxs[0] Then
						GUICtrlSetState(-1,$GUI_DISABLE)
						$VideoList_RemoveVideoButton_State = $GUI_DISABLE
					Else
						$VideoList_RemoveVideoButton_State = $GUI_ENABLE
					EndIf

				$VideoList_RemoveAllVideosButton = GUICtrlCreateButton('Remove all',$RemoveAllVideosXpos,$ButtonsYpos,$C_ButtonsXsize,$C_ButtonsYsize)
				GUICtrlSetResizing(-1,$GUI_DOCKALL)


			; Draw all videos from aVids in the listview and show them correcty
				VideoList_ListView_AddVideosFromaVids()


			; Select any active item
				For $a = 1 To $aVids_aActiveIdxs[0]
					_GUICtrlListView_SetItemSelected($VideoList_ListView, $aVids_aActiveIdxs[$a]-1, True)
				Next





			GUIRegisterMsg($WM_NOTIFY,VideoList_WM_NOTIFY)

		Else
			; Repos the controls
				GUICtrlSetPos($VideoList_ListView,$xStart,$yStart,$xEnd-$xStart,$ListViewYendPos-$yStart)

				GUICtrlSetPos($VideoList_AddVideoButton,$C_ButtonsXspace,$ButtonsYpos,$C_ButtonsXsize,$C_ButtonsYsize)
				GUICtrlSetPos($VideoList_RemoveVideoButton,$RemoveVideoXpos,$ButtonsYpos,$C_ButtonsXsize,$C_ButtonsYsize)
				GUICtrlSetPos($VideoList_RemoveAllVideosButton,$RemoveAllVideosXpos,$ButtonsYpos,$C_ButtonsXsize,$C_ButtonsYsize)

		EndIf

		_GUICtrlListView_SetColumnWidth($VideoList_ListView,$C_VideoList_ListView_colidxmax,$LVSCW_AUTOSIZE_USEHEADER)

	EndFunc



	Func VideoList_ListView_ResizeColumns1()
		#cs
			This function will resize the columns of the listview
		#ce
		_GUICtrlListView_SetColumnWidth($VideoList_ListView,$C_VideoList_ListView_colidx_SorceVid,$LVSCW_AUTOSIZE_USEHEADER)
		If $aVids[0][$C_aVids_idx2_0_EncoderStatusExists] Then _
		_GUICtrlListView_SetColumnWidth($VideoList_ListView,$C_VideoList_ListView_colidx_EncodedPercent,$LVSCW_AUTOSIZE_USEHEADER)
		_GUICtrlListView_SetColumnWidth($VideoList_ListView,$C_VideoList_ListView_colidx_Duration,$LVSCW_AUTOSIZE_USEHEADER)
		_GUICtrlListView_SetColumnWidth($VideoList_ListView,$C_VideoList_ListView_colidx_Size,$LVSCW_AUTOSIZE_USEHEADER)

		If $aProfiles[0][0] And $aProfiles[1][$C_aProfiles_idx2_VidCount] Then _
		_GUICtrlListView_SetColumnWidth($VideoList_ListView,$C_VideoList_ListView_colidx_Profile,$LVSCW_AUTOSIZE_USEHEADER)
		_GUICtrlListView_SetColumnWidth($VideoList_ListView,$C_VideoList_ListView_colidx_OutVid,$LVSCW_AUTOSIZE_USEHEADER)
		_GUICtrlListView_SetColumnWidth($VideoList_ListView,$C_VideoList_ListView_colidx_Command,465)


	EndFunc



	Func VideoList_HideCtrls()
		GUIRegisterMsg($WM_NOTIFY,'')
		GUICtrlSetState($VideoList_ListView,$GUI_HIDE)
		GUICtrlSetState($VideoList_AddVideoButton,$GUI_HIDE)
		GUICtrlSetState($VideoList_RemoveVideoButton,$GUI_HIDE)
		GUICtrlSetState($VideoList_RemoveAllVideosButton,$GUI_HIDE)
	EndFunc

	Func VideoList_UnHideCtrls()
		GUICtrlSetState($VideoList_ListView,$GUI_SHOW)
		GUICtrlSetState($VideoList_AddVideoButton,$GUI_SHOW)
		GUICtrlSetState($VideoList_RemoveVideoButton,$GUI_SHOW)
		GUICtrlSetState($VideoList_RemoveAllVideosButton,$GUI_SHOW)
		GUIRegisterMsg($WM_NOTIFY, VideoList_WM_NOTIFY)
	EndFunc




#EndRegion



#Region WM_NOTIFY

	Func VideoList_WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
		;If Not $VideoList_bMonitorWmNotify Then Return
		#forceref $hWnd, $iMsg, $wParam
		Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo
		; Local $tBuffer
		$hWndListView = $VideoList_ListView
		If Not IsHWnd($VideoList_ListView) Then $hWndListView = GUICtrlGetHandle($VideoList_ListView)

		$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
		$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
		$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
		$iCode = DllStructGetData($tNMHDR, "Code")

	;~ 	Local Static $KeyWasPressed = False

		Switch $hWndFrom
			Case $hWndListView

	;~ 			If $iCode = $LVN_KEYDOWN Then $KeyWasPressed = True


				Switch $iCode

					Case $LVN_KEYDOWN

						; Call to Items changed event...
							AdlibRegister(VideoList_ItemsChangedEvent_Adlib,100)


						; Check if the "Delete" key pressed and if so, delete all selected videos
							$taGLVKEYDOWN = DllStructCreate("int;int;int;int;uint", $lParam)
							If Hex(DllStructGetData($taGLVKEYDOWN, 4), 2) = Hex($VK_DELETE, 2) Then _
								VideoList_DeleteSelected()

					Case $NM_CLICK, $NM_RCLICK
						VideoList_ItemsChangedEvent()



					Case $LVN_ITEMCHANGED ; An item has changed



						$tInfo = DllStructCreate($tagNMLISTVIEW, $lParam)

						Local $iTem, $iNewState, $iOldState

						$iTem = DllStructGetData($tInfo, "Item")
						$iNewState = DllStructGetData($tInfo, "NewState")
						$iOldState = DllStructGetData($tInfo, "OldState")


						If Not BitAND($iOldState,$LVIS_SELECTED) And BitAND($iNewState,$LVIS_SELECTED) Then
							; Case video X selected

							aVids_aActiveIdxs_Add($iTem+1)


						ElseIf BitAND($iOldState,$LVIS_SELECTED) And Not BitAND($iNewState,$LVIS_SELECTED) Then
							; Case video X unselected
							Local $iItemIndexPos = _ArraySearch($aVids_aActiveIdxs,$iTem+1,1)
							If $iItemIndexPos > 0 Then
								_ArrayDelete($aVids_aActiveIdxs,$iItemIndexPos)
								$aVids_aActiveIdxs[0] -= 1
							EndIf
						EndIf

				EndSwitch

		EndSwitch
		Return $GUI_RUNDEFMSG
	EndFunc   ;==>WM_NOTIFY


	Func VideoList_ItemsChangedEvent()

		; Update the preview frame
			PrMo_Frame_Update()
		; return in case there is no change
			If Arrays1DIsEqual($aVids_aActiveIdxs,$aVids_aActiveIdxs_old) Then Return

		; Draw the settings of the selected videos
			$SettingsGUI_ComboTitle_CostumeSelectionProfile = SettingsGUI_DrawCommonSettings(True)

		; Disable / Enable the remove selected button - enable if some video selected, otherwise disable the button
			VideoList_ItemsChangedEvent_SetRemoveButtonState()

		; Update the old seleted videos array
			$aVids_aActiveIdxs_old = $aVids_aActiveIdxs
	EndFunc

	Func VideoList_ItemsChangedEvent_SetRemoveButtonState()
		If $aVids_aActiveIdxs[0] Then
			If $VideoList_RemoveVideoButton_State <> $GUI_ENABLE Then
				GUICtrlSetState($VideoList_RemoveVideoButton,$GUI_ENABLE)
				$VideoList_RemoveVideoButton_State = $GUI_ENABLE
			EndIf
		Else
			If $VideoList_RemoveVideoButton_State <> $GUI_DISABLE Then
				GUICtrlSetState($VideoList_RemoveVideoButton,$GUI_DISABLE)
				$VideoList_RemoveVideoButton_State = $GUI_DISABLE
			EndIf
		EndIf
	EndFunc

	Func VideoList_ItemsChangedEvent_Adlib()
		VideoList_ItemsChangedEvent()
		AdlibUnRegister(VideoList_ItemsChangedEvent_Adlib)
	EndFunc






#EndRegion

#Region Monitor events from the list view

	Func VideoList_ProcessMsg()



		Switch $GUI_MSG[$C_GUIMsg_idx1_ControlID]
			Case $VideoList_AddVideoButton
				VideoList_AddVideos()

			Case $VideoList_RemoveVideoButton
				VideoList_DeleteSelected()

			Case $VideoList_RemoveAllVideosButton

				VideoList_DeleteAll()

		EndSwitch

	EndFunc






#EndRegion

#Region React to events

	Func VideoList_AddVideos()

		GUIDisable($MainGUI_hGUI)
		;Commander_SuspendOrResumeExeProcess(True,$C_PraiortyLevelMax-1)

		Local $sSelectedFiles = FileOpenDialog( _
		'Select videos to add', _
		$LastDir, _
		'Videos (*.avi;*.mkv;*.flv;*.mp4;*.wmv;*.divx;*.mov;*.xvid;*.mpc;*.mts) | All (*)', _
		$FD_FILEMUSTEXIST + $FD_MULTISELECT)

		;Commander_SuspendOrResumeExeProcess(False,$C_PraiortyLevelMax-1)

		If Not @error Then

			Local $aTmp = StringSplit($sSelectedFiles,'|',1)
			If $aTmp[0] = 1 Then
				$LastDir = GetDirFromFilePath($sSelectedFiles)
				aVids_AddVideo($sSelectedFiles)
				If Not @error Then
					$tmp = aVids_UpdateCommonPath()
					If $VideoList_ListView Then
						If $tmp Then VideoList_ListView_ReDrawFullOutputPathForAllVids()
						VideoList_ListView_AddNewVideo($aVids[0][0])
					EndIf
					SettingsGUI_ComboTitle_InitComboStrings()
					SettingsGUI_ComboTitle_ReDraw()
				Else
					MsgBox(64,'','Video already exists or unknown error')
				EndIf

			Else
				$LastDir = $aTmp[1]
				If StringRight($LastDir,1) <> '\' Then $LastDir &= '\'
				For $a = 2 To $aTmp[0]
					aVids_AddVideo($LastDir&$aTmp[$a])
					If @error Then ContinueLoop
					If $VideoList_ListView Then VideoList_ListView_AddNewVideo($aVids[0][0])
				Next


				If aVids_UpdateCommonPath() And $VideoList_ListView Then _
					VideoList_ListView_ReDrawFullOutputPathForAllVids()

				SettingsGUI_ComboTitle_InitComboStrings()
				SettingsGUI_ComboTitle_ReDraw()
			EndIf


			If $VideoList_ListView Then VideoList_ListView_ResizeColumns1()

		EndIf


		GUIEnable($MainGUI_hGUI)

		;SettingsGUI_DrawCommonSettings(True)


	EndFunc



	Func VideoList_AddVideosFromFolder($sFolder,$iMode) ; $iMode = $FLTAR_NORECUR / $FLTAR_RECUR

		Local $aVideos = _FileListToArrayRec($sFolder, _
			';*.'&StringReplace($InputFileTypes,',',';*.') , _
			$FLTAR_FILESFOLDERS, $iMode , $FLTAR_NOSORT);, $FLTAR_FULLPATH)

		If Not IsArray($aVideos) Then Return SetError(1)


		If StringRight($sFolder,1) <> '\' Then $sFolder &= '\'

		For $a = 1 To $aVideos[0]
			;If Not GetFileExtFromStr($aVideos[$a]) Then ContinueLoop
			;ConsoleWrite($sFolder&$aVideos[$a] &@CRLF)
			aVids_AddVideo($sFolder&$aVideos[$a])
			If @error Then ContinueLoop
			If $VideoList_ListView Then VideoList_ListView_AddNewVideo($aVids[0][0])

		Next

		$tmp = aVids_UpdateCommonPath()
		If $VideoList_ListView Then
			If $tmp Then VideoList_ListView_ReDrawFullOutputPathForAllVids()
			VideoList_ListView_ResizeColumns1()
		EndIf

		SettingsGUI_ComboTitle_InitComboStrings()
		SettingsGUI_ComboTitle_ReDraw()








	EndFunc



	Func VideoList_AddVideosFromFolder_GUI($p_sFolder = Null, $bSetMsgProcessor = True)

		GUICtrlSetState($Menu_File_AddVideosFromFolder,$GUI_DISABLE)

		If Not $p_sFolder Then
			;Commander_SuspendOrResumeExeProcess(True,$C_PraiortyLevelMax-1)
			$p_sFolder = FileSelectFolder('Select folder from where to add videos',$LastDir)
			;Commander_SuspendOrResumeExeProcess(False,$C_PraiortyLevelMax-1)

			If Not $p_sFolder Then Return GUICtrlSetState($Menu_File_AddVideosFromFolder,$GUI_ENABLE)
		EndIf



		Local Enum $hGUI, $ThisFolderOnly_Radio, $IncludeSubFolders_Radio, $Continue_Button, $FileTypes_Input, $iMode, $sFolder, $p_max

		Local $p[$p_max]

		$p[$sFolder] = $p_sFolder
		$LastDir = $p[$sFolder]


		Local Const $C_xSize = 831, $C_ySize = 156
		Local $xPos = -1, $yPos = -1

		GUIGetXYtoOpenOnCenter($MainGUI_hGUI,$xPos,$yPos, $C_xSize, $C_ySize)

		$p[$hGUI] = GUICreate('Add videos from folder: "'&$p[$sFolder]&'"', $C_xSize, $C_ySize, $xPos,$yPos, $WS_BORDER,$WS_EX_TOOLWINDOW,$MainGUI_hGUI)
		$p[$ThisFolderOnly_Radio] = GUICtrlCreateRadio("Add videos only from this folder and don't include videos from sub folders",16, 10, 633, 17)
		GUICtrlSetFont(-1, 12, 800, 0, "Tahoma")
		GUICtrlSetState(-1,$GUI_CHECKED)
		$p[$IncludeSubFolders_Radio] = GUICtrlCreateRadio("Add videos from this folder and from it's sub folders", 16, 42, 561, 17)
		$p[$iMode] = $FLTAR_NORECUR
		GUICtrlSetFont(-1, 12, 800, 0, "Tahoma")
		$p[$Continue_Button] = GUICtrlCreateButton("Continue", 656, 8, 147, 59)
		GUICtrlSetFont(-1, 12, 800, 0, "Tahoma")

		GUICtrlCreateLabel("File types to include:", 16, 70, 158, 23)
		GUICtrlSetFont(-1, 12, 400, 4, "Tahoma")
		$p[$FileTypes_Input] = GUICtrlCreateInput($InputFileTypes, 16, 94, 785, 27)
		GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")



		GUISetState(@SW_SHOW)

		VideoList_AddVideosFromFolder_ProcessMsg($p)

		If $bSetMsgProcessor Then aExtraFuncCalls_AddFunc(VideoList_AddVideosFromFolder_ProcessMsg)


	EndFunc


	Func VideoList_AddVideosFromFolder_ProcessMsg($p = Default)
		Local Static $ps
		Local Enum $hGUI, $ThisFolderOnly_Radio, $IncludeSubFolders_Radio, $Continue_Button, $FileTypes_Input, $iMode, $sFolder, $p_max

		If $p <> Default Then
			$ps = $p
			Return
		EndIf


		If $GUI_MSG[$C_GUIMsg_idx1_hGUI] <> $ps[$hGUI] Then Return



		Switch $GUI_MSG[$C_GUIMsg_idx1_ControlID]

			Case $ps[$ThisFolderOnly_Radio]
				$ps[$iMode] = $FLTAR_NORECUR
			Case $ps[$IncludeSubFolders_Radio]
				$ps[$iMode] = $FLTAR_RECUR
			Case $ps[$Continue_Button]



				$InputFileTypes = StringStripWS(GUICtrlRead($ps[$FileTypes_Input]),3)
				If Not $InputFileTypes Then $InputFileTypes = $ini_C_def_InputFileTypes

				GUIDelete($ps[$hGUI])


				VideoList_AddVideosFromFolder($ps[$sFolder],$ps[$iMode])


				;aExtraFuncCalls_RemoveFunc(VideoList_AddVideosFromFolder_ProcessMsg)
				;$ps = Null
				GUICtrlSetState($Menu_File_AddVideosFromFolder,$GUI_ENABLE)
				Return True ; Return true to not call his function again from the main loop next time

		EndSwitch


	EndFunc


	Func VideoList_DeleteSelected()
		If Not $aVids_aActiveIdxs[0] Then Return

		GUIRegisterMsg($WM_NOTIFY,'')
		;$VideoList_bMonitorWmNotify = False

		_ArraySort($aVids_aActiveIdxs,0,1,$aVids_aActiveIdxs[0])

		Local $aVids_IdxOffset = 0, $aVids_aActiveIdxs_Idx = 1, $aVids_aActiveIdxs_IdxMax = $aVids_aActiveIdxs[0]

		While $aVids_aActiveIdxs[0]
			aVids_RemoveRow($aVids_aActiveIdxs[$aVids_aActiveIdxs_Idx]-$aVids_IdxOffset)
			_GUICtrlListView_DeleteItem($VideoList_ListView,$aVids_aActiveIdxs[$aVids_aActiveIdxs_Idx]-1-$aVids_IdxOffset)
			;_ArrayDelete($aVids_aActiveIdxs,1)
			$aVids_aActiveIdxs[0] -= 1
			$aVids_IdxOffset += 1
			$aVids_aActiveIdxs_Idx += 1
			;If $aVids_aActiveIdxs_Idx > $aVids_aActiveIdxs_IdxMax Then ExitLoop
		WEnd

		ReDim $aVids_aActiveIdxs[1]

		;$VideoList_bMonitorWmNotify = True

		If aVids_UpdateCommonPath() Then VideoList_ListView_ReDrawFullOutputPathForAllVids()

		SettingsGUI_ComboTitle_InitComboStrings(True)
		SettingsGUI_DrawCommonSettings(True)

		GUIRegisterMsg($WM_NOTIFY,VideoList_WM_NOTIFY)

		PrMo_Frame_Update()

	EndFunc


	Func VideoList_DeleteAll()
		If Not $aVids[0][0] Then Return

		If $VideoList_ListView Then
			GUIRegisterMsg($WM_NOTIFY,Null)
			_GUICtrlListView_DeleteAllItems($VideoList_ListView)
		EndIf
		ReDim $aVids[1][$C_aVids_idxmax2]
		$aVids[0][0] = 0
		ReDim $aVids_aActiveIdxs[1]
		$aVids_aActiveIdxs[0] = 0
		$aVids_aActiveIdxs_old = $aVids_aActiveIdxs


		SettingsGUI_ComboTitle_InitComboStrings(True)
		SettingsGUI_DrawCommonSettings(True)

		If $VideoList_ListView Then GUIRegisterMsg($WM_NOTIFY,VideoList_WM_NOTIFY)
		PrMo_Frame_Update()
	EndFunc

#EndRegion





#Region Code for draw videos on the listview from the aVids table


	#Region Functions to draw the  info about the videos - video time , size , name and settings
	Func VideoList_ListView_AddVideosFromaVids()
		#cs
			This function will draw on the display list all the videos in the aVids table
		#ce
		For $a = 1 To $aVids[0][0]
			VideoList_ListView_AddNewVideo($a)
		Next
		VideoList_ListView_ResizeColumns1()
	EndFunc

	Func VideoList_ListView_AddNewVideo($aVidsIndexKey) ; $aVidsIndexKey is the index in the aVids array
		#cs
			This function will add new item on the list view and draw on the item the info
			of the selected video in the aVids table
		#ce
		_GUICtrlListView_AddItem($VideoList_ListView,'')
		VideoList_ListView_UpdateVideo($aVidsIndexKey)
	EndFunc

	Func VideoList_ListView_UpdateVideo($aVidsIndexKey) ; Redraw every settings on the selected video
		#cs


			Draw the info of the video on the display. the info of the video is loaded from the aVids table
			$aVidsIndexKey = the index of the video in the aVids table and also point to the 0-base index in
			the listview display
		#ce


		Local $iItemIdx = $aVidsIndexKey-1 ; Init the index in the list view


		; Draw the input path of the video  TODO
			_GUICtrlListView_SetItemText( _
			$VideoList_ListView, _ 											; $hWnd
			$iItemIdx, _ 													; $iIndex
			$aVids[$aVidsIndexKey][$C_aVids_idx2_InputPath], _ 				; $sText
			$C_VideoList_ListView_colidx_SorceVid) 							; $iSubItem

		; Draw the size of the video
			_GUICtrlListView_SetItemText( _
			$VideoList_ListView, _ 														; $hWnd
			$iItemIdx, _ 																; $iIndex
			ByteSuffix($aVids[$aVidsIndexKey][$C_aVids_idx2_OriginalSize]), _ 			; $sText
			$C_VideoList_ListView_colidx_Size) 											; $iSubItem


		; Draw the time of the video
			VideoList_ListView_UpdateTime($aVidsIndexKey)

		If $aVids[$aVidsIndexKey][$C_aVids_idx2_ProfileID] Then
			_GUICtrlListView_SetItemText( _
			$VideoList_ListView, _ 								; $hWnd
			$iItemIdx, _ 										; $iIndex
			$aVids[$aVidsIndexKey][$C_aVids_idx2_ProfileID], _ 	; $sText
			$C_VideoList_ListView_colidx_Profile) 				; $iSubItem
		EndIf




		_GUICtrlListView_SetItemText( _
		$VideoList_ListView, _ 									; $hWnd
		$iItemIdx, _ 											; $iIndex
		aVids_ReadSet($aVidsIndexKey,$C_aVids_idx2_Command), _	 ; $sText
		$C_VideoList_ListView_colidx_Command) 					; $iSubItem



		_GUICtrlListView_SetItemText( _
		$VideoList_ListView, _ 											; $hWnd
		$iItemIdx, _ 													; $iIndex
		aVids_GenerateRealFullFilePath($aVidsIndexKey), _ 				; $sText
		$C_VideoList_ListView_colidx_OutVid) 							; $iSubItem



		If $aVids[$aVidsIndexKey][$C_aVids_idx2_EncoderStatus] Then VideoList_ListView_UpdateEncodedStatus($aVidsIndexKey)




	EndFunc


	#EndRegion


	#Region Update specific cols
	Func VideoList_ListView_UpdateTime($aVidsIndex)

		; Get the time of the video from the aVids table
		Local $iDuration = $aVids[$aVidsIndex][$C_aVids_idx2_Duration_s]

		; If there is no data then return
		If Not $iDuration Then Return

		If $iDuration > 0 Then
			; We have no error -> write the time in HMS format
			_GUICtrlListView_SetItemText($VideoList_ListView,$aVidsIndex-1,Sec2Time($iDuration),$C_VideoList_ListView_colidx_Duration)
;~ 		Else
			; We have some error so we draw the error as "Error"
;~ 			_GUICtrlListView_SetItemText($VideoList_ListView,$aVidsIndex-1,'Error',$C_VideoList_ListView_colidx_Duration)
		EndIf

	EndFunc


	Func VideoList_ListView_UpdateEncodedStatus($aVidsIndex)
		If Not $VideoList_ListView Then Return

		_GUICtrlListView_SetItemText( _
		$VideoList_ListView, _ 											; $hWnd
		$aVidsIndex-1, _ 												; $iIndex
		$aVids[$aVidsIndex][$C_aVids_idx2_EncoderStatus], _ 		; $sText
		$C_VideoList_ListView_colidx_EncodedPercent) 					; $iSubItem

		If Not $aVids[0][$C_aVids_idx2_0_EncoderStatusExists] Then
			_GUICtrlListView_SetColumnWidth($VideoList_ListView,$C_VideoList_ListView_colidx_EncodedPercent,$LVSCW_AUTOSIZE_USEHEADER)
			$aVids[0][$C_aVids_idx2_0_EncoderStatusExists] = True
		EndIf
	EndFunc




	Func VideoList_ListView_ReDrawFullOutputPathForAllVids()
		;If Not $VideoList_ListView Then Return

		For $a = 1 To $aVids[0][0]
			If $Encoder_sActiveVid = $aVids[$a][$C_aVids_idx2_InputPath] Then ContinueLoop
			_GUICtrlListView_SetItemText( _
			$VideoList_ListView, _ 											; $hWnd
			$a-1, _ 													; $iIndex
			aVids_GenerateRealFullFilePath($a), _ 				; $sText
			$C_VideoList_ListView_colidx_OutVid) 							; $iSubItem
		Next

	EndFunc


	#EndRegion

	#Region Functions to draw *non-constant* info about the videos. for example the settings of the videos
	Func VideoList_ListView_DrawVidInfoFromaVidsIndexToListViewRaw($aVids_idx1,$aVids_idx2)
		#cs
			Get the selected feild ($aVids_idx2) from the selected video ($aVids_idx1)
			->
			Draw the it on the correct area in the listview (in the correct way)
		#ce

		If Not $VideoList_ListView Then Return


		Switch $aVids_idx2

			Case $C_aVids_idx2_OutputName,$C_aVids_idx2_OutContainer,$C_aVids_idx2_OutputFolder
				; $C_VideoList_ListView_colidx_OutVid


				_GUICtrlListView_SetItemText( _
				$VideoList_ListView, _ 											; $hWnd
				$aVids_idx1-1, _ 													; $iIndex
				aVids_GenerateRealFullFilePath($aVids_idx1), _ 						; $sText
				$C_VideoList_ListView_colidx_OutVid) 								; $iSubItem



			Case $C_aVids_idx2_Command
				;$C_VideoList_ListView_colidx_Command

					_GUICtrlListView_SetItemText( _
					$VideoList_ListView, _ 											; $hWnd
					$aVids_idx1-1, _ 													; $iIndex
					$aVids[$aVids_idx1][$C_aVids_idx2_Command], _ 				; $sText
					$C_VideoList_ListView_colidx_Command) 							; $iSubItem

		EndSwitch



	EndFunc


	Func VideoList_ListView_ReDrawDefaults()
		#cs
			This function will redraw all the defaults
		#ce

		If Not $VideoList_ListView Then Return


		For $a = 1 To $aVids[0][0]
			If $aVids[$a][$C_aVids_idx2_ProfileID] Then ContinueLoop
			VideoList_ListView_ReDrawDefaults_iDx($a)
		Next

	EndFunc


	Func VideoList_ListView_ReDrawDefaults_iDx($aVids_idx1)

		_GUICtrlListView_SetItemText( _
		$VideoList_ListView, _ 									; $hWnd
		$aVids_idx1-1, _ 										; $iIndex
		aVids_GenerateRealFullFilePath($aVids_idx1), _ 			; $sText
		$C_VideoList_ListView_colidx_OutVid) 					; $iSubItem


		_GUICtrlListView_SetItemText( _
		$VideoList_ListView, _ 									; $hWnd
		$aVids_idx1-1, _ 										; $iIndex
		$aVids[0][$C_aVids_idx2_Command], _ 						; $sText
		$C_VideoList_ListView_colidx_Command) 					; $iSubItem


	EndFunc

	#EndRegion
#EndRegion






