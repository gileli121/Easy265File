#NoTrayIcon


#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/RM /SV=1 /SF=1 /PE

#AutoIt3Wrapper_Icon=Resources\icon.ico

#AutoIt3Wrapper_Res_Description=Easy265File v1.0.0-alpha
#AutoIt3Wrapper_Res_Fileversion=1.000
#AutoIt3Wrapper_Res_ProductVersion=1.000
#AutoIt3Wrapper_Res_LegalCopyright=© 2017 gileli121@gmail.com
#AutoIt3Wrapper_Res_Comment=easy265file.blogspot.com


#AutoIt3Wrapper_Res_File_Add=Resources\License.txt, rt_rcdata, License

#AutoIt3Wrapper_Res_File_Add=Resources\images\donate.png, rt_rcdata, Image_DonateButton
#AutoIt3Wrapper_Res_File_Add=Resources\images\save.png, rt_rcdata, Image_SaveButton
#AutoIt3Wrapper_Res_File_Add=Resources\images\save_to_selected.png, rt_rcdata, Image_SaveToSelected
#AutoIt3Wrapper_Res_File_Add=Resources\images\delete_settings.png, rt_rcdata, Image_DeleteSettings



#Region Includes & Global variables


#Region Autoit Includes
	#include <ButtonConstants.au3>
	#include <GUIConstantsEx.au3>
	#include <ColorConstantS.au3>
	#include <StaticConstants.au3>
	#include <WindowsConstants.au3>
	#include <SliderConstants.au3>
	#include <TabConstants.au3>
	#include <StaticConstants.au3>
	#include <EditConstants.au3>
	#include <ComboConstants.au3>
	#include <Array.au3>
	#include <GDIPlus.au3>
	#include <WinAPIMisc.au3>
	#include <AutoItConstants.au3>
	#include <TreeViewConstants.au3>
	#include <WinAPIGdi.au3>
	#include <WinAPISys.au3>
	#include <GuiListView.au3>
	#include <MsgBoxConstants.au3>
	#include <String.au3>
	#include <WinAPIvkeysConstants.au3>
	#include <ScrollBarsConstants.au3>
	#include <GuiEdit.au3>
	#include <File.au3>
	#include <StringConstants.au3>
	#include <FileConstants.au3>

#EndRegion

#Region Software Includes
	#include 'Include\Commander.au3'
	#include 'Include\StrDB.au3'

	#include 'Include\Processes_Threads_nDLLs\_ProcessListFunctions.au3'
	#include <resources.au3>
	#Include 'Include\NotifyBox.au3'
#EndRegion



#Region Tabels - GLOBALS
	#include 'Include\aProfiles.Globals.au3'
	#include 'Include\aVids.Globals.au3'
	#include 'Include\aExtraFuncCalls.Globals.au3'
#EndRegion

#Region Software Includes - GLOBALS

	#include 'Include\Common.Globals.au3'
	#include 'Include\Constants.au3'
	#include 'Include\MainGUI.Globals.au3'
	#include 'Include\SettingsGUI.Globals.au3'
	#include 'Include\PreviewModule.Globals.au3'
	#include 'Include\VideosList.Globals.au3'
	#include 'Include\Encoder.Globals.au3'
	#include 'Include\Menu.Globals.au3'


#EndRegion

#Region Software Includes
	#include 'Include\LowLevelFunctions.au3'
	#include 'Include\Common.au3'
	#include 'Include\MainGUI.au3'
	#include 'Include\SettingsGUI.au3'
	#include 'Include\PreviewModule.au3'
	#include 'Include\VideosList.au3'
	#include 'Include\Encoder.au3'
	#include 'Include\Menu.au3'
	#include 'Include\OtherGUIs.au3'
#EndRegion


#Region Tabels
	#include 'Include\aVids.au3'
	#include 'Include\aProfiles.au3'
	#include 'Include\aExtraFuncCalls.au3'
#EndRegion


#EndRegion



#cs
	========================================== CODE START FROM HERE ===========================================
#ce




#Region Test area

#cs
	HotKeySet('{1}','Debug1')
	Func Debug1()
		_ArrayDisplay($aVids,'Count: '&$aVids[0][0])
	EndFunc


	HotKeySet('{2}','Debug2')
	Func Debug2()
		_ArrayDisplay($Commander_aJobList)
	EndFunc

	HotKeySet('{3}',Debug3)
	Func Debug3()
;~ 		SaveTasks()
;~ 		ConsoleWrite('SaveTasks' &' (L: '&@ScriptLineNumber&')'&@CRLF)

		_ArrayDisplay($aVids_aActiveIdxs_old)
	EndFunc
#ce


#EndRegion






#Region ================ Prepering few stuff before creating the GUI =======================




; Some stuff we need later:
	MainGUI_UpdateBordersXYsizes() ; Need to get the default sizes fo the borders (for few stuff)


; Load settings:
	LoadMainSettings() ; Load the main settings (not including settings for gui)

; Show the user the license agreement in case he did not agre before
	If Not $ini_LicenseAgreement Then
		LicenseAgreement_GUI(False)
		Do
			$GUI_MSG = GUIGetMsg(1)
		Until LicenseAgreement_GUI_ProcessMsg()
	EndIf

	PreviewModule_LoadSettings() ; Load the main settings for the preview stuff

	MainGUI_LoadSettings() ; Load the display settings for the GUI


; Load selected files from command line (if there any)
	LoadFilesOnStartUp()


	_GDIPlus_Startup() ; Start the GDI module (needed for showing the preview frames)


; Clean the temp folder in case it wasnt cleaned before
	DeleteSupTempsFolders()


#EndRegion





#Region ================================= Create the main GUI (MainGUI) ==========================
; Create the main window of the program
	$MainGUI_hGUI = GUICreate($C_SoftwareName&' v'&$C_sSoftwareVer, $MaGU_ClientSize1_X, $MaGU_ClientSize1_Y,-1,-1,$WS_OVERLAPPEDWINDOW, $WS_EX_ACCEPTFILES)

; Create the main console of the program
	Local Const $C_ConsoleXsize = 643, $C_ConsoleYsize = 592




; Create menu items
	$Menu_File = GUICtrlCreateMenu('File')
		$Menu_File_AddVideo = GUICtrlCreateMenuItem('Add video(s)',$Menu_File)
		$Menu_File_AddVideosFromFolder = GUICtrlCreateMenuItem('Add folder',$Menu_File)
		GUICtrlCreateMenuItem(Null,$Menu_File)
		$Menu_File_SaveTasks = GUICtrlCreateMenuItem('Save tasks',$Menu_File)
		$Menu_File_LoadTasks = GUICtrlCreateMenuItem('Load tasks',$Menu_File)
		GUICtrlCreateMenuItem(Null,$Menu_File)
		$Menu_File_Exit = GUICtrlCreateMenuItem('Exit',$Menu_File)


	$Menu_Options = GUICtrlCreateMenu('Options')
		$Menu_Options_FFmpegDir = GUICtrlCreateMenuItem('Change FFmpeg folder',$Menu_Options)
		GUICtrlCreateMenuItem(Null,$Menu_Options)
		$Menu_Options_ChangeTMP = GUICtrlCreateMenuItem('Change TEMP folder',$Menu_Options)
		$Menu_Options_CleanTMP = GUICtrlCreateMenuItem('Clean TEMP folder',$Menu_Options)
		GUICtrlCreateMenuItem(Null,$Menu_Options)
		$Menu_Options_OutputPreview = GUICtrlCreateMenuItem('Output preview settings',$Menu_Options)


	$Menu_Help = GUICtrlCreateMenu('Help')
		$Menu_Help_Donate = GUICtrlCreateMenuItem('Donate ',$Menu_Help)
		GUICtrlCreateMenuItem(Null,$Menu_Help)
		$Menu_Help_About = GUICtrlCreateMenuItem('About',$Menu_Help)
		$Menu_Help_License = GUICtrlCreateMenuItem('License',$Menu_Help)
		GUICtrlCreateMenuItem(Null,$Menu_Help)
		$Menu_Help_WebSite = GUICtrlCreateMenuItem('Website',$Menu_Help)
		$Menu_Help_CheckForUpdate = GUICtrlCreateMenuItem('Check for updates',$Menu_Help)






; Maximize the main window if the ini files tell us to do so
	If $ini_MainGUI_Maximized Then GUISetState(@SW_MAXIMIZE,$MainGUI_hGUI)


; Create the controls & sub-window on the main window
	MainGUI_DrawAreas(True)
	MainGUI_Area_Bottom_DrawExpandState() ; Draw the correct arro on the expand button


; Draw the settings of the selected files
	SettingsGUI_DrawCommonSettings(True)


; Show the main GUI
	GUISetState(@SW_SHOW,$MainGUI_hGUI)



; Draw the selected preview frame in the selected the video
	PrMo_Frame_Update()



; Register some massange handles thred
	GUIRegisterMsg($WM_SIZE, WM_SIZE) ; Thred for sizing events
	GUIRegisterMsg($WM_GETMINMAXINFO,WM_GETMINMAXINFO) ; Thred for minimizing/maximizing events
	GUIRegisterMsg($WM_DROPFILES, WM_DROPFILES_FUNC)

; Open the settings window to set the folder to ffmpeg.exe if we need to..
	If Not FileExists($FFmpegPath) Or Not FileExists($FFprobePath) Then SetFFmpegFolder_GUI()

#EndRegion - DONE




#Region Prepering few stuf for the MAIN LOOP
Local $GuiLoopProcessors1_Timer
Local Const $C_GuiLoopProcessors1_WaitTime = 250
#EndRegion


#Region @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ <MAIN LOOP> @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

										#cs
											Run the main loop here:
										#ce
										While 1
											SOFTWARE_MAIN_LOOP()
										WEnd

Func SOFTWARE_MAIN_LOOP() ; =====> 	The func of the main loop can be called form other places also if needed


	Commander_ProcessJobs() ; Keep to handle command-line jobs at the same time (if there any)


	$GUI_MSG = GUIGetMsg(1) ; Update the main massage varible

	#cs
		React to evets from all GUIs of the software
	#ce
	Switch $GUI_MSG[$C_GUIMsg_idx1_hGUI]

		Case $SettingsGUI_hGUI ; React to evets from the settings GUI that is part of the main GUI
			; If the main massage is about the settings sub window then process the masseges for the settings sub window
			SettingsGUI_ProcessMsg()
		Case $PrMo_MainGUI_hGUI, $PrMo_MainGUI_hPerentGUI ; React to evets from the preview GUI that is part of the main GUI
			PrMo_MainGUI_ProcessMsg()

			If $GUI_MSG[$C_GUIMsg_idx1_hGUI] = $MainGUI_hGUI Then ContinueCase


		Case $MainGUI_hGUI ; React to evets from the main GUI

			Switch $GUI_MSG[$C_GUIMsg_idx1_ControlID]


			#Region Menu buttons
			#Region


			; Add videos:
				Case $Menu_File_AddVideo
					VideoList_AddVideos()
				Case $Menu_File_AddVideosFromFolder
					VideoList_AddVideosFromFolder_GUI()


			; save / load tasks
				Case $Menu_File_SaveTasks

					GUICtrlSetState($Menu_File_SaveTasks,$GUI_DISABLE)
					GUIDisable($MainGUI_hGUI)
					;Commander_SuspendOrResumeExeProcess(True,$C_PraiortyLevelMax-1)

					$tmp = FileSaveDialog('Select where to save the tasks file', $LastDir, 'Tasks (*.e265tasks)',  $FD_PROMPTOVERWRITE,'Saved tasks')
					If Not @error Then
						$LastDir = $tmp
						SaveTasks($LastDir)
						If @error Then MsgBox(16,'Error','Error saving the tasks file.'&@CRLF&'Error code: '&@error)
					EndIf

					GUICtrlSetState($Menu_File_SaveTasks,$GUI_ENABLE)
					GUIEnable($MainGUI_hGUI)
					;Commander_SuspendOrResumeExeProcess(False,$C_PraiortyLevelMax-1)

				Case $Menu_File_LoadTasks

					GUICtrlSetState($Menu_File_LoadTasks,$GUI_DISABLE)
					GUIDisable($MainGUI_hGUI)
					;Commander_SuspendOrResumeExeProcess(True,$C_PraiortyLevelMax-1)

					$tmp = FileOpenDialog('Select the tasks file to load', $LastDir, 'Tasks (*.e265tasks)', $FD_FILEMUSTEXIST)
					If Not @error Then
						If Not $aVids[0][0] Or MsgBox($MB_YESNOCANCEL, '', _
						'You have some tasks (videos) in the list. if you continue, it will overwrite these tasks.'&@CRLF& _
						'Select yes to continue') = $IDYES Then

							LoadTasks($tmp)
							If @error Then
								Switch @error
									Case 1
										MsgBox(16,'Error','Error loading the tasks')
									Case 2
										MsgBox(64,'Error','Loaded with errors')
								EndSwitch
							EndIf

						EndIf



					EndIf
					GUICtrlSetState($Menu_File_LoadTasks,$GUI_ENABLE)
					GUIEnable($MainGUI_hGUI)
					;Commander_SuspendOrResumeExeProcess(False,$C_PraiortyLevelMax-1)


			; Change ffmpeg dir
				Case $Menu_Options_FFmpegDir
					SetFFmpegFolder_GUI()

			; Change or clean temp folder
				Case $Menu_Options_ChangeTMP
					ChangeTempFolder_GUI()

				Case $Menu_Options_CleanTMP
					DeleteSupTempsFolders()

					For $a = 1 To $aVids[0][0]
						$aVids[$a][$C_aVids_idx2_aOutPre] = Null
					Next
					PrMo_Frame_Update()

			; Change output preview settings
				Case $Menu_Options_OutputPreview
					OutputPreviewSetTimes_GUI()

			; Help the developer
				Case $Menu_Help_Donate
					ShellExecute($C_DonationLink)
				Case $Menu_Help_WebSite
					ShellExecute($C_SoftwareWebsite)
				Case $Menu_Help_CheckForUpdate
					ShellExecute($C_SoftwareDownloadPage)
			; About
				Case $Menu_Help_About
					_NotifyBox(64, 'About', _
					'Version: v'&$C_sSoftwareVer&@CRLF& _
					'Website: easy265file.blogspot.com'&@CRLF& _
					'Developed by gileli121@gmail.com / gil900'&@CRLF&@CRLF& _
					'NO WARRANTY ON ANY DAMAGE!' _
					)
				Case $Menu_Help_License
					GUICtrlSetState($Menu_Help_License,$GUI_DISABLE)
					LicenseAgreement_GUI()

			#EndRegion
			#EndRegion


			#Region standad buttons on the main GUI:
			#Region


				Case $GUI_EVENT_CLOSE, $Menu_File_Exit
						; If the user click the X button or choose to exit thruth the menue then exit the program

					;Return True ; Exit main loop to exit the program
					SOFTWARE_SHUTDOWN()


				Case $MainGUI_StartEncude_Button
				; The user choose to encode the videos
					;TODO
					If Not $aVids[0][0] Then Return MsgBox(64,Null,'Please add at least 1 video',0,$MainGUI_hGUI)


					Encoder_Job_Start()



				Case $MainGUI_Expand_Button
					; The user click on the expand/unexpand arro
					#cs
						The code bellow will expand/unexpend the the gui

					#ce

					Local $aWinPos, $xWinPos,$yWinPos,$xWinSize,$yWinSize
					$aWinPos = WinGetPos($MainGUI_hGUI)
					If Not @error Then
						$xWinPos = $aWinPos[0]
						$yWinPos = $aWinPos[1]
						$xWinSize = $aWinPos[2]

						$aWinPos[3] -= $MainGUI_BordersSize_Y
						If $MainGUI_Expanded Then
							$yWinSize = $aWinPos[3]*($C_MaGU_ClientSize1_Y_NoExpand_def/$C_MaGU_ClientSize1_Y_Expand_def)
							$MainGUI_Expanded = 0
						Else
							$yWinSize = $aWinPos[3]*($C_MaGU_ClientSize1_Y_Expand_def/$C_MaGU_ClientSize1_Y_NoExpand_def)
							$MainGUI_Expanded = 1
						EndIf
						$yWinSize = Round($yWinSize)+$MainGUI_BordersSize_Y


						Local $yWorkArea = GetScreenWorkArea()[1]
						$tmp = $yWinPos+$yWinSize
						If $tmp > $yWorkArea Then
							$yWinPos -= $tmp-$yWorkArea
							If $yWinPos < 0 Then
								$yWinSize += $yWinPos
								$yWinPos = 0
							EndIf
						EndIf



					Else
						If $MainGUI_Expanded Then
							$yWinSize = $C_MaGU_ClientSize1_Y_NoExpand_def+$MainGUI_BordersSize_Y
							$xWinSize = $C_MaGU_ClientSize1_X_NoExpand_def+$MainGUI_BordersSize_X
							$MainGUI_Expanded = 0
						Else
							$yWinSize = $C_MaGU_ClientSize1_Y_Expand_def+$MainGUI_BordersSize_Y
							$xWinSize = $C_MaGU_ClientSize1_X_Expand_def+$MainGUI_BordersSize_X
							$MainGUI_Expanded = 1
						EndIf
						$xWinPos = (@DesktopWidth/2)-($xWinSize/2)
						$yWinPos = (@DesktopHeight/2)-($yWinSize/2)
					EndIf


					MainGUI_InitMinDefWinSize()

					GUIRegisterMsg($WM_SIZE, '')


					; Resize the window
					WinMove($MainGUI_hGUI,'',$xWinPos,$yWinPos,$xWinSize,$yWinSize)



					If $MainGUI_Expanded Then
						If $VideoList_ListView Then
							MainGUI_DrawAreas(False,False)
							VideoList_UnHideCtrls()
						Else
							MainGUI_DrawAreas(False,True)

						EndIf
					Else
						VideoList_HideCtrls()
						MainGUI_DrawAreas(False,False)
					EndIf

					MainGUI_Area_Bottom_DrawExpandState()

					PrMo_Frame_ReDrawImageAfterSizeChange()


					GUIRegisterMsg($WM_SIZE, 'WM_SIZE')




			#EndRegion
			#EndRegion

			EndSwitch



			If $MainGUI_Expanded Then VideoList_ProcessMsg() ; If the video list is shown then process the masseges for the list view







		#EndRegion

		#Region GUIs not part of the main GUI
		#Region

			Case $Encoder_GUI_h
				Encoder_GUI_ProcessMsg()




			#Region Menu GUIs
			#Region
			#cs
				Case $OptionsMenu


				Case $PreviewMenu
			#ce

			#EndRegion
			#EndRegion

		#EndRegion
		#EndRegion

	EndSwitch




	#cs
		Monitor changes where there is need to do this every $C_GuiLoopProcessors1_WaitTime ms
	#ce
	If TimerDiff($GuiLoopProcessors1_Timer) >= $C_GuiLoopProcessors1_WaitTime Then

		; do stuf for the settings subwindow ...
			GUISwitch($SettingsGUI_hGUI)
			SettingsGUI_ProcessLoop()


		; do stuff for the preview subwindow ...
			GUISwitch($PrMo_MainGUI_hGUI)
			PrMo_MainGUI_ProcessLoop()




			GUISwitch($MainGUI_hGUI)





		$GuiLoopProcessors1_Timer = TimerInit()
	EndIf


	aExtraFuncCalls_CallFuncs()

EndFunc
#EndRegion



#Region ================================== SHUT DOWN =====================================



Func SOFTWARE_SHUTDOWN()

	PrMo_Frame_UnSetImage() ; Cleen the image in the preview in case there ware any

	MainGUI_WriteSettings() ; Write any changed that belong to the GUI

	GUIDelete($MainGUI_hGUI) ; Delete the main GUI


	SaveMainSettings() ; Save the main settings

	PreviewModule_SaveSettings() ; Save the settings of the preview


	; Clean resorse
		DeleteSupTempsFolders()
		_GDIPlus_Shutdown()

	Exit

EndFunc

#EndRegion SHUT DOWN - END






