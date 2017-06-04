



Func aProfiles_Add($ProfileID,$aVids_iDx,$iVidCount = 1)



	$aProfiles[0][0] += 1
	ReDim $aProfiles[$aProfiles[0][0]+1][$C_aProfiles_idx2max]
	$aProfiles[$aProfiles[0][0]][$C_aProfiles_idx2_nID] = $ProfileID
	$aProfiles[$aProfiles[0][0]][$C_aProfiles_idx2_Command] = $aVids[$aVids_iDx][$C_aVids_idx2_Command]
	$aProfiles[$aProfiles[0][0]][$C_aProfiles_idx2_OutputName] = $aVids[$aVids_iDx][$C_aVids_idx2_OutputName]
	$aProfiles[$aProfiles[0][0]][$C_aProfiles_idx2_OutputFolder] = $aVids[$aVids_iDx][$C_aVids_idx2_OutputFolder]
	$aProfiles[$aProfiles[0][0]][$C_aProfiles_idx2_OutContainer] = $aVids[$aVids_iDx][$C_aVids_idx2_OutContainer]
	$aProfiles[$aProfiles[0][0]][$C_aProfiles_idx2_VidCount] = $iVidCount



EndFunc




Func aProfiles_Remove($ProfileID)
	Local $iProfilePos = _ArraySearch($aProfiles,$ProfileID,1,$aProfiles[0][0],0,0,1,$C_aProfiles_idx2_nID)
	If $iProfilePos <= 0 Or Not $aProfiles[$iProfilePos][$C_aProfiles_idx2_VidCount] Then Return
	$aProfiles[$iProfilePos][$C_aProfiles_idx2_VidCount] -= 1
EndFunc


Func aProfiles_ReInitialize()
	For $a = 1 To $aProfiles[0][0]
		$aProfiles[$a][$C_aProfiles_idx2_VidCount] = 0
		For $a2 = 1 To $aVids[0][0]
			If $aVids[$a2][$C_aVids_idx2_ProfileID] <> $aProfiles[$a][$C_aProfiles_idx2_nID] Then ContinueLoop
			$aProfiles[$a][$C_aProfiles_idx2_VidCount] += 1
		Next
	Next
	_ArraySort($aProfiles,1,1,$aProfiles[0][0],$C_aProfiles_idx2_VidCount)
EndFunc








