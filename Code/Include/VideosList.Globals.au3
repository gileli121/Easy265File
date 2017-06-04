

Global $VideoList_hGUI

Global $VideoList_xSize, $VideoList_ySize

;Global $VideoList_bItemsChangedEvent


; Controls
Global $VideoList_ListView
Global $VideoList_AddVideoButton
Global $VideoList_RemoveVideoButton
	Global $VideoList_RemoveVideoButton_State
Global $VideoList_RemoveAllVideosButton


Global Enum _
	$C_VideoList_ListView_colidx_SorceVid , _
	$C_VideoList_ListView_colidx_EncodedPercent , _
	$C_VideoList_ListView_colidx_Duration , _
	$C_VideoList_ListView_colidx_Size , _
	$C_VideoList_ListView_colidx_Profile , _
	$C_VideoList_ListView_colidx_OutVid , _
	$C_VideoList_ListView_colidx_Command , _
	$C_VideoList_ListView_colidxmax






;Global $VideoList_bMonitorWmNotify = True

#cs
		_GUICtrlListView_AddColumn($VideoList_ListView, "Source video", 85)
		_GUICtrlListView_AddColumn($VideoList_ListView, "Duration",80)
		_GUICtrlListView_AddColumn($VideoList_ListView, "Size",80)
		_GUICtrlListView_AddColumn($VideoList_ListView, "Profile", 50)
		_GUICtrlListView_AddColumn($VideoList_ListView, "Output video", 85)
		_GUICtrlListView_AddColumn($VideoList_ListView, "Command", 200)
#ce



