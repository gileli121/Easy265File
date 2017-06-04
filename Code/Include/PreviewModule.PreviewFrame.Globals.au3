
#include 'PreviewModule.PreviewFrame.GDIDrawImage.Globals.au3'

; PrMo_Frame_HandleMovingImageEvent()
	Global $PrMo_Frame_hmie_MouseXpos = -1
	Global $PrMo_Frame_hmie_MouseYpos = -1


; Frame
	; GUI
		;Global $PrMo_Frame_hPerentGUI
		Global $PrMo_Frame_hGUI

		Global $PrMo_Frame_hTextFrame
			Global Const $C_PrMo_Frame_DefaultText = 'Preview'
			Global Const $C_PrMo_Frame_LoadingText = 'Loading'
			Global Const $C_PrMo_Frame_ErrorText = 'Error'



	; Image
		Global $PrMo_Frame_iImageScale
		Global $PrMo_Frame_iImageScaleFit
		Global $PrMo_Frame_sImagePath





		Global Const $C_PrMo_Fr_OutputJobID = 'OUTPUT_PREVIEW'

; Arrays structure

	; aOutputData


		Global Const $C_PrMo_Fr_aOutData_idx2_0_ActiveID = 1
		Global Const $C_PrMo_Fr_aOutData_idx2_ID = 0
		Global Const $C_PrMo_Fr_aOutData_idx2_aRanges = 1 ; index to aRanges (v)
			; aRanges
				Global Const $C_PrMo_Fr_aOutData_aRanges_idx2_Start = 0
				Global Const $C_PrMo_Fr_aOutData_aRanges_idx2_End = 1
				Global Const $C_PrMo_Fr_aOutData_aRanges_idx2max = 2
		Global Const $C_PrMo_Fr_aOutData_idx2max = 2






; --------------------------------------------------------------------------------------

#cs

Output_ProcessedTimes ->
	ID
	PrecessedTimes ->
		[0] MinTime = -1	[1] MaxTime = -1
		[1] ...
		[2] ...

#ce

Global Const $PrMo_Fr_Out_PrDa_C_idxmax = 2, $PrMo_Fr_Out_PrDa_C_idx_ID = 0, _
			$PrMo_Fr_Out_PrDa_C_idx_TimeRange = 1

Global Const $PrMo_Fr_Out_PrDa_C_idx_TiRa_idxmax2D = 2, $PrMo_Fr_Out_PrDa_C_idx_TiRa_idx2D_Min = 0, _
			$PrMo_Fr_Out_PrDa_C_idx_TiRa_idx2D_Max = 1


Global $PrMo_Frame_bGUIErrorCase = True


; Will be deleted
	Global Const $PrMo_Fr_In_PrDa_C_idxmax = 2, $PrMo_Fr_In_PrDa_C_idx_ID = 0, $PrMo_Fr_In_PrDa_C_idx_Time = 1
