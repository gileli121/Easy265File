#include-once
#include <Array.au3>
#include <ArrayExtra.au3>
#include 'Processes_Threads_nDLLs\_ProcessListFunctions.au3'

; Consts

Global Enum _
	$C_Commander_idx_JobID, _
	$C_Commander_idx_ExeFile, _
	$C_Commander_idx_Command, _
	$C_Commander_idx_MaxWaitTime, _
	$C_Commander_idx_TerminateOnMaxWaitTime, _
	$C_Commander_idx_iPraiortyLevel, _
	$C_Commander_idx_Step1Func, _
	$C_Commander_idx_Step1Func_Args, _
	$C_Commander_idx_Step2Func, _
	$C_Commander_idx_Step2Func_Args, _
	$C_Commander_idx_Step3Func, _
	$C_Commander_idx_Step3Func_Args, _
	$C_Commander_idx_Step4Func, _
	$C_Commander_idx_Step4Func_Args, _
	$Commander_C_IdxMax


Global Const $Commander_C_MaxWaitTime_DefTime = 5000
Global Const $Commander_C_MaxWaitTime_NoLimit = -2
Global Const $Commander_C_MaxWaitTime_NoWait = -1


Global Enum $Commander_C_output_idx_IsError , _
			$Commander_C_output_idx_CmdRead , _
			$Commander_C_output_idxmax


Global Enum $Commander_C_output_JobState_NoError , _
			$Commander_C_output_JobState_Error



Global Const $C_Commander_CalledFuncReturn_TerminateAndDeleteJob = 1
Global Const $C_Commander_Return = 2
Global Const $C_Commander_CalledFuncReturn_ResetJob = 3
Global Const $C_Commander_CalledFuncReturn_SkipJob = 4






Global $Commander_aJobList[0][$Commander_C_IdxMax]

Global $Commander_StopJob

Global $Commander_Step = 1, $Commander_Pid = -1


;~ Global $Commander_ProcessHandle



OnAutoItExitRegister(Commander_ProcessCloseTree)


#cs
	$iPraiortyLevel:
		0 - Set the job to be the latest
		1 - Set the job to be the next job
		2 >= Set the job to be the first job as long the first job have lower praiorty.
			if the first job have bigger praiorty then the job will set to area with lower praiorty


#ce
Func Commander_AddJob($ExeFile, _
					$sCommand, _
					$JobID = Null, _
					$iPraiortyLevel = 0, _
					$iMaxWaitTime = Default, _
					$bTerminateOnMaxWaitTime = Default, _
					$Step1Func = Null, _
					$aStep1Func_Args = Default, _
					$Step2Func = Null, _
					$aStep2Func_Args = Default, _
					$Step3Func = Null, _
					$aStep3Func_Args = Default, _
					$Step4Func = Null, _
					$aStep4Func_Args = Default)

	; Set defaults
		If $iMaxWaitTime = Default Then $iMaxWaitTime = $Commander_C_MaxWaitTime_NoLimit
		If $bTerminateOnMaxWaitTime = Default Then $bTerminateOnMaxWaitTime = True


	; Enforce praiorty rules






	Local $idx, $size
	$size = UBound($Commander_aJobList)
	If Not $size Then
		#cs
			the size of the array is 0
		#ce

		ReDim $Commander_aJobList[1][$Commander_C_IdxMax]
		$idx = 0
	Else

		#cs
			The size of the array must be bigger than 0
		#ce

		$size -= 1 ; We work from now with 1b index

		Switch $iPraiortyLevel
			Case 0 ; עדיפות 0 - נגדיר להוסיף את זה תמיד לסוף
				$idx = $size+1
			Case 1
				#cs
					אם העדיפות שווה ל 1 אז ננסה לבדוק אם יש מקום
					להכניס את הגוב לאינדקס טיפה גבוהה יותר מ 0
					למקרה שמתבצע כבר גוב מסויים. אחרי הכל המטרה של עדיפות
					זו היא לא להשתלט על גוב שכבר מתבצע בזה הרגע
				#ce
				If $size >= 1 Then
					$idx = 1
				Else
					$idx = 0
				EndIf


			Case Else ; אני מניח פה שהעדיפות חייבת להיות גדולה מ 1
				#cs

					בתרחיש שבו העדיפות גדולה יותר, תמיד נכניס את הגוב לאינדקס 0 כדי לממש
					אותו מיד

				#ce

				$idx = 0


		EndSwitch

		;_ArrayDisplay($Commander_aJobList,$idx)

		; Set job idx
		Local $JobID_idx = -1
		; look for the job id if there is need to look
		If $JobID Then
			$JobID_idx = _ArraySearch($Commander_aJobList,$JobID,0,$size,0,0,0,$C_Commander_idx_JobID)
			If $JobID_idx >= 0 And $iPraiortyLevel < $Commander_aJobList[$JobID_idx][$C_Commander_idx_iPraiortyLevel] Then Return
		EndIf

		#cs
			בנקודה זו נבדוק אם אנו הולכים לגשת לגוב שכבר רץ בזה הרגע
			במידה וכן, נבדוק אם אנו הולכים להשתלט עליו

		#ce

		If Not $idx Then;And $iPraiortyLevel >= 2 Then ; אם אנו הולכים לגשת לגוב שרץ הרגע ומתכוונים לשנות אותו
			;ConsoleWrite(1 &' (L: '&@ScriptLineNumber&')'&@CRLF)

			If $iPraiortyLevel >= $Commander_aJobList[$idx][$C_Commander_idx_iPraiortyLevel] Then
				; יש לנו הרשאה לשנות את הגוב
;~ 				If $iPraiortyLevel <> 2 Or $JobID_idx > 0 Then
					If $Commander_Pid >= 0 Then
						Commander_ProcessCloseTree()
						$Commander_Pid = -1
					EndIf
					$Commander_Step = 1
;~ 				EndIf
			Else
				;If Not $JobID_idx Then Return
				; אין לנו הרשאה לגעת בגוב
				; נחפש גוב שיש לנו הרשאה לגעת בו

				Local $idx_new = -1
				; אנו מחפשים גוב שיש לנו הרשאה לגעת בו
				For $a = 1 To UBound($Commander_aJobList)-1
					If $iPraiortyLevel >= $Commander_aJobList[$a][$C_Commander_idx_iPraiortyLevel] Then

						$idx_new = $a
						ExitLoop
					EndIf
				Next
				If $idx_new > 0 Then
					;If $JobID_idx >= 0 And $Commander_aJobList[$idx_new][$C_Commander_idx_JobID] = $Commander_aJobList[$JobID_idx][$C_Commander_idx_JobID] Then Return
					$idx = $idx_new
				Else
					If $JobID_idx >= 0 Then Return
					$idx = $size+1
				EndIf

			EndIf

		EndIf


		;If $idx <= $size And $idx <> $JobID_idx Then


		If $JobID_idx >= 0 Then
			If $idx <= $size Then
				If $idx <> $JobID_idx Then
					Array2DReplace( _
					$Commander_aJobList, _	; ByRef $Array
					$JobID_idx, _			; $SourceRow
					$idx, _					; $TargetRow
					0, _						; $iStartCol
					$Commander_C_IdxMax-1)	; $iEndCol)
				EndIf
			Else
				$idx = $JobID_idx
			EndIf
		Else
			If $idx <= $size Then
				_ArrayInsert($Commander_aJobList,$idx)
			Else
				$size = $idx
				ReDim $Commander_aJobList[$size+1][$Commander_C_IdxMax]
			EndIf
		EndIf

	EndIf

	#cs
		We done to set idx
		סיימנו להגדיר את הפוזיציה היכן לרשום את הגוב במערך
	#ce


	; Write the job data


	$Commander_aJobList[$idx][$C_Commander_idx_JobID] = $JobID
	$Commander_aJobList[$idx][$C_Commander_idx_ExeFile] = $ExeFile
	$Commander_aJobList[$idx][$C_Commander_idx_Command] = $sCommand
	$Commander_aJobList[$idx][$C_Commander_idx_MaxWaitTime] = $iMaxWaitTime
	$Commander_aJobList[$idx][$C_Commander_idx_TerminateOnMaxWaitTime] = $bTerminateOnMaxWaitTime

	$Commander_aJobList[$idx][$C_Commander_idx_iPraiortyLevel] =  $iPraiortyLevel

;~ 	If $iPraiortyLevel >= 4 Then
;~ 		$Commander_aJobList[$idx][$C_Commander_idx_iPraiortyLevel] =  $iPraiortyLevel
;~ 	Else
;~ 		$Commander_aJobList[$idx][$C_Commander_idx_iPraiortyLevel] = 0
;~ 	EndIf

	$Commander_aJobList[$idx][$C_Commander_idx_Step1Func] = $Step1Func
	$Commander_aJobList[$idx][$C_Commander_idx_Step1Func_Args] = $aStep1Func_Args

	$Commander_aJobList[$idx][$C_Commander_idx_Step2Func] = $Step2Func
	$Commander_aJobList[$idx][$C_Commander_idx_Step2Func_Args] = $aStep2Func_Args

	$Commander_aJobList[$idx][$C_Commander_idx_Step3Func] = $Step3Func
	$Commander_aJobList[$idx][$C_Commander_idx_Step3Func_Args] = $aStep3Func_Args

	$Commander_aJobList[$idx][$C_Commander_idx_Step4Func] = $Step4Func
	$Commander_aJobList[$idx][$C_Commander_idx_Step4Func_Args] = $aStep4Func_Args


EndFunc







Func Commander_ProcessJobs()
	Local Static $iMaxWaitTime = 0, $Timer, $stdRead, $bStdRead, $tmp, $tmpTimer, $iJobState, _ ; $Step = 0,$iPid = 0, $stdReadMode
				$aJobOutput, $aStep3FuncInputTmp
	Local Const $C_ProcessExists_CheckWaitTime = 100



	; Before stat, check if there is any job. if not then return.
	If Not UBound($Commander_aJobList) Then Return


	Switch $Commander_Step
		Case 1 ; <-----  Prepere for process step

			;ToolTip('Step 1')



			; Call to step 1 func
			If IsFunc($Commander_aJobList[0][$C_Commander_idx_Step1Func]) Then
				;ConsoleWrite('$Commander_aJobList[0][$C_Commander_idx_Step1Func]' &' (L: '&@ScriptLineNumber&')'&@CRLF)
				If $Commander_aJobList[0][$C_Commander_idx_Step1Func_Args] = Default Then
;~ 					$tmp = Call($Commander_aJobList[0][$C_Commander_idx_Step1Func])
					$tmp = $Commander_aJobList[0][$C_Commander_idx_Step1Func]()
				Else
;~ 					$tmp = Call($Commander_aJobList[0][$C_Commander_idx_Step1Func],$Commander_aJobList[0][$C_Commander_idx_Step1Func_Args])
					$tmp = $Commander_aJobList[0][$C_Commander_idx_Step1Func]($Commander_aJobList[0][$C_Commander_idx_Step1Func_Args])
				EndIf
				If $tmp Then
					If $tmp = $C_Commander_Return Then Return
					Commander_EnforceCalledFuncOrder($tmp)
					Return Commander_ProcessJobs()
				EndIf
			EndIf




			; Reset $aJobOutput
			Local $aTmp[$Commander_C_output_idxmax]
			$aJobOutput = $aTmp

			; Run the exe file
			$Commander_Pid = -1
			$Commander_Pid = _
				Run( _
						@ComSpec&' /c ""'&$Commander_aJobList[0][$C_Commander_idx_ExeFile]&'" '&$Commander_aJobList[0][$C_Commander_idx_Command]&'', _
						@ScriptDir, _
						@SW_HIDE, _
						$STDERR_MERGED _
					)
;~ $STDIN_CHILD & $STDOUT_CHILD
			$aJobOutput[$Commander_C_output_idx_IsError] = @error

			; Call to step 2 func
			If IsFunc($Commander_aJobList[0][$C_Commander_idx_Step2Func]) Then
				$tmp = Commander_CallExFunc( _
										$aJobOutput, _												 ; ByRef $CommanderOutput
										$Commander_aJobList[0][$C_Commander_idx_Step2Func], _ 		; ByRef $StepFunc
										$Commander_aJobList[0][$C_Commander_idx_Step2Func_Args] _	 ; ByRef $StepFunc_Args
									)
				If $tmp Then
					If $tmp = $C_Commander_Return Then Return
					Return Commander_ProcessJobs()
				EndIf
			EndIf

			#cs
			If _
				$Commander_aJobList[0][$C_Commander_idx_Step2Func] _
				And _
				Commander_CallExFunc( _
										$aJobOutput, _												 ; ByRef $CommanderOutput
										$Commander_aJobList[0][$C_Commander_idx_Step2Func], _ 		; ByRef $StepFunc
										$Commander_aJobList[0][$C_Commander_idx_Step2Func_Args] _	 ; ByRef $StepFunc_Args
									) _
			Then _
				Return ;Commander_ProcessJobs()
			#ce

			; If we have error or we set it to no time then we stop here
			If _
				$aJobOutput[$Commander_C_output_idx_IsError] _
				Or _
				$Commander_aJobList[0][$C_Commander_idx_MaxWaitTime] = $Commander_C_MaxWaitTime_NoWait _
				Then _
			Return _ArrayDelete($Commander_aJobList,0) ; In error case or no-wait just exit and delete the job


		; Prepere for the next step

			; Reset MaxWaitTime
			If $Commander_aJobList[0][$C_Commander_idx_MaxWaitTime] <> $Commander_C_MaxWaitTime_NoLimit Then
				If $Commander_aJobList[0][$C_Commander_idx_MaxWaitTime] Then
					$iMaxWaitTime = $Commander_aJobList[0][$C_Commander_idx_MaxWaitTime]
				Else
					$iMaxWaitTime = $Commander_C_MaxWaitTime_DefTime
				EndIf
			EndIf



			; Reset stdRead
			$stdRead = ''
			; Reset $bStdRead
			If _
				IsFunc($Commander_aJobList[0][$C_Commander_idx_Step2Func]) _
				Or _
				IsFunc($Commander_aJobList[0][$C_Commander_idx_Step3Func]) _
				Or _
				IsFunc($Commander_aJobList[0][$C_Commander_idx_Step4Func]) _
			Then
				$bStdRead = True
				$aStep3FuncInputTmp = $aTmp
			Else
				$bStdRead = False
			EndIf

			; Reset $iJobState
			$iJobState = $Commander_C_output_JobState_NoError

			; Set timers
			$Timer = TimerInit()
			$tmpTimer = $Timer

		; Jump to step 2
			$Commander_Step = 2
			Return ;Commander_ProcessJobs()

		Case 2 ; <-----  Process step
			;ToolTip('Step 2')

			If $Commander_StopJob Then
				$Commander_StopJob = False
				Commander_ProcessCloseTree();ProcessClose($Commander_Pid)
				_ArrayDelete($Commander_aJobList,0) ; Delete the job
				$Commander_Step = 1
				Return
			EndIf

			; If there is function to call at the end, prepere the output for it (to send it later)
			If $bStdRead Then
				$stdRead = StdoutRead($Commander_Pid)
				If Not @error Then

					If IsFunc($Commander_aJobList[0][$C_Commander_idx_Step4Func]) And $stdRead Then _
						$aJobOutput[$Commander_C_output_idx_CmdRead] &= $stdRead ;$stdRead &= $tmp

					If IsFunc($Commander_aJobList[0][$C_Commander_idx_Step3Func]) Then

						; Call to step 3 func
						;$aStep3FuncInputTmp[$Commander_C_output_idx_CmdRead] = $tmp

						$tmp = Commander_CallExFunc( _
												$stdRead, _												 ; ByRef $CommanderOutput
												$Commander_aJobList[0][$C_Commander_idx_Step3Func], _ 		; ByRef $StepFunc
												$Commander_aJobList[0][$C_Commander_idx_Step3Func_Args] _	 ; ByRef $StepFunc_Args
												)
						If $tmp Then
							If $tmp = $C_Commander_Return Then Return
							Return Commander_ProcessJobs()
						EndIf


						#cs
						If Commander_CallExFunc( _
												$aStep3FuncInputTmp, _												 ; ByRef $CommanderOutput
												$Commander_aJobList[0][$C_Commander_idx_Step3Func], _ 		; ByRef $StepFunc
												$Commander_aJobList[0][$C_Commander_idx_Step3Func_Args] _	 ; ByRef $StepFunc_Args
												) Then 	Return ;Commander_ProcessJobs()
						#ce

					EndIf





				EndIf
			EndIf

			; Check every $C_ProcessExists_CheckWaitTime ms if the cmd process exists and if not then jump to the finish step
			If TimerDiff($tmpTimer) > $C_ProcessExists_CheckWaitTime Then
				If Not ProcessExists($Commander_Pid) Then
					; Jump to the finish step
					$Commander_Step = 3
					Return ;Commander_ProcessJobs()
				EndIf
				$tmpTimer = TimerInit()
			EndIf

			; Check if the running time is taking to long time. if the running time bigger then $iMaxWaitTime then
			; terminate / un-terminate the cmd process and jump to the finish step
			If $Commander_aJobList[0][$C_Commander_idx_MaxWaitTime] <> $Commander_C_MaxWaitTime_NoLimit And _
				TimerDiff($Timer) > $iMaxWaitTime Then

				; If the job set to terminate the cmd process in this case, then terminate it
				If $Commander_aJobList[0][$C_Commander_idx_TerminateOnMaxWaitTime] Then Commander_ProcessCloseTree();ProcessClose($Commander_Pid)

				; Jump to the finish step
				$iJobState = $Commander_C_output_JobState_Error
				$Commander_Step = 3
				Return ;Commander_ProcessJobs()
			EndIf

		Case 3 ; <-----  Finish step
;~ 			ToolTip('Step 3')

			; Save the func args into temp variables
			Local $Step4Func = $Commander_aJobList[0][$C_Commander_idx_Step4Func]
			Local $Step4Func_Args = $Commander_aJobList[0][$C_Commander_idx_Step4Func_Args]



			; Delete the job from the array and reset the step
			_ArrayDelete($Commander_aJobList,0)
			$Commander_Step = 1


			; Call to sStep4Func if we need to

			If IsFunc($Step4Func) Then
;~ 				$Step4Func($aJobOutput,$Step4Func_Args)
				$tmp = Commander_CallExFunc( _
										$aJobOutput, _		 ; ByRef $CommanderOutput
										$Step4Func, _ 		; ByRef $StepFunc
										$Step4Func_Args _	 ; ByRef $StepFunc_Args
									)
				If $tmp Then
					If $tmp = $C_Commander_Return Then Return
					Return Commander_ProcessJobs()
				EndIf
			EndIf

			#cs
			If _
				$Step4Func _
				And _
				Commander_CallExFunc( _
										$aJobOutput, _		 ; ByRef $CommanderOutput
										$Step4Func, _ 		; ByRef $StepFunc
										$Step4Func_Args _	 ; ByRef $StepFunc_Args
									) _
			Then _
				Return ;Commander_ProcessJobs()
			#ce

;~ 			If $Commander_aJobList[0][$C_Commander_idx_Step4Func] And _
;~ 				Commander_CallExFunc($aJobOutput, $C_Commander_idx_Step4Func,$C_Commander_idx_Step4Func_Args) _
;~ 			Then Return Commander_ProcessJobs()

			; Finaly, delete the job from the list (to not repeat it again), and reset the $Step to 0 (to start over on the next job if avilable)
;~ 			_ArrayDelete($Commander_aJobList,0) ; Delete the job
;~ 			$Commander_Step = 1 ; Set step to 1


	EndSwitch

EndFunc




Func Commander_CallExFunc(ByRef $CommanderOutput, ByRef $StepFunc, ByRef $StepFunc_Args)

	;If Not $Commander_aJobList[0][$idx_sStepFunc] Then Return

	If Not IsFunc($StepFunc) Then Return SetError(1)

	Local $FuncReturn
	If $StepFunc_Args = Default Then
;~ 		$FuncReturn = Call($StepFunc,$CommanderOutput)
		$FuncReturn = $StepFunc($CommanderOutput)

	Else
;~ 		$FuncReturn = Call( _
;~ 					$StepFunc, _
;~ 					$CommanderOutput, _
;~ 					$StepFunc_Args _
;~ 				)

		$FuncReturn = $StepFunc($CommanderOutput,$StepFunc_Args)
	EndIf

	If Not $FuncReturn Then Return
	Commander_EnforceCalledFuncOrder($FuncReturn)
	Return $FuncReturn
EndFunc

Func Commander_EnforceCalledFuncOrder($FuncReturn)

	Switch $FuncReturn
		Case $C_Commander_Return
		Case $C_Commander_CalledFuncReturn_TerminateAndDeleteJob
;~ 			ConsoleWrite('$C_Commander_CalledFuncReturn_TerminateAndDeleteJob' &' (L: '&@ScriptLineNumber&')'&@CRLF)
			_ArrayDelete($Commander_aJobList,0)
			$Commander_Step = 1
			Commander_ProcessCloseTree()
			$Commander_Pid = -1
		Case $C_Commander_CalledFuncReturn_ResetJob
			$Commander_Step = 1
		;Case $C_Commander_CalledFuncReturn_SkipJob
			; TODO
	EndSwitch

EndFunc

Func Commander_TerminateAndDeleteActiveJob()
	If Not UBound($Commander_aJobList) Then Return
	_ArrayDelete($Commander_aJobList,0)
	$Commander_Step = 1
	Commander_ProcessCloseTree()
	$Commander_Pid = -1
EndFunc


Func Commander_TerminateAndDeleteJob($JobID)
	Local $JobID_idx = _ArraySearch($Commander_aJobList,$JobID,0,0,0,0,1,$C_Commander_idx_JobID)
	If $JobID_idx < 0 Then Return
	_ArrayDelete($Commander_aJobList,$JobID_idx)
	If $JobID_idx Then Return
	Commander_ProcessCloseTree()
	$Commander_Step = 1
	$Commander_Pid = -1
EndFunc


Func Commander_StopJob()
	$Commander_StopJob = True
EndFunc

#cs
Func Commander_OnAutoItExitRegister()
	Commander_ProcessCloseTree()
;~ 	If UBound($Commander_aJobList) Then
;~ 		ProcessClose($Commander_aJobList[0][$Commander_C_idx_ExeFile])
;~ 	EndIf
EndFunc
#ce

#Region process management low level code
Func Commander_ProcessCloseTree()
	Local $aProcessChilds = _ProcessGetChildren($Commander_Pid)
	;_ArrayDisplay($aProcessChilds)
	If IsArray($aProcessChilds) Then
		For $a = 1 To $aProcessChilds[0][0]
			ProcessClose($aProcessChilds[$a][1])
		Next
	EndIf
	ProcessClose($Commander_Pid)
EndFunc
#EndRegion



Func Commander_SuspendOrResumeExeProcess($bSuspend,$iPraiortyAccessLevel)
	If $Commander_Pid <= 0 Or Not UBound($Commander_aJobList) Then Return
	If $iPraiortyAccessLevel < $Commander_aJobList[0][$C_Commander_idx_iPraiortyLevel] Then Return



	Local $aProcessChilds = _ProcessGetChildren($Commander_Pid)
	;_ArrayDisplay($aProcessChilds)
	If Not IsArray($aProcessChilds) Then Return SetError(1)

	For $a = 1 To $aProcessChilds[0][0]
		Commander_ProcessSuspendOrResume($aProcessChilds[$a][1],$bSuspend)
		If @error Then Return SetError(2)
	Next


EndFunc


;~ Func Commander_Process_OpenHandle($iPid)
;~ 	; Open the handle
;~ 		$tmp = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $iPid)
;~ 		If Not IsArray($tmp) Then Return SetError(1)
;~ 		$Commander_ProcessHandle = $tmp[0]


;~ EndFunc


Func Commander_ProcessSuspendOrResume($iPid,$bSuspend)
	Local $aPidHandle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $iPid)
	If Not IsArray($aPidHandle) Then Return SetError(1)
	Local $sucess
	If $bSuspend Then
		$sucess = DllCall("ntdll.dll", "int", "NtSuspendProcess", "int", $aPidHandle[0])
	Else
		$sucess = DllCall("ntdll.dll", "int", "NtResumeProcess", "int", $aPidHandle[0])
	EndIf
	DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $aPidHandle[0])
	If Not IsArray($sucess) Then Return SetError(2)

EndFunc   ;==>_ProcessSuspend

;~ Func Commander_ProcessResume($iPid)
;~ 	Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $iPid)
;~ 	Local $i_sucess = DllCall("ntdll.dll", "int", "NtResumeProcess", "int", $ai_Handle[0])
;~ 	DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
;~ 	If IsArray($i_sucess) Then
;~ 		Return 1
;~ 	Else
;~ 		SetError(1)
;~ 		Return 0
;~ 	EndIf
;~ EndFunc   ;==>_ProcessResume


#cs

Exampl:

Commander_AddJob($ini_def_FFmpegPath, _
					'-i "xxxxx.mp4"  -c:v libx265  -x265-params crf=40  "xxxxx.mp4"', _
					Null, _
					0, _
					Default, _
					Default, _
					'Step1', _
					Default, _
					'Step2', _
					Default, _
					'Step3', _
					Default, _
					'Step4', _
					Default)


Func Step1()
	ConsoleWrite('Step1' &' (L: '&@ScriptLineNumber&')'&@CRLF)

	;Return $C_Commander_Return ; <- this will cause to run step 1() in loop


EndFunc


Func Step2(ByRef $aCom)
	ConsoleWrite('Step2' &' (L: '&@ScriptLineNumber&')'&@CRLF)
	;Return $C_Commander_Return;$C_Commander_CalledFuncReturn_TerminateAndDeleteJob


	;Return $C_Commander_Return ; <- this will cause to run step 1() + step2() in loop


EndFunc

Func Step3(ByRef $aCom)
	ConsoleWrite('Step3' &' (L: '&@ScriptLineNumber&')'&@CRLF)

EndFunc

Func Step4(ByRef $aCom)
	ConsoleWrite('Step4' &' (L: '&@ScriptLineNumber&')'&@CRLF)
EndFunc



While Sleep(1000)

	Commander_ProcessJobs()

WEnd

Exit


#ce



