#include <..\[Includes]\_WinTimeFunctions.au3>
; ===============================================================================================================================
; <WinTimeFunctionsTest.au3>
;
;	Test of _WinTimeFunctions.au3
;
; Author: Ascend4nt
; ===============================================================================================================================

; ===============================================================================================================================
;  -  TESTS  -
; ===============================================================================================================================

Func _UFTC64($iTime64)
	Return _WinTime_UTCFileTimeFormat($iTime64,8+4,1,True)
EndFunc

Func _LFTC64($iTime64)
	Return _WinTime_LocalFileTimeFormat($iTime64,8+4,1,True)
EndFunc

Local $sFinalDisplay
Local $iTime64=_WinTime_GetSystemTimeAsLocalFileTime()
$sFinalDisplay="_WinTime_GetSystemTimeAsLocalFileTime(): "&$iTime64&", Converted to Formatted SystemTime: "&_UFTC64($iTime64)&@CRLF
$sFinalDisplay&="Add 950,001 nanoseconds to it: "&_UFTC64(_WinTime_AddToFileTime($iTime64,0,0,0,0,0,950001))&@CRLF
$sFinalDisplay&="Add 50 milliseconds to it: "&_UFTC64(_WinTime_AddToFileTime($iTime64,0,0,0,0,50))&@CRLF
$sFinalDisplay&="Add 10 seconds to it: "&_UFTC64(_WinTime_AddToFileTime($iTime64,0,0,0,10))&@CRLF
$sFinalDisplay&="Add 30 minutes to it: "&_UFTC64(_WinTime_AddToFileTime($iTime64,0,0,30))&@CRLF
$sFinalDisplay&="Add 10 hours to it: "&_UFTC64(_WinTime_AddToFileTime($iTime64,0,10))&@CRLF
$sFinalDisplay&="Subtract 8 hours from it: "&_UFTC64(_WinTime_AddToFileTime($iTime64,0,-8))&@CRLF
$sFinalDisplay&="Add 1 Day (24 hours) to it: "&_UFTC64(_WinTime_AddToFileTime($iTime64,1))&@CRLF

Local $iCurrentLocalFileTime=_WinTime_SystemTimeToLocalFileTime(@YEAR,@MON,@MDAY,@HOUR,@MIN,@SEC,@MSEC)

$sFinalDisplay&="Current (macro) time "&_WinTime_FormatTime(@YEAR,@MON,@MDAY,@HOUR,@MIN,@SEC,@MSEC,@WDAY-1,4+8,1,True)& _
	", converted to *Local* FileTime: "&$iCurrentLocalFileTime&", and back: "&_LFTC64($iCurrentLocalFileTime)&@CRLF
$sFinalDisplay&="Current (macro) time converted to UTC (GMT) Time: "&_LFTC64(_WinTime_LocalFileTimeToUTCFileTime($iCurrentLocalFileTime))&@CRLF

$sFinalDisplay&="Smallest *UTC* date, [may be blank due to UTC-to-Local conversion giving negative #] number 0: "&_UFTC64(0)&@CRLF
$sFinalDisplay&="Smallest *Local* date [skips UTC-to-Local conversion], number 0: "&_LFTC64(0)&@CRLF
$sFinalDisplay&="The greatest *UTC* date, number 0x7FFFFFFFFFFFE950 (9,223,372,036,854,770,000): "&_UFTC64(9223372036854770000)&@CRLF

$sFinalDisplay&="Max *input* (Local) FileTime [December 31,30827 @ 23:59:59:999]: "&_WinTime_SystemTimeToLocalFileTime(30827,12,31,23,59,59,999)&@CRLF
$sFinalDisplay&="Min *input* (Local) FileTime (skips UTC-to-Local conversion due to possibility of negative # result):"&@CRLF& _
	"		[January 1, 1601 @ 00:00:00:0000]: "&_WinTime_SystemTimeToLocalFileTime(1601,1,1,0,0,0,0)&@CRLF

$sFinalDisplay&="To convert *from* *UTC* FileTime to *Local* FileTime, Add this value to FileTime:"&_WinTime_GetUTCToLocalFileTimeDelta()& _
	" (or "&(_WinTime_GetUTCToLocalFileTimeDelta()/36000000000)&" hours)"&@CRLF
$sFinalDisplay&="To convert *from* *Local* FileTime to *UTC* FileTime, Add this value to FileTime:"&_WinTime_GetLocalToUTCFileTimeDelta()& _
	" (or "&(_WinTime_GetLocalToUTCFileTimeDelta()/36000000000)&" hours)"&@CRLF

MsgBox(0,"_WinTime function experiments result:",$sFinalDisplay)
ConsoleWrite("_WinTime function experiments result:"&@CRLF&$sFinalDisplay)
