

#Region Program Names

	Global Const $C_SoftwareName = 'Easy265File'
	Global Const $C_Developer = 'gileli121@gmail'
	;Global Const $SoftwareName = 'Easy265File (by gileli121@gmail)'

	Global Const $C_sSoftwareVer = '1.0.0-alpha'

	Global Const $C_SoftwareWebsite = 'http://easy265file.blogspot.com'
	Global Const $C_DonationLink = 'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=6K2UDXJH8EWPQ'
	Global Const $C_SoftwareDownloadPage = 'http://easy265file.blogspot.com/p/download.html'



#EndRegion

#Region


	Global Const $C_OutputFolderName = 'Encoded by Easy265File'


	Global Const $C_OutputConteiners_ComboList = '.mp4|.mkv|.avi'
	Global Const $C_FileOpenDialog_InputVideosString = '*.3gp;*.3gpp;*.ape;*.avi;*.bmp;*.divx;*.flac;*.flv;*.gif;*.jpg;*.m2ts;*.mk3d;*.mka;*.mkv;*.mov;*.mp3;*.mp4;*.mpc;*.mts;*.ofr;*.ofs;*.ogg;*.ogm;*.ogv;*.opus;*.png;*.rm;*.rmvb;*.spx;*.tak;*.tiff;*.ts;*.tta;*.wav;*.webm;*.wmv;*.wv;*.xvid'
	Global Const $ini_C_def_InputFileTypes = 'avi,mkv,flv,mp4,wmv,divx,mov,xvid,mpc,mts'



#EndRegion




#Region Other constants for some low level codes

	Global Const $C_iDyTextSize = 19 ; when creating labels, the Default y size of the label is $C_iDyTextSize. this size is size of one line


	Global Const $C_BKColor_SetChanged = 0xFA8E8E, $C_BKColor_SetUnChanged = 0xFFFFFF


	Global Const $C_GUIMsg_idx1_ControlID = 0
	Global Const $C_GUIMsg_idx1_hGUI = 1


#EndRegion



#Region WinAPI
	Global Const $SM_CXSIZEFRAME = 32
	Global Const $SM_CYSIZEFRAME = 33


	Global Const $WIN_STATE_ACTIVE = 8

#EndRegion



Global Const _
	$C_PraiortyLevel_VideoInfo_Receive = 0, _
	$C_PraiortyLevel_UpdatePreviewFrame = 3, _
	$C_PraiortyLevel_Encoder = 4, _
	$C_PraiortyLevelMax = 5







