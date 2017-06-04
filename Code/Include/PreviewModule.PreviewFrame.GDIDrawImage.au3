
;~ #include-once
;~ #include <GDIPlus.au3>


;~ #include <Array.au3> ; <------------------------------------------------------------ TEST ONLY !!!!!!!!






Func PrMo_Fr_GDIDrawImage_InitializeGUI($hGUI = 0)

	If $PreMo_Frame_gdi_hGUI Then PrMo_Fr_GDIDrawImage_UnInitializeGUI()

	If $hGUI Then $PreMo_Frame_gdi_hGUI = $hGUI ; Set the GUI variable

	; Update the client area of the GUI
	$PreMo_Frame_gdi_aGUIClientSize = WinGetClientSize($PreMo_Frame_gdi_hGUI)
	If @error Then Return SetError(1)


	; Set hGraphic for the GUI
	If $PreMo_Frame_gdi_hGraphic Then _GDIPlus_GraphicsDispose($PreMo_Frame_gdi_hGraphic)

	$PreMo_Frame_gdi_hGraphic = _GDIPlus_GraphicsCreateFromHWND($PreMo_Frame_gdi_hGUI)
	If @error Then Return SetError(1,0,PrMo_Fr_GDIDrawImage_UnInitializeGUI())


EndFunc

Func PrMo_Fr_GDIDrawImage_UnInitializeGUI()
	_GDIPlus_GraphicsDispose($PreMo_Frame_gdi_hGraphic)
	$PreMo_Frame_gdi_hGUI = 0
	$PreMo_Frame_gdi_hGraphic = 0
	$PreMo_Frame_gdi_aGUIClientSize = 0
EndFunc






Func PrMo_Fr_GDIDrawImage_SetImageFromFile($FilePath)
	If $PreMo_Frame_gdi_hBitmap Then PrMo_Fr_GDIDrawImage_UnSetImage()

	$PreMo_Frame_gdi_hImage = _GDIPlus_ImageLoadFromFile($FilePath)
	$PreMo_Frame_gdi_Image_aXYsize = _GDIPlus_ImageGetDimension($PreMo_Frame_gdi_hImage)
	If @error Then
		PrMo_Fr_GDIDrawImage_UnSetImage()
		Return SetError(1)
	EndIf
	$PreMo_Frame_gdi_Image_aXYsizeSource = $PreMo_Frame_gdi_Image_aXYsize
	$PreMo_Frame_gdi_hBitmap = _GDIPlus_BitmapCreateFromScan0($PreMo_Frame_gdi_Image_aXYsize[0], $PreMo_Frame_gdi_Image_aXYsize[1])
	$PreMo_Frame_gdi_hContext = _GDIPlus_ImageGetGraphicsContext($PreMo_Frame_gdi_hBitmap)
	_GDIPlus_GraphicsDrawImageRect($PreMo_Frame_gdi_hContext, $PreMo_Frame_gdi_hImage, 0, 0, $PreMo_Frame_gdi_Image_aXYsize[0], $PreMo_Frame_gdi_Image_aXYsize[1])


EndFunc

#cs
Func _GDIDrawImage_InitializeImage()

EndFunc
#ce


Func PrMo_Fr_GDIDrawImage_UnSetImage()

	If $PreMo_Frame_gdi_hContext Then
		_GDIPlus_GraphicsDispose($PreMo_Frame_gdi_hContext)
		$PreMo_Frame_gdi_hContext = 0
	EndIf
	If $PreMo_Frame_gdi_hBitmap Then
		_GDIPlus_BitmapDispose($PreMo_Frame_gdi_hBitmap)
		$PreMo_Frame_gdi_hBitmap = 0
	EndIf
	If $PreMo_Frame_gdi_hImage Then
		_GDIPlus_ImageDispose($PreMo_Frame_gdi_hImage)
		$PreMo_Frame_gdi_hImage = 0
	EndIf

	;$PreMo_Frame_gdi_hBitmap = 0
	;$PreMo_Frame_gdi_hImage = 0
	;$PreMo_Frame_gdi_hContext = 0
	$PreMo_Frame_gdi_Image_aXYsize = 0
	$PreMo_Frame_gdi_Image_Xpos = 0
	$PreMo_Frame_gdi_Image_Ypos = 0
	$PreMo_Frame_gdi_Image_aXYsizeSource = 0
	$PreMo_Frame_gdi_Image_Xpos_iChange = 0
	$PreMo_Frame_gdi_Image_Ypos_iChange = 0
EndFunc

Func PrMo_Fr_GDIDrawImage_GetFitScaleFactorFromImage()
	If Not IsArray($PreMo_Frame_gdi_Image_aXYsizeSource) Then Return SetError(1) ; BUG that i leaved !!!!!!
	Local $iScaleFactor = PrMo_Fr_GDIDrawImage_GetFitScaleFactorFromImage_Inter($PreMo_Frame_gdi_Image_aXYsizeSource[1],$PreMo_Frame_gdi_aGUIClientSize[1])
	If Not @error Then Return $iScaleFactor
	Return PrMo_Fr_GDIDrawImage_GetFitScaleFactorFromImage_Inter($PreMo_Frame_gdi_Image_aXYsizeSource[0],$PreMo_Frame_gdi_aGUIClientSize[0])
EndFunc

Func PrMo_Fr_GDIDrawImage_GetFitScaleFactorFromImage_Inter($iImgSize,$iClientSize)
	Local $iScaleFactor = $iClientSize/$iImgSize
	If Int($PreMo_Frame_gdi_Image_aXYsizeSource[0]*$iScaleFactor) > $PreMo_Frame_gdi_aGUIClientSize[0] Or _
	Int($PreMo_Frame_gdi_Image_aXYsizeSource[1]*$iScaleFactor) > $PreMo_Frame_gdi_aGUIClientSize[1] Then Return SetError(1)
	Return $iScaleFactor
EndFunc


Func PrMo_Fr_GDIDrawImage_DrawImage($iScaleFactor = 0)

	If $iScaleFactor Then
		$PreMo_Frame_gdi_Image_aXYsize[0] = Round($PreMo_Frame_gdi_Image_aXYsizeSource[0]*$iScaleFactor)
		$PreMo_Frame_gdi_Image_aXYsize[1] = Round($PreMo_Frame_gdi_Image_aXYsizeSource[1]*$iScaleFactor)
	EndIf


	; Calculate were ( X , Y Poses) to draw the image so it will be on shown on the center of the GUI
	$PreMo_Frame_gdi_Image_Xpos = Round(($PreMo_Frame_gdi_aGUIClientSize[0]/2)-($PreMo_Frame_gdi_Image_aXYsize[0]/2))
	$PreMo_Frame_gdi_Image_Ypos = Round(($PreMo_Frame_gdi_aGUIClientSize[1]/2)-($PreMo_Frame_gdi_Image_aXYsize[1]/2))


	; Draw the image
	PrMo_Fr_GDIDrawImage_ReDrawImage()

EndFunc

Func PrMo_Fr_GDIDrawImage_ReDrawImage()
	; Clean the GUI in case there is something

	;_WinAPI_InvalidateRect($PreMo_Frame_gdi_hGUI)

	Local $Xpos = $PreMo_Frame_gdi_Image_Xpos+$PreMo_Frame_gdi_Image_Xpos_iChange, $Ypos = $PreMo_Frame_gdi_Image_Ypos+$PreMo_Frame_gdi_Image_Ypos_iChange

	PrMo_Fr_GDIDrawImage_GDICleanArea(0,0,$Xpos,$PreMo_Frame_gdi_aGUIClientSize[1])
	PrMo_Fr_GDIDrawImage_GDICleanArea(0,0,$PreMo_Frame_gdi_aGUIClientSize[0],$Ypos)
	PrMo_Fr_GDIDrawImage_GDICleanArea($Xpos+$PreMo_Frame_gdi_Image_aXYsize[0],0,$PreMo_Frame_gdi_aGUIClientSize[0]-($Xpos+$PreMo_Frame_gdi_Image_aXYsize[0]),$PreMo_Frame_gdi_aGUIClientSize[1])
	PrMo_Fr_GDIDrawImage_GDICleanArea(0,$Ypos+$PreMo_Frame_gdi_Image_aXYsize[1],$PreMo_Frame_gdi_aGUIClientSize[0],$PreMo_Frame_gdi_aGUIClientSize[1]-($Ypos+$PreMo_Frame_gdi_Image_aXYsize[1]))

	_GDIPlus_GraphicsDrawImageRect($PreMo_Frame_gdi_hGraphic, $PreMo_Frame_gdi_hBitmap, $Xpos, $Ypos,$PreMo_Frame_gdi_Image_aXYsize[0],$PreMo_Frame_gdi_Image_aXYsize[1])
	;ConsoleWrite('DrawRes: '&$PreMo_Frame_gdi_Image_aXYsize[0]&','&$PreMo_Frame_gdi_Image_aXYsize[1] & @CRLF)
EndFunc


Func PrMo_Fr_GDIDrawImage_GDICleanArea($x_pos,$y_pos,$x_size,$y_size)
	Local $tRect = DllStructCreate($tagRECT)
	DllStructSetData($tRect, 'Left', $x_pos)
	DllStructSetData($tRect, 'Top', $y_pos)
	DllStructSetData($tRect, 'Right', $x_pos+$x_size)
	DllStructSetData($tRect, 'Bottom', $y_pos+$y_size)
	If Not _WinAPI_InvalidateRect($PreMo_Frame_gdi_hGUI, $tRect, True) Then _
	Return SetError(1)
EndFunc






