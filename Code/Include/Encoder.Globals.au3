

Global Const $C_Encoder_JobID = 'EncoderJOB'


Func Encoder_ReAllocate_ActiveVid()
	Global _
		$Encoder_sActiveVid = Null , _; The path to the video that is currently under encoding
		$Encoder_iActiveVidIndex = Null, _ ; The index of the active video in aVids array
		$Encoder_ActiveVid_sOutFileName = Null , _ ; The output name
		$Encoder_ActiveVid_sOutFilePath = Null, _	; The output file path
		$Encoder_iCommanderErrorCount = 0
EndFunc

Encoder_ReAllocate_ActiveVid()


Global $Encoder_iEncodedFilesCount
Global $Encoder_iWaitForFfmpegTimer

Global $Encoder_iOverWriteFile
Global Const $C_Encoder_iOverWriteFile_Unseted = -1, $C_Encoder_iOverWriteFile_False = 0, $C_Encoder_iOverWriteFile_True = 1

Global $Encoder_ConsoleSavedText, $Encoder_ConsoleSavedText_Len


Global $Encoder_bSuspended = False








#include 'Encoder_GUI.Globals.au3'
