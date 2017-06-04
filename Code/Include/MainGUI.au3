

#Region Low-Level code
	Func MainGUI_UpdateBordersXYsizes()

		Local $xBorderSize = _WinAPI_GetSystemMetrics($SM_CXSIZEFRAME)
		If Not $xBorderSize Then Return
		$xBorderSize *= 2

		Local $yBorderSize = _WinAPI_GetSystemMetrics($SM_CYSIZEFRAME)
		If Not $yBorderSize Then Return
		$yBorderSize *= 2

		Local $yTitleSize = _WinAPI_GetSystemMetrics($SM_CYCAPTION)
		If Not $yTitleSize Then Return

		$MainGUI_BordersSize_X = $xBorderSize
		$MainGUI_BordersSize_Y = $yTitleSize+$yBorderSize
		$MainGUI_BordersSize_bError = False


	EndFunc

	Func MainGUI_InitMinDefWinSize()
		If $MainGUI_Expanded Then
			$MaGU_ClientSize1_X_def = $C_MaGU_ClientSize1_X_Expand_def
			$MaGU_ClientSize1_Y_def = $C_MaGU_ClientSize1_Y_Expand_def
		Else
			$MaGU_ClientSize1_X_def = $C_MaGU_ClientSize1_X_NoExpand_def
			$MaGU_ClientSize1_Y_def = $C_MaGU_ClientSize1_Y_NoExpand_def
		EndIf
	EndFunc


	Func MainGUI_EnforceMinSize($hWnd, $iMsg, $wParam, $lParam)
		Local $tagMaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $lParam)
		DllStructSetData($tagMaxinfo, 7, $MaGU_ClientSize1_X_def+$MainGUI_BordersSize_X) ; min X
		DllStructSetData($tagMaxinfo, 8, $MaGU_ClientSize1_Y_def+$MainGUI_BordersSize_Y) ; min Y

		Return 0
	EndFunc


#EndRegion


#Region settings initializers


	Func MainGUI_LoadSettings()

		; Get the Expanded state ($MainGUI_Expanded)
		$ini_MainGUI_Expanded = Number(GetSet('MainGUI','expanded',$C_ini_MainGUI_Expanded_def))
		$MainGUI_Expanded = $ini_MainGUI_Expanded


		; Init $MaGU_ClientSize1_X_def & $MaGU_ClientSize1_Y_def according to the expanded state ($MainGUI_Expanded)
		MainGUI_InitMinDefWinSize()

		; Load the saved winsize state

		$MaGU_ClientSize1_X = $MaGU_ClientSize1_X_def
		$MaGU_ClientSize1_Y = $MaGU_ClientSize1_Y_def

		If Not $MainGUI_BordersSize_bError Then

			$ini_MainGUI_xSize = Number(GetSet('MainGUI','x_size',$MaGU_ClientSize1_X_def))
			If $ini_MainGUI_xSize < @DesktopWidth Then
				$tmp = $ini_MainGUI_xSize-$MainGUI_BordersSize_X
				If $tmp > $MaGU_ClientSize1_X_def Then $MaGU_ClientSize1_X = $tmp
			EndIf

			$ini_MainGUI_ySize = Number(GetSet('MainGUI','y_size',$MaGU_ClientSize1_Y_def))
			If $ini_MainGUI_ySize < @DesktopHeight Then
				$tmp = $ini_MainGUI_ySize-$MainGUI_BordersSize_Y
				If $tmp > $MaGU_ClientSize1_Y_def Then $MaGU_ClientSize1_Y = $tmp
			EndIf
		EndIf

		; Load the maximized state
		$ini_MainGUI_Maximized = Number(GetSet('MainGUI','maximized',$C_ini_MainGUI_Maximized_def))




	EndFunc

	Func MainGUI_WriteSettings()
		Local $tmp

		; Write the maximaized state
		Local $Maximized
		$tmp = WinGetState($MainGUI_hGUI)
		If Not @error Then
			If BitAND($tmp, 32) Then
				; Maximaized case
				$Maximized = 1
			Else
				; Minimaized case
				$Maximized = 0
			EndIf
		EndIf
		If $Maximized <> $ini_MainGUI_Maximized Then IniWrite($ini,'MainGUI','maximized',$Maximized)


		; Write the new pos of the window
		If Not $Maximized And Not $MainGUI_BordersSize_bError Then
			$tmp = WinGetPos($MainGUI_hGUI)
			If Not @error Then
				If $ini_MainGUI_xSize <> $tmp[2] Then IniWrite($ini,'MainGUI','x_size',$tmp[2])
				If $ini_MainGUI_ySize <> $tmp[3] Then IniWrite($ini,'MainGUI','y_size',$tmp[3])
			EndIf
		EndIf


		; Write the expanded state
		If $MainGUI_Expanded <> $ini_MainGUI_Expanded Then _
			IniWrite($ini,'MainGUI','expanded',$MainGUI_Expanded)



	EndFunc



#EndRegion



#Region Core code for draw ctrls on the main window

	Func MainGUI_DrawAreas($bDraw,$bDrawVideoList = Default)


		Local $aClientSize = WinGetClientSize($MainGUI_hGUI)
		If @error Then
			Local $aClientSize[2]
			$aClientSize[0] = $MaGU_ClientSize1_X
			$aClientSize[1] = $MaGU_ClientSize1_Y-30
		EndIf

		Local $xEnd, $BottomArea_yPos
		$xEnd = $aClientSize[0] - $C_MainGUI_Areas_xSpace
		$BottomArea_yPos = $aClientSize[1] - $C_MaGU_Ar_Bottom_ySize_def


		If Not $MainGUI_Expanded Then


			MainGUI_Area_PreviewAndSettings_Draw( _
			$bDraw, _									;$bCreateCtrls
			$C_MainGUI_Areas_xSpace, _							;$xStart
			$xEnd, _											;$xEnd
			$C_MainGUI_Areas_ySpace, _							;$yStart
			$BottomArea_yPos)											;$yEnd



		Else
			If $bDrawVideoList = Default Then $bDrawVideoList = $bDraw

			Local Const $C_PrevAndSett_yPercentSize = 0.55
			Local $TotalYsize = $BottomArea_yPos-$C_MainGUI_Areas_ySpace
			Local $PrevAndSet_ySize = Round($TotalYsize*$C_PrevAndSett_yPercentSize)

			Local $yStartEnd = $C_MainGUI_Areas_ySpace+$PrevAndSet_ySize

			MainGUI_Area_PreviewAndSettings_Draw( _
			$bDraw, _									;$bCreateCtrls
			$C_MainGUI_Areas_xSpace, _							;$xStart
			$xEnd, _											;$xEnd
			$C_MainGUI_Areas_ySpace, _							;$yStart
			$yStartEnd)			;$yEnd

			$yStartEnd += $C_MainGUI_Areas_ySpace

			VideoList_DrawCtrls( _
			$bDrawVideoList, _					;$bDraw
			$C_MainGUI_Areas_xSpace, _			;$xStart
			$xEnd, _							;$xEnd
			$yStartEnd, _						;$yStart
			$BottomArea_yPos)					;$yEnd


		EndIf


		MainGUI_Area_Bottom_Draw( _
		$bDraw, _											;$bCreateCtrls
		$C_MainGUI_Areas_xSpace, _							;$xStart
		$xEnd, _											;$xEnd
		$BottomArea_yPos)											;$yStart


	EndFunc


	Func MainGUI_Area_PreviewAndSettings_Draw($bCreateCtrls,$xStart,$xEnd,$yStart,$yEnd)

			Local Const $C_SpaceFromCenter = 6 , $C_ExPrButton_ySize = 24, $C_ExPrButton_ySpace = 1

			$tmp = Round(($xEnd-$xStart)/2)

			Local $xSize = $tmp-$C_SpaceFromCenter
			Local $ySize = $yEnd-$yStart


			Local $Pre_xPos = $xStart+$tmp+$C_SpaceFromCenter
			Local $ExpPreBu_yPos = $yStart+$ySize+$C_ExPrButton_ySpace



			If $bCreateCtrls Then

				SettingsGUI_Create($MainGUI_hGUI,$xSize, $ySize, $xStart,$yStart)
				PreviewModule_MainGUI_Create($xSize,$ySize,$Pre_xPos,$yStart,$MainGUI_hGUI)

			Else
				SettingsGUI_RePos($xStart,$yStart,$xSize,$ySize)
				PreviewModule_MainGUI_Create($xSize,$ySize,$Pre_xPos,$yStart,Null)
				GUICtrlSetPos($MainGUI_ExpandPreview_Button,$Pre_xPos, $ExpPreBu_yPos,$xSize, $C_ExPrButton_ySize)
			EndIf


	EndFunc





	Func MainGUI_Area_Bottom_Draw($bCreateCtrls,$xStart,$xEnd,$yStart)

		;$C_MaGU_Ar_Bottom_ySize_def
		Local Const $C_ExBut_xSize = 206, $C_ExBut_ySize = 18, _
		$C_ExBut_yFixPos = 2, $C_StartComprBut_yFixPos = 21, _
		$C_StartComprBut_ySize = 40

		Local $ExBut_xPos, $ExBut_yPos, $xTSize = $xEnd-$xStart

		$ExBut_xPos = $xStart+Round((($xTSize)-$C_ExBut_xSize)/2)
		$ExBut_yPos = $yStart+$C_ExBut_yFixPos



		$StartComprBut_yPos = $yStart+$C_StartComprBut_yFixPos


		If $bCreateCtrls Then
			$MainGUI_Expand_Button = GUICtrlCreateButton('',$ExBut_xPos,$ExBut_yPos,$C_ExBut_xSize, $C_ExBut_ySize)
			GUICtrlSetFont(-1, 18, 400, 0, "Webdings")
			GUICtrlSetResizing(-1,$GUI_DOCKALL)


			$MainGUI_StartEncude_Button = GUICtrlCreateButton('Encode',$xStart,$StartComprBut_yPos,$xTSize, $C_StartComprBut_ySize)
			GUICtrlSetResizing(-1,$GUI_DOCKALL)
			GUICtrlSetFont(-1, 22, 400, 0, "Tahoma")

		Else
			GUICtrlSetPos($MainGUI_Expand_Button,$ExBut_xPos,$ExBut_yPos,$C_ExBut_xSize, $C_ExBut_ySize)
			GUICtrlSetPos($MainGUI_StartEncude_Button,$xStart,$StartComprBut_yPos,$xTSize, $C_StartComprBut_ySize)
		EndIf


		#cs

		Local $yPosStart = $MaGU_ClientSize2_Y-$C_MaGU_Ar_Bottom_ySize_def

		Local Const $C_Expand_Button_xSize = 206, $C_Expand_Button_ySize = 18
		Local $Expand_Button_xPos = $MaGU_ClientSize2_X_Center-Round($C_Expand_Button_xSize/2)


		;Local $Expand_Button_yPos = $yPosStart
		Local $StartCompress_Button_yPos = $yPosStart+21

		Local $StartCompress_Button_xSize = $MaGU_ClientSize2_X-($C_MainGUI_Areas_xSpace*2)+2
		Local Const $C_StartCompress_Button_ySize = 40
		Local $StartCompress_Button_xPos = $MaGU_ClientSize2_X_Center-Round($StartCompress_Button_xSize/2)


		If $bCreateCtrls Then


			$MainGUI_Expand_Button = GUICtrlCreateButton('',$Expand_Button_xPos,$yPosStart,$C_Expand_Button_xSize, $C_Expand_Button_ySize)
			GUICtrlSetFont(-1, 18, 400, 0, "Webdings")
			GUICtrlSetResizing(-1,$GUI_DOCKALL)

			$MainGUI_StartEncude_Button = GUICtrlCreateButton("Start Compress",$StartCompress_Button_xPos,$StartCompress_Button_yPos, _
											$StartCompress_Button_xSize, $C_StartCompress_Button_ySize)
			GUICtrlSetResizing(-1,$GUI_DOCKALL)
			GUICtrlSetFont(-1, 22, 400, 0, "Tahoma")

		Else

			GUICtrlSetPos($MainGUI_StartEncude_Button,$StartCompress_Button_xPos,$StartCompress_Button_yPos, $StartCompress_Button_xSize, $C_StartCompress_Button_ySize)
			GUICtrlSetPos($MainGUI_Expand_Button,$Expand_Button_xPos,$yPosStart, $C_Expand_Button_xSize, $C_Expand_Button_ySize)

		EndIf

		#ce

	EndFunc

	Func MainGUI_Area_Bottom_DrawExpandState()
		If $MainGUI_Expanded Then
			GUICtrlSetData($MainGUI_Expand_Button,'5')
		Else
			GUICtrlSetData($MainGUI_Expand_Button,'6')
		EndIf
	EndFunc

#EndRegion


#Region windows changes events

	Func MainGUI_SizingEvent($hWnd, $iMsg, $wParam, $lParam)
		; RePos the controls
		MainGUI_DrawAreas(False)
		AdlibRegister(PrMo_Frame_ReDrawImageAfterSizeChange_Adlib)
	EndFunc

#EndRegion














































































































