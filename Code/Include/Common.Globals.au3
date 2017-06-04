
Global Const $C_TempDirMark = '<DefaultTempDir>'
Global $TmpFolder_def = $C_TempDirMark&'\temp\'
Global $TmpFolder
Global $ini = @ScriptDir&'\settings.ini'


#Region Ini_*

	Global $ini_FFmpegFolder


	Global $ini_FFmpegCommand

	Global $ini_OutContainer
	Global $ini_OutFilename
	Global $ini_OutputFolder
	Global $ini_InputFileTypes
		Global $InputFileTypes


	Global $ini_LastDir


	Global $ini_LicenseAgreement


#EndRegion


#Region Ini_* Defaults
;~ 			Global $ini_def_FFmpegPath = @ScriptDir&'\ffmpeg\bin\ffmpeg.exe' ; V
;~ 			Global $ini_def_FFprobePath = @ScriptDir&'\ffmpeg\bin\ffprobe.exe'

	Global $ini_def_FFmpegFolder = @ScriptDir&'\ffmpeg\bin\'


	Global Const $ini_C_def_FFmpegCommand = '-i <input>  -c:v libx265  -x265-params crf=25  <output>' ; V
	Global Const $ini_C_def_OutContainer = '.mp4' ; V
	Global Const $ini_C_def_OutFilename = '?.x265' ; V
	Global Const $ini_C_def_OutputFolder = '?_Converted\|'



#EndRegion

	; Macros for name
	Global Const $C_sVideoNameMark = '?'

	; Macros for save path
	Global Const $C_sRootFolderPath = '?' ; The common path macro string
	Global Const $C_sNotFullPath = '|' ; The path after the base macro string



#Region Loaded_Settings
	Global $FFmpegCommand ; V
	Global $FFmpegPath
	Global $FFprobePath
	Global $LastDir





#EndRegion




#Region Other

	Global $GUI_MSG





#EndRegion
