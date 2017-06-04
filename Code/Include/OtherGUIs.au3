



Func LicenseAgreement_GUI($bRegisterMsgLoop = True)

	Local Enum $GUILicenseAgreement, $Agre_Button, $Disagree_Button, $p_max
	Local $p[$p_max]

	$p[$GUILicenseAgreement] = GUICreate($C_SoftwareName & ' - EULA', 586, 479)

	GUICtrlCreateEdit(Null, 16, 56, 553, 353, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL))
	GUICtrlSetBkColor(-1, 0xF0F5F7)
	GUICtrlSetData(-1, _ResourceGetAsString('License'))
	GUICtrlCreateLabel('End User License Agreement (EULA)', 16, 8, 552, 37, $SS_CENTER)
	GUICtrlSetFont(-1, 20, 400, 4, "Tahoma")
	GUICtrlSetColor(-1, 0xFF0000)
	$p[$Agre_Button] = GUICtrlCreateButton('Agree', 144, 424, 107, 41)

	GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
	$p[$Disagree_Button] = GUICtrlCreateButton('Disagree', 326, 424, 107, 41)
	If $ini_LicenseAgreement Then GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
	GUISetState(@SW_SHOW)

	LicenseAgreement_GUI_ProcessMsg($p)

	If Not $bRegisterMsgLoop Then Return

	aExtraFuncCalls_AddFunc(LicenseAgreement_GUI_ProcessMsg)


EndFunc


Func LicenseAgreement_GUI_ProcessMsg($p = Default)

	Local Enum $GUILicenseAgreement, $Agre_Button, $Disagree_Button, $p_max
	Local Static $ps
	If $p <> Default Then
		$ps = $p
		Return
	EndIf

	If $GUI_MSG[$C_GUIMsg_idx1_hGUI] <> $ps[$GUILicenseAgreement] Then Return

	Switch $GUI_MSG[$C_GUIMsg_idx1_ControlID]

		Case $ps[$Agre_Button]
			If Not $ini_LicenseAgreement Then
				$ini_LicenseAgreement = 1
				IniWrite($ini,'Main','AgreLicense',$ini_LicenseAgreement)
			EndIf
			ContinueCase

		Case $GUI_EVENT_CLOSE

			If $GUI_MSG[$C_GUIMsg_idx1_ControlID] = $GUI_EVENT_CLOSE And Not $ini_LicenseAgreement Then ContinueCase
			GUIDelete($ps[$GUILicenseAgreement])
			If $MainGUI_hGUI <> -1 Then GUICtrlSetState($Menu_Help_License,$GUI_ENABLE)
			Return True

		Case $ps[$Disagree_Button]
			MsgBox(48, "", "In order to use the software, you must agree to the terms of use.", 0, $GUILicenseAgreement)
			SOFTWARE_SHUTDOWN()
	EndSwitch
EndFunc


