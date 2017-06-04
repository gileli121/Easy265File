#NoTrayIcon
Global Const $0 = 0xFF0000
Global Const $1 = 0x00C00000
Global Const $2 = BitOR($1, 0x00010000, 0x00020000, 0, 0x00080000, 0x00040000)
Global Const $3 = 0x004E
Global Const $4 = 0 - 2
Global Const $5 = 0 - 5
Global Const $6 = 0xC5
Global Const $7 = 0xB5
Global Const $8 = 0x00B7
Global Const $9 = 0xB1
Global Const $a = 0x003010c0
Global Enum $b, $c, $d, $e, $f, $g, $h
Func _0(ByRef $i, $j, $k = 0, $l = "|", $m = @CRLF, $n = $b)
If $k = Default Then $k = 0
If $l = Default Then $l = "|"
If $m = Default Then $m = @CRLF
If $n = Default Then $n = $b
If Not IsArray($i) Then Return SetError(1, 0, -1)
Local $o = UBound($i, 1)
Local $p = 0
Switch $n
Case $d
$p = Int
Case $e
$p = Number
Case $f
$p = Ptr
Case $g
$p = Hwnd
Case $h
$p = String
EndSwitch
Switch UBound($i, 0)
Case 1
If $n = $c Then
ReDim $i[$o + 1]
$i[$o] = $j
Return $o
EndIf
If IsArray($j) Then
If UBound($j, 0) <> 1 Then Return SetError(5, 0, -1)
$p = 0
Else
Local $q = StringSplit($j, $l, 2 + 1)
If UBound($q, 1) = 1 Then
$q[0] = $j
EndIf
$j = $q
EndIf
Local $r = UBound($j, 1)
ReDim $i[$o + $r]
For $s = 0 To $r - 1
If IsFunc($p) Then
$i[$o + $s] = $p($j[$s])
Else
$i[$o + $s] = $j[$s]
EndIf
Next
Return $o + $r - 1
Case 2
Local $t = UBound($i, 2)
If $k < 0 Or $k > $t - 1 Then Return SetError(4, 0, -1)
Local $u, $v = 0, $w
If IsArray($j) Then
If UBound($j, 0) <> 2 Then Return SetError(5, 0, -1)
$u = UBound($j, 1)
$v = UBound($j, 2)
$p = 0
Else
Local $x = StringSplit($j, $m, 2 + 1)
$u = UBound($x, 1)
Local $q[$u][0], $y
For $s = 0 To $u - 1
$y = StringSplit($x[$s], $l, 2 + 1)
$w = UBound($y)
If $w > $v Then
$v = $w
ReDim $q[$u][$v]
EndIf
For $0z = 0 To $w - 1
$q[$s][$0z] = $y[$0z]
Next
Next
$j = $q
EndIf
If UBound($j, 2) + $k > UBound($i, 2) Then Return SetError(3, 0, -1)
ReDim $i[$o + $u][$t]
For $10 = 0 To $u - 1
For $0z = 0 To $t - 1
If $0z < $k Then
$i[$10 + $o][$0z] = ""
ElseIf $0z - $k > $v - 1 Then
$i[$10 + $o][$0z] = ""
Else
If IsFunc($p) Then
$i[$10 + $o][$0z] = $p($j[$10][$0z - $k])
Else
$i[$10 + $o][$0z] = $j[$10][$0z - $k]
EndIf
EndIf
Next
Next
Case Else
Return SetError(2, 0, -1)
EndSwitch
Return UBound($i, 1) - 1
EndFunc
Func _5(ByRef $11, Const ByRef $12, $k = 0)
If $k = Default Then $k = 0
If Not IsArray($11) Then Return SetError(1, 0, -1)
If Not IsArray($12) Then Return SetError(2, 0, -1)
Local $13 = UBound($11, 0)
Local $14 = UBound($12, 0)
Local $15 = UBound($11, 1)
Local $16 = UBound($12, 1)
If $k < 0 Or $k > $16 - 1 Then Return SetError(6, 0, -1)
Switch $13
Case 1
If $14 <> 1 Then Return SetError(4, 0, -1)
ReDim $11[$15 + $16 - $k]
For $s = $k To $16 - 1
$11[$15 + $s - $k] = $12[$s]
Next
Case 2
If $14 <> 2 Then Return SetError(4, 0, -1)
Local $17 = UBound($11, 2)
If UBound($12, 2) <> $17 Then Return SetError(5, 0, -1)
ReDim $11[$15 + $16 - $k][$17]
For $s = $k To $16 - 1
For $0z = 0 To $17 - 1
$11[$15 + $s - $k][$0z] = $12[$s][$0z]
Next
Next
Case Else
Return SetError(3, 0, -1)
EndSwitch
Return UBound($11, 1)
EndFunc
Func _6(ByRef $i, $18)
If Not IsArray($i) Then Return SetError(1, 0, -1)
Local $o = UBound($i, 1) - 1
If IsArray($18) Then
If UBound($18, 0) <> 1 Or UBound($18, 1) < 2 Then Return SetError(4, 0, -1)
Else
Local $19, $x, $y
$18 = StringStripWS($18, 8)
$x = StringSplit($18, ";")
$18 = ""
For $s = 1 To $x[0]
If Not StringRegExp($x[$s], "^\d+(-\d+)?$") Then Return SetError(3, 0, -1)
$y = StringSplit($x[$s], "-")
Switch $y[0]
Case 1
$18 &= $y[1] & ";"
Case 2
If Number($y[2]) >= Number($y[1]) Then
$19 = $y[1] - 1
Do
$19 += 1
$18 &= $19 & ";"
Until $19 = $y[2]
EndIf
EndSwitch
Next
$18 = StringSplit(StringTrimRight($18, 1), ";")
EndIf
If $18[1] < 0 Or $18[$18[0]] > $o Then Return SetError(5, 0, -1)
Local $1a = 0
Switch UBound($i, 0)
Case 1
For $s = 1 To $18[0]
$i[$18[$s]] = ChrW(0xFAB1)
Next
For $1b = 0 To $o
If $i[$1b] == ChrW(0xFAB1) Then
ContinueLoop
Else
If $1b <> $1a Then
$i[$1a] = $i[$1b]
EndIf
$1a += 1
EndIf
Next
ReDim $i[$o - $18[0] + 1]
Case 2
Local $t = UBound($i, 2) - 1
For $s = 1 To $18[0]
$i[$18[$s]][0] = ChrW(0xFAB1)
Next
For $1b = 0 To $o
If $i[$1b][0] == ChrW(0xFAB1) Then
ContinueLoop
Else
If $1b <> $1a Then
For $0z = 0 To $t
$i[$1a][$0z] = $i[$1b][$0z]
Next
EndIf
$1a += 1
EndIf
Next
ReDim $i[$o - $18[0] + 1][$t + 1]
Case Else
Return SetError(2, 0, False)
EndSwitch
Return UBound($i, 1)
EndFunc
Func _a(ByRef $i, $18, $j = "", $k = 0, $l = "|", $m = @CRLF, $n = $b)
If $j = Default Then $j = ""
If $k = Default Then $k = 0
If $l = Default Then $l = "|"
If $m = Default Then $m = @CRLF
If $n = Default Then $n = $b
If Not IsArray($i) Then Return SetError(1, 0, -1)
Local $o = UBound($i, 1) - 1
Local $p = 0
Switch $n
Case $d
$p = Int
Case $e
$p = Number
Case $f
$p = Ptr
Case $g
$p = Hwnd
Case $h
$p = String
EndSwitch
Local $x, $y
If IsArray($18) Then
If UBound($18, 0) <> 1 Or UBound($18, 1) < 2 Then Return SetError(4, 0, -1)
Else
Local $19
$18 = StringStripWS($18, 8)
$x = StringSplit($18, ";")
$18 = ""
For $s = 1 To $x[0]
If Not StringRegExp($x[$s], "^\d+(-\d+)?$") Then Return SetError(3, 0, -1)
$y = StringSplit($x[$s], "-")
Switch $y[0]
Case 1
$18 &= $y[1] & ";"
Case 2
If Number($y[2]) >= Number($y[1]) Then
$19 = $y[1] - 1
Do
$19 += 1
$18 &= $19 & ";"
Until $19 = $y[2]
EndIf
EndSwitch
Next
$18 = StringSplit(StringTrimRight($18, 1), ";")
EndIf
If $18[1] < 0 Or $18[$18[0]] > $o Then Return SetError(5, 0, -1)
For $s = 2 To $18[0]
If $18[$s] < $18[$s - 1] Then Return SetError(3, 0, -1)
Next
Local $1a = $o + $18[0]
Local $1c = $18[0]
Local $1d = $18[$1c]
Switch UBound($i, 0)
Case 1
If $n = $c Then
ReDim $i[$o + $18[0] + 1]
For $1e = $o To 0 Step -1
$i[$1a] = $i[$1e]
$1a -= 1
$1d = $18[$1c]
While $1e = $1d
$i[$1a] = $j
$1a -= 1
$1c -= 1
If $1c < 1 Then ExitLoop 2
$1d = $18[$1c]
WEnd
Next
Return $o + $18[0] + 1
EndIf
ReDim $i[$o + $18[0] + 1]
If IsArray($j) Then
If UBound($j, 0) <> 1 Then Return SetError(5, 0, -1)
$p = 0
Else
Local $q = StringSplit($j, $l, 2 + 1)
If UBound($q, 1) = 1 Then
$q[0] = $j
$p = 0
EndIf
$j = $q
EndIf
For $1e = $o To 0 Step -1
$i[$1a] = $i[$1e]
$1a -= 1
$1d = $18[$1c]
While $1e = $1d
If $1c <= UBound($j, 1) Then
If IsFunc($p) Then
$i[$1a] = $p($j[$1c - 1])
Else
$i[$1a] = $j[$1c - 1]
EndIf
Else
$i[$1a] = ""
EndIf
$1a -= 1
$1c -= 1
If $1c = 0 Then ExitLoop 2
$1d = $18[$1c]
WEnd
Next
Case 2
Local $t = UBound($i, 2)
If $k < 0 Or $k > $t - 1 Then Return SetError(6, 0, -1)
Local $u, $v
If IsArray($j) Then
If UBound($j, 0) <> 2 Then Return SetError(7, 0, -1)
$u = UBound($j, 1)
$v = UBound($j, 2)
$p = 0
Else
$x = StringSplit($j, $m, 2 + 1)
$u = UBound($x, 1)
StringReplace($x[0], $l, "")
$v = @extended + 1
Local $q[$u][$v]
For $s = 0 To $u - 1
$y = StringSplit($x[$s], $l, 2 + 1)
For $0z = 0 To $v - 1
$q[$s][$0z] = $y[$0z]
Next
Next
$j = $q
EndIf
If UBound($j, 2) + $k > UBound($i, 2) Then Return SetError(8, 0, -1)
ReDim $i[$o + $18[0] + 1][$t]
For $1e = $o To 0 Step -1
For $0z = 0 To $t - 1
$i[$1a][$0z] = $i[$1e][$0z]
Next
$1a -= 1
$1d = $18[$1c]
While $1e = $1d
For $0z = 0 To $t - 1
If $0z < $k Then
$i[$1a][$0z] = ""
ElseIf $0z - $k > $v - 1 Then
$i[$1a][$0z] = ""
Else
If $1c - 1 < $u Then
If IsFunc($p) Then
$i[$1a][$0z] = $p($j[$1c - 1][$0z - $k])
Else
$i[$1a][$0z] = $j[$1c - 1][$0z - $k]
EndIf
Else
$i[$1a][$0z] = ""
EndIf
EndIf
Next
$1a -= 1
$1c -= 1
If $1c = 0 Then ExitLoop 2
$1d = $18[$1c]
WEnd
Next
Case Else
Return SetError(2, 0, -1)
EndSwitch
Return UBound($i, 1)
EndFunc
Func _i(ByRef $i, $k = 0, $1f = 0)
If $k = Default Then $k = 0
If $1f = Default Then $1f = 0
If Not IsArray($i) Then Return SetError(1, 0, 0)
If UBound($i, 0) <> 1 Then Return SetError(3, 0, 0)
If Not UBound($i) Then Return SetError(4, 0, 0)
Local $1g, $1h = UBound($i) - 1
If $1f < 1 Or $1f > $1h Then $1f = $1h
If $k < 0 Then $k = 0
If $k > $1f Then Return SetError(2, 0, 0)
For $s = $k To Int(($k + $1f - 1) / 2)
$1g = $i[$s]
$i[$s] = $i[$1f]
$i[$1f] = $1g
$1f -= 1
Next
Return 1
EndFunc
Func _j(Const ByRef $i, $j, $k = 0, $1f = 0, $1i = 0, $1j = 0, $1k = 1, $1l = -1, $1m = False)
If $k = Default Then $k = 0
If $1f = Default Then $1f = 0
If $1i = Default Then $1i = 0
If $1j = Default Then $1j = 0
If $1k = Default Then $1k = 1
If $1l = Default Then $1l = -1
If $1m = Default Then $1m = False
If Not IsArray($i) Then Return SetError(1, 0, -1)
Local $o = UBound($i) - 1
If $o = -1 Then Return SetError(3, 0, -1)
Local $t = UBound($i, 2) - 1
Local $1n = False
If $1j = 2 Then
$1j = 0
$1n = True
EndIf
If $1m Then
If UBound($i, 0) = 1 Then Return SetError(5, 0, -1)
If $1f < 1 Or $1f > $t Then $1f = $t
If $k < 0 Then $k = 0
If $k > $1f Then Return SetError(4, 0, -1)
Else
If $1f < 1 Or $1f > $o Then $1f = $o
If $k < 0 Then $k = 0
If $k > $1f Then Return SetError(4, 0, -1)
EndIf
Local $1o = 1
If Not $1k Then
Local $1p = $k
$k = $1f
$1f = $1p
$1o = -1
EndIf
Switch UBound($i, 0)
Case 1
If Not $1j Then
If Not $1i Then
For $s = $k To $1f Step $1o
If $1n And VarGetType($i[$s]) <> VarGetType($j) Then ContinueLoop
If $i[$s] = $j Then Return $s
Next
Else
For $s = $k To $1f Step $1o
If $1n And VarGetType($i[$s]) <> VarGetType($j) Then ContinueLoop
If $i[$s] == $j Then Return $s
Next
EndIf
Else
For $s = $k To $1f Step $1o
If $1j = 3 Then
If StringRegExp($i[$s], $j) Then Return $s
Else
If StringInStr($i[$s], $j, $1i) > 0 Then Return $s
EndIf
Next
EndIf
Case 2
Local $1q
If $1m Then
$1q = $o
If $1l > $1q Then $1l = $1q
If $1l < 0 Then
$1l = 0
Else
$1q = $1l
EndIf
Else
$1q = $t
If $1l > $1q Then $1l = $1q
If $1l < 0 Then
$1l = 0
Else
$1q = $1l
EndIf
EndIf
For $0z = $1l To $1q
If Not $1j Then
If Not $1i Then
For $s = $k To $1f Step $1o
If $1m Then
If $1n And VarGetType($i[$0z][$0z]) <> VarGetType($j) Then ContinueLoop
If $i[$0z][$s] = $j Then Return $s
Else
If $1n And VarGetType($i[$s][$0z]) <> VarGetType($j) Then ContinueLoop
If $i[$s][$0z] = $j Then Return $s
EndIf
Next
Else
For $s = $k To $1f Step $1o
If $1m Then
If $1n And VarGetType($i[$0z][$s]) <> VarGetType($j) Then ContinueLoop
If $i[$0z][$s] == $j Then Return $s
Else
If $1n And VarGetType($i[$s][$0z]) <> VarGetType($j) Then ContinueLoop
If $i[$s][$0z] == $j Then Return $s
EndIf
Next
EndIf
Else
For $s = $k To $1f Step $1o
If $1j = 3 Then
If $1m Then
If StringRegExp($i[$0z][$s], $j) Then Return $s
Else
If StringRegExp($i[$s][$0z], $j) Then Return $s
EndIf
Else
If $1m Then
If StringInStr($i[$0z][$s], $j, $1i) > 0 Then Return $s
Else
If StringInStr($i[$s][$0z], $j, $1i) > 0 Then Return $s
EndIf
EndIf
Next
EndIf
Next
Case Else
Return SetError(2, 0, -1)
EndSwitch
Return SetError(6, 0, -1)
EndFunc
Func _l(ByRef $i, $1r = 0, $k = 0, $1f = 0, $1l = 0, $1s = 0)
If $1r = Default Then $1r = 0
If $k = Default Then $k = 0
If $1f = Default Then $1f = 0
If $1l = Default Then $1l = 0
If $1s = Default Then $1s = 0
If Not IsArray($i) Then Return SetError(1, 0, 0)
Local $1h = UBound($i) - 1
If $1h = -1 Then Return SetError(5, 0, 0)
If $1f = Default Then $1f = 0
If $1f < 1 Or $1f > $1h Or $1f = Default Then $1f = $1h
If $k < 0 Or $k = Default Then $k = 0
If $k > $1f Then Return SetError(2, 0, 0)
If $1r = Default Then $1r = 0
If $1s = Default Then $1s = 0
If $1l = Default Then $1l = 0
Switch UBound($i, 0)
Case 1
If $1s Then
_o($i, $k, $1f)
Else
_m($i, $k, $1f)
EndIf
If $1r Then _i($i, $k, $1f)
Case 2
If $1s Then Return SetError(6, 0, 0)
Local $1t = UBound($i, 2) - 1
If $1l > $1t Then Return SetError(3, 0, 0)
If $1r Then
$1r = -1
Else
$1r = 1
EndIf
_n($i, $1r, $k, $1f, $1l, $1t)
Case Else
Return SetError(4, 0, 0)
EndSwitch
Return 1
EndFunc
Func _m(ByRef $i, Const ByRef $k, Const ByRef $1f)
If $1f <= $k Then Return
Local $1g
If($1f - $k) < 15 Then
Local $1u
For $s = $k + 1 To $1f
$1g = $i[$s]
If IsNumber($1g) Then
For $0z = $s - 1 To $k Step -1
$1u = $i[$0z]
If($1g >= $1u And IsNumber($1u)) Or(Not IsNumber($1u) And StringCompare($1g, $1u) >= 0) Then ExitLoop
$i[$0z + 1] = $1u
Next
Else
For $0z = $s - 1 To $k Step -1
If(StringCompare($1g, $i[$0z]) >= 0) Then ExitLoop
$i[$0z + 1] = $i[$0z]
Next
EndIf
$i[$0z + 1] = $1g
Next
Return
EndIf
Local $1v = $k, $1w = $1f, $1x = $i[Int(($k + $1f) / 2)], $1y = IsNumber($1x)
Do
If $1y Then
While($i[$1v] < $1x And IsNumber($i[$1v])) Or(Not IsNumber($i[$1v]) And StringCompare($i[$1v], $1x) < 0)
$1v += 1
WEnd
While($i[$1w] > $1x And IsNumber($i[$1w])) Or(Not IsNumber($i[$1w]) And StringCompare($i[$1w], $1x) > 0)
$1w -= 1
WEnd
Else
While(StringCompare($i[$1v], $1x) < 0)
$1v += 1
WEnd
While(StringCompare($i[$1w], $1x) > 0)
$1w -= 1
WEnd
EndIf
If $1v <= $1w Then
$1g = $i[$1v]
$i[$1v] = $i[$1w]
$i[$1w] = $1g
$1v += 1
$1w -= 1
EndIf
Until $1v > $1w
_m($i, $k, $1w)
_m($i, $1v, $1f)
EndFunc
Func _n(ByRef $i, Const ByRef $1o, Const ByRef $k, Const ByRef $1f, Const ByRef $1l, Const ByRef $1t)
If $1f <= $k Then Return
Local $1g, $1v = $k, $1w = $1f, $1x = $i[Int(($k + $1f) / 2)][$1l], $1y = IsNumber($1x)
Do
If $1y Then
While($1o *($i[$1v][$1l] - $1x) < 0 And IsNumber($i[$1v][$1l])) Or(Not IsNumber($i[$1v][$1l]) And $1o * StringCompare($i[$1v][$1l], $1x) < 0)
$1v += 1
WEnd
While($1o *($i[$1w][$1l] - $1x) > 0 And IsNumber($i[$1w][$1l])) Or(Not IsNumber($i[$1w][$1l]) And $1o * StringCompare($i[$1w][$1l], $1x) > 0)
$1w -= 1
WEnd
Else
While($1o * StringCompare($i[$1v][$1l], $1x) < 0)
$1v += 1
WEnd
While($1o * StringCompare($i[$1w][$1l], $1x) > 0)
$1w -= 1
WEnd
EndIf
If $1v <= $1w Then
For $s = 0 To $1t
$1g = $i[$1v][$s]
$i[$1v][$s] = $i[$1w][$s]
$i[$1w][$s] = $1g
Next
$1v += 1
$1w -= 1
EndIf
Until $1v > $1w
_n($i, $1o, $k, $1w, $1l, $1t)
_n($i, $1o, $1v, $1f, $1l, $1t)
EndFunc
Func _o(ByRef $i, $1z, $20, $21 = True)
If $1z > $20 Then Return
Local $22 = $20 - $1z + 1
Local $s, $0z, $23, $24, $25, $26, $27, $28
If $22 < 45 Then
If $21 Then
$s = $1z
While $s < $20
$0z = $s
$24 = $i[$s + 1]
While $24 < $i[$0z]
$i[$0z + 1] = $i[$0z]
$0z -= 1
If $0z + 1 = $1z Then ExitLoop
WEnd
$i[$0z + 1] = $24
$s += 1
WEnd
Else
While 1
If $1z >= $20 Then Return 1
$1z += 1
If $i[$1z] < $i[$1z - 1] Then ExitLoop
WEnd
While 1
$23 = $1z
$1z += 1
If $1z > $20 Then ExitLoop
$26 = $i[$23]
$27 = $i[$1z]
If $26 < $27 Then
$27 = $26
$26 = $i[$1z]
EndIf
$23 -= 1
While $26 < $i[$23]
$i[$23 + 2] = $i[$23]
$23 -= 1
WEnd
$i[$23 + 2] = $26
While $27 < $i[$23]
$i[$23 + 1] = $i[$23]
$23 -= 1
WEnd
$i[$23 + 1] = $27
$1z += 1
WEnd
$28 = $i[$20]
$20 -= 1
While $28 < $i[$20]
$i[$20 + 1] = $i[$20]
$20 -= 1
WEnd
$i[$20 + 1] = $28
EndIf
Return 1
EndIf
Local $29 = BitShift($22, 3) + BitShift($22, 6) + 1
Local $2a, $2b, $2c, $2d, $2e, $2f
$2c = Ceiling(($1z + $20) / 2)
$2b = $2c - $29
$2a = $2b - $29
$2d = $2c + $29
$2e = $2d + $29
If $i[$2b] < $i[$2a] Then
$2f = $i[$2b]
$i[$2b] = $i[$2a]
$i[$2a] = $2f
EndIf
If $i[$2c] < $i[$2b] Then
$2f = $i[$2c]
$i[$2c] = $i[$2b]
$i[$2b] = $2f
If $2f < $i[$2a] Then
$i[$2b] = $i[$2a]
$i[$2a] = $2f
EndIf
EndIf
If $i[$2d] < $i[$2c] Then
$2f = $i[$2d]
$i[$2d] = $i[$2c]
$i[$2c] = $2f
If $2f < $i[$2b] Then
$i[$2c] = $i[$2b]
$i[$2b] = $2f
If $2f < $i[$2a] Then
$i[$2b] = $i[$2a]
$i[$2a] = $2f
EndIf
EndIf
EndIf
If $i[$2e] < $i[$2d] Then
$2f = $i[$2e]
$i[$2e] = $i[$2d]
$i[$2d] = $2f
If $2f < $i[$2c] Then
$i[$2d] = $i[$2c]
$i[$2c] = $2f
If $2f < $i[$2b] Then
$i[$2c] = $i[$2b]
$i[$2b] = $2f
If $2f < $i[$2a] Then
$i[$2b] = $i[$2a]
$i[$2a] = $2f
EndIf
EndIf
EndIf
EndIf
Local $2g = $1z
Local $2h = $20
If(($i[$2a] <> $i[$2b]) And($i[$2b] <> $i[$2c]) And($i[$2c] <> $i[$2d]) And($i[$2d] <> $i[$2e])) Then
Local $2i = $i[$2b]
Local $2j = $i[$2d]
$i[$2b] = $i[$1z]
$i[$2d] = $i[$20]
Do
$2g += 1
Until $i[$2g] >= $2i
Do
$2h -= 1
Until $i[$2h] <= $2j
$23 = $2g
While $23 <= $2h
$25 = $i[$23]
If $25 < $2i Then
$i[$23] = $i[$2g]
$i[$2g] = $25
$2g += 1
ElseIf $25 > $2j Then
While $i[$2h] > $2j
$2h -= 1
If $2h + 1 = $23 Then ExitLoop 2
WEnd
If $i[$2h] < $2i Then
$i[$23] = $i[$2g]
$i[$2g] = $i[$2h]
$2g += 1
Else
$i[$23] = $i[$2h]
EndIf
$i[$2h] = $25
$2h -= 1
EndIf
$23 += 1
WEnd
$i[$1z] = $i[$2g - 1]
$i[$2g - 1] = $2i
$i[$20] = $i[$2h + 1]
$i[$2h + 1] = $2j
_o($i, $1z, $2g - 2, True)
_o($i, $2h + 2, $20, False)
If($2g < $2a) And($2e < $2h) Then
While $i[$2g] = $2i
$2g += 1
WEnd
While $i[$2h] = $2j
$2h -= 1
WEnd
$23 = $2g
While $23 <= $2h
$25 = $i[$23]
If $25 = $2i Then
$i[$23] = $i[$2g]
$i[$2g] = $25
$2g += 1
ElseIf $25 = $2j Then
While $i[$2h] = $2j
$2h -= 1
If $2h + 1 = $23 Then ExitLoop 2
WEnd
If $i[$2h] = $2i Then
$i[$23] = $i[$2g]
$i[$2g] = $2i
$2g += 1
Else
$i[$23] = $i[$2h]
EndIf
$i[$2h] = $25
$2h -= 1
EndIf
$23 += 1
WEnd
EndIf
_o($i, $2g, $2h, False)
Else
Local $1s = $i[$2c]
$23 = $2g
While $23 <= $2h
If $i[$23] = $1s Then
$23 += 1
ContinueLoop
EndIf
$25 = $i[$23]
If $25 < $1s Then
$i[$23] = $i[$2g]
$i[$2g] = $25
$2g += 1
Else
While $i[$2h] > $1s
$2h -= 1
WEnd
If $i[$2h] < $1s Then
$i[$23] = $i[$2g]
$i[$2g] = $i[$2h]
$2g += 1
Else
$i[$23] = $1s
EndIf
$i[$2h] = $25
$2h -= 1
EndIf
$23 += 1
WEnd
_o($i, $1z, $2g - 1, True)
_o($i, $2h + 1, $20, False)
EndIf
EndFunc
Global Const $2k = 0x0026200A
Global Const $2l = "struct;long X;long Y;endstruct"
Global Const $2m = "struct;long Left;long Top;long Right;long Bottom;endstruct"
Global Const $2n = "struct;hwnd hWndFrom;uint_ptr IDFrom;INT Code;endstruct"
Global Const $2o = "uint Version;ptr Callback;bool NoThread;bool NoCodecs"
Global Const $2p = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
Global Const $2q = $2n & ";int Item;int SubItem;uint NewState;uint OldState;uint Changed;" & "struct;long ActionX;long ActionY;endstruct;lparam Param"
Global Const $2r = "uint cbSize;uint fMask;uint fStyle;dword clrFore;dword clrBack;ptr lpText;uint cch;" & "int iImage;hwnd hwndChild;uint cxMinChild;uint cyMinChild;uint cx;handle hbmBack;uint wID;uint cyChild;uint cyMaxChild;" & "uint cyIntegral;uint cxIdeal;lparam lParam;uint cxHeader" &((@OSVersion = "WIN_XP") ? "" : ";" & $2m & ";uint uChevronState")
Global Enum $2s = 0, $2t, $2u, $2v
Func _14(Const $2w = @error, Const $2x = @extended)
Local $2y = DllCall("kernel32.dll", "dword", "GetLastError")
Return SetError($2w, $2x, $2y[0])
EndFunc
Func _15($2z, Const $2w = @error, Const $2x = @extended)
DllCall("kernel32.dll", "none", "SetLastError", "dword", $2z)
Return SetError($2w, $2x, Null)
EndFunc
Func _17($30, $31, $32, $33, $34 = 0, $35 = 0)
Local $36 = DllCall("advapi32.dll", "bool", "AdjustTokenPrivileges", "handle", $30, "bool", $31, "struct*", $32, "dword", $33, "struct*", $34, "struct*", $35)
If @error Then Return SetError(@error, @extended, False)
Return Not($36[0] = 0)
EndFunc
Func _1d($37 = $2u)
Local $36 = DllCall("advapi32.dll", "bool", "ImpersonateSelf", "int", $37)
If @error Then Return SetError(@error, @extended, False)
Return Not($36[0] = 0)
EndFunc
Func _1h($38, $39)
Local $36 = DllCall("advapi32.dll", "bool", "LookupPrivilegeValueW", "wstr", $38, "wstr", $39, "int64*", 0)
If @error Or Not $36[0] Then Return SetError(@error, @extended, 0)
Return $36[3]
EndFunc
Func _1j($3a, $3b = 0, $3c = False)
If $3b = 0 Then
Local $2y = DllCall("kernel32.dll", "handle", "GetCurrentThread")
If @error Then Return SetError(@error + 10, @extended, 0)
$3b = $2y[0]
EndIf
Local $36 = DllCall("advapi32.dll", "bool", "OpenThreadToken", "handle", $3b, "dword", $3a, "bool", $3c, "handle*", 0)
If @error Or Not $36[0] Then Return SetError(@error, @extended, 0)
Return $36[4]
EndFunc
Func _1k($3a, $3b = 0, $3c = False)
Local $30 = _1j($3a, $3b, $3c)
If $30 = 0 Then
Local Const $3d = 1008
If _14() <> $3d Then Return SetError(20, _14(), 0)
If Not _1d() Then Return SetError(@error + 10, _14(), 0)
$30 = _1j($3a, $3b, $3c)
If $30 = 0 Then Return SetError(@error, _14(), 0)
EndIf
Return $30
EndFunc
Func _1l($30, $3e, $3f)
Local $3g = _1h("", $3e)
If $3g = 0 Then Return SetError(@error + 10, @extended, False)
Local Const $3h = "dword Count;align 4;int64 LUID;dword Attributes"
Local $3i = DllStructCreate($3h)
Local $3j = DllStructGetSize($3i)
Local $34 = DllStructCreate($3h)
Local $3k = DllStructGetSize($34)
Local $3l = DllStructCreate("int Data")
DllStructSetData($3i, "Count", 1)
DllStructSetData($3i, "LUID", $3g)
If Not _17($30, False, $3i, $3j, $34, $3l) Then Return SetError(2, @error, False)
DllStructSetData($34, "Count", 1)
DllStructSetData($34, "LUID", $3g)
Local $3m = DllStructGetData($34, "Attributes")
If $3f Then
$3m = BitOR($3m, 0x00000002)
Else
$3m = BitAND($3m, BitNOT(0x00000002))
EndIf
DllStructSetData($34, "Attributes", $3m)
If Not _17($30, False, $34, $3k, $3i, $3l) Then Return SetError(3, @error, False)
Return True
EndFunc
Func _1q($3n, $3o, $3p = 0, $3q = 0, $3r = 0, $3s = "wparam", $3t = "lparam", $3u = "lresult")
Local $2y = DllCall("user32.dll", $3u, "SendMessageW", "hwnd", $3n, "uint", $3o, $3s, $3p, $3t, $3q)
If @error Then Return SetError(@error, @extended, "")
If $3r >= 0 And $3r <= 4 Then Return $2y[$3r]
Return $2y
EndFunc
Global Const $3v = Ptr(-1)
Global Const $3w = Ptr(-1)
Global Const $3x = BitShift(0x0100, 8)
Global Const $3y = BitShift(0x2000, 8)
Global Const $3z = BitShift(0x8000, 8)
Global $40[64][2] = [[0, 0]]
Func _2j($41)
Local $2y = DllCall("gdi32.dll", "bool", "DeleteObject", "handle", $41)
If @error Then Return SetError(@error, @extended, False)
Return $2y[0]
EndFunc
Func _3d($42)
Local $2y = DllCall("kernel32.dll", "bool", "FreeLibrary", "handle", $42)
If @error Then Return SetError(@error, @extended, False)
Return $2y[0]
EndFunc
Func _3h($3n)
If Not IsHWnd($3n) Then $3n = GUICtrlGetHandle($3n)
Local $2y = DllCall("user32.dll", "int", "GetClassNameW", "hwnd", $3n, "wstr", "", "int", 4096)
If @error Or Not $2y[0] Then Return SetError(@error, @extended, '')
Return SetExtended($2y[0], $2y[2])
EndFunc
Func _3u($3n)
Local $2y = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $3n)
If @error Then Return SetError(@error, @extended, 0)
Return $2y[0]
EndFunc
Func _43($43)
Local $44 = "wstr"
If $43 = "" Then
$43 = 0
$44 = "ptr"
EndIf
Local $2y = DllCall("kernel32.dll", "handle", "GetModuleHandleW", $44, $43)
If @error Then Return SetError(@error, @extended, 0)
Return $2y[0]
EndFunc
Func _44($45 = False, $3n = 0)
Local $46 = Opt("MouseCoordMode", 1)
Local $47 = MouseGetPos()
Opt("MouseCoordMode", $46)
Local $48 = DllStructCreate($2l)
DllStructSetData($48, "X", $47[0])
DllStructSetData($48, "Y", $47[1])
If $45 And Not _65($3n, $48) Then Return SetError(@error + 20, @extended, 0)
Return $48
EndFunc
Func _4i($49)
Local $2y = DllCall("user32.dll", "int", "GetSystemMetrics", "int", $49)
If @error Then Return SetError(@error, @extended, 0)
Return $2y[0]
EndFunc
Func _4o($3n, $49)
Local $4a = "GetWindowLongW"
If @AutoItX64 Then $4a = "GetWindowLongPtrW"
Local $2y = DllCall("user32.dll", "long_ptr", $4a, "hwnd", $3n, "int", $49)
If @error Or Not $2y[0] Then Return SetError(@error + 10, @extended, 0)
Return $2y[0]
EndFunc
Func _4t($3n, ByRef $4b)
Local $2y = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $3n, "dword*", 0)
If @error Then Return SetError(@error, @extended, 0)
$4b = $2y[2]
Return $2y[0]
EndFunc
Func _50($3n, ByRef $4c)
If $3n = $4c Then Return True
For $4d = $40[0][0] To 1 Step -1
If $3n = $40[$4d][0] Then
If $40[$4d][1] Then
$4c = $3n
Return True
Else
Return False
EndIf
EndIf
Next
Local $4b
_4t($3n, $4b)
Local $4e = $40[0][0] + 1
If $4e >= 64 Then $4e = 1
$40[0][0] = $4e
$40[$4e][0] = $3n
$40[$4e][1] =($4b = @AutoItPID)
Return $40[$4e][1]
EndFunc
Func _55($3n, $4f = 0, $4g = True)
Local $2y = DllCall("user32.dll", "bool", "InvalidateRect", "hwnd", $3n, "struct*", $4f, "bool", $4g)
If @error Then Return SetError(@error, @extended, False)
Return $2y[0]
EndFunc
Func _58($4h, $4i, $4j, $4k, $4l, $4m)
Local $2y, $4n = "int"
If IsString($4i) Then $4n = "wstr"
$2y = DllCall("user32.dll", "handle", "LoadImageW", "handle", $4h, $4n, $4i, "uint", $4j, "int", $4k, "int", $4l, "uint", $4m)
If @error Then Return SetError(@error, @extended, 0)
Return $2y[0]
EndFunc
Func _5a($4o, $4p = 0)
Local $2y = DllCall("kernel32.dll", "handle", "LoadLibraryExW", "wstr", $4o, "ptr", 0, "dword", $4p)
If @error Then Return SetError(@error, @extended, 0)
Return $2y[0]
EndFunc
Func _65($3n, ByRef $48)
Local $2y = DllCall("user32.dll", "bool", "ScreenToClient", "hwnd", $3n, "struct*", $48)
If @error Then Return SetError(@error, @extended, False)
Return $2y[0]
EndFunc
Func _6o($3n, $49, $4q)
_15(0)
Local $4a = "SetWindowLongW"
If @AutoItX64 Then $4a = "SetWindowLongPtrW"
Local $2y = DllCall("user32.dll", "long_ptr", $4a, "hwnd", $3n, "int", $49, "long_ptr", $4q)
If @error Then Return SetError(@error, @extended, 0)
Return $2y[0]
EndFunc
Global Const $4r = 'struct;dword OSVersionInfoSize;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128];endstruct'
Global Const $4s = _8f()
Func _7p($4t, $22)
Local $4u = DllCall('kernel32.dll', 'bool', 'IsBadReadPtr', 'struct*', $4t, 'uint_ptr', $22)
If @error Then Return SetError(@error, @extended, False)
Return $4u[0]
EndFunc
Func _7q($4t, $22)
Local $4u = DllCall('kernel32.dll', 'bool', 'IsBadWritePtr', 'struct*', $4t, 'uint_ptr', $22)
If @error Then Return SetError(@error, @extended, False)
Return $4u[0]
EndFunc
Func _7s($4v, $4w, $22)
If _7p($4w, $22) Then Return SetError(10, @extended, 0)
If _7q($4v, $22) Then Return SetError(11, @extended, 0)
DllCall('ntdll.dll', 'none', 'RtlMoveMemory', 'struct*', $4v, 'struct*', $4w, 'ulong_ptr', $22)
If @error Then Return SetError(@error, @extended, 0)
Return 1
EndFunc
Func _8f()
Local $4x = DllStructCreate($4r)
DllStructSetData($4x, 1, DllStructGetSize($4x))
Local $4u = DllCall('kernel32.dll', 'bool', 'GetVersionExW', 'struct*', $4x)
If @error Or Not $4u[0] Then Return SetError(@error, @extended, 0)
Return BitOR(BitShift(DllStructGetData($4x, 2), -8), DllStructGetData($4x, 3))
EndFunc
Func _cw(ByRef $48, $4y = 1)
If DllStructGetSize($48) <> 8 Then Return SetError(@error + 10, @extended, 0)
Local $4u = DllCall('user32.dll', 'handle', 'MonitorFromPoint', 'struct', $48, 'dword', $4y)
If @error Then Return SetError(@error, @extended, 0)
Return $4u[0]
EndFunc
Global $4z = 0
Global $50 = 0
Global $51 = 0
Global $52 = True
Func _fp($53, $54, $55 = $2k, $56 = 0, $57 = 0)
Local $2y = DllCall($4z, "uint", "GdipCreateBitmapFromScan0", "int", $53, "int", $54, "int", $56, "int", $55, "struct*", $57, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $2y[0] Then Return SetError(10, $2y[0], 0)
Return $2y[6]
EndFunc
Func _fr($58, $59 = 0xFF000000)
Local $2y = DllCall($4z, "int", "GdipCreateHBITMAPFromBitmap", "handle", $58, "handle*", 0, "dword", $59)
If @error Then Return SetError(@error, @extended, 0)
If $2y[0] Then Return SetError(10, $2y[0], 0)
Return $2y[2]
EndFunc
Func _fs($58)
Local $2y = DllCall($4z, "int", "GdipDisposeImage", "handle", $58)
If @error Then Return SetError(@error, @extended, False)
If $2y[0] Then Return SetError(10, $2y[0], False)
Return True
EndFunc
Func _h6($3n)
Local $2y = DllCall($4z, "int", "GdipCreateFromHWND", "hwnd", $3n, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $2y[0] Then Return SetError(10, $2y[0], 0)
Return $2y[2]
EndFunc
Func _h7($5a)
Local $2y = DllCall($4z, "int", "GdipDeleteGraphics", "handle", $5a)
If @error Then Return SetError(@error, @extended, False)
If $2y[0] Then Return SetError(10, $2y[0], False)
Return True
EndFunc
Func _hh($5a, $5b, $5c, $5d, $5e, $5f)
Local $2y = DllCall($4z, "int", "GdipDrawImageRect", "handle", $5a, "handle", $5b, "float", $5c, "float", $5d, "float", $5e, "float", $5f)
If @error Then Return SetError(@error, @extended, False)
If $2y[0] Then Return SetError(10, $2y[0], False)
Return True
EndFunc
Func _iv($5b)
Local $2y = DllCall($4z, "int", "GdipDisposeImage", "handle", $5b)
If @error Then Return SetError(@error, @extended, False)
If $2y[0] Then Return SetError(10, $2y[0], False)
Return True
EndFunc
Func _iw($5b)
Local $2y = DllCall($4z, "int", "GdipGetImageDimension", "handle", $5b, "float*", 0, "float*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $2y[0] Then Return SetError(10, $2y[0], 0)
Local $5g[2] = [$2y[2], $2y[3]]
Return $5g
EndFunc
Func _iy($5b)
Local $2y = DllCall($4z, "int", "GdipGetImageGraphicsContext", "handle", $5b, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $2y[0] Then Return SetError(10, $2y[0], 0)
Return $2y[2]
EndFunc
Func _j7($4o)
Local $2y = DllCall($4z, "int", "GdipLoadImageFromFile", "wstr", $4o, "handle*", 0)
If @error Then Return SetError(@error, @extended, 0)
If $2y[0] Then Return SetError(10, $2y[0], 0)
Return $2y[2]
EndFunc
Func _n0()
If $4z = 0 Then Return SetError(-1, -1, False)
$50 -= 1
If $50 = 0 Then
DllCall($4z, "none", "GdiplusShutdown", "ulong_ptr", $51)
DllClose($4z)
$4z = 0
EndIf
Return True
EndFunc
Func _n1($5h = Default, $5i = False)
$50 += 1
If $50 > 1 Then Return True
If $5h = Default Then $5h = "gdiplus.dll"
$4z = DllOpen($5h)
If $4z = -1 Then
$50 = 0
Return SetError(1, 2, False)
EndIf
Local $5j = FileGetVersion($5h)
$5j = StringSplit($5j, ".")
If $5j[1] > 5 Then $52 = False
Local $5k = DllStructCreate($2o)
Local $5l = DllStructCreate("ulong_ptr Data")
DllStructSetData($5k, "Version", 1)
Local $2y = DllCall($4z, "int", "GdiplusStartup", "struct*", $5l, "struct*", $5k, "ptr", 0)
If @error Then Return SetError(@error, @extended, False)
If $2y[0] Then Return SetError(10, $2y[0], False)
$51 = DllStructGetData($5l, "Data")
If $5i Then Return $4z
Return SetExtended($5j[1], True)
EndFunc
Func _oe($5m, $5n, $22 = 32)
If($22 <= 0) Or($22 > 256) Then Return SetError(11, 0, 0)
Local $5o = DllStructCreate('byte[' & $22 & ']')
Local $4u = DllCall('shlwapi.dll', 'uint', 'HashData', 'struct*', $5m, 'dword', $5n, 'struct*', $5o, 'dword', $22)
If @error Then Return SetError(@error, @extended, 0)
If $4u[0] Then Return SetError(10, $4u[0], 0)
Return DllStructGetData($5o, 1)
EndFunc
Func _of($5p, $5q = True, $22 = 32)
Local $5r = StringLen($5p)
If Not $5r Or($22 > 256) Then Return SetError(12, 0, 0)
Local $5s = DllStructCreate('wchar[' &($5r + 1) & ']')
If Not $5q Then
$5p = StringLower($5p)
EndIf
DllStructSetData($5s, 1, $5p)
Local $5t = _oe($5s, 2 * $5r, $22)
If @error Then Return SetError(@error, @extended, 0)
Return $5t
EndFunc
Func _ql($5u)
Local $5v = DllStructCreate('dword;long[4];long[4];dword;wchar[32]')
DllStructSetData($5v, 1, DllStructGetSize($5v))
Local $4u = DllCall('user32.dll', 'bool', 'GetMonitorInfoW', 'handle', $5u, 'struct*', $5v)
If @error Or Not $4u[0] Then Return SetError(@error + 10, @extended, 0)
Local $2y[4]
For $s = 0 To 1
$2y[$s] = DllStructCreate($2m)
_7s($2y[$s], DllStructGetPtr($5v, $s + 2), 16)
Next
$2y[3] = DllStructGetData($5v, 5)
Switch DllStructGetData($5v, 4)
Case 1
$2y[2] = 1
Case Else
$2y[2] = 0
EndSwitch
Return $2y
EndFunc
Global Const $5w = "handle hProc;ulong_ptr Size;ptr Mem"
Func _t7(ByRef $5x)
Local $5m = DllStructGetData($5x, "Mem")
Local $5y = DllStructGetData($5x, "hProc")
Local $5z = _tk($5y, $5m, 0, 0x00008000)
DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $5y)
If @error Then Return SetError(@error, @extended, False)
Return $5z
EndFunc
Func _t8($60, $4p = 0)
Local $2y = DllCall("kernel32.dll", "handle", "GlobalAlloc", "uint", $4p, "ulong_ptr", $60)
If @error Then Return SetError(@error, @extended, 0)
Return $2y[0]
EndFunc
Func _t9($61)
Local $2y = DllCall("kernel32.dll", "ptr", "GlobalFree", "handle", $61)
If @error Then Return SetError(@error, @extended, False)
Return $2y[0]
EndFunc
Func _ta($61)
Local $2y = DllCall("kernel32.dll", "ptr", "GlobalLock", "handle", $61)
If @error Then Return SetError(@error, @extended, 0)
Return $2y[0]
EndFunc
Func _tc($61)
Local $2y = DllCall("kernel32.dll", "bool", "GlobalUnlock", "handle", $61)
If @error Then Return SetError(@error, @extended, 0)
Return $2y[0]
EndFunc
Func _td($3n, $5n, ByRef $5x)
Local $2y = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $3n, "dword*", 0)
If @error Then Return SetError(@error + 10, @extended, 0)
Local $62 = $2y[2]
If $62 = 0 Then Return SetError(1, 0, 0)
Local $3a = BitOR(0x00000008, 0x00000010, 0x00000020)
Local $5y = _tl($3a, False, $62, True)
Local $63 = BitOR(0x00002000, 0x00001000)
Local $5m = _ti($5y, 0, $5n, $63, 0x00000004)
If $5m = 0 Then Return SetError(2, 0, 0)
$5x = DllStructCreate($5w)
DllStructSetData($5x, "hProc", $5y)
DllStructSetData($5x, "Size", $5n)
DllStructSetData($5x, "Mem", $5m)
Return $5m
EndFunc
Func _te($4w, $64, $22)
DllCall("kernel32.dll", "none", "RtlMoveMemory", "struct*", $64, "struct*", $4w, "ulong_ptr", $22)
If @error Then Return SetError(@error, @extended)
EndFunc
Func _tf(ByRef $5x, $65, $64, $5n)
Local $2y = DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", DllStructGetData($5x, "hProc"), "ptr", $65, "struct*", $64, "ulong_ptr", $5n, "ulong_ptr*", 0)
If @error Then Return SetError(@error, @extended, False)
Return $2y[0]
EndFunc
Func _tg(ByRef $5x, $65, $64 = 0, $5n = 0, $66 = "struct*")
If $64 = 0 Then $64 = DllStructGetData($5x, "Mem")
If $5n = 0 Then $5n = DllStructGetData($5x, "Size")
Local $2y = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", DllStructGetData($5x, "hProc"), "ptr", $64, $66, $65, "ulong_ptr", $5n, "ulong_ptr*", 0)
If @error Then Return SetError(@error, @extended, False)
Return $2y[0]
EndFunc
Func _ti($5y, $4t, $5n, $67, $68)
Local $2y = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "handle", $5y, "ptr", $4t, "ulong_ptr", $5n, "dword", $67, "dword", $68)
If @error Then Return SetError(@error, @extended, 0)
Return $2y[0]
EndFunc
Func _tk($5y, $4t, $5n, $69)
Local $2y = DllCall("kernel32.dll", "bool", "VirtualFreeEx", "handle", $5y, "ptr", $4t, "ulong_ptr", $5n, "dword", $69)
If @error Then Return SetError(@error, @extended, False)
Return $2y[0]
EndFunc
Func _tl($3a, $6a, $62, $6b = False)
Local $2y = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $3a, "bool", $6a, "dword", $62)
If @error Then Return SetError(@error + 10, @extended, 0)
If $2y[0] Then Return $2y[0]
If Not $6b Then Return 0
Local $30 = _1k(BitOR(0x00000020, 0x00000008))
If @error Then Return SetError(@error + 20, @extended, 0)
_1l($30, "SeDebugPrivilege", True)
Local $6c = @error
Local $6d = @extended
Local $6e = 0
If Not @error Then
$2y = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $3a, "bool", $6a, "dword", $62)
$6c = @error
$6d = @extended
If $2y[0] Then $6e = $2y[0]
_1l($30, "SeDebugPrivilege", False)
If @error Then
$6c = @error + 30
$6d = @extended
EndIf
Else
$6c = @error + 40
EndIf
DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $30)
Return SetError($6c, $6d, $6e)
EndFunc
Global Const $6f =(0x1000 + 9)
Global Const $6g =(0x1000 + 8)
Global Const $6h =(0x1000 + 31)
Global Const $6i =(0x1000 + 5)
Global Const $6j =(0x1000 + 75)
Global Const $6k =(0x1000 + 4)
Global Const $6l = 0x2000 + 6
Global Const $6m =(0x1000 + 27)
Global Const $6n =(0x1000 + 97)
Global Const $6o =(0x1000 + 7)
Global Const $6p =(0x1000 + 77)
Global Const $6q =(0x1000 + 26)
Global Const $6r =(0x1000 + 96)
Global Const $6s =(0x1000 + 30)
Global Const $6t =(0x1000 + 6)
Global Const $6u =(0x1000 + 76)
Global Const $6v =(0x1000 + 43)
Global Const $6w =(-100 - 1)
Global Const $6x =(-100 - 55)
Global $6y
Global Const $6z = "uint Mask;int Fmt;int CX;ptr Text;int TextMax;int SubItem;int Image;int Order;int cxMin;int cxDefault;int cxIdeal"
Func _v0($3n, $70, $53 = 50, $71 = -1, $72 = -1, $73 = False)
Return _y7($3n, _vz($3n), $70, $53, $71, $72, $73)
EndFunc
Func _v1($3n, $70, $72 = -1, $74 = 0)
Return _y9($3n, $70, -1, $72, $74)
EndFunc
Func _vf($3n)
If _wq($3n) = 0 Then Return True
Local $75 = 0
If IsHWnd($3n) Then
$75 = _3u($3n)
Else
$75 = $3n
$3n = GUICtrlGetHandle($3n)
EndIf
If $75 < 10000 Then
Local $74 = 0
For $49 = _wq($3n) - 1 To 0 Step -1
$74 = _wz($3n, $49)
If GUICtrlGetState($74) > 0 And GUICtrlGetHandle($74) = 0 Then
GUICtrlDelete($74)
EndIf
Next
If _wq($3n) = 0 Then Return True
EndIf
Return _1q($3n, $6f) <> 0
EndFunc
Func _vh($3n, $49)
Local $75 = 0
If IsHWnd($3n) Then
$75 = _3u($3n)
Else
$75 = $3n
$3n = GUICtrlGetHandle($3n)
EndIf
If $75 < 10000 Then
Local $74 = _wz($3n, $49)
If GUICtrlGetState($74) > 0 And GUICtrlGetHandle($74) = 0 Then
If GUICtrlDelete($74) Then
Return True
EndIf
EndIf
EndIf
Return _1q($3n, $6g, $49) <> 0
EndFunc
Func _vz($3n)
Return _1q(_wf($3n), 0x1200)
EndFunc
Func _wf($3n)
If IsHWnd($3n) Then
Return HWnd(_1q($3n, $6h))
Else
Return HWnd(GUICtrlSendMsg($3n, $6h, 0, 0))
EndIf
EndFunc
Func _wq($3n)
If IsHWnd($3n) Then
Return _1q($3n, $6k)
Else
Return GUICtrlSendMsg($3n, $6k, 0, 0)
EndIf
EndFunc
Func _wt($3n, ByRef $76)
Local $77 = _xv($3n)
Local $6e
If IsHWnd($3n) Then
If _50($3n, $6y) Then
$6e = _1q($3n, $6j, 0, $76, 0, "wparam", "struct*")
Else
Local $78 = DllStructGetSize($76)
Local $5x
Local $5m = _td($3n, $78, $5x)
_tg($5x, $76)
If $77 Then
_1q($3n, $6j, 0, $5m, 0, "wparam", "ptr")
Else
_1q($3n, $6i, 0, $5m, 0, "wparam", "ptr")
EndIf
_tf($5x, $5m, $76, $78)
_t7($5x)
EndIf
Else
Local $79 = DllStructGetPtr($76)
If $77 Then
$6e = GUICtrlSendMsg($3n, $6j, 0, $79)
Else
$6e = GUICtrlSendMsg($3n, $6i, 0, $79)
EndIf
EndIf
Return $6e <> 0
EndFunc
Func _wz($3n, $49)
Local $76 = DllStructCreate($2p)
DllStructSetData($76, "Mask", 0x00000004)
DllStructSetData($76, "Item", $49)
_wt($3n, $76)
Return DllStructGetData($76, "Param")
EndFunc
Func _xv($3n)
If IsHWnd($3n) Then
Return _1q($3n, $6l) <> 0
Else
Return GUICtrlSendMsg($3n, $6l, 0, 0) <> 0
EndIf
EndFunc
Func _y7($3n, $49, $70, $53 = 50, $71 = -1, $72 = -1, $73 = False)
Local $7a[3] = [0x0000, 0x0001, 0x0002]
Local $77 = _xv($3n)
Local $7b = StringLen($70) + 1
Local $7c
If $77 Then
$7c = DllStructCreate("wchar Text[" & $7b & "]")
$7b *= 2
Else
$7c = DllStructCreate("char Text[" & $7b & "]")
EndIf
Local $7d = DllStructGetPtr($7c)
Local $7e = DllStructCreate($6z)
Local $7f = BitOR(0x0001, 0x0002, 0x0004)
If $71 < 0 Or $71 > 2 Then $71 = 0
Local $7g = $7a[$71]
If $72 <> -1 Then
$7f = BitOR($7f, 0x0010)
$7g = BitOR($7g, 0x8000, 0x0800)
EndIf
If $73 Then $7g = BitOR($7g, 0x1000)
DllStructSetData($7c, "Text", $70)
DllStructSetData($7e, "Mask", $7f)
DllStructSetData($7e, "Fmt", $7g)
DllStructSetData($7e, "CX", $53)
DllStructSetData($7e, "TextMax", $7b)
DllStructSetData($7e, "Image", $72)
Local $6e
If IsHWnd($3n) Then
If _50($3n, $6y) Then
DllStructSetData($7e, "Text", $7d)
$6e = _1q($3n, $6n, $49, $7e, 0, "wparam", "struct*")
Else
Local $7h = DllStructGetSize($7e)
Local $5x
Local $5m = _td($3n, $7h + $7b, $5x)
Local $7i = $5m + $7h
DllStructSetData($7e, "Text", $7i)
_tg($5x, $7e, $5m, $7h)
_tg($5x, $7c, $7i, $7b)
If $77 Then
$6e = _1q($3n, $6n, $49, $5m, 0, "wparam", "ptr")
Else
$6e = _1q($3n, $6m, $49, $5m, 0, "wparam", "ptr")
EndIf
_t7($5x)
EndIf
Else
Local $7j = DllStructGetPtr($7e)
DllStructSetData($7e, "Text", $7d)
If $77 Then
$6e = GUICtrlSendMsg($3n, $6n, $49, $7j)
Else
$6e = GUICtrlSendMsg($3n, $6m, $49, $7j)
EndIf
EndIf
If $71 > 0 Then _yq($3n, $6e, $70, $53, $71, $72, $73)
Return $6e
EndFunc
Func _y9($3n, $70, $49 = -1, $72 = -1, $74 = 0)
Local $77 = _xv($3n)
Local $7b, $7c, $6e
If $49 = -1 Then $49 = 999999999
Local $76 = DllStructCreate($2p)
DllStructSetData($76, "Param", $74)
$7b = StringLen($70) + 1
If $77 Then
$7c = DllStructCreate("wchar Text[" & $7b & "]")
$7b *= 2
Else
$7c = DllStructCreate("char Text[" & $7b & "]")
EndIf
DllStructSetData($7c, "Text", $70)
DllStructSetData($76, "Text", DllStructGetPtr($7c))
DllStructSetData($76, "TextMax", $7b)
Local $7f = BitOR(0x00000001, 0x00000004)
If $72 >= 0 Then $7f = BitOR($7f, 0x00000002)
DllStructSetData($76, "Mask", $7f)
DllStructSetData($76, "Item", $49)
DllStructSetData($76, "Image", $72)
If IsHWnd($3n) Then
If _50($3n, $6y) Or($70 = -1) Then
$6e = _1q($3n, $6p, 0, $76, 0, "wparam", "struct*")
Else
Local $78 = DllStructGetSize($76)
Local $5x
Local $5m = _td($3n, $78 + $7b, $5x)
Local $7i = $5m + $78
DllStructSetData($76, "Text", $7i)
_tg($5x, $76, $5m, $78)
_tg($5x, $7c, $7i, $7b)
If $77 Then
$6e = _1q($3n, $6p, 0, $5m, 0, "wparam", "ptr")
Else
$6e = _1q($3n, $6o, 0, $5m, 0, "wparam", "ptr")
EndIf
_t7($5x)
EndIf
Else
Local $79 = DllStructGetPtr($76)
If $77 Then
$6e = GUICtrlSendMsg($3n, $6p, 0, $79)
Else
$6e = GUICtrlSendMsg($3n, $6o, 0, $79)
EndIf
EndIf
Return $6e
EndFunc
Func _yq($3n, $49, $70, $53 = -1, $71 = -1, $72 = -1, $73 = False)
Local $77 = _xv($3n)
Local $7a[3] = [0x0000, 0x0001, 0x0002]
Local $7b = StringLen($70) + 1
Local $7c
If $77 Then
$7c = DllStructCreate("wchar Text[" & $7b & "]")
$7b *= 2
Else
$7c = DllStructCreate("char Text[" & $7b & "]")
EndIf
Local $7d = DllStructGetPtr($7c)
Local $7e = DllStructCreate($6z)
Local $7f = 0x0004
If $71 < 0 Or $71 > 2 Then $71 = 0
$7f = BitOR($7f, 0x0001)
Local $7g = $7a[$71]
If $53 <> -1 Then $7f = BitOR($7f, 0x0002)
If $72 <> -1 Then
$7f = BitOR($7f, 0x0010)
$7g = BitOR($7g, 0x8000, 0x0800)
Else
$72 = 0
EndIf
If $73 Then $7g = BitOR($7g, 0x1000)
DllStructSetData($7c, "Text", $70)
DllStructSetData($7e, "Mask", $7f)
DllStructSetData($7e, "Fmt", $7g)
DllStructSetData($7e, "CX", $53)
DllStructSetData($7e, "TextMax", $7b)
DllStructSetData($7e, "Image", $72)
Local $6e
If IsHWnd($3n) Then
If _50($3n, $6y) Then
DllStructSetData($7e, "Text", $7d)
$6e = _1q($3n, $6r, $49, $7e, 0, "wparam", "struct*")
Else
Local $7h = DllStructGetSize($7e)
Local $5x
Local $5m = _td($3n, $7h + $7b, $5x)
Local $7i = $5m + $7h
DllStructSetData($7e, "Text", $7i)
_tg($5x, $7e, $5m, $7h)
_tg($5x, $7c, $7i, $7b)
If $77 Then
$6e = _1q($3n, $6r, $49, $5m, 0, "wparam", "ptr")
Else
$6e = _1q($3n, $6q, $49, $5m, 0, "wparam", "ptr")
EndIf
_t7($5x)
EndIf
Else
Local $7j = DllStructGetPtr($7e)
DllStructSetData($7e, "Text", $7d)
If $77 Then
$6e = GUICtrlSendMsg($3n, $6r, $49, $7j)
Else
$6e = GUICtrlSendMsg($3n, $6q, $49, $7j)
EndIf
EndIf
Return $6e <> 0
EndFunc
Func _yt($3n, $7k, $53)
If IsHWnd($3n) Then
Return _1q($3n, $6s, $7k, $53)
Else
Return GUICtrlSendMsg($3n, $6s, $7k, $53)
EndIf
EndFunc
Func _zi($3n, $49, $7l = True, $7m = False)
Local $7n = DllStructCreate($2p)
Local $6e, $7o = 0, $7p = 0, $5n, $5x, $5m
If($7l = True) Then $7o = 0x0002
If($7m = True And $49 <> -1) Then $7p = 0x0001
DllStructSetData($7n, "Mask", 0x00000008)
DllStructSetData($7n, "Item", $49)
DllStructSetData($7n, "State", BitOR($7o, $7p))
DllStructSetData($7n, "StateMask", BitOR(0x0002, $7p))
$5n = DllStructGetSize($7n)
If IsHWnd($3n) Then
$5m = _td($3n, $5n, $5x)
_tg($5x, $7n, $5m, $5n)
$6e = _1q($3n, $6v, $49, $5m)
_t7($5x)
Else
$6e = GUICtrlSendMsg($3n, $6v, $49, DllStructGetPtr($7n))
EndIf
Return $6e <> 0
EndFunc
Func _zl($3n, $49, $70, $1l = 0)
Local $77 = _xv($3n)
Local $6e
If $1l = -1 Then
Local $7q = Opt('GUIDataSeparatorChar')
Local $7r = _vz($3n)
Local $7s = StringSplit($70, $7q)
If $7r > $7s[0] Then $7r = $7s[0]
For $s = 1 To $7r
$6e = _zl($3n, $49, $7s[$s], $s - 1)
If Not $6e Then ExitLoop
Next
Return $6e
EndIf
Local $7b = StringLen($70) + 1
Local $7c
If $77 Then
$7c = DllStructCreate("wchar Text[" & $7b & "]")
$7b *= 2
Else
$7c = DllStructCreate("char Text[" & $7b & "]")
EndIf
Local $7d = DllStructGetPtr($7c)
Local $76 = DllStructCreate($2p)
DllStructSetData($7c, "Text", $70)
DllStructSetData($76, "Mask", 0x00000001)
DllStructSetData($76, "item", $49)
DllStructSetData($76, "SubItem", $1l)
If IsHWnd($3n) Then
If _50($3n, $6y) Then
DllStructSetData($76, "Text", $7d)
$6e = _1q($3n, $6u, 0, $76, 0, "wparam", "struct*")
Else
Local $78 = DllStructGetSize($76)
Local $5x
Local $5m = _td($3n, $78 + $7b, $5x)
Local $7i = $5m + $78
DllStructSetData($76, "Text", $7i)
_tg($5x, $76, $5m, $78)
_tg($5x, $7c, $7i, $7b)
If $77 Then
$6e = _1q($3n, $6u, 0, $5m, 0, "wparam", "ptr")
Else
$6e = _1q($3n, $6t, 0, $5m, 0, "wparam", "ptr")
EndIf
_t7($5x)
EndIf
Else
Local $79 = DllStructGetPtr($76)
DllStructSetData($76, "Text", $7d)
If $77 Then
$6e = GUICtrlSendMsg($3n, $6u, 0, $79)
Else
$6e = GUICtrlSendMsg($3n, $6t, 0, $79)
EndIf
EndIf
Return $6e <> 0
EndFunc
Func _102($5p, $7t, $7u, $46 = 0, $7v = False)
$7t = $7t ? "\Q" & $7t & "\E" : "\A"
If $46 <> 1 Then $46 = 0
If $46 = 0 Then
$7u = $7u ? "(?=\Q" & $7u & "\E)" : "\z"
Else
$7u = $7u ? "\Q" & $7u & "\E" : "\z"
EndIf
If $7v = Default Then
$7v = False
EndIf
Local $7w = StringRegExp($5p, "(?s" &(Not $7v ? "i" : "") & ")" & $7t & "(.*?)" & $7u, 3)
If @error Then Return SetError(1, 0, 0)
Return $7w
EndFunc
Global Const $7x = 0x2E
Func _124($3n, $7y)
If Not IsHWnd($3n) Then $3n = GUICtrlGetHandle($3n)
If BitAND($7y, 1) <> 1 And BitAND($7y, 0) <> 0 And BitAND($7y, 3) <> 3 And BitAND($7y, 2) <> 2 And BitAND($7y, 4) <> 4 Then Return 0
If $7y == 4 Then
Return _1q($3n, $8)
Else
Return _1q($3n, $7, $7y)
EndIf
EndFunc
Func _12h($3n, $k, $1f)
If Not IsHWnd($3n) Then $3n = GUICtrlGetHandle($3n)
_1q($3n, $9, $k, $1f)
EndFunc
Func _12q($7z, $80 = "*", $3r = 0, $81 = 0, $82 = 0, $83 = 1)
If Not FileExists($7z) Then Return SetError(1, 1, "")
If $80 = Default Then $80 = "*"
If $3r = Default Then $3r = 0
If $81 = Default Then $81 = 0
If $82 = Default Then $82 = 0
If $83 = Default Then $83 = 1
If $81 > 1 Or Not IsInt($81) Then Return SetError(1, 6, "")
Local $84 = False
If StringLeft($7z, 4) == "\\?\" Then
$84 = True
EndIf
Local $85 = ""
If StringRight($7z, 1) = "\" Then
$85 = "\"
Else
$7z = $7z & "\"
EndIf
Local $86[100] = [1]
$86[1] = $7z
Local $87 = 0, $88 = ""
If BitAND($3r, 4) Then
$87 += 2
$88 &= "H"
$3r -= 4
EndIf
If BitAND($3r, 8) Then
$87 += 4
$88 &= "S"
$3r -= 8
EndIf
Local $89 = 0
If BitAND($3r, 16) Then
$89 = 0x400
$3r -= 16
EndIf
Local $8a = 0
If $81 < 0 Then
StringReplace($7z, "\", "", 0, 2)
$8a = @extended - $81
EndIf
Local $8b = "", $8c = "", $8d = "*"
Local $8e = StringSplit($80, "|")
Switch $8e[0]
Case 3
$8c = $8e[3]
ContinueCase
Case 2
$8b = $8e[2]
ContinueCase
Case 1
$8d = $8e[1]
EndSwitch
Local $8f = ".+"
If $8d <> "*" Then
If Not _12t($8f, $8d) Then Return SetError(1, 2, "")
EndIf
Local $8g = ".+"
Switch $3r
Case 0
Switch $81
Case 0
$8g = $8f
EndSwitch
Case 2
$8g = $8f
EndSwitch
Local $8h = ":"
If $8b <> "" Then
If Not _12t($8h, $8b) Then Return SetError(1, 3, "")
EndIf
Local $8i = ":"
If $81 Then
If $8c Then
If Not _12t($8i, $8c) Then Return SetError(1, 4, "")
EndIf
If $3r = 2 Then
$8i = $8h
EndIf
Else
$8i = $8h
EndIf
If Not($3r = 0 Or $3r = 1 Or $3r = 2) Then Return SetError(1, 5, "")
If Not($82 = 0 Or $82 = 1 Or $82 = 2) Then Return SetError(1, 7, "")
If Not($83 = 0 Or $83 = 1 Or $83 = 2) Then Return SetError(1, 8, "")
If $89 Then
Local $8j = DllStructCreate("struct;align 4;dword FileAttributes;uint64 CreationTime;uint64 LastAccessTime;uint64 LastWriteTime;" & "dword FileSizeHigh;dword FileSizeLow;dword Reserved0;dword Reserved1;wchar FileName[260];wchar AlternateFileName[14];endstruct")
Local $8k = DllOpen('kernel32.dll'), $8l
EndIf
Local $8m[100] = [0]
Local $8n = $8m, $8o = $8m, $8p = $8m
Local $8q = False, $8r = 0, $8s = "", $39 = "", $8t = ""
Local $8u = 0, $8v = ''
Local $8w[100][2] = [[0, 0]]
While $86[0] > 0
$8s = $86[$86[0]]
$86[0] -= 1
Switch $83
Case 1
$8t = StringReplace($8s, $7z, "")
Case 2
If $84 Then
$8t = StringTrimLeft($8s, 4)
Else
$8t = $8s
EndIf
EndSwitch
If $89 Then
$8l = DllCall($8k, 'handle', 'FindFirstFileW', 'wstr', $8s & "*", 'struct*', $8j)
If @error Or Not $8l[0] Then
ContinueLoop
EndIf
$8r = $8l[0]
Else
$8r = FileFindFirstFile($8s & "*")
If $8r = -1 Then
ContinueLoop
EndIf
EndIf
If $3r = 0 And $82 And $83 Then
_12s($8w, $8t, $8n[0] + 1)
EndIf
$8v = ''
While 1
If $89 Then
$8l = DllCall($8k, 'int', 'FindNextFileW', 'handle', $8r, 'struct*', $8j)
If @error Or Not $8l[0] Then
ExitLoop
EndIf
$39 = DllStructGetData($8j, "FileName")
If $39 = ".." Then
ContinueLoop
EndIf
$8u = DllStructGetData($8j, "FileAttributes")
If $87 And BitAND($8u, $87) Then
ContinueLoop
EndIf
If BitAND($8u, $89) Then
ContinueLoop
EndIf
$8q = False
If BitAND($8u, 16) Then
$8q = True
EndIf
Else
$8q = False
$39 = FileFindNextFile($8r, 1)
If @error Then
ExitLoop
EndIf
$8v = @extended
If StringInStr($8v, "D") Then
$8q = True
EndIf
If StringRegExp($8v, "[" & $88 & "]") Then
ContinueLoop
EndIf
EndIf
If $8q Then
Select
Case $81 < 0
StringReplace($8s, "\", "", 0, 2)
If @extended < $8a Then
ContinueCase
EndIf
Case $81 = 1
If Not StringRegExp($39, $8i) Then
_12s($86, $8s & $39 & "\")
EndIf
EndSelect
EndIf
If $82 Then
If $8q Then
If StringRegExp($39, $8g) And Not StringRegExp($39, $8i) Then
_12s($8p, $8t & $39 & $85)
EndIf
Else
If StringRegExp($39, $8f) And Not StringRegExp($39, $8h) Then
If $8s = $7z Then
_12s($8o, $8t & $39)
Else
_12s($8n, $8t & $39)
EndIf
EndIf
EndIf
Else
If $8q Then
If $3r <> 1 And StringRegExp($39, $8g) And Not StringRegExp($39, $8i) Then
_12s($8m, $8t & $39 & $85)
EndIf
Else
If $3r <> 2 And StringRegExp($39, $8f) And Not StringRegExp($39, $8h) Then
_12s($8m, $8t & $39)
EndIf
EndIf
EndIf
WEnd
If $89 Then
DllCall($8k, 'int', 'FindClose', 'ptr', $8r)
Else
FileClose($8r)
EndIf
WEnd
If $89 Then
DllClose($8k)
EndIf
If $82 Then
Switch $3r
Case 2
If $8p[0] = 0 Then Return SetError(1, 9, "")
ReDim $8p[$8p[0] + 1]
$8m = $8p
_o($8m, 1, $8m[0])
Case 1
If $8o[0] = 0 And $8n[0] = 0 Then Return SetError(1, 9, "")
If $83 = 0 Then
_12r($8m, $8o, $8n)
_o($8m, 1, $8m[0])
Else
_12r($8m, $8o, $8n, 1)
EndIf
Case 0
If $8o[0] = 0 And $8p[0] = 0 Then Return SetError(1, 9, "")
If $83 = 0 Then
_12r($8m, $8o, $8n)
$8m[0] += $8p[0]
ReDim $8p[$8p[0] + 1]
_5($8m, $8p, 1)
_o($8m, 1, $8m[0])
Else
Local $8m[$8n[0] + $8o[0] + $8p[0] + 1]
$8m[0] = $8n[0] + $8o[0] + $8p[0]
_o($8o, 1, $8o[0])
For $s = 1 To $8o[0]
$8m[$s] = $8o[$s]
Next
Local $8x = $8o[0] + 1
_o($8p, 1, $8p[0])
Local $8y = ""
For $s = 1 To $8p[0]
$8m[$8x] = $8p[$s]
$8x += 1
If $85 Then
$8y = $8p[$s]
Else
$8y = $8p[$s] & "\"
EndIf
Local $8z = 0, $90 = 0
For $0z = 1 To $8w[0][0]
If $8y = $8w[$0z][0] Then
$90 = $8w[$0z][1]
If $0z = $8w[0][0] Then
$8z = $8n[0]
Else
$8z = $8w[$0z + 1][1] - 1
EndIf
If $82 = 1 Then
_o($8n, $90, $8z)
EndIf
For $23 = $90 To $8z
$8m[$8x] = $8n[$23]
$8x += 1
Next
ExitLoop
EndIf
Next
Next
EndIf
EndSwitch
Else
If $8m[0] = 0 Then Return SetError(1, 9, "")
ReDim $8m[$8m[0] + 1]
EndIf
Return $8m
EndFunc
Func _12r(ByRef $91, $92, $93, $82 = 0)
ReDim $92[$92[0] + 1]
If $82 = 1 Then _o($92, 1, $92[0])
$91 = $92
$91[0] += $93[0]
ReDim $93[$93[0] + 1]
If $82 = 1 Then _o($93, 1, $93[0])
_5($91, $93, 1)
EndFunc
Func _12s(ByRef $94, $95, $96 = -1)
If $96 = -1 Then
$94[0] += 1
If UBound($94) <= $94[0] Then ReDim $94[UBound($94) * 2]
$94[$94[0]] = $95
Else
$94[0][0] += 1
If UBound($94) <= $94[0][0] Then ReDim $94[UBound($94) * 2][2]
$94[$94[0][0]][0] = $95
$94[$94[0][0]][1] = $96
EndIf
EndFunc
Func _12t(ByRef $80, $97)
If StringRegExp($97, "\\|/|:|\<|\>|\|") Then Return 0
$97 = StringReplace(StringStripWS(StringRegExpReplace($97, "\s*;\s*", ";"), 1 + 2), ";", "|")
$97 = StringReplace(StringReplace(StringRegExpReplace($97, "[][$^.{}()+\-]", "\\$0"), "?", "."), "*", ".*?")
$80 = "(?i)^(" & $97 & ")\z"
Return 1
EndFunc
Func _135(ByRef $98,$99,$9a,$9b,$9c)
Local $9d
For $9e = $9b To $9c
$9d = $98[$9a][$9e]
$98[$9a][$9e] = $98[$99][$9e]
$98[$99][$9e] = $9d
Next
EndFunc
Global $9f=DllOpen("kernel32.dll")
Global $9g=DllOpen("user32.dll")
Global $9h=Ptr(-1)
If StringRegExp(@OSVersion,"_(XP|200(0|3))") Then
Dim $9i=0x0400
Else
Dim $9i=0x1000
EndIf
Func _136(ByRef $9j)
If Not IsPtr($9j) Or $9j=0 Then Return SetError(1,0,False)
Local $4u=DllCall($9f,"bool","CloseHandle","handle",$9j)
If @error Then Return SetError(2,@error,False)
If Not $4u[0] Then Return SetError(3,@error,False)
$9j=0
Return True
EndFunc
Func _137(ByRef $9k)
If IsInt($9k) Then Return True
$9k=ProcessExists($9k)
If $9k Then Return True
Return SetError(1,0,False)
EndFunc
Func _146($62,$4p)
Local $4u
For $s=1 To 10
$4u=DllCall($9f,"handle","CreateToolhelp32Snapshot","dword",$4p,"dword",$62)
If @error Then Return SetError(2,@error,-1)
If $4u[0]=-1 Then
If BitAND($4p,0x19) And _14()=24 Then ContinueLoop
Return SetError(3,0,-1)
EndIf
Sleep(0)
Next
If $4u[0]=-1 Then Return SetError(4,0,-1)
Return $4u[0]
EndFunc
Func _147($9l=0,$9m=0)
Local $9n,$4u,$4b,$9o,$9p
Local $9q=1,$9r=0,$9s=100,$9t[$9s+1][5],$9u=0,$9v=0
Local $9w=DllStructCreate("dword;dword;dword;ulong_ptr;dword;dword;dword;long;dword;wchar[260]"),$9x=DllStructGetPtr($9w)
DllStructSetData($9w,1,DllStructGetSize($9w))
If(IsString($9l) And $9l<>"") Or(IsNumber($9l) And $9m>2) Then $9u=1
If BitAND($9m,8) Then
$9v=-1
$9m=BitAND($9m,7)
EndIf
$9n=_146(0,0x40000002)
If @error Then Return SetError(@error,@extended,"")
$4u=DllCall($9f,"bool","Process32FirstW","handle",$9n,"ptr",$9x)
While 1
If @error Then
Local $9y=@error
_136($9n)
Return SetError(2,$9y,"")
EndIf
If Not $4u[0] Then ExitLoop
$9p=DllStructGetData($9w,10)
$4b=DllStructGetData($9w,3)
$9o=DllStructGetData($9w,7)
If $9u Then
Switch $9m
Case 0
If $9l<>$9p Then $9q=0
Case 1
If StringInStr($9p,$9l)=0 Then $9q=0
Case 2
If Not StringRegExp($9p,$9l) Then $9q=0
Case 3
If $9l<>$4b Then $9q=0
Case Else
If $9l<>$9o Then $9q=0
EndSwitch
$9q+=$9v
EndIf
If $9q Then
$9r+=1
If $9r>$9s Then
$9s+=10
ReDim $9t[$9s+1][5]
EndIf
$9t[$9r][0]=$9p
$9t[$9r][1]=$4b
$9t[$9r][2]=$9o
$9t[$9r][3]=DllStructGetData($9w,6)
$9t[$9r][4]=DllStructGetData($9w,8)
If $9u And $9m=3 Then ExitLoop
EndIf
$9q=1
$4u=DllCall($9f,"bool","Process32NextW","handle",$9n,"ptr",$9x)
WEnd
_136($9n)
ReDim $9t[$9r+1][5]
$9t[0][0]=$9r
Return $9t
EndFunc
Func _148($9z)
If Not _137($9z) Then Return SetError(1,0,"")
Local $a0=_147($9z,4)
Return SetError(@error,@extended,$a0)
EndFunc
Global Enum $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $aa, $ab, $ac, $ad, $ae, $af
Global Enum $ag , $ah , $ai
Global Enum $aj , $ak
Global $al[0][$af]
Global $am
Global $an = 1, $ao = -1
OnAutoItExitRegister(_14p)
Func _14i($ap, $aq, $ar = Null, $as = 0, $at = Default, $au = Default, $av = Null, $aw = Default, $ax = Null, $ay = Default, $az = Null, $b0 = Default, $b1 = Null, $b2 = Default)
If $at = Default Then $at = -2
If $au = Default Then $au = True
Local $b3, $b4
$b4 = UBound($al)
If Not $b4 Then
ReDim $al[1][$af]
$b3 = 0
Else
$b4 -= 1
Switch $as
Case 0
$b3 = $b4+1
Case 1
If $b4 >= 1 Then
$b3 = 1
Else
$b3 = 0
EndIf
Case Else
$b3 = 0
EndSwitch
Local $b5 = -1
If $ar Then
$b5 = _j($al,$ar,0,$b4,0,0,0,$a1)
If $b5 >= 0 And $as < $al[$b5][$a6] Then Return
EndIf
If Not $b3 Then
If $as >= $al[$b3][$a6] Then
If $ao >= 0 Then
_14p()
$ao = -1
EndIf
$an = 1
Else
Local $b6 = -1
For $9e = 1 To UBound($al)-1
If $as >= $al[$9e][$a6] Then
$b6 = $9e
ExitLoop
EndIf
Next
If $b6 > 0 Then
$b3 = $b6
Else
If $b5 >= 0 Then Return
$b3 = $b4+1
EndIf
EndIf
EndIf
If $b5 >= 0 Then
If $b3 <= $b4 Then
If $b3 <> $b5 Then
_135( $al, $b5, $b3, 0, $af-1)
EndIf
Else
$b3 = $b5
EndIf
Else
If $b3 <= $b4 Then
_a($al,$b3)
Else
$b4 = $b3
ReDim $al[$b4+1][$af]
EndIf
EndIf
EndIf
$al[$b3][$a1] = $ar
$al[$b3][$a2] = $ap
$al[$b3][$a3] = $aq
$al[$b3][$a4] = $at
$al[$b3][$a5] = $au
$al[$b3][$a6] = $as
$al[$b3][$a7] = $av
$al[$b3][$a8] = $aw
$al[$b3][$a9] = $ax
$al[$b3][$aa] = $ay
$al[$b3][$ab] = $az
$al[$b3][$ac] = $b0
$al[$b3][$ad] = $b1
$al[$b3][$ae] = $b2
EndFunc
Func _14j()
Local Static $at = 0, $b7, $b8, $b9, $9d, $ba, $bb, $bc, $bd
Local Const $be = 100
If Not UBound($al) Then Return
Switch $an
Case 1
If IsFunc($al[0][$a7]) Then
If $al[0][$a8] = Default Then
$9d = $al[0][$a7]()
Else
$9d = $al[0][$a7]($al[0][$a8])
EndIf
If $9d Then
If $9d = 2 Then Return
_14l($9d)
Return _14j()
EndIf
EndIf
Local $q[$ai]
$bc = $q
$ao = -1
$ao = Run( @ComSpec&' /c ""'&$al[0][$a2]&'" '&$al[0][$a3]&'', @ScriptDir, @SW_HIDE, 8 )
$bc[$ag] = @error
If IsFunc($al[0][$a9]) Then
$9d = _14k( $bc, $al[0][$a9], $al[0][$aa] )
If $9d Then
If $9d = 2 Then Return
Return _14j()
EndIf
EndIf
If $bc[$ag] Or $al[0][$a4] = -1 Then Return _6($al,0)
If $al[0][$a4] <> -2 Then
If $al[0][$a4] Then
$at = $al[0][$a4]
Else
$at = 5000
EndIf
EndIf
$b8 = ''
If IsFunc($al[0][$a9]) Or IsFunc($al[0][$ab]) Or IsFunc($al[0][$ad]) Then
$b9 = True
$bd = $q
Else
$b9 = False
EndIf
$bb = $aj
$b7 = TimerInit()
$ba = $b7
$an = 2
Return
Case 2
If $am Then
$am = False
_14p()
_6($al,0)
$an = 1
Return
EndIf
If $b9 Then
$b8 = StdoutRead($ao)
If Not @error Then
If IsFunc($al[0][$ad]) And $b8 Then $bc[$ah] &= $b8
If IsFunc($al[0][$ab]) Then
$9d = _14k( $b8, $al[0][$ab], $al[0][$ac] )
If $9d Then
If $9d = 2 Then Return
Return _14j()
EndIf
EndIf
EndIf
EndIf
If TimerDiff($ba) > $be Then
If Not ProcessExists($ao) Then
$an = 3
Return
EndIf
$ba = TimerInit()
EndIf
If $al[0][$a4] <> -2 And TimerDiff($b7) > $at Then
If $al[0][$a5] Then _14p()
$bb = $ak
$an = 3
Return
EndIf
Case 3
Local $b1 = $al[0][$ad]
Local $bf = $al[0][$ae]
_6($al,0)
$an = 1
If IsFunc($b1) Then
$9d = _14k( $bc, $b1, $bf )
If $9d Then
If $9d = 2 Then Return
Return _14j()
EndIf
EndIf
EndSwitch
EndFunc
Func _14k(ByRef $bg, ByRef $bh, ByRef $bi)
If Not IsFunc($bh) Then Return SetError(1)
Local $bj
If $bi = Default Then
$bj = $bh($bg)
Else
$bj = $bh($bg,$bi)
EndIf
If Not $bj Then Return
_14l($bj)
Return $bj
EndFunc
Func _14l($bj)
Switch $bj
Case 2
Case 1
_6($al,0)
$an = 1
_14p()
$ao = -1
Case 3
$an = 1
EndSwitch
EndFunc
Func _14m()
If Not UBound($al) Then Return
_6($al,0)
$an = 1
_14p()
$ao = -1
EndFunc
Func _14n($ar)
Local $b5 = _j($al,$ar,0,0,0,0,1,$a1)
If $b5 < 0 Then Return
_6($al,$b5)
If $b5 Then Return
_14p()
$an = 1
$ao = -1
EndFunc
Func _14p()
Local $bk = _148($ao)
If IsArray($bk) Then
For $9e = 1 To $bk[0][0]
ProcessClose($bk[$9e][1])
Next
EndIf
ProcessClose($ao)
EndFunc
Func _14q($bl,$bm)
If $ao <= 0 Or Not UBound($al) Then Return
If $bm < $al[0][$a6] Then Return
Local $bk = _148($ao)
If Not IsArray($bk) Then Return SetError(1)
For $9e = 1 To $bk[0][0]
_14r($bk[$9e][1],$bl)
If @error Then Return SetError(2)
Next
EndFunc
Func _14r($4b,$bl)
Local $bn = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $4b)
If Not IsArray($bn) Then Return SetError(1)
Local $bo
If $bl Then
$bo = DllCall("ntdll.dll", "int", "NtSuspendProcess", "int", $bn[0])
Else
$bo = DllCall("ntdll.dll", "int", "NtResumeProcess", "int", $bn[0])
EndIf
DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $bn[0])
If Not IsArray($bo) Then Return SetError(2)
EndFunc
Global $bp[1] = [0]
Func _14s(ByRef $70)
$bp = StringSplit($70,@CRLF,1)
EndFunc
Func _14t()
Global $bp[1] = [0]
EndFunc
Func _14u($bq,$br = Default, $bs = Default)
Local $bt = _j($bp,'['&$bq&']',1,$bp[0])
If $bt = -1 Then Return SetError(1,0,-1)
If $br = Default And $bs = Default Then Return $bt
Local $9e = $bt+1
If $9e > $bp[0] Then Return SetError(1,0,-1)
Local $9d
Do
If StringLeft($bp[$9e],1) = '[' And StringRight($bp[$9e],1) = ']' Then
$bt = _j($bp,'['&$bq&']',$9e+1,$bp[0])
If $bt = -1 Then
Return SetError(1,0,-1)
Else
$9e = $bt+1
If $9e > $bp[0] Then Return SetError(1,0,-1)
EndIf
EndIf
$9d = StringSplit($bp[$9e],'=',1)
If $9d[0] >= 2 And StringStripWS($9d[1],3) = $br And StringStripWS(StringTrimLeft($bp[$9e],StringLen($9d[1])+1),3) = $bs Then Return $bt
$9e += 1
Until $9e > $bp[0]
Return SetError(1,0,-1)
EndFunc
Func _14v($bq,$br,$bu = Default,$bt = Default)
If $bu = Default Then $bu = Null
If $bt = Default Then
$bt = _j($bp,'['&$bq&']',1,$bp[0])
If $bt = -1 Then Return $bu
EndIf
Local $9e = $bt+1
If $9e > $bp[0] Then Return $bu
Local $9d
Do
If StringLeft($bp[$9e],1) = '[' And StringRight($bp[$9e],1) = ']' Then Return $bu
$9d = StringSplit($bp[$9e],'=',1)
If $9d[0] >= 2 And StringStripWS($9d[1],3) = $br Then Return StringStripWS(StringTrimLeft($bp[$9e],StringLen($9d[1])+1),3)
$9e += 1
Until $9e > $bp[0]
Return $bu
EndFunc
Func _14w($bt)
Local $bv[1][2]
$bv[0][0] = 0
If $bt = -1 Then Return $bv
For $9e = $bt+1 To $bp[0]
If StringLeft($bp[$9e],1) = '[' And StringRight($bp[$9e],1) = ']' Then ExitLoop
$9d = StringSplit($bp[$9e],'=',1)
If $9d[0] < 1 Then ContinueLoop
$bv[0][0] += 1
ReDim $bv[$bv[0][0]+1][2]
$bv[$bv[0][0]][0] = $9d[1]
$bv[$bv[0][0]][1] = StringTrimLeft($bp[$9e],StringLen($9d[1])+1)
Next
Return $bv
EndFunc
Func _14x($bq, $br, $bw, $bt = Default)
If $bt = Default Then $bt = _j($bp,'['&$bq&']',1,$bp[0])
If $bt = -1 Then
$bt = _156(2)
$bp[$bt] = '['&$bq&']'
$bp[$bt+1] = $br&'='&$bw
Else
Local $bx = -1
For $9e = $bt+1 To $bp[0]
If StringLeft($bp[$9e],1) = '[' And StringRight($bp[$9e],1) = ']' Then ExitLoop
$9d = StringSplit($bp[$9e],'=',1)
If $9d[0] < 1 Then ContinueLoop
If $9d[1] <> $br Then ContinueLoop
$bx = $9e
ExitLoop
Next
If $bx = -1 Then
$bx = $bt+1
If $bx > $bp[0] Then
$bp[0] += 1
ReDim $bp[$bp[0]+1]
Else
$bp[$bx] = StringStripWS($bp[$bx],3)
If $bp[$bx] Then
$bp[0] += 1
_a($bp,$bx)
EndIf
EndIf
EndIf
$bp[$bx] = $br&'='&$bw
EndIf
Return $bt
EndFunc
Func _14y($bq)
$bt = _j($bp,'['&$bq&']',1,$bp[0])
If $bt <> -1 Then Return $bt
$bt = _156(1)
$bp[$bt] = '['&$bq&']'
Return $bt
EndFunc
Func _14z($by)
Return _j($bp,'[['&$by&']]',1,$bp[0])
EndFunc
Func _150($bz)
Local $c0[1] = [0]
If $bz = -1 Then Return SetError(1,0,$c0)
For $9e = $bz+1 To $bp[0]
$bp[$9e] = StringStripWS($bp[$9e],3)
If $bp[$9e] = '[[]]' Then ExitLoop
$c0[0] += 1
ReDim $c0[$c0[0]+1]
$c0[$c0[0]] = $bp[$9e]
Next
Return $c0
EndFunc
Func _152($bz)
If $bz = -1 Then Return SetError(1)
Local $9e = $bz+1
If $9e > $bp[0] Or $bp[$9e] = '[[]]' Then Return
Do
_6($bp,$9e)
$bp[0] -= 1
Until $9e = $bp[0]+1 Or $bp[$9e] = '[[]]'
EndFunc
Func _153($by)
Local $bz = _j($bp,'[['&$by&']]',1,$bp[0])
If $bz <> -1 Then
_152($bz)
Return $bz
EndIf
$bz = _156(2)
$bp[$bz] = '[['&$by&']]'
$bp[$bz+1] = '[[]]'
Return $bz
EndFunc
Func _154($bz, ByRef $i, $k = 1, $1f = Default)
If $bz = -1 Then Return SetError(1)
_152($bz)
If $1f = Default Then $1f = UBound($i)-1
Local $c1 = $bz+1
If $c1 > $bp[0] Then
For $9e = $k To $1f
$bp[0] += 1
ReDim $bp[$bp[0]+1]
$bp[$bp[0]] = $i[$9e]
Next
Else
For $9e = $1f To $k Step -1
$bp[0] += 1
_a($bp,$c1,$i[$9e],0,@CRLF)
Next
EndIf
EndFunc
Func _156($c2)
Local $c3 = -1
For $9e = $bp[0] To 1 Step -1
$bp[$9e] = StringStripWS($bp[$9e],3)
If $bp[$9e] Then ExitLoop
$c3 = $9e
Next
If $c3 = -1 Then
$c3 = $bp[0]+1
$bp[0] += $c2
ReDim $bp[$bp[0]+1]
Else
Local $c4 = $bp[0]-$c3+1
If $c4 < $c2 Then
$bp[0] += $c2-$c4
ReDim $bp[$bp[0]+1]
EndIf
EndIf
Return $c3
EndFunc
Func _157()
Local $c5 = ''
For $9e = 1 To $bp[0]
$c5 &= $bp[$9e]
If $9e < $bp[0] Then $c5 &= @CRLF
Next
Return $c5
EndFunc
_n1()
Func _158($c6, $c7 = 10, $c8 = 0, $c9 = -1)
Local Const $ca = 0
Local $4h, $58, $cb, $cc, $cd, $ce
If $c9 = -1 Then
$4h = _43("")
Else
$4h = _5a($c9, 0x02)
EndIf
If $4h = 0 Then Return SetError(1, 0, 0)
If $c7 = 2 Then
$58 = _58($4h, $c6, $ca, 0, 0, 0)
If @error Then Return SetError(2, 0, 0)
Return $58
EndIf
If $c8 <> 0 Then
$cb = DllCall("kernel32.dll", "ptr", "FindResourceExW", "ptr", $4h, "long", $c7, "wstr", $c6, "short", $c8)
Else
$cb = DllCall("kernel32.dll", "ptr", "FindResourceW", "ptr", $4h, "wstr", $c6, "long", $c7)
EndIf
If @error Then Return SetError(3, 0, 0)
$cb = $cb[0]
If $cb = 0 Then Return SetError(4, 0, 0)
$ce = DllCall("kernel32.dll", "dword", "SizeofResource", "ptr", $4h, "ptr", $cb)
If @error Then Return SetError(5, 0, 0)
$ce = $ce[0]
If $ce = 0 Then Return SetError(6, 0, 0)
$cc = DllCall("kernel32.dll", "ptr", "LoadResource", "ptr", $4h, "ptr", $cb)
If @error Then Return SetError(7, 0, 0)
$cc = $cc[0]
If $cc = 0 Then Return SetError(8, 0, 0)
$cd = DllCall("kernel32.dll", "ptr", "LockResource", "ptr", $cc)
If @error Then Return SetError(9, 0, 0)
$cd = $cd[0]
If $cd = 0 Then Return SetError(10, 0, 0)
If $c9 <> -1 Then _3d($4h)
If @error Then Return SetError(11, 0, 0)
SetExtended($ce)
Return $cd
EndFunc
Func _159($c6, $c7 = 10, $c8 = 0, $c9 = -1)
Local $cf, $ce, $cg
$cf = _158($c6, $c7, $c8, $c9)
If @error Then
SetError(1, 0, 0)
Return ''
EndIf
$ce = @extended
$cg = DllStructCreate("char[" & $ce & "]", $cf)
Return DllStructGetData($cg, 1)
EndFunc
Func _15f($ch, $c6, $c7 = 10, $c9 = -1)
Local $ci, $cj, $ck, $cl, $cm, $cn, $58
$ci = _158($c6, $c7, 0, $c9)
If @error Then Return SetError(1, 0, 0)
$cj = @extended
If $c7 = 2 Then
_15g($ch, $ci)
If @error Then Return SetError(2, 0, 0)
Else
$ck = _t8($cj,2)
$cl = _ta($ck)
_te($ci,$cl,$cj)
_tc($ck)
$cm = DllCall( "ole32.dll","int","CreateStreamOnHGlobal", "ptr",$ck, "int",1, "ptr*",0)
$cm = $cm[3]
$cn = DllCall($4z,"int","GdipCreateBitmapFromStream", "ptr",$cm, "ptr*",0)
$cn = $cn[2]
$58 = _fr($cn)
_15g($ch, $58)
If @error Then SetError(3, 0, 0)
_fs($cn)
_2j($cm)
_t9($ck)
EndIf
Return 1
EndFunc
Func _15g($ch, $58)
Local Const $co = 0x0172
Local Const $cp = 0x0173
Local Const $cq = 0xF7
Local Const $cr = 0xF6
Local Const $ca = 0
Local Const $cs = 0x0E
Local Const $ct = 0x0080
Local Const $cu = -16
Local $3n, $cv, $cw, $cx, $cy, $cz
$3n = GUICtrlGetHandle($ch)
If $3n = 0 Then Return SetError(1, 0, 0)
$ch = _3u($3n)
If @error Then Return SetError(2, 0, 0)
Switch _3h($ch)
Case "Button"
$cx = $cq
$cy = $cr
$cz = $ct
Case "Static"
$cx = $co
$cy = $cp
$cz = $cs
Case Else
Return SetError(3, 0, 0)
EndSwitch
$cw = _4o($3n, $cu)
If @error Then Return SetError(4, 0, 0)
_6o($3n, $cu, BitOR($cw, $cz))
If @error Then Return SetError(5, 0, 0)
$cv = _1q($3n, $cx, $ca, $58)
If @error Then Return SetError(6, 0, 0)
If $cv Then _2j($cv)
Return 1
EndFunc
Dim $d0[1][4] = [[0, 1, 0, 0]]
OnAutoItExitRegister('_15k')
Func _15i($4p, $9p, $70, $d1 = 0, $d2 = 0, $4h = 0, $d3 = 0)
Local $d4 = Opt('WinTitleMatchMode', 3)
Local $d5 = DllStructCreate('uint Size;hwnd hOwner;ptr hInstance;ptr Text;ptr Caption;dword Style;ptr Icon;dword_ptr ContextHelpId;ptr MsgBoxCallback;dword LanguageId')
Local $d6 = DllStructCreate('wchar[' &(StringLen($9p) + 1) & ']')
Local $d7 = DllStructCreate('wchar[' &(StringLen($70) + 1) & ']')
Local $d8, $d9 = WinList($9p)
Local $da, $3n = 0, $db = 0
Local $dc
If($d3) And(BitAND($4p, 0x80)) Then
If Not IsString($d3) Then
$d3 = '#' & $d3
EndIf
$da = DllStructCreate('wchar[' &(StringLen($d3) + 1) & ']')
If Not $4h Then
$dc = DllCall('kernel32.dll', 'ptr', 'GetModuleHandleW', 'ptr', 0)
If Not @error Then
$4h = $dc[0]
EndIf
EndIf
Else
$da = 0
EndIf
DllStructSetData($d6, 1, $9p)
DllStructSetData($d7, 1, $70)
DllStructSetData($da, 1, $d3)
DllStructSetData($d5, 'Size', DllStructGetSize($d5))
DllStructSetData($d5, 'hOwner', $d2)
DllStructSetData($d5, 'hInstance', $4h)
DllStructSetData($d5, 'Text', DllStructGetPtr($d7))
DllStructSetData($d5, 'Caption', DllStructGetPtr($d6))
DllStructSetData($d5, 'Style', BitAND($4p, 0xFFFFBFF8))
DllStructSetData($d5, 'Icon', DllStructGetPtr($da))
DllStructSetData($d5, 'ContextHelpId', 0)
DllStructSetData($d5, 'MsgBoxCallback', 0)
DllStructSetData($d5, 'LanguageId', 0)
Do
$dc = DllCall('kernel32.dll', 'ptr', 'GetModuleHandleW', 'wstr', 'user32.dll')
If(@error) Or(Not $dc[0]) Then
ExitLoop
EndIf
$dc = DllCall('kernel32.dll', 'ptr', 'GetProcAddress', 'ptr', $dc[0], 'str', 'MessageBoxIndirectW')
If(@error) Or(Not $dc[0]) Then
ExitLoop
EndIf
$dc = DllCall('kernel32.dll', 'ptr', 'CreateThread', 'ptr', 0, 'dword_ptr', 0, 'ptr', $dc[0], 'ptr', DllStructGetPtr($d5), 'dword', 0, 'dword*', 0)
If(@error) Or(Not $dc[0]) Then
ExitLoop
EndIf
While 1
Sleep(10)
$d8 = WinList($9p)
For $s = 1 To $d8[0][0]
For $0z = 1 To $d9[0][0]
If $d8[$s][1] = $d9[$0z][1] Then
ContinueLoop 2
EndIf
Next
$3n = $d8[$s][1]
ExitLoop 2
Next
WEnd
Until 1
Opt('WinTitleMatchMode', $d4)
If Not $3n Then
Return SetError(1, 0, 0)
EndIf
If $d1 Then
$d0[0][1] += 1
$d0[0][0] += 1
ReDim $d0[$d0[0][0] + 1][4]
$d0[$d0[0][0]][0] = $3n
$d0[$d0[0][0]][1] = 1000 * $d1
$d0[$d0[0][0]][2] = TimerInit()
$d0[$d0[0][0]][3] = 0
If Not $d0[0][3] Then
$d0[0][2] = DllCallbackRegister('_15j', 'none', '')
$dc = DllCall('user32.dll', 'uint_ptr', 'SetTimer', 'hwnd', 0, 'uint_ptr', 0, 'uint', 200, 'ptr', DllCallBackGetPtr($d0[0][2]))
If(@error) Or(Not $dc[0]) Then
DllCallbackFree($d0[0][2])
$db = 1
Else
$d0[0][3] = $dc[0]
$d0[0][1] -= 1
EndIf
EndIf
$d0[0][1] -= 1
EndIf
Return SetError($db, 0, $3n)
EndFunc
Func _15j()
If $d0[0][1] Then
Return
EndIf
$d0[0][1] += 1
Local $dc, $dd = 1
While 1
For $s = $dd To $d0[0][0]
If TimerDiff($d0[$s][2]) >= $d0[$s][1] Then
If WinExists($d0[$s][0]) Then
DllCall('user32.dll', 'lresult', 'SendMessage', 'hwnd', $d0[$s][0], 'uint', 0x0010, 'wparam', 0, 'lparam', 0)
EndIf
$dd = $s
For $0z = $s To $d0[0][0] - 1
For $23 = 0 To 3
$d0[$0z][$23] = $d0[$0z + 1][$23]
Next
Next
ReDim $d0[$d0[0][0]][4]
$d0[0][0] -= 1
If Not $d0[0][0] Then
$dc = DllCall('user32.dll', 'int', 'KillTimer', 'hwnd', 0, 'uint_ptr', $d0[0][3])
If(Not @error) And($dc[0]) Then
$d0[0][3] = 0
DllCallbackFree($d0[0][2])
Return
EndIf
EndIf
ContinueLoop 2
EndIf
Next
ExitLoop
WEnd
$d0[0][1] -= 1
EndFunc
Func _15k()
$d0[0][1] += 1
If $d0[0][3] Then
DllCall('user32.dll', 'int', 'KillTimer', 'hwnd', 0, 'uint_ptr', $d0[0][3])
DllCallbackFree($d0[0][2])
EndIf
EndFunc
Global Enum $de, $df, $dg, $dh, $di, $dj, $dk
Global $dl = 0
Global $dm[1][$dk]
Global $dn[1][12]
Global $do
Global $dp[1] = [0], $dq = $dp
Global $dr[1] = [0]
Global Const $ds = '<DefaultTempDir>'
Global $dt = $ds&'\temp\'
Global $du
Global $dv = @ScriptDir&'\settings.ini'
Global $dw
Global $dx
Global $dy
Global $dz
Global $e0
Global $e1
Global $e2
Global $e3
Global $e4
Global $e5 = @ScriptDir&'\ffmpeg\bin\'
Global Const $e6 = '-i <input>  -c:v libx265  -x265-params crf=25  <output>'
Global $e7
Global $e8
Global $e9
Global $ea
Global Const $eb = 'http://easy265file.blogspot.com'
Global Const $ec = 'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=6K2UDXJH8EWPQ'
Global Const $ed = 'http://easy265file.blogspot.com/p/download.html'
Global Const $ee = 'Encoded by Easy265File'
Global Const $ef = '.mp4|.mkv|.avi'
Global Const $eg = 'avi,mkv,flv,mp4,wmv,divx,mov,xvid,mpc,mts'
Global Const $eh = 0xFA8E8E, $ei = 0xFFFFFF
Global $ej = -1, $ek, $el, $em, $en, $eo
Global $ep, $eq
Global $er
Global $es, $et
Global $eu = 16, $ev = 38, $ew = True
Global $ex, $ey
Global $ez, $f0
Global $f1
Global $f2 = -1
Global $f3
Global $f4
Global $f5
Global $f6
Global $f7[1] = [0]
Global Const $f8 = 'Edit default settings'
Global $f9
Global $fa
Global $fb
Global $fc
Global $fd
Global $fe = $ei
Global $ff
Global $fg
Global $fh
Global $fi
Global $fj
Global $fk, $fl = $ei
Global $fm, $fn = $ei
Global $fo, $fp = $ei
Global $fq
Global $fr
Global $fs
Global $ft
Global $fu
Global $fv
Global $fw
Global $fx = 64
Global $fy
Global $fz = 64
Global $g0
Global $g1
Global $g2
Global $g3, $g4
Global $g5
Global $g6
Global $g7
Global $g8
Global $g9
Global $ga
Global $gb
Global $gc
Global $gd, $ge
Global $gf, $gg, $gh
Global $gi = 0, $gj = 0
Global $gk, $gl,$gm , $gn, $go,$gp, $gq
Global $gr
Global $gs
Global $gt
Global $gu
Global $gv
Global Const $gw = 'OUTPUT_PREVIEW'
Global $gx = True
Global $gy
Global $gz
Global $h0
Global $h1
Global $h2
Global Enum $h3 , $h4 , $h5 , $h6 , $h7 , $h8 , $h9 , $ha
Func _15l()
Global $hb = Null , $hc = Null, $hd = Null , $he = Null, $hf = 0
EndFunc
_15l()
Global $hg
Global $hh
Global $hi
Global $hj, $hk
Global $hl = False
Global $hm = -1
Global $hn
Global $ho
Global $hp
Global $hq
Global $hr
Global $hs
Global $ht
Global $hu
Global $hv
Global $hw
Global $hx
Global $hy
Global $hz
Global $i0
Global $i1
Global $i2
Global $i3
Global $i4
Global $i5
Global $i6
Global $i7
Global $i8
Global $i9
Func _15m($ia)
GUISetState(@SW_DISABLE,$ia)
EndFunc
Func _15n($ia)
GUISetState(@SW_ENABLE,$ia)
WinActivate($ia)
EndFunc
Func _15o($60)
Local $49 = 0
Local Static $i = [' bytes', ' KB', ' MB', ' GB', ' TB', ' PB', ' EB', ' ZB', ' YB']
While $60 > 1023
$49 += 1
$60 /= 1024
WEnd
Return Round($60) & $i[$49]
EndFunc
Func _15p($ib,$ic = '')
If StringInStr($ib,@CRLF) Or StringInStr($ib,@LF) Then
$ib = StringReplace($ib,@CRLF,$ic)
$ib = StringReplace($ib,@LF,$ic)
EndIf
Return $ib
EndFunc
Func _15q($id,$br,$ie)
$9d = IniRead($dv,$id,$br,$ie)
If Not $9d Then $9d = $ie
Return $9d
EndFunc
Func _15r($if)
Local $4o = StringSplit($if, '\', 1)
Return $4o[$4o[0]]
EndFunc
Func _15s($if)
Return StringTrimRight($if,StringLen(_15r($if)))
EndFunc
Func _15v($7z)
Local $q = StringSplit($7z, '\', 1)
Local $ig = $q[$q[0]]
$q = StringSplit($ig, '.', 1)
If $q[0] < 2 Then Return ''
Return $q[$q[0]]
EndFunc
Func _15x($ih)
Local $ii, $ij, $id
$ii = Int($ih / 3600)
$ij = Int(($ih - $ii * 3600) / 60)
$id = $ih - $ii * 3600 - $ij * 60
Return StringFormat('%02d:%02d:%02d', $ii, $ij, $id)
EndFunc
Func _15y($ik)
$9d = StringSplit($ik, ':', 1)
If $9d[0] <> 3 Then Return SetError(1, 0, 0)
Return($9d[1] * 3600) +($9d[2] * 60) + $9d[3]
EndFunc
Func _15z(ByRef $il)
If Not FileExists($il) Then DirCreate($il)
EndFunc
Func _160($ib)
Local Const $im = 8
Local $in = _of($ib,True,$im)
If @error Then Return SetError(1)
Return StringTrimLeft($in,2)
EndFunc
Func _161()
Local $c0 = _162()
If Not @error Then Return $c0
Return _163()
EndFunc
Func _162()
Local $io = _44()
If @error Then Return SetError(1)
Local $5u = _cw($io)
If @error Then Return SetError(2)
Local $ip = _ql($5u)
If Not IsArray($ip) Then Return SetError(3)
Local $c0[2] = [DllStructGetData($ip[1], 3),DllStructGetData($ip[1], 4)]
Return $c0
EndFunc
Func _163()
Local $c0[2] = [@DesktopWidth,@DesktopHeight-30]
Return $c0
EndFunc
Func _164(ByRef $iq, ByRef $ir)
Local $is = UBound($iq)-1, $it = UBound($ir)-1
If $is <> $it Then Return False
For $9e = 0 To $is
If $iq[$9e] <> $ir[$9e] Then Return False
Next
Return True
EndFunc
Func _165($iu, $iv)
Local $iw
For $9e = 1 To $iv
$iw &= $iu
Next
Return $iw
EndFunc
Func _166()
ToolTip(Null)
AdlibUnRegister(_166)
EndFunc
Func _167($ia, $ix, $iy, $iz = 5000)
Local $j0 = Default, $j1 = Default
Local $j2 = WinGetPos($ia)
If IsArray($j2) Then
Local $j3 = WinGetClientSize($ia)
If IsArray($j3) Then
Local $j4 = ControlGetPos($ia,Null,$ix)
If IsArray($j4) Then
$j0 =($j2[2]-$j3[0])+$j2[0]+$j4[0]
$j1 =($j2[3]-$j3[1])+$j2[1]+$j4[1]+$j4[3]
EndIf
EndIf
EndIf
ToolTip($iy,$j0,$j1)
AdlibRegister(_166,$iz)
EndFunc
Func _168($j5)
$9d = StringSplit($j5,'%',1)
If $9d[0] <> 2 Or $9d[2] Then Return 0
Return Number($9d[1])
EndFunc
Func _16a($j6, $j7)
$9d = StringSplit($j6,$j7,1)
If $9d[0] < 2 Then Return SetError(1,0,'error')
$9d = StringSplit($9d[2],'=',1)
If $9d[0] < 2 Then Return SetError(2,0,'error')
$9d = StringStripWS($9d[2],3)
$j8 = StringSplit($9d,' ',1)
If $j8[0] < 2 Then Return $9d
Return StringStripWS(StringTrimRight($9d,StringLen($j8[$j8[0]])),3)
EndFunc
Func _16b($j9,$ja)
If StringRight($j9,1) <> '\' Then $j9 &= '\'
If StringRight($ja,1) <> '\' Then $ja &= '\'
If $j9 = $ja Then Return True
Return False
EndFunc
Func _16c($jb, ByRef $jc, ByRef $jd, $je, $jf)
Local $jg = WinGetPos($jb)
If Not IsArray($jg) Then Return
$jc = $jg[0] + Round( $jg[2]/2 - $je/2 )
$jd = $jg[1] + Round( $jg[3]/2 - $jf/2 )
EndFunc
Func _16d()
$dw = _15q('Main','FFmpegBinFolder',$e5)
If StringRight($dw,1) <> '\' Then $dw &= '\'
$e7 = $dw&'ffmpeg.exe'
$e8 = $dw&'ffprobe.exe'
$du = _15q('Main','TempDir',$dt)
$du = StringReplace($du,$ds,@ScriptDir,1)
If StringRight($du,1) <> '\' Then $du &= '\'
If $du = @ScriptDir&'\' Then $du = $dt
$e3 = _15q('Main','LastDir',@ScriptDir)
$e9 = $e3
$e1 = _15q('Main','InputFileTypes',$eg)
$e2 = $e1
$dx = _15q('Main','FFmpegCommand',$e6)
$dn[0][5] = $dx
$dy = _15q('Main','Container','.mp4')
$dn[0][6] = $dy
$dz = _15q('Main','OutFilename','?.x265')
$dn[0][4] = $dz
$e0 = _15q('Main','OutputFolder','?_Converted\|')
$dn[0][3] = $e0
$e4 = Number(_15q('Main','AgreLicense',0))
EndFunc
Func _16e()
If $dn[0][5] <> $dx Then IniWrite($dv,'Main','FFmpegCommand',$dn[0][5])
If $dn[0][6] <> $dy Then IniWrite($dv,'Main','Container',$dn[0][6])
If $dn[0][4] <> $dz Then IniWrite($dv,'Main','OutFilename',$dn[0][4])
If $dn[0][3] <> $e0 Then IniWrite($dv,'Main','OutputFolder',$dn[0][3])
If $e2 <> $e1 Then IniWrite($dv,'Main','InputFileTypes',$e2)
If $e9 <> $e3 Then IniWrite($dv,'Main','LastDir',$e9)
EndFunc
Global Enum $jh, $ji, $jj
Func _16f($jk,$jl)
Local $jm[$jj]
$jm[$jh] = $jk
$jm[$ji] = $dn[$jk][0]
_14i( $e8 , '-v error -show_format -show_streams "'&$dn[$jk][0]&'"' , $dn[$jk][0] , $jl , Default , False , Null , Default , Null , Default , Null , Default , _16g , $jm)
EndFunc
Func _16g($jn, ByRef $jm)
Local $jk = $jm[$jh]
Local $jo = $jm[$ji]
_16l($jk,$jo)
If @error Then Return
_14s($jn[$ah])
$9d = _14u('FORMAT')
$dn[$jk][8] = _14v(Null,'duration',-1,$9d)
_14t()
If $gy Then
_193($jk)
EndIf
If $dp[0] And $dp[1] = $jk Then
_180()
EndIf
EndFunc
Func _16h($3n, $3o, $3p, $3q)
#forceref $3o, $3p
Switch $3n
Case $ej
_16w($3n, $3o, $3p, $3q)
EndSwitch
Return 'GUI_RUNDEFMSG'
EndFunc
Func _16i($3n, $3o, $3p, $3q)
Switch $3n
Case $ej
Return _16p($3n, $3o, $3p, $3q)
EndSwitch
Return 0
EndFunc
Func _16j($3n, $jp, $3p, $3q)
GUIRegisterMsg(0x0233, Null)
If $gy Then
GUIRegisterMsg($3, '')
_1ab()
For $9e = 1 To $dn[0][0]
_zi($gy, $9e-1, False,True)
Next
EndIf
Local $cj, $jq, $7z, $jr
Local $js = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $3p, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
For $s = 0 To $js[0] - 1
$cj = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $3p, "int", $s, "ptr", 0, "int", 0)
$cj = $cj[0] + 1
$jq = DllStructCreate("char[" & $cj & "]")
DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $3p, "int", $s, "ptr", DllStructGetPtr($jq), "int", $cj)
$7z = DllStructGetData($jq, 1)
$jq = 0
If Not FileExists($7z) Then ContinueLoop
If FileGetSize($7z) Then
$jr = _15v($7z)
If Not $jr Or Not StringInStr($eg,$jr) Then ContinueLoop
_1a1($7z)
If @error Then ContinueLoop
$dp[0] += 1
ReDim $dp[$dp[0]+1]
$dp[$dp[0]] = $dn[0][0]
If Not $gy Then ContinueLoop
_191($dn[0][0])
_zi($gy, $dn[0][0]-1, True, True)
Else
_18w($7z,False)
Do
_1ah()
Until _18x()
$dp[0] += 1
ReDim $dp[$dp[0]+1]
$dp[$dp[0]] = $dn[0][0]
If $gy Then  _zi($gy, $dn[0][0]-1, True, True)
EndIf
Next
Local $9d = _1a6()
If $gy Then
If $9d Then _195()
_18m()
GUIRegisterMsg($3, _18p)
EndIf
_18q()
_176()
_175()
GUIRegisterMsg(0x0233, _16j)
EndFunc
Func _16k()
If Not $cmdline[0] Then Return
For $9e = 1 To $cmdline[0]
_1a1($cmdline[$9e])
Next
_1a6()
EndFunc
Func _16l(ByRef $jk, $jt)
$5n = UBound($dn)-1
If $5n <> $dn[0][0] Then
$dn[0][0] = $5n
EndIf
If Not $5n Then Return SetError(1)
If $jk <= $5n And $dn[$jk][0] = $jt Then Return
For $9e = 1 To $5n
If $dn[$9e][0] = $jt Then
$jk = $9e
Return
EndIf
Next
Return SetError(1)
EndFunc
Func _16m()
DirRemove($g8,1)
EndFunc
Func _16n()
Local $ju = _4i(32)
If Not $ju Then Return
$ju *= 2
Local $jv = _4i(33)
If Not $jv Then Return
$jv *= 2
Local $jw = _4i(4)
If Not $jw Then Return
$eu = $ju
$ev = $jw+$jv
$ew = False
EndFunc
Func _16o()
If $et Then
$ex = 797
$ey = 621
Else
$ex = 797
$ey = 380
EndIf
EndFunc
Func _16p($3n, $3o, $3p, $3q)
Local $jx = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $3q)
DllStructSetData($jx, 7, $ex+$eu)
DllStructSetData($jx, 8, $ey+$ev)
Return 0
EndFunc
Func _16q()
$es = Number(_15q('MainGUI','expanded',0))
$et = $es
_16o()
$ez = $ex
$f0 = $ey
If Not $ew Then
$ep = Number(_15q('MainGUI','x_size',$ex))
If $ep < @DesktopWidth Then
$9d = $ep-$eu
If $9d > $ex Then $ez = $9d
EndIf
$eq = Number(_15q('MainGUI','y_size',$ey))
If $eq < @DesktopHeight Then
$9d = $eq-$ev
If $9d > $ey Then $f0 = $9d
EndIf
EndIf
$er = Number(_15q('MainGUI','maximized',0))
EndFunc
Func _16r()
Local $9d
Local $jy
$9d = WinGetState($ej)
If Not @error Then
If BitAND($9d, 32) Then
$jy = 1
Else
$jy = 0
EndIf
EndIf
If $jy <> $er Then IniWrite($dv,'MainGUI','maximized',$jy)
If Not $jy And Not $ew Then
$9d = WinGetPos($ej)
If Not @error Then
If $ep <> $9d[2] Then IniWrite($dv,'MainGUI','x_size',$9d[2])
If $eq <> $9d[3] Then IniWrite($dv,'MainGUI','y_size',$9d[3])
EndIf
EndIf
If $et <> $es Then IniWrite($dv,'MainGUI','expanded',$et)
EndFunc
Func _16s($jz,$k0 = Default)
Local $k1 = WinGetClientSize($ej)
If @error Then
Local $k1[2]
$k1[0] = $ez
$k1[1] = $f0-30
EndIf
Local $k2, $k3
$k2 = $k1[0] - 10
$k3 = $k1[1] - 63
If Not $et Then
_16t( $jz, 10, $k2, 3, $k3)
Else
If $k0 = Default Then $k0 = $jz
Local Const $k4 = 0.55
Local $k5 = $k3-3
Local $k6 = Round($k5*$k4)
Local $k7 = 3+$k6
_16t( $jz, 10, $k2, 3, $k7)
$k7 += 3
_18l( $k0, 10, $k2, $k7, $k3)
EndIf
_16u( $jz, 10, $k2, $k3)
EndFunc
Func _16t($k8,$k9,$k2,$ka,$kb)
Local Const $kc = 6 , $kd = 24, $ke = 1
$9d = Round(($k2-$k9)/2)
Local $je = $9d-$kc
Local $jf = $kb-$ka
Local $kf = $k9+$9d+$kc
Local $kg = $ka+$jf+$ke
If $k8 Then
_16x($ej,$je, $jf, $k9,$ka)
_18c($je,$jf,$kf,$ka,$ej)
Else
_171($k9,$ka,$je,$jf)
_18c($je,$jf,$kf,$ka,Null)
GUICtrlSetPos($em,$kf, $kg,$je, $kd)
EndIf
EndFunc
Func _16u($k8,$k9,$k2,$ka)
Local Const $kh = 206, $ki = 18, $kj = 2, $kk = 21, $kl = 40
Local $km, $kn, $ko = $k2-$k9
$km = $k9+Round((($ko)-$kh)/2)
$kn = $ka+$kj
$kp = $ka+$kk
If $k8 Then
$el = GUICtrlCreateButton('',$km,$kn,$kh, $ki)
GUICtrlSetFont(-1, 18, 400, 0, "Webdings")
GUICtrlSetResizing(-1,0x0322)
$ek = GUICtrlCreateButton('Encode',$k9,$kp,$ko, $kl)
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetFont(-1, 22, 400, 0, "Tahoma")
Else
GUICtrlSetPos($el,$km,$kn,$kh, $ki)
GUICtrlSetPos($ek,$k9,$kp,$ko, $kl)
EndIf
EndFunc
Func _16v()
If $et Then
GUICtrlSetData($el,'5')
Else
GUICtrlSetData($el,'6')
EndIf
EndFunc
Func _16w($3n, $3o, $3p, $3q)
_16s(False)
AdlibRegister(_17w)
EndFunc
Func _16x($d2,$kq,$kr, $ks , $kt)
$f1 = $d2
$f2 = GUICreate('Settings',$kq, $kr, $ks, $kt, 0x40000000, 0x00000200, $f1)
WinMove($f2,'',$ks, $kt,$kq, $kr)
$9d = WinGetClientSize($f2)
If IsArray($9d) Then
$kq = $9d[0]
$kr = $9d[1]
EndIf
_16y(True,$kq,$kr)
GUISetState(@SW_SHOW)
GUISwitch($f1)
EndFunc
Func _16y($jz,$kq,$kr)
Local Const $ku = 30, $kv = 30
Local $kw = $kr-$ku-$kv
$fa = $kq-(5*2)
Local Const $kx = 75
Local $ky = $kr-$kx-$kv-5
Local $kz = $kr-$kv
Local Const $l0 = 109
Local $l1 = $kq-$l0
Local Const $l2 = 5
Local Const $l3 = $kv
Local Const $l4 = $kv
Local Const $l5 = $l2
Local Const $l6 = $l5+$l3+$l2
Local Const $l7 = $l6+$l3+$l2
If $jz Then
_176()
$f3 = GUICtrlCreateCombo('',0,1,$kq,$kr,BitOR(0x3,0x40))
GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
GUICtrlSetResizing(-1,0x0322)
$fv = GUICtrlCreatePic('', $l1, $kz, $l0, $kv)
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetCursor(-1, 0)
_15f($fv, 'Image_DonateButton')
$fw = GUICtrlCreateButton('',$l5,$kz,$l3,$l4)
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetTip(-1, 'So these settings will be active for any video without profile', 'Save settings to default')
_15f($fw, 'Image_SaveButton')
$fy = GUICtrlCreateButton('',$l6,$kz,$l3,$l4)
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetTip(-1, 'It will create new profile with these settings for the selected videos.'&@CRLF& '(The settings will be active only on the selected videos)', 'Save settings to selected videos')
_15f($fy, 'Image_SaveToSelected')
$g0 = GUICtrlCreateButton('',$l7,$kz,$l3,$l4)
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetTip(-1, 'If no video was selected then this button will reset the default settings.'&@CRLF& 'Otherwise it will remove the settings of the selected videos.', 'Reset default settings / Clear settings of the selected videos')
_15f($g0, 'Image_DeleteSettings')
$f9 = GUICtrlCreateTab(1, $ku, $kq, $kw)
GUICtrlSetResizing(-1,0x0322)
$fb = GUICtrlCreateTabItem('Command')
GUICtrlCreateLabel('FFmpeg command:',5, 53, $fa, 19,0x0200)
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetFont(-1, 10, 400, 4, "Tahoma")
GUICtrlSetColor(-1, 0x0066CC)
$fd = GUICtrlCreateEdit('', 5, $kx, $fa, $ky)
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
$ff = GUICtrlCreateTabItem('Output')
_16z($jz)
Else
GUISwitch($f2)
GUICtrlSetPos($f3,0,0,$kq,$kr)
GUICtrlSetPos($fv,$l1, $kz, $l0, $kv)
GUICtrlSetPos($fw,$l5,$kz,$l3,$l4)
GUICtrlSetPos($fy,$l6,$kz,$l3,$l4)
GUICtrlSetPos($g0,$l7,$kz,$l3,$l4)
_16z($jz)
GUICtrlSetPos($f9,1, $ku, $kq, $kw)
GUICtrlSetPos($fd,5, $kx, $fa, $ky)
GUISwitch($f1)
EndIf
EndFunc
Func _16z($jz)
Local Const $l8 = 0x0066CC, $l9 = 0x0000FF, $la = 0x3f5f91
Local $lb = 5+15
Local Const $lc = 22, $ld = 17
Local Static $le, $lf, $lg
Local $lh = $lb+10
Local $li = $fa-$lh-5
Local Const $lj = 75
Local $lk = $lb+$lj+5
Local $ll = $fa-$lk-5
Local Const $lm = 88
Local Const $ln = 97
Local Const $lo = 114
Local $lp = $lo
If $fj Then $lp += $lc
Local Const $lq = 50
Local $lr = $lb+$lq+5
Local Const $ls = 30
Local $lt = $fa-$lr-5+20
Local $lu = $lr-20
Local $lv = $fa-$lr-5-$ls-5
Local $lw = $lr+$lv+5
Local $lx = 100
Local $ly = 5+$lx
Local $lz = $fa-$ly-5
Local $m0 = $lp+$ld+6
Local $m1 = $m0+$lc
Local $m2 = $m1
If $fj Then $m2 += $lc
Local $m3 = $m2+$lc+7
If $jz Then
Local Const $m4 = 115
Local $m5 = $m4+5
Local Const $m6 = 90
Local Const $m7 = 58
GUICtrlCreateLabel('Output container:',5,$m7,$m4)
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetFont(-1, 10, 400, 4, "Tahoma")
GUICtrlSetColor(-1, $la)
$fk = GUICtrlCreateCombo($fi,$m5,$m7,$m6,Default,BitOR(0x2,0x40))
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetData(-1,$ef)
GUICtrlCreateLabel('Variables:',5, $lm, $fa, Default,0x0200)
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetFont(-1, 10, 400, 4, "Tahoma")
GUICtrlSetColor(-1, $la)
GUICtrlCreateLabel('Video name:',$lb, $lo, $lj, Default,0x0200)
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
$le = GUICtrlCreateLabel('?'&' = Input',$lk,$ln,$ll,Default,0x1)
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetColor(-1, $l8)
$fm = GUICtrlCreateInput($fh,$lk,$lo,$ll,Default)
GUICtrlSetResizing(-1,0x0322)
$fs = GUICtrlCreateLabel('',$lh,$lp,$li,19)
If Not $fj Then GUICtrlSetState(-1,32)
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetFont(-1, 10, 800, 0, "Tahoma")
GUICtrlSetColor(-1, $l9)
$lf = GUICtrlCreateLabel('Folder:',$lb,$m1,$lq)
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
$lg = GUICtrlCreateLabel('?'&' = Common path, '&'|'&' = Path after '&'?', $lu,$m0,$lt,Default,0x1)
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetColor(-1, $l8)
$fo = GUICtrlCreateInput($fg,$lr,$m1,$lv,19)
GUICtrlSetResizing(-1,0x0322)
$fq = GUICtrlCreateButton('...',$lw,$m1,$ls,19)
GUICtrlSetResizing(-1,0x0322)
$ft = GUICtrlCreateLabel('',$lh,$m2,$li,19)
If Not $fj Then GUICtrlSetState(-1,32)
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetFont(-1, 10, 800, 0, "Tahoma")
GUICtrlSetColor(-1, $l9)
$fu = GUICtrlCreateLabel('Full save path:',5,$m3,$lx)
If Not $fj Then GUICtrlSetState(-1,32)
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetFont(-1, 10, 400, 4, "Tahoma")
$fr = GUICtrlCreateInput('',$ly,$m3,$lz,Default,BitOR(0x00000080,2048))
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetFont(-1, 10, 800, 0, "Tahoma")
GUICtrlSetColor(-1,$l9)
If Not $fj Then GUICtrlSetState(-1,32)
Else
GUICtrlSetPos($le,$lk,$ln,$ll)
GUICtrlSetPos($fm,$lk,$lo,$ll)
GUICtrlSetPos($fs,$lh,$lp,$li,19)
GUICtrlSetPos($lf,$lb,$m1,$lq)
GUICtrlSetPos($lg,$lu,$m0,$lt)
GUICtrlSetPos($fo,$lr,$m1,$lv,19)
GUICtrlSetPos($fq,$lw,$m1,$ls,19)
GUICtrlSetPos($ft,$lh,$m2,$li,19)
GUICtrlSetPos($fu,5,$m3,$lx)
GUICtrlSetPos($fr,$ly,$m3,$lz)
EndIf
EndFunc
Func _170($m8)
GUICtrlSetState($fs,$m8)
GUICtrlSetState($ft,$m8)
GUICtrlSetState($fu,$m8)
GUICtrlSetState($fr,$m8)
EndFunc
Func _171($jc,$jd,$je,$jf)
WinMove($f2,'',$jc,$jd,$je,$jf)
Local $m9 = WinGetClientSize($f2)
If Not @error Then
$je = $m9[0]
$jf = $m9[1]
EndIf
_16y(False,$je,$jf)
EndFunc
Func _172($ma = False,$mb = True)
GUISwitch($f2)
Local $mc, $md, $me, $mf, $mg
If $dp[0] Then
Local $mh = False
$mg = _1a0($dp[1],2)
$mc = _1a0($dp[1],5)
$md = _1a0($dp[1],4)
$me = _1a0($dp[1],6)
$mf = _1a0($dp[1],3)
For $9e = 2 To $dp[0]
If $mg = _1a0($dp[$9e],2) Then ContinueLoop
If Not $mh Then $mh = True
If $mc <> '*' And $mc <> _1a0($dp[$9e],5) Then $mc = '*'
If $md <> '*' And $md <> _1a0($dp[$9e],4) Then $md = '*'
If $me <> '*' And $me <> _1a0($dp[$9e],6) Then $me = '*'
If $mf <> '*' And $mf <> _1a0($dp[$9e],3) Then $mf = '*'
Next
If $mh Then $mg = '*'
If $ma Then
If $dp[0] <> 1 Then
$f4 = _174($dp[0],$mg)
Else
If $mg Then
$f4 = $dn[$dp[1]][1]&' [Profile '&$mg&']'
Else
$f4 = $dn[$dp[1]][1]&' [No Profile]'
EndIf
EndIf
_175()
EndIf
Else
$mg = ''
$f4 = $f8
$mc = $dn[0][5]
$md = $dn[0][4]
$me = $dn[0][6]
$mf = $dn[0][3]
If $ma Then
_175()
EndIf
EndIf
If $mb Then
$fc = _17e($mc)
$fi = $me
$fh = $md
$fg = $mf
_17f($fd,$fc,$fe)
_17f($fk,$fi,$fl,True)
_17f($fm,$fh,$fn)
_17f($fo,$fg,$fp)
If $dp[0] = 1 Then
_173()
If Not $fj Then
$fj = True
_16z(False)
_170(16)
EndIf
Else
If $fj Then
$fj = False
_170(32)
_16z(False)
EndIf
EndIf
If $dp[0] >= 1 Then
If $fz <> 64 Then
GUICtrlSetState($fy,64)
$fz = 64
EndIf
Else
If $fz <> 128 Then
GUICtrlSetState($fy,128)
$fz = 128
EndIf
EndIf
If $mg <> '*' Then
If $fx <> 64 Then
GUICtrlSetState($fw,64)
$fx = 64
EndIf
Else
If $fx <> 128 Then
GUICtrlSetState($fw,128)
$fx = 128
EndIf
EndIf
EndIf
GUISwitch($f1)
Return $mg
EndFunc
Func _173()
Local $4o = _1a2($dp[1],$fh,$fi)
GUICtrlSetData($fs,$4o)
GUICtrlSetTip($fs,$4o,'File name preview:')
Local $mi = _1a3($dp[1],$fg)
GUICtrlSetData($ft,$mi)
GUICtrlSetTip($ft,$mi,'Save folder preview:')
If StringRight($mi,1) <> '\' Then $mi &= '\'
Local $mj = $mi&$4o
GUICtrlSetData($fr,$mj)
GUICtrlSetTip($fr,$mj,'File path preview:')
EndFunc
Func _174($mk,$mg = Null)
If Not $mg Then
$mg = '[No Profile]'
Else
$mg = '[Profile '&$mg&']'
EndIf
Return $mk&' Videos '&$mg
EndFunc
Func _175()
$9d = StringSplit($f5,'|',1)
If _j($9d,$f4,1,$9d[0]) <= 0 Then
$9d = $f5&'|'&$f4
Else
$9d = $f5
EndIf
GUISwitch($f2)
GUICtrlSetData($f3,'')
GUICtrlSetData($f3,$9d,$f4)
GUICtrlSetTip($f3,$f4)
GUISwitch($f1)
EndFunc
Func _176($ml = False)
If $ml Then
$f4 = $f8
_1ae()
EndIf
Local $mm = 0, $mn
For $9e = 1 To $dn[0][0]
If Not $dn[$9e][2] Then
$mm += 1
$mn = $9e
EndIf
Next
$f5 = $f8
If $mm Then
If $mm > 1 Then
$f5 &= '|'&$mm&' Videos [No Profile]'
Else
$f5 &= '|'&$dn[$mn][1]&' [No Profile]'
EndIf
EndIf
If Not $dm[0][0] Or Not $dm[1][$df] Then Return
For $9e = 1 To $dm[0][0]
If Not $dm[$9e][$df] Then ExitLoop
If $dm[$9e][$df] <> 1 Then
$f5 &= '|'&$dm[$9e][$df]&' Videos [Profile '&$dm[$9e][$de]&']'
Else
$9d = _j($dn,$dm[$9e][$de],1,$dn[0][0],0,0,1,2)
If $9d > 0 Then
$f5 &= '|'&$dn[$9d][1]&' [Profile '&$dm[$9e][$de]&']'
Else
$f5 &= '|'&$dm[$9e][$df]&' Videos [Profile '&$dm[$9e][$de]&']'
EndIf
EndIf
Next
EndFunc
Func _177()
$9d = _15p($fc,'  ')
If $9d <> $dn[0][5] Then $dn[0][5] = $9d
If $fi <> $dn[0][6] Then $dn[0][6] = $fi
If $fh <> $dn[0][4] Then $dn[0][4] = $fh
If $fg <> $dn[0][3] Then $dn[0][3] = $fg
_197()
_19c()
EndFunc
Func _178()
For $9e = 1 To $dp[0]
_179(_17d(),$dp[$9e],5)
_179($fi,$dp[$9e],6)
_179($fh,$dp[$9e],4)
_179($fg,$dp[$9e],3)
_19c($dp[$9e])
Next
_17a()
EndFunc
Func _179($mo,$jk,$mp)
If $mo <> '*' Then
If $dn[$jk][$mp] And $mo = $dn[$jk][$mp] Then Return
$dn[$jk][$mp] = $mo
Else
If $dn[$jk][$mp] Then Return
$mo = $dn[0][$mp]
$dn[$jk][$mp] = $mo
EndIf
_196($jk,$mp)
EndFunc
Func _17a()
Local $mq = False
If $dp[0] Then
Local $mr
For $9e = 1 To $dp[0]
$mr = 0
For $ms = 1 To $dm[0][0]
If $dn[$dp[$9e]][5] <> $dm[$ms][$dg] Then ContinueLoop
If $dn[$dp[$9e]][4] <> $dm[$ms][$dh] Then ContinueLoop
If $dn[$dp[$9e]][3] <> $dm[$ms][$di] Then ContinueLoop
If $dn[$dp[$9e]][6] <> $dm[$ms][$dj] Then ContinueLoop
$mr = $dm[$ms][$de]
If $dn[$dp[$9e]][2] = $mr Then ContinueLoop 2
$dm[$ms][$df] += 1
ExitLoop
Next
If Not $mq Then $mq = True
If $dn[$dp[$9e]][2] Then _1ad($dn[$dp[$9e]][2])
If Not $mr Then
$dl += 1
$mr = $dl
_1ac($mr,$dp[$9e])
EndIf
_l($dm,1,1,$dm[0][0],$df)
$dn[$dp[$9e]][2] = $mr
If $gy Then
_zl( $gy, $dp[$9e]-1, $dn[$dp[$9e]][2], $h7)
EndIf
Next
If $dm[0][0] Then  _yt($gy,$h7,-2)
_176()
EndIf
Return $mq
EndFunc
Func _17b()
$9d = GUICtrlRead($f3)
If $9d <> $f4 Then
$f4 = $9d
GUICtrlSetTip($f3,$f4)
_1ab()
If $f4 <> $f8 Then
Local $mg, $mt
$9d = _102($f4,' [',']')
If IsArray($9d) Then
$mg = $9d[UBound($9d)-1]
$mt = StringStripWS(StringTrimRight($f4,StringLen($mg)+2),3)
If $mg = 'No Profile' Then
$mg = ''
Else
$mg = StringStripWS(StringTrimLeft($mg,StringLen('Profile')),3)
EndIf
$9d = StringSplit($mt,' ',1)
If $9d[0] = 2 And $9d[2] = 'Videos' Then
If $mg = $f6 And $9d[1] = $f7[0] Then
$dp = $f7
Else
For $9e = 1 To $dn[0][0]
If $dn[$9e][2] = $mg Then
_1a8($9e)
EndIf
Next
EndIf
Else
Local $k = 1
$9d = _j($dn,$mt,$k,$dn[0][0],0,0,1,1)
If $9d > 0 Then
While $dn[$9d][2] <> $mg
$9d = -1
$k += 1
If $k > $dn[0][0] Then ExitLoop
$9d = _j($dn,$mt,$k,$dn[0][0],0,0,1,4)
If $9d < 1 Then ExitLoop
WEnd
EndIf
If $9d > 0 Then
_1a8($9d)
EndIf
EndIf
EndIf
EndIf
If $gy Then
GUIRegisterMsg($3, '')
For $9e = 1 To $dn[0][0]
_zi($gy, $9e-1, False,True)
Next
For $9e = 1 To $dp[0]
_zi($gy, $dp[$9e]-1, True, True)
Next
GUIRegisterMsg($3, _18p)
EndIf
_172(False)
_17z()
_18r()
$dq = $dp
Return
EndIf
$9d = StringStripWS(GUICtrlRead($fd),3)
If $9d <> $fc Then
$fc = $9d
_17g($fd,$fe,$ei)
_17z()
Return
EndIf
$9d = StringStripWS(GUICtrlRead($fk),3)
If $9d <> $fi Then
$fi = $9d
If $dp[0] = 1 Then _173()
_17g($fk,$fl,$ei,True)
EndIf
$9d = StringStripWS(GUICtrlRead($fm),3)
If $9d <> $fh Then
$fh = $9d
If $dp[0] = 1 Then _173()
_17g($fm,$fn,$ei,True)
EndIf
$9d = StringStripWS(GUICtrlRead($fo),3)
If $9d <> $fg Then
$fg = $9d
If $dp[0] = 1 Then _173()
_17g($fo,$fp,$ei,True)
EndIf
EndFunc
Func _17c()
GUISwitch($f2)
Switch $ea[0]
Case $fq
Local $mu = FileSelectFolder('Select output folder', $e9,0,Null,$ej)
If $mu Then
If StringRight($mu,1) <> '\' Then $mu &= '\'
GUICtrlSetData($fo,$mu&'|')
$e9 = $mu
EndIf
Case $fw
_177()
_176()
_172(True,False)
Case $fy
_178()
_176(True)
_172(True,False)
Case $g0
If Not $dp[0] Then
$dn[0][3] = '?_Converted\|'
$dn[0][4] = '?.x265'
$dn[0][5] = $e6
$dn[0][6] = '.mp4'
_197()
_19c()
Else
For $9e = 1 To $dp[0]
If Not $dn[$dp[$9e]][2] Then ContinueLoop
_1ad($dn[$dp[$9e]][2])
$dn[$dp[$9e]][2] = ''
If $gy Then
_zl( $gy, $dp[$9e]-1, '', $h7)
EndIf
For $ms = 3 To 6
$dn[$dp[$9e]][$ms] = ''
Next
If $gy Then _198($dp[$9e])
_19c($dp[$9e])
Next
_l($dm,1,1,$dm[0][0],$df)
_176()
EndIf
_172(True,True)
Case $fv
ShellExecute($ec)
EndSwitch
GUISwitch($f1)
EndFunc
Func _17d()
Return _15p(StringStripWS($fc,3),'  ')
EndFunc
Func _17e( $mc)
Return StringReplace($mc,'  ',@CRLF)
EndFunc
Func _17f($ch, $mv, ByRef $mw,$mx = False)
$my = GUICtrlRead($ch)
If $my = $mv Then Return
Local $mz
If $mv = '*' Then
$mz = $eh
Else
$mz = $ei
EndIf
If $mz <> $mw Then
GUICtrlSetBkColor($ch,$mz)
$mw = $mz
EndIf
If Not $mx Then
GUICtrlSetData($ch,$mv)
Else
GUICtrlSetData($ch,$mv,$mv)
GUICtrlSetState($ch,16)
EndIf
EndFunc
Func _17g($ix, ByRef $n0, $n1, $mx = False)
If $n0 = $n1 Then Return
GUICtrlSetBkColor($ix,$n1)
If $mx Then GUICtrlSetState($ix,16)
EndFunc
Func _17h($ia = 0)
If $gf Then _17i()
If $ia Then $gf = $ia
$gg = WinGetClientSize($gf)
If @error Then Return SetError(1)
If $gh Then _h7($gh)
$gh = _h6($gf)
If @error Then Return SetError(1,0,_17i())
EndFunc
Func _17i()
_h7($gh)
$gf = 0
$gh = 0
$gg = 0
EndFunc
Func _17j($n2)
If $gk Then _17k()
$gl = _j7($n2)
$gq = _iw($gl)
If @error Then
_17k()
Return SetError(1)
EndIf
$gp = $gq
$gk = _fp($gq[0], $gq[1])
$gm = _iy($gk)
_hh($gm, $gl, 0, 0, $gq[0], $gq[1])
EndFunc
Func _17k()
If $gm Then
_h7($gm)
$gm = 0
EndIf
If $gk Then
_fs($gk)
$gk = 0
EndIf
If $gl Then
_iv($gl)
$gl = 0
EndIf
$gq = 0
$gn = 0
$go = 0
$gp = 0
$gi = 0
$gj = 0
EndFunc
Func _17l()
If Not IsArray($gp) Then Return SetError(1)
Local $n3 = _17m($gp[1],$gg[1])
If Not @error Then Return $n3
Return _17m($gp[0],$gg[0])
EndFunc
Func _17m($n4,$n5)
Local $n3 = $n5/$n4
If Int($gp[0]*$n3) > $gg[0] Or Int($gp[1]*$n3) > $gg[1] Then Return SetError(1)
Return $n3
EndFunc
Func _17n($n3 = 0)
If $n3 Then
$gq[0] = Round($gp[0]*$n3)
$gq[1] = Round($gp[1]*$n3)
EndIf
$gn = Round(($gg[0]/2)-($gq[0]/2))
$go = Round(($gg[1]/2)-($gq[1]/2))
_17o()
EndFunc
Func _17o()
Local $jc = $gn+$gi, $jd = $go+$gj
_17p(0,0,$jc,$gg[1])
_17p(0,0,$gg[0],$jd)
_17p($jc+$gq[0],0,$gg[0]-($jc+$gq[0]),$gg[1])
_17p(0,$jd+$gq[1],$gg[0],$gg[1]-($jd+$gq[1]))
_hh($gh, $gk, $jc, $jd,$gq[0],$gq[1])
EndFunc
Func _17p($n6,$n7,$n8,$n9)
Local $4f = DllStructCreate($2m)
DllStructSetData($4f, 'Left', $n6)
DllStructSetData($4f, 'Top', $n7)
DllStructSetData($4f, 'Right', $n6+$n8)
DllStructSetData($4f, 'Bottom', $n7+$n9)
If Not _55($gf, $4f, True) Then Return SetError(1)
EndFunc
Func _17q($na,$nb,$nc,$nd,$ne)
$gr = GUICreate('',$nd,$ne,$nb,$nc,0x40000000,0,$na)
GUISetBkColor(0x000000)
$gs = GUICtrlCreateLabel('Preview',$nb,$nc,$nd,$ne,0x1+0x0200)
GUICtrlSetFont(-1, 30, 400, 0, "Tahoma")
GUICtrlSetBkColor(-1,0x000000)
GUICtrlSetColor(-1, $0)
GUISetState(@SW_SHOW,$gr)
_17h($gr)
If Not @error Then $gx = False
EndFunc
Func _17r($jc,$jd,$je,$jf)
WinMove($gr,'',$jc,$jd,$je,$jf)
EndFunc
Func _17s($nf)
If $gx Then Return
_17k()
_17j($nf)
If @error Then
Return SetError(@error)
EndIf
$gv = $nf
$gu = _17l()
If Not @error Then
$gt = $gu
Else
$gt = 1
EndIf
_17n($gt)
EndFunc
Func _17t($70 = 'Preview')
_55($gf)
ControlSetText($gr,Null,$gs,$70)
Sleep(25)
EndFunc
Func _17u()
$gv = Null
Return _17k()
EndFunc
Func _17v()
$gg = WinGetClientSize($gf)
If @error Then Return SetError(1)
If $gh Then _h7($gh)
$gh = _h6($gf)
If @error Then Return SetError(1,0,_17i())
If Not $gl Or Not $gv Then Return
$gu = _17l()
If Not @error Then
$gt = $gu
Else
$gt = 1
EndIf
_17n($gt)
EndFunc
Func _17w()
_17v()
AdlibUnRegister(_17w)
EndFunc
Func _17y()
_17u()
_17t()
DirRemove($g8,1)
For $9e = 1 To $dn[0][0]
$dn[$9e][10] = Null
Next
EndFunc
Func _17z()
If Not $dp[0] Or $dp[0] > 1 Then
_17u()
_17t()
Return
EndIf
If Not _164($dp,$dq) Then $gv = Null
If $dn[$dp[1]][8] <= 0 Then
_16f($dp[1],3)
Else
_180()
EndIf
EndFunc
Func _180()
Local Static $ng = _15z($g8)
$g7 =($g4/10000)*$dn[$dp[1]][8]
If $g7 > $dn[$dp[1]][8]-1 Then $g7 = $dn[$dp[1]][8]-1
Switch $g2
Case 0
_181( $dp[1] , Default)
Case 1
_182( $dp[1], Default)
EndSwitch
EndFunc
Func _181($jk,$nh = Default)
Local $ni = $g8&$dn[$jk][9]&'_IN_'&$g7&'.png'
Local $6c
If FileExists($ni) Then
_17s($ni)
$6c = @error
If $6c <> 1 Then Return
EndIf
If Not _164($dp,$dq) Or $6c = 1 Then _17t('Loading')
Local $aq = '-ss '&$g7&' -i "'&$dn[$jk][0]&'" -vframes 1 -y "'&$ni&'"'
If $nh = Default Then $nh = 3
Local $nj[3] = [$jk,$dn[$jk][0],$ni]
_14i( $e7 , $aq, $dn[$jk][0] , $nh , Default , Default , Null , Default , Null , Default , Null , Default , _18b , $nj)
EndFunc
Func _182($jk,$nh = Default)
If $nh = Default Then $nh = 3
Local $nk = $g5
Local $nl = $g7-$g5
If $nl < 0 Then
$nk += $nl
$nl = 0
EndIf
$nm = _160($dn[$jk][9]&_17d())
If @error Then
Return
EndIf
Local $nn = _189($nm,$g7)
If FileExists($nn) Then
_17s($nn)
Return
EndIf
Local $no = _184( $dn[$jk][10], $nm, $g7)
If $no Then
Local Const $np =($dn[$jk][10])[0][1]
Local Const $nq =(($dn[$jk][10])[$np][1])[$no][0]
Local Const $nr =(($dn[$jk][10])[$np][1])[$no][1]
_188( $jk, _18a($nm,$nq,$nr), $nk+($g7-$nq), $nn, $nh)
Return
EndIf
_17u()
_17t('Loading')
Local $ns = $g7, $nt = $g7+$g6
Local $nu = _18a( $nm, $ns, $nt)
Local $aq = '-ss '&$nl&' '& StringReplace(StringReplace(_15p($fc,'  '),'<input>', ' "'&$dn[$jk][0]&'" ',1),'<output>', ' -t '&$g5+$g6+0.5&' -y "'&$nu&'"',-1)
Local $nv = [ $jk, $dn[$jk][0] ]
Local $nw = [ $jk, $dn[$jk][0], $nu, $nm, $ns, $nt, $nk, $g7, $nn, $nh ]
_14i( $e7 , $aq, $gw , $nh , Default , Default , Null , Default , Null , Default , _183 , $nv , _185, $nw)
EndFunc
Func _183(ByRef $nx, ByRef $1w)
Local Enum $jk, $ny
_16l($1w[$jk],$1w[$ny])
If @error Then Return 1
EndFunc
Func _184(ByRef $nz,$nm,$o0)
If Not IsArray($nz) Or Not $nz[0][0] Then Return
If $nz[$nz[0][1]][0] <> $nm Then
Local $o1 = False
For $9e = 1 To $nz[0][0]
If $nz[$9e][0] = $nm Then
$nz[0][1] = $9e
$o1 = True
EndIf
Next
If Not $o1 Then Return
EndIf
For $9e = 1 To($nz[$nz[0][1]][1])[0][0]
If $o0 >=($nz[$nz[0][1]][1])[$9e][0] And $o0 <=($nz[$nz[0][1]][1])[$9e][1] Then
Return $9e
EndIf
Next
EndFunc
Func _185(ByRef $o2, ByRef $1w)
Local Enum $jk, $o3, $o4, $o5, $o6, $o7, $nk, $o8, $o9, $nh
If Not $dp[0] Or $dp[1] <> $1w[$jk] Then Return
_16l($1w[$jk],$1w[$o3])
If @error Then Return
If $o2[$ag] = $ak Then
Return _17t('Error EFFTV_1')
EndIf
If Not FileExists($1w[$o4]) Then
Return _17t('Error EFFTV_2')
EndIf
_186( $dn[$1w[$jk]][10], $1w[$o5], $1w[$o6], $1w[$o7])
_188($1w[$jk],$1w[$o4],$1w[$nk], $1w[$o9],$1w[$nh])
EndFunc
Func _186(ByRef $nz,$o5,$oa,$ob)
If Not IsArray($nz) Then
Local $9d[2][2]
$9d[0][0] = 1
$9d[0][1] = 1
$9d[1][0] = $o5
$nz = $9d
Local $9d[2][2]
$9d[0][0] = 1
$9d[1][0] = $oa
$9d[1][1] = $ob
$nz[1][1] = $9d
Return
EndIf
Local $oc = $nz[0][1]
If $nz[$oc][0] <> $o5 Then
Local $o1 = False
For $9e = 1 To $nz[0][0]
If $nz[$9e][0] = $o5 Then
$oc = $9e
$o1 = True
ExitLoop
EndIf
Next
If Not $o1 Then
$nz[0][0] += 1
ReDim $nz[$nz[0][0]+1][2]
$oc = $nz[0][0]
$nz[$oc][0] = $o5
Local $9d[1][2]
$nz[$oc][1] = $9d
EndIf
$nz[0][1] = $oc
EndIf
_187( $nz[$oc][1], $oa, $ob)
EndFunc
Func _187(ByRef $od, $oa, $ob)
$od[0][0] += 1
ReDim $od[$od[0][0]+1][2]
$od[$od[0][0]][0] = $oa
$od[$od[0][0]][1] = $ob
EndFunc
Func _188($jk,$nu,$nk, $oe,$nh)
If Not $dp[0] Or $dp[1] <> $jk Then Return
Local $aq = '-ss '&$nk&' -i "'&$nu&'" -vframes 1 -y "'&$oe&'"'
Local $nw[] = [ $jk, $dn[$jk][0], $oe ]
_14i( $e7 , $aq, $gw , $nh , Default , Default , Null , Default , Null , Default , Null , Default , _18b, $nw)
EndFunc
Func _189($nm,$o8)
Return $g8&$nm&'_OUT_'&$o8&'.png'
EndFunc
Func _18a($nm,$ns,$nt)
Return $g8&$nm&'_OUT_'&$ns&'-'&$nt&'.mp4'
EndFunc
Func _18b(ByRef $o2, ByRef $1w)
Local Enum $jk, $of, $og
_16l($1w[$jk],$1w[$of])
If @error Then Return
If Not $dp[0] Or $dp[1] <> $1w[$jk] Then Return
If $o2[$ag] = $ak Then Return _17t('Error SPFTI_1')
If Not FileExists($1w[$og]) Then Return _17t('Error SPFTI_2')
_17s($1w[$og])
EndFunc
Func _18c($je,$jf,$jc,$jd,$jb = Null)
Local Const $oh = 24, $oi = 26, $oj = 1
Local $ok = $jf-$oi
Local $ol = $jd+$ok+$oj
If $jb Then
$g9 = $jb
$ga = GUICreate('',$je, $ok, $jc, $jd, 0x40000000, 0x00000200, $jb)
WinMove($ga,'',$jc, $jd,$je, $ok)
$9d = WinGetClientSize($ga)
If IsArray($9d) Then
$je = $9d[0]
$ok = $9d[1]
EndIf
GUISetState(@SW_SHOW)
_18d(True,$je,$ok)
GUISwitch($g9)
$gb = GUICtrlCreateButton('Open Image',$jc,$ol,$je,$oh)
GUICtrlSetResizing(-1,0x0322)
GUICtrlSetFont(-1, 11, 800, 0, "Tahoma")
Else
WinMove($ga,'',$jc,$jd,$je,$ok)
$9d = WinGetClientSize($ga)
If IsArray($9d) Then
$je = $9d[0]
$ok = $9d[1]
EndIf
_18d(False,$je,$ok)
GUISwitch($g9)
GUICtrlSetPos($gb,$jc,$ol,$je,$oh)
EndIf
EndFunc
Func _18d($jz,$je,$jf)
Local Const $om = 6
Local Const $kv = 26
Local Const $on = 60
Local Const $oo = 25
Local $op = $je-$on
Local Const $oq = $kv
Local $or = $jf-$oq
Local $os = $or+2
Local Const $ot = $om/2
Local Const $ou = $om/2
Local $ov = $je-$om
Local $ow = $jf-$om-$kv
If $jz Then
$gd = GUICtrlCreateSlider(0, $or, $op, $oq, BitOR(0x0001,0x0008,0x0010))
GUICtrlSetLimit(-1,10000,0)
GUICtrlSetData(-1,$g4)
GUICtrlSetResizing(-1,0x0322)
$ge = GUICtrlCreateCombo('', $op, $os,$on,$oo,BitOR(0x3,0x40))
GUICtrlSetData(-1,'Input|Output')
Switch $g2
Case 0
$gc = 'Input'
Case 1
$gc = 'Output'
Case 2
$gc = 'Both'
EndSwitch
GUICtrlSetData(-1,$gc)
GUICtrlSetResizing(-1,0x0322)
_17q($ga,$ot,$ou,$ov,$ow)
Else
GUICtrlSetPos($gd,0, $or, $op, $oq)
GUICtrlSetPos($ge,$op, $os,$on,$oo)
_17r($ot,$ou,$ov,$ow)
EndIf
EndFunc
Func _18e()
$9d = GUICtrlRead($ge)
If $9d <> $gc Then
$gc = $9d
Switch $gc
Case 'Input'
$g2 = 0
Case 'Output'
$g2 = 1
Case 'Both'
$g2 = 2
EndSwitch
_17z()
Return
EndIf
$9d = GUICtrlRead($gd)
If $9d <> $g4 Then
$g4 = $9d
AdlibRegister(_18g,100)
EndIf
EndFunc
Func _18f()
Switch $ea[0]
Case $gb
If Not $gv Then
ToolTip('No preview was loaded')
AdlibRegister(_166,1000)
Return
EndIf
ShellExecute($gv)
EndSwitch
EndFunc
Func _18g()
_17z()
AdlibUnRegister(_18g)
EndFunc
Func _18h()
$g1 = Number(_15q('Preview','Mode',1))
Switch $g1
Case 0, 1, 2
$g2 = $g1
Case Else
$g2 = 1
EndSwitch
$g3 = Number(_15q('Preview','TimeSlider',2500))
$g4 = $g3
$g5 = Number(_15q('Preview','ProcessBefore',3))
$g6 = Number(_15q('Preview','ProcessAfter',1))
_18i()
EndFunc
Func _18i()
$g8 = $du
If StringRight($g8,1) <> '\' Then $g8 &= '\'
$g8 &= 'preview\'
EndFunc
Func _18j()
If $g2 <> $g1 Then IniWrite($dv,'Preview','Mode',$g2)
If $g4 <> $g3 Then IniWrite($dv,'Preview','TimeSlider',$g4)
EndFunc
Func _18l($jz,$k9,$k2,$ka,$kb)
Local $ox = $kb-30
Local $oy = $ox+5
Local Const $oz = 25
Local Const $p0 = 10
Local Const $p1 = 102
Local $p2 =($p0*2)+$p1
Local $p3 = $p2+$p1+$p0
If $jz Then
$gy = GUICtrlCreateListView("", $k9,$ka,$k2-$k9,$ox-$ka, BitOR(0x0001, 0x0008), BitOR(0x00000200, 0x00000001, 0x00000020))
GUICtrlSetResizing(-1,0x0322)
_v0($gy, "Source video")
_v0($gy, "% Encoded",1)
_v0($gy, "Duration")
_v0($gy, "Size")
_v0($gy, "Profile",1)
_v0($gy, "Output path")
_v0($gy, "Command")
_18m()
$gz = GUICtrlCreateButton('Add videos',$p0,$oy,$p1,$oz)
GUICtrlSetResizing(-1,0x0322)
$h0 = GUICtrlCreateButton('Remove selected',$p2,$oy,$p1,$oz)
GUICtrlSetResizing(-1,0x0322)
If Not $dp[0] Then
GUICtrlSetState(-1,128)
$h1 = 128
Else
$h1 = 64
EndIf
$h2 = GUICtrlCreateButton('Remove all',$p3,$oy,$p1,$oz)
GUICtrlSetResizing(-1,0x0322)
_190()
For $9e = 1 To $dp[0]
_zi($gy, $dp[$9e]-1, True)
Next
GUIRegisterMsg($3,_18p)
Else
GUICtrlSetPos($gy,$k9,$ka,$k2-$k9,$ox-$ka)
GUICtrlSetPos($gz,$p0,$oy,$p1,$oz)
GUICtrlSetPos($h0,$p2,$oy,$p1,$oz)
GUICtrlSetPos($h2,$p3,$oy,$p1,$oz)
EndIf
_yt($gy,$ha,-2)
EndFunc
Func _18m()
_yt($gy,$h3,-2)
If $dn[0][11] Then  _yt($gy,$h4,-2)
_yt($gy,$h5,-2)
_yt($gy,$h6,-2)
If $dm[0][0] And $dm[1][$df] Then  _yt($gy,$h7,-2)
_yt($gy,$h8,-2)
_yt($gy,$h9,465)
EndFunc
Func _18n()
GUIRegisterMsg($3,'')
GUICtrlSetState($gy,32)
GUICtrlSetState($gz,32)
GUICtrlSetState($h0,32)
GUICtrlSetState($h2,32)
EndFunc
Func _18o()
GUICtrlSetState($gy,16)
GUICtrlSetState($gz,16)
GUICtrlSetState($h0,16)
GUICtrlSetState($h2,16)
GUIRegisterMsg($3, _18p)
EndFunc
Func _18p($3n, $3o, $3p, $3q)
#forceref $3n, $3o, $3p
Local $p4, $p5, $p6, $p7, $p8, $p9
$p8 = $gy
If Not IsHWnd($gy) Then $p8 = GUICtrlGetHandle($gy)
$p7 = DllStructCreate($2n, $3q)
$p4 = HWnd(DllStructGetData($p7, "hWndFrom"))
$p5 = DllStructGetData($p7, "IDFrom")
$p6 = DllStructGetData($p7, "Code")
Switch $p4
Case $p8
Switch $p6
Case $6x
AdlibRegister(_18s,100)
$pa = DllStructCreate("int;int;int;int;uint", $3q)
If Hex(DllStructGetData($pa, 4), 2) = Hex($7x, 2) Then _18y()
Case $4, $5
_18q()
Case $6w
$p9 = DllStructCreate($2q, $3q)
Local $pb, $pc, $pd
$pb = DllStructGetData($p9, "Item")
$pc = DllStructGetData($p9, "NewState")
$pd = DllStructGetData($p9, "OldState")
If Not BitAND($pd,0x0002) And BitAND($pc,0x0002) Then
_1a8($pb+1)
ElseIf BitAND($pd,0x0002) And Not BitAND($pc,0x0002) Then
Local $pe = _j($dp,$pb+1,1)
If $pe > 0 Then
_6($dp,$pe)
$dp[0] -= 1
EndIf
EndIf
EndSwitch
EndSwitch
Return 'GUI_RUNDEFMSG'
EndFunc
Func _18q()
_17z()
If _164($dp,$dq) Then Return
$f6 = _172(True)
_18r()
$dq = $dp
EndFunc
Func _18r()
If $dp[0] Then
If $h1 <> 64 Then
GUICtrlSetState($h0,64)
$h1 = 64
EndIf
Else
If $h1 <> 128 Then
GUICtrlSetState($h0,128)
$h1 = 128
EndIf
EndIf
EndFunc
Func _18s()
_18q()
AdlibUnRegister(_18s)
EndFunc
Func _18t()
Switch $ea[0]
Case $gz
_18u()
Case $h0
_18y()
Case $h2
_18z()
EndSwitch
EndFunc
Func _18u()
_15m($ej)
Local $pf = FileOpenDialog( 'Select videos to add', $e9, 'Videos (*.avi;*.mkv;*.flv;*.mp4;*.wmv;*.divx;*.mov;*.xvid;*.mpc;*.mts) | All (*)', 1 + 4)
If Not @error Then
Local $q = StringSplit($pf,'|',1)
If $q[0] = 1 Then
$e9 = _15s($pf)
_1a1($pf)
If Not @error Then
$9d = _1a6()
If $gy Then
If $9d Then _195()
_191($dn[0][0])
EndIf
_176()
_175()
Else
MsgBox(64,'','Video already exists or unknown error')
EndIf
Else
$e9 = $q[1]
If StringRight($e9,1) <> '\' Then $e9 &= '\'
For $9e = 2 To $q[0]
_1a1($e9&$q[$9e])
If @error Then ContinueLoop
If $gy Then _191($dn[0][0])
Next
If _1a6() And $gy Then _195()
_176()
_175()
EndIf
If $gy Then _18m()
EndIf
_15n($ej)
EndFunc
Func _18v($pg,$46)
Local $ph = _12q($pg, ';*.'&StringReplace($e2,',',';*.') , 0, $46 , 0)
If Not IsArray($ph) Then Return SetError(1)
If StringRight($pg,1) <> '\' Then $pg &= '\'
For $9e = 1 To $ph[0]
_1a1($pg&$ph[$9e])
If @error Then ContinueLoop
If $gy Then _191($dn[0][0])
Next
$9d = _1a6()
If $gy Then
If $9d Then _195()
_18m()
EndIf
_176()
_175()
EndFunc
Func _18w($pi = Null, $pj = True)
GUICtrlSetState($hv,128)
If Not $pi Then
$pi = FileSelectFolder('Select folder from where to add videos',$e9)
If Not $pi Then Return GUICtrlSetState($hv,64)
EndIf
Local Enum $ia, $pk, $pl, $pm, $pn, $46, $pg, $po
Local $pp[$po]
$pp[$pg] = $pi
$e9 = $pp[$pg]
Local Const $pq = 831, $pr = 156
Local $jc = -1, $jd = -1
_16c($ej,$jc,$jd, $pq, $pr)
$pp[$ia] = GUICreate('Add videos from folder: "'&$pp[$pg]&'"', $pq, $pr, $jc,$jd, 0x00800000,0x00000080,$ej)
$pp[$pk] = GUICtrlCreateRadio("Add videos only from this folder and don't include videos from sub folders",16, 10, 633, 17)
GUICtrlSetFont(-1, 12, 800, 0, "Tahoma")
GUICtrlSetState(-1,1)
$pp[$pl] = GUICtrlCreateRadio("Add videos from this folder and from it's sub folders", 16, 42, 561, 17)
$pp[$46] = 0
GUICtrlSetFont(-1, 12, 800, 0, "Tahoma")
$pp[$pm] = GUICtrlCreateButton("Continue", 656, 8, 147, 59)
GUICtrlSetFont(-1, 12, 800, 0, "Tahoma")
GUICtrlCreateLabel("File types to include:", 16, 70, 158, 23)
GUICtrlSetFont(-1, 12, 400, 4, "Tahoma")
$pp[$pn] = GUICtrlCreateInput($e2, 16, 94, 785, 27)
GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
GUISetState(@SW_SHOW)
_18x($pp)
If $pj Then _1af(_18x)
EndFunc
Func _18x($pp = Default)
Local Static $ps
Local Enum $ia, $pk, $pl, $pm, $pn, $46, $pg, $po
If $pp <> Default Then
$ps = $pp
Return
EndIf
If $ea[1] <> $ps[$ia] Then Return
Switch $ea[0]
Case $ps[$pk]
$ps[$46] = 0
Case $ps[$pl]
$ps[$46] = 1
Case $ps[$pm]
$e2 = StringStripWS(GUICtrlRead($ps[$pn]),3)
If Not $e2 Then $e2 = $eg
GUIDelete($ps[$ia])
_18v($ps[$pg],$ps[$46])
GUICtrlSetState($hv,64)
Return True
EndSwitch
EndFunc
Func _18y()
If Not $dp[0] Then Return
GUIRegisterMsg($3,'')
_l($dp,0,1,$dp[0])
Local $pt = 0, $pu = 1, $pv = $dp[0]
While $dp[0]
_19z($dp[$pu]-$pt)
_vh($gy,$dp[$pu]-1-$pt)
$dp[0] -= 1
$pt += 1
$pu += 1
WEnd
ReDim $dp[1]
If _1a6() Then _195()
_176(True)
_172(True)
GUIRegisterMsg($3,_18p)
_17z()
EndFunc
Func _18z()
If Not $dn[0][0] Then Return
If $gy Then
GUIRegisterMsg($3,Null)
_vf($gy)
EndIf
ReDim $dn[1][12]
$dn[0][0] = 0
ReDim $dp[1]
$dp[0] = 0
$dq = $dp
_176(True)
_172(True)
If $gy Then GUIRegisterMsg($3,_18p)
_17z()
EndFunc
Func _190()
For $9e = 1 To $dn[0][0]
_191($9e)
Next
_18m()
EndFunc
Func _191($pw)
_v1($gy,'')
_192($pw)
EndFunc
Func _192($pw)
Local $px = $pw-1
_zl( $gy, $px, $dn[$pw][0], $h3)
_zl( $gy, $px, _15o($dn[$pw][7]), $h6)
_193($pw)
If $dn[$pw][2] Then
_zl( $gy, $px, $dn[$pw][2], $h7)
EndIf
_zl( $gy, $px, _1a0($pw,5), $h9)
_zl( $gy, $px, _1a4($pw), $h8)
If $dn[$pw][11] Then _194($pw)
EndFunc
Func _193($py)
Local $pz = $dn[$py][8]
If Not $pz Then Return
If $pz > 0 Then
_zl($gy,$py-1,_15x($pz),$h5)
EndIf
EndFunc
Func _194($py)
If Not $gy Then Return
_zl( $gy, $py-1, $dn[$py][11], $h4)
If Not $dn[0][11] Then
_yt($gy,$h4,-2)
$dn[0][11] = True
EndIf
EndFunc
Func _195()
For $9e = 1 To $dn[0][0]
If $hb = $dn[$9e][0] Then ContinueLoop
_zl( $gy, $9e-1, _1a4($9e), $h8)
Next
EndFunc
Func _196($jk,$mp)
If Not $gy Then Return
Switch $mp
Case 4,6,3
_zl( $gy, $jk-1, _1a4($jk), $h8)
Case 5
_zl( $gy, $jk-1, $dn[$jk][5], $h9)
EndSwitch
EndFunc
Func _197()
If Not $gy Then Return
For $9e = 1 To $dn[0][0]
If $dn[$9e][2] Then ContinueLoop
_198($9e)
Next
EndFunc
Func _198($jk)
_zl( $gy, $jk-1, _1a4($jk), $h8)
_zl( $gy, $jk-1, $dn[0][5], $h9)
EndFunc
Func _199()
GUICtrlSetState($ek,128)
$hm = GUICreate(Null, 588, 368,-1,-1,-1,-1)
GUISetBkColor(0xdae8ed,$hm)
$hn = GUICtrlCreateProgress(8, 32, 577, 25)
GUICtrlCreateLabel('Total progress:', 8, 14, 570, 17)
$ho = GUICtrlCreateProgress(8, 58, 577, 14)
$hp = GUICtrlCreateEdit('', 8, 104, 577, 217,BitOR($a,2048))
GUICtrlSendMsg($hp, $6, -1, 0)
GUICtrlSetBkColor(-1,0xc6ea77)
GUICtrlCreateLabel("ffmpeg basic output:", 8, 80, 208, 17)
$hq = GUICtrlCreateButton("Abort", 8, 328, 409, 33)
$hr = GUICtrlCreateButton('Suspend', 424, 328, 75, 33)
GUICtrlSetTip(-1,'Experimental, do not use!','Warning!')
$hs = GUICtrlCreateButton("Skip this video", 504, 328, 78, 33)
GUICtrlSetState(-1,128)
GUISetState(@SW_SHOW,$hm)
$q0 = True
EndFunc
Func _19a()
GUIDelete($hm)
$hm = -1
GUICtrlSetState($ek,64)
EndFunc
Func _19b()
Switch $ea[0]
Case $hq, -3
If Not $hc Then
_14n('EncoderJOB')
_19a()
Else
_15m($ej)
If MsgBox(4,'Still encoding', 'I still encoding the video'&@CRLF&$dn[$hc][1]&@CRLF& 'Are you sure you wand to cancel the encoding ?', 0,$hm) = 6 Then
_19a()
_14n('EncoderJOB')
_19d(@CRLF&@CRLF&'Encoding canceled',2,0,False)
$dn[$hc][11] &= ' (Canceled)'
$dn[0][11] = Null
_194($hc)
$hc = Null
$hb = Null
EndIf
_15n($ej)
WinActivate($hm)
EndIf
Case $hs
_15m($ej)
If MsgBox(4,'Are you sure?', 'Are you sure you want to skip encoding'&@CRLF&$dn[$hc][1]&@CRLF& '?', 0,$hm) = 6 Then
_19d(@CRLF&@CRLF&'Skipping video "'&$dn[$hc][1]&'"',2)
$dn[$hc][11] &= ' (Skipped)'
$dn[0][11] = Null
_194($hc)
_19h()
EndIf
_15n($ej)
WinActivate($hm)
Case $hr
If Not $hl Then
_14q(True,4+1)
If @error Then Return
GUICtrlSetData($hr,'Resume')
$hl = True
Else
_14q(False,4+1)
If @error Then Return
GUICtrlSetData($hr,'Suspend')
$hl = False
EndIf
EndSwitch
EndFunc
Func _19c($jk = $hc)
If Not $hc Then Return
If $hc <> $jk Then Return
_15m($ej)
If MsgBox(4,'Message - "'&$dn[$hc][1]&'"', 'If you changed the encoding settings to video - "'&$dn[$hc][1]&'"'&@CRLF&@CRLF& $dn[$hc][0]&@CRLF&@CRLF& 'You need to restart the encoding process of this video.'&@CRLF&@CRLF& 'Do you want to restart the encoding?', 0,$hm) = 6 Then
_19d(Null,2)
_19e(False)
EndIf
_15n($ej)
WinActivate($hm)
EndFunc
Func _19d($70,$q1 = 1,$q2 = 0, $q3 = True)
If $q2 Then
Local $q4 = StringSplit($70,@CRLF,1)
If $q4[0] = 1 Then
$70 = _165(' ',$q2*5)&$70
Else
$70 = ''
For $9e = 1 To $q4[0]
$70 &= _165(' ',$q2*5)&$q4[$9e]
If $9e < $q4[0] Then $70 &= @CRLF
Next
EndIf
EndIf
For $9e = 1 To $q1
$70 &= @CRLF
Next
If Not $q3 Then Return $70
Local $1f = StringLen(GUICtrlRead($hp))
_12h($hp, $1f, $1f)
_124($hp, 4)
GUICtrlSetData($hp,$70,$1f)
Return $70
EndFunc
Func _19e($q5)
_14n('EncoderJOB')
Sleep(500)
If FileDelete($he) Then
_19d('restart encoding "'&$dn[$hc][1]&'"',2)
$dn[$hc][11] = Null
_194($hc)
_19h($q5)
Else
_19d(@CRLF&@CRLF&'ERROR: could not delete the video -> skipping to next video.',2)
_19h()
EndIf
EndFunc
Func _19f()
$hg = 0
$hl = False
_199()
_19d( 'Start encoding '&$dn[0][0]&' videos'&@CRLF& ' (The number of videos can change if you add/delete videos during encoding)' , 2)
Local $q6 = True
$hi = -1
For $9e = 1 To $dn[0][0]
If $dn[$9e][11] Then
$dn[$9e][11] = Null
_194($9e)
EndIf
If $q6 Then
$9d = _1a4($9e)
If FileExists($9d) Then
_15m($ej)
If MsgBox(4,'Message','Some files already exist.'&@CRLF&'Do you want to overwite them?',0,$hm) = 6 Then
$hi = 1
Else
$hi = 0
EndIf
_15n($ej)
WinActivate($hm)
$q6 = False
EndIf
EndIf
Next
_19h()
EndFunc
Func _19g()
_14n('EncoderJOB')
GUICtrlSetState($hs,128)
GUICtrlSetState($hr,128)
GUICtrlSetData($hq,'Close')
WinSetTitle($hm,Null,'Done')
_15l()
Return 2
EndFunc
Func _19h($q7 = False,$q8 = 4)
WinSetTitle($hm,Null,'Encoding ...')
If Not $q7 Then
_15l()
For $9e = 1 To $dn[0][0]
If $dn[$9e][11] Then ContinueLoop
$hc = $9e
ExitLoop
Next
If Not $hc Then Return _19g()
$dn[$hc][11] = '?'
_194($hc)
$hb = $dn[$hc][0]
Local $q9 = _1a3($hc)
_15z($q9)
$hd = _1a2($hc)
If StringRight($q9,1) <> '\' Then $q9 &= '\'
$he = $q9&$hd
If _16b($hb,$he) Then
_19d("Error: input path can't be the same as the output path -> skipping video (encoding failed)",2,1)
$dn[$hc][11] = 'Error - skipped'
_194($hc)
Return _19h()
EndIf
_19d('File: '&$hd&' (output name)',2,0)
If FileExists($he) Then
Local $qa
Switch $hi
Case 1
$qa = True
Case -1
_15m($ej)
If MsgBox(4,'Message','Overwrite file:'&@CRLF&$he&@CRLF&'?'&@CRLF& '(Message will close in 10 seconds with the answer "NO")',10) = 6 Then $qa = True
_15n($ej)
WinActivate($hm)
Case 0
$qa = False
EndSwitch
If $qa Then
If Not FileDelete($he) Then
_19d('Error: could not delete the file. skipping video (encoding failed)',2,1)
$dn[$hc][11] = 'Error - skipped'
_194($hc)
Return _19h()
EndIf
Else
$dn[$hc][11] = 'Skipped'
_194($hc)
_19d('Video file already exists -> skipped.',2,1)
Return _19h()
EndIf
EndIf
EndIf
GUICtrlSetData($ho,0)
Local $aq = $dn[$hc][5]
If Not $aq Then $aq = $dn[0][5]
$aq = StringReplace(StringReplace($aq,'<input>','"'&$dn[$hc][0] &'"',1),'<output>','"'&$he&'"',1)
_14i( $e7 , $aq , 'EncoderJOB' , $q8 , -2 , False , _19i , $aq , _19j , Default , _19k , Default , _19l , Default)
EndFunc
Func _19i($aq)
_16l($hc,$hb)
If @error Then Return _19h()
Local Static $qb
Local Const $qc = 10
If $dn[$hc][8] <= 0 Then
$qb += 1
If $qb <= $qc Then
_19d('Getting duration (Attempt '&$qb&' of '&$qc&')',1,1)
_16f($hc,$al[0][$a6])
Else
_19d('Error getting the video duration skipping video (encoding failed)',1,1)
_19h()
$qb = 0
EndIf
Return 2
EndIf
$qb = 0
_19d('Command: "'&$aq&'"',1,1)
_19d('Input file: "'&$dn[$hc][0]&'"',1,1)
_19d('Size: '&_15o($dn[$hc][7]),1,2)
_19d('Duration: '&_15x($dn[$hc][8]),1,2)
_19d('Output file: "'&$hd&'"',2,1)
_19d('Running ffmpeg:',2,0)
EndFunc
Func _19j(ByRef $jn)
_16l($hc,$hb)
If @error Then
_19h()
Return 2
EndIf
If $jn[$ag] Then
_19d('Error',2,1)
_14m()
Return 2
EndIf
GUICtrlSetState($hs,64)
$hj = GUICtrlRead($hp)
$hk = StringLen($hj)
$hh = TimerInit()
EndFunc
Func _19k(ByRef $b8)
If Not $b8 Then
If Not $hl Then
If TimerDiff($hh) > 3600000 Then
$hf += 1
_19d('Error: could not get output from ffmpeg for more than 1 minute -> attempt number '&$hf&' of 3',0,1)
If $hf <= 3 Then
_19d('attempt number '&$hf&' of 3: ',0,1)
Return _19e(True)
Else
_16l($hc,$hb)
If Not @error Then
_19d(@CRLF&'too many attempts -> skipping video (failed to encode video)',1,1)
$dn[$hc][11] &= ' (skipped)'
$dn[0][11] = Null
_194($hc)
_19h()
EndIf
Return 2
EndIf
EndIf
EndIf
Return
Else
If $hl Then _14q($hl,4+1)
EndIf
$hh = TimerInit()
_16l($hc,$hb)
If @error Then
_19h()
Return 2
EndIf
$9d = _16a($b8, 'time')
If Not @error Then
$9d = _15y($9d)
If Not @error Then
$j8 = Round(($9d/$dn[$hc][8])*100,3)&'%'
If $j8 <> $dn[$hc][11] Then
$dn[$hc][11] = $j8
_194($hc)
WinSetTitle($hm,Null, $j8&' , File '&$hg+1&'/'&$dn[0][0]&' , "'&$dn[$hc][1]&'"')
EndIf
GUICtrlSetData($ho,($9d/$dn[$hc][8])*100)
EndIf
EndIf
$9d = _19d($b8,1,3,False)
GUICtrlSetData($hp,$hj&$9d)
_12h($hp, $hk, $hk)
_124($hp, 4)
EndFunc
Func _19l(ByRef $jn)
_16l($hc,$hb)
If @error Then
_19h()
Return 2
EndIf
If _168($dn[$hc][11]) >= 99 Then
$dn[$hc][11] = '100%'
_194($hc)
EndIf
$hg += 1
GUICtrlSetData($hn,($hg/$dn[0][0])*100)
GUICtrlSetData($ho,100)
_19d( 'Size: '&_15o($dn[$hc][7])&' - > '&_15o(FileGetSize($he)), 2,1)
_19h()
EndFunc
Func _19m($qd)
_14t()
Local $qe = _14y('DefaultSettings')
_14x(Null, 'OutputFolder',$dn[0][3],$qe)
_14x(Null, 'OutputName',$dn[0][4],$qe)
_14x(Null, 'Command',$dn[0][5],$qe)
_14x(Null, 'OutContainer',$dn[0][6],$qe)
If $dm[0][0] Then
Local $qf = _14y('Profiles')
For $9e = 1 To $dm[0][0]
_14x(Null, $dm[$9e][$de], _19n($9e), $qf)
Next
EndIf
If $dn[0][0] Then
Local $qg[$dn[0][0]]
For $9e = 0 To UBound($qg)-1
$qg[$9e] = _19o($9e+1)
Next
$qh = _153('Videos')
_154($qh,$qg, 0)
EndIf
Local $qi = _157()
_14t()
Local $qj = FileOpen($qd,2+8)
If $qj = -1 Then Return SetError(1)
If Not FileWrite($qj,$qi) Then SetError(2)
FileClose($qj)
EndFunc
Func _19n($qk)
Local $c5
$c5 &= 'VidCount='&$dm[$qk][$df]
$c5 &= '|@|Command='&$dm[$qk][$dg]
$c5 &= '|@|OutputName='&$dm[$qk][$dh]
$c5 &= '|@|OutputFolder='&$dm[$qk][$di]
$c5 &= '|@|OutContainer='&$dm[$qk][$dj]
Return $c5
EndFunc
Func _19o($ql)
Local $c5
$c5 = 'Path='&$dn[$ql][0]
If $dn[$ql][2] Then $c5 &= '|@|profile='&$dn[$ql][2]
If $dn[$ql][8] Then $c5 &= '|@|duration='&$dn[$ql][8]
If $dn[$ql][11] Then $c5 &= '|@|status='&$dn[$ql][11]
Return $c5
EndFunc
Func _19p($qm)
Local $qn = FileRead($qm)
If @error Then Return SetError(1)
_14s($qn)
If $dn[0][0] Then _18z()
$9d = _14u('DefaultSettings')
$dn[0][3] = _14v(Null,'OutputFolder','?_Converted\|',$9d)
$dn[0][4] = _14v(Null,'OutputName','?.x265',$9d)
$dn[0][5] = _14v(Null,'Command',$e6,$9d)
$dn[0][6] = _14v(Null,'OutContainer','.mp4',$9d)
If $dm[0][0] Then
$dm[0][0] = 0
ReDim $dm[1][$dk]
EndIf
$9d = _14u('Profiles')
Local $qo = _14w($9d)
Local $qp = _14z('Videos')
If $qp = -1 Then Return
Local $qq = _150($qp)
If Not $qq[0] Then Return
Local $6c, $qr, $qs, $qt, $qu
For $9e = 1 To $qq[0]
$9d = StringReplace($qq[$9e],'|@|',@CRLF)
_14s($9d)
$qr = _14v(Null,'Path',Null,0)
If Not $qr Then
$6c = 2
ContinueLoop
EndIf
$qs = Number(_14v(Null,'duration',-1,0))
If $qs = -1 Then
_1a1($qr)
Else
_1a1($qr,$qs)
EndIf
If @error Then
$6c = 2
ContinueLoop
EndIf
$qu = _14v(Null,'status',Null,0)
If $qu Then
$dn[$dn[0][0]][11] = $qu
$dn[0][11] = True
EndIf
$qt = _14v(Null,'profile',Null,0)
If Not $qt Then ContinueLoop
Local $qv = _j($dm,$qt,1,$dm[0][0],0,0,1,$de)
If $qv <= 0 Then
$9d = _j($qo,$qt,1,$qo[0][0],0,0,1,0)
If $9d = -1 Then ContinueLoop
$j8 = StringReplace($qo[$9d][1],'|@|',@CRLF)
_14s($j8)
$dm[0][0] += 1
ReDim $dm[$dm[0][0]+1][$dk]
$qv = $dm[0][0]
$dm[$qv][$de] = $qt
$dm[$qv][$df] = _14v(Null,'VidCount',Null,0)
$dm[$qv][$dg] = _14v(Null,'Command',Null,0)
$dm[$qv][$dh] = _14v(Null,'OutputName',Null,0)
$dm[$qv][$di] = _14v(Null,'OutputFolder',Null,0)
$dm[$qv][$dj] = _14v(Null,'OutContainer',Null,0)
EndIf
$dn[$dn[0][0]][2] = $qt
$dn[$dn[0][0]][5] = $dm[$qv][$dg]
$dn[$dn[0][0]][4] = $dm[$qv][$dh]
$dn[$dn[0][0]][3] = $dm[$qv][$di]
$dn[$dn[0][0]][6] = $dm[$qv][$dj]
Next
_1a6()
If $gy Then _190()
_14t()
_176(True)
_172(True)
Return SetError($6c)
EndFunc
Func _19q()
Local Enum $ia, $qw, $qx, $qy, $po
Local $pp[$po]
_15m($ej)
GUICtrlSetState($i0,128)
Local Const $pq = 486, $pr = 131
Local $jc = -1, $jd = -1
_16c($ej,$jc,$jd, $pq, $pr)
$pp[$ia] = GUICreate("Set the FFmpeg bin folder path",$pq,$pr, $jc, $jd,-1,-1,$ej)
GUICtrlCreateLabel("Write here the path to where ffmpeg.exe and ffprobe.exe located:", 8, 16, 468, 23)
GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
$pp[$qw] = GUICtrlCreateInput($dw, 8, 48, 361, 21)
$pp[$qx] = GUICtrlCreateButton("Done", 168, 88, 145, 33)
GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
$pp[$qy] = GUICtrlCreateButton("Browse", 384, 47, 83, 25)
GUISetState(@SW_SHOW)
_19r($pp)
_1af(_19r)
EndFunc
Func _19r($pp = Default)
Local Enum $ia, $qw, $qx, $qy, $po
Local Static $ps
If $pp <> Default Then
$ps = $pp
Return
EndIf
If $ea[1] <> $ps[$ia] Then Return
Switch $ea[0]
Case $ps[$qy]
$9d = FileSelectFolder('Select the folder where ffmpeg.exe and ffprobe.exe located',@ScriptDir)
If Not $9d Then Return
GUICtrlSetData($ps[$qw],$9d)
Case $ps[$qx]
$9d = StringStripWS(GUICtrlRead($ps[$qw]),3)
If Not $9d Then Return _167($ps[$ia], $ps[$qw], 'Error: Nothing written here')
If StringRight($9d,1) <> '\' Then $9d &= '\'
$j8 = $9d&'ffmpeg.exe'
If Not FileExists($j8) Then Return _167($ps[$ia], $ps[$qw], 'Error: ffmpeg.exe not found in this folder')
$e7 = $j8
$j8 = $9d&'ffprobe.exe'
If Not FileExists($j8) Then Return _167($ps[$ia], $ps[$qw], 'Error: ffmpeg.exe found, but not ffprobe.exe'&@CRLF&'You need also ffprobe.exe')
$e8 = $j8
$dw = $9d
IniWrite($dv,'Main','FFmpegBinFolder',$dw)
ContinueCase
Case -3
_166()
GUIDelete($ps[$ia])
GUICtrlSetState($i0,64)
$9d = $dw
If StringRight($9d,1) <> '\' Then $9d &= '\'
If Not FileExists($9d&'ffmpeg.exe') Or Not FileExists($9d&'ffprobe.exe') Then _1ai()
_15n($ej)
Return True
EndSwitch
EndFunc
Func _19s()
Local Enum $ia, $qz, $qx, $qy, $po
Local $pp[$po]
GUICtrlSetState($i1,128)
Local Const $pq = 486, $pr = 131
Local $jc = -1, $jd = -1
_16c($ej,$jc,$jd, $pq, $pr)
$pp[$ia] = GUICreate("Set folder for temporary files", $pq, $pr, $jc, $jd,-1,-1,$ej)
GUICtrlCreateLabel("Write here the path to where the temporary files will be stored", 8, 16, 445, 23)
GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
$pp[$qz] = GUICtrlCreateInput($du, 8, 48, 361, 21)
$pp[$qx] = GUICtrlCreateButton("Done", 168, 88, 145, 33)
GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
$pp[$qy] = GUICtrlCreateButton("Browse", 384, 47, 83, 25)
GUISetState(@SW_SHOW)
_19t($pp)
_1af(_19t)
EndFunc
Func _19t($pp = Default)
Local Enum $ia, $qz, $qx, $qy, $po
Local Static $ps
If $pp <> Default Then
$ps = $pp
Return
EndIf
If $ea[1] <> $ps[$ia] Then Return
Switch $ea[0]
Case $ps[$qy]
$9d = FileSelectFolder('Select the folder where the temporary files will be stored',@ScriptDir)
If Not $9d Then Return
GUICtrlSetData($ps[$qz],$9d)
Case $ps[$qx]
$9d = StringStripWS(GUICtrlRead($ps[$qz]),3)
If Not $9d Then Return _167($ps[$ia], $ps[$qz], 'Error: Nothing written here')
$9d = StringReplace($9d,$ds,@ScriptDir,1)
If StringRight($9d,1) <> '\' Then $9d &= '\'
If $9d = @ScriptDir&'\' Then Return _167($ps[$ia], $ps[$qz], "Error: temp folder can't be the software folder")
If $9d <> $du Then
$du = $9d
_17y()
_18i()
_15z($g8)
_17z()
IniWrite($dv,'Main','TempDir',StringReplace($du,@ScriptDir,$ds,1))
EndIf
ContinueCase
Case -3
_166()
GUIDelete($ps[$ia])
GUICtrlSetState($i1,64)
Return True
EndSwitch
EndFunc
Func _19u()
Local Enum $ia, $r0, $r1, $qx, $po
Local $pp[$po]
GUICtrlSetState($i3,128)
Local Const $pq = 609, $pr = 120
Local $jc = -1, $jd = -1
_16c($ej,$jc,$jd, $pq, $pr)
$pp[$ia] = GUICreate("Output preview settings", $pq, $pr, $jc, $jd,-1,-1,$ej)
GUICtrlCreateLabel("Seconds to encode before the requested time:", 8, 16, 337, 23)
GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
GUICtrlCreateLabel("The bigger the number, the bigger accuracy of the preview (in case the video compression algorithm use motion)", 24, 44, 413, 36)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
GUICtrlSetColor(-1, 0x0066CC)
$pp[$r0] = GUICtrlCreateInput($g5, 352, 14, 89, 27, BitOR(0x00000080,8192))
GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
GUICtrlCreateLabel("Seconds to encode after the requested time:", 8, 80, 316, 23)
GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
$pp[$r1] = GUICtrlCreateInput($g6, 352, 78, 89, 27, BitOR(0x00000080,8192))
GUICtrlSetFont(-1, 12, 400, 0, "Tahoma")
$pp[$qx] = GUICtrlCreateButton("Done", 464, 12, 129, 97)
GUICtrlSetFont(-1, 20, 400, 0, "Tahoma")
GUISetState(@SW_SHOW)
_19v($pp)
_1af(_19v)
EndFunc
Func _19v($pp = Default)
Local Enum $ia, $r0, $r1, $qx, $po
Local Static $ps
If $pp <> Default Then
$ps = $pp
Return
EndIf
If $ea[1] <> $ps[$ia] Then Return
Switch $ea[0]
Case $ps[$qx]
Local Const $r2 = "Error: can't be 0 or empty"
Local $r3 = Number(GUICtrlRead($ps[$r0]))
If Not $r3 Then Return _167($ps[$ia], $ps[$r0],$r2)
Local $r4 = Number(GUICtrlRead($ps[$r1]))
If $r3 <> $g5 Or $r4 <> $g6 Then
_17y()
_15z($g8)
If $r3 <> $g5 Then
$g5 = $r3
IniWrite($dv,'Preview','ProcessBefore',$r3)
EndIf
If $r4 <> $g6 Then
$g6 = $r4
IniWrite($dv,'Preview','ProcessAfter',$r4)
EndIf
EndIf
ContinueCase
Case -3
_166()
GUIDelete($ps[$ia])
GUICtrlSetState($i3,64)
Return True
EndSwitch
EndFunc
Func _19w($r5 = True)
Local Enum $r6, $r7, $r8, $po
Local $pp[$po]
$pp[$r6] = GUICreate('Easy265File' & ' - EULA', 586, 479)
GUICtrlCreateEdit(Null, 16, 56, 553, 353, BitOR(64, 128, 2048, 4096, 0x00200000, 0x00100000))
GUICtrlSetBkColor(-1, 0xF0F5F7)
GUICtrlSetData(-1, _159('License'))
GUICtrlCreateLabel('End User License Agreement (EULA)', 16, 8, 552, 37, 0x1)
GUICtrlSetFont(-1, 20, 400, 4, "Tahoma")
GUICtrlSetColor(-1, 0xFF0000)
$pp[$r7] = GUICtrlCreateButton('Agree', 144, 424, 107, 41)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
$pp[$r8] = GUICtrlCreateButton('Disagree', 326, 424, 107, 41)
If $e4 Then GUICtrlSetState(-1, 128)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
_19x($pp)
If Not $r5 Then Return
_1af(_19x)
EndFunc
Func _19x($pp = Default)
Local Enum $r6, $r7, $r8, $po
Local Static $ps
If $pp <> Default Then
$ps = $pp
Return
EndIf
If $ea[1] <> $ps[$r6] Then Return
Switch $ea[0]
Case $ps[$r7]
If Not $e4 Then
$e4 = 1
IniWrite($dv,'Main','AgreLicense',$e4)
EndIf
ContinueCase
Case -3
If $ea[0] = -3 And Not $e4 Then ContinueCase
GUIDelete($ps[$r6])
If $ej <> -1 Then GUICtrlSetState($i7,64)
Return True
Case $ps[$r8]
MsgBox(48, "", "In order to use the software, you must agree to the terms of use.", 0, $r6)
_1ai()
EndSwitch
EndFunc
Func _19y()
$dn[0][0] += 1
ReDim $dn[$dn[0][0]+1][12]
EndFunc
Func _19z($r9)
$dn[0][0] -= 1
Return _6($dn,$r9)
EndFunc
Func _1a0($b3,$ra)
If $b3 > $dn[0][0] Then Return SetError(1)
If Not $dn[$b3][$ra] Then Return $dn[0][$ra]
Return $dn[$b3][$ra]
EndFunc
Func _1a1($rb, $pz = Default)
Local $rc = FileGetSize($rb)
If Not $rc Then Return SetError(1)
If $dn[0][0] And _j($dn,$rb,1,$dn[0][0],0,0,1,0) <> -1 Then Return SetError(2)
_19y()
$dn[$dn[0][0]][0] = $rb
$dn[$dn[0][0]][7] = $rc
If @error Then $dn[$dn[0][0]][7] = -1
$dn[$dn[0][0]][1] = _15r($rb)
$dn[$dn[0][0]][9] = _160($rb)
If $pz = Default Then
_16f($dn[0][0], 0)
Else
$dn[$dn[0][0]][8] = $pz
EndIf
EndFunc
Func _1a2($ql,$rd = Default,$re = Default)
If $ql > $dn[0][0] Then Return SetError(1)
If $rd = Default Then $rd = $dn[$ql][4]
If $re = Default Then $re = $dn[$ql][6]
Local $rf = _15v($dn[$ql][1])
Local $rg = StringTrimRight($dn[$ql][1],StringLen($rf)+1)
If Not $rd Then $rd = $dn[0][4]
Local $39 = StringReplace($rd,'?',$rg,1)
If Not $re Then $re = $dn[0][6]
If Not $re Then $re = '.'&$rf
Return $39&$re
EndFunc
Func _1a3($ql,$rh = Default)
If $ql > $dn[0][0] Then Return SetError(1)
If $rh = Default Then $rh = $dn[$ql][3]
If Not $rh Then $rh = $dn[0][3]
Local $ri = $dn[$ql][0]
$rh = StringReplace($rh,'?',$do,1)
Local $rj
If StringLeft($ri,StringLen($do)) = $do Then
$rj = StringTrimRight($ri,StringLen($dn[$ql][1])+1)
$rj = StringTrimLeft($rj,StringLen($do)+1)
Else
$9d = StringSplit($ri,':\',1)
If $9d[0] = 2 Then
$rj = StringTrimRight($9d[2],StringLen($dn[$ql][1])+1)
Else
$rj = $ee
EndIf
EndIf
$rh = StringReplace($rh,'|',$rj,1)
Return $rh
EndFunc
Func _1a4($ql)
If $ql > $dn[0][0] Then Return SetError(1)
$9d = _1a3($ql)
If StringRight($9d,1) <> '\' Then $9d &= '\'
Return $9d&_1a2($ql)
EndFunc
Func _1a6()
Local $rk = $do
$do = ''
If $dn[0][0] Then
Local $rl = StringSplit($dn[1][0],'\',1)
ReDim $rl[$rl[0]]
$rl[0] -= 1
Local $rm
For $9e = 2 To $dn[0][0]
$rm = StringSplit($dn[$9e][0],'\',1)
$rm[0] -= 1
If $rm[0] <> $rl[0] Then
If $rm[0] > $rl[0] Then
$rm[0] = $rl[0]
Else
$rl[0] = $rm[0]
EndIf
EndIf
For $ms = $rm[0] To 2 Step -1
If $rm[$ms] <> $rl[$ms] Then $rl[0] = $ms-1
Next
Next
If $rl[0] Then
If $rl[0] = 1 Then
$do = $rl[1]&'\'&$ee
Else
For $9e = 1 To $rl[0]
$do &= $rl[$9e]
If $9e < $rl[0] Then $do &= '\'
Next
EndIf
Else
$do = 'C:\'&$ee
SetError(1)
EndIf
Else
$do = 'C:\'&$ee
EndIf
If $rk <> $do Then
Return True
Else
Return False
EndIf
EndFunc
Func _1a8($b3)
_0($dp,$b3)
$dp[0] += 1
EndFunc
Func _1ab()
ReDim $dp[1]
$dp[0] = 0
EndFunc
Func _1ac($rn,$ql,$ro = 1)
$dm[0][0] += 1
ReDim $dm[$dm[0][0]+1][$dk]
$dm[$dm[0][0]][$de] = $rn
$dm[$dm[0][0]][$dg] = $dn[$ql][5]
$dm[$dm[0][0]][$dh] = $dn[$ql][4]
$dm[$dm[0][0]][$di] = $dn[$ql][3]
$dm[$dm[0][0]][$dj] = $dn[$ql][6]
$dm[$dm[0][0]][$df] = $ro
EndFunc
Func _1ad($rn)
Local $rp = _j($dm,$rn,1,$dm[0][0],0,0,1,$de)
If $rp <= 0 Or Not $dm[$rp][$df] Then Return
$dm[$rp][$df] -= 1
EndFunc
Func _1ae()
For $9e = 1 To $dm[0][0]
$dm[$9e][$df] = 0
For $ms = 1 To $dn[0][0]
If $dn[$ms][2] <> $dm[$9e][$de] Then ContinueLoop
$dm[$9e][$df] += 1
Next
Next
_l($dm,1,1,$dm[0][0],$df)
EndFunc
Func _1af($rq)
_0($dr,$rq)
$dr[0] += 1
EndFunc
Func _1ag()
If Not $dr[0] Then Return
Local $9e = 1
Do
If Not $dr[$9e]() Then
$9e += 1
Else
_6($dr,$9e)
$dr[0] -= 1
EndIf
Until $9e > $dr[0]
EndFunc
_16n()
_16d()
If Not $e4 Then
_19w(False)
Do
$ea = GUIGetMsg(1)
Until _19x()
EndIf
_18h()
_16q()
_16k()
_n1()
_16m()
$ej = GUICreate('Easy265File'&' v'&'1.0.0-alpha', $ez, $f0,-1,-1,$2, 0x00000010)
$ht = GUICtrlCreateMenu('File')
$hu = GUICtrlCreateMenuItem('Add video(s)',$ht)
$hv = GUICtrlCreateMenuItem('Add folder',$ht)
GUICtrlCreateMenuItem(Null,$ht)
$hw = GUICtrlCreateMenuItem('Save tasks',$ht)
$hx = GUICtrlCreateMenuItem('Load tasks',$ht)
GUICtrlCreateMenuItem(Null,$ht)
$hy = GUICtrlCreateMenuItem('Exit',$ht)
$hz = GUICtrlCreateMenu('Options')
$i0 = GUICtrlCreateMenuItem('Change FFmpeg folder',$hz)
GUICtrlCreateMenuItem(Null,$hz)
$i1 = GUICtrlCreateMenuItem('Change TEMP folder',$hz)
$i2 = GUICtrlCreateMenuItem('Clean TEMP folder',$hz)
GUICtrlCreateMenuItem(Null,$hz)
$i3 = GUICtrlCreateMenuItem('Output preview settings',$hz)
$i4 = GUICtrlCreateMenu('Help')
$i5 = GUICtrlCreateMenuItem('Donate ',$i4)
GUICtrlCreateMenuItem(Null,$i4)
$i6 = GUICtrlCreateMenuItem('About',$i4)
$i7 = GUICtrlCreateMenuItem('License',$i4)
GUICtrlCreateMenuItem(Null,$i4)
$i8 = GUICtrlCreateMenuItem('Website',$i4)
$i9 = GUICtrlCreateMenuItem('Check for updates',$i4)
If $er Then GUISetState(@SW_MAXIMIZE,$ej)
_16s(True)
_16v()
_172(True)
GUISetState(@SW_SHOW,$ej)
_17z()
GUIRegisterMsg(0x0005, _16h)
GUIRegisterMsg(0x0024,_16i)
GUIRegisterMsg(0x0233, _16j)
If Not FileExists($e7) Or Not FileExists($e8) Then _19q()
Local $rr
While 1
_1ah()
WEnd
Func _1ah()
_14j()
$ea = GUIGetMsg(1)
Switch $ea[1]
Case $f2
_17c()
Case $ga, $g9
_18f()
If $ea[1] = $ej Then ContinueCase
Case $ej
Switch $ea[0]
Case $hu
_18u()
Case $hv
_18w()
Case $hw
GUICtrlSetState($hw,128)
_15m($ej)
$9d = FileSaveDialog('Select where to save the tasks file', $e9, 'Tasks (*.e265tasks)', 16,'Saved tasks')
If Not @error Then
$e9 = $9d
_19m($e9)
If @error Then MsgBox(16,'Error','Error saving the tasks file.'&@CRLF&'Error code: '&@error)
EndIf
GUICtrlSetState($hw,64)
_15n($ej)
Case $hx
GUICtrlSetState($hx,128)
_15m($ej)
$9d = FileOpenDialog('Select the tasks file to load', $e9, 'Tasks (*.e265tasks)', 1)
If Not @error Then
If Not $dn[0][0] Or MsgBox(3, '', 'You have some tasks (videos) in the list. if you continue, it will overwrite these tasks.'&@CRLF& 'Select yes to continue') = 6 Then
_19p($9d)
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
GUICtrlSetState($hx,64)
_15n($ej)
Case $i0
_19q()
Case $i1
_19s()
Case $i2
_16m()
For $9e = 1 To $dn[0][0]
$dn[$9e][10] = Null
Next
_17z()
Case $i3
_19u()
Case $i5
ShellExecute($ec)
Case $i8
ShellExecute($eb)
Case $i9
ShellExecute($ed)
Case $i6
_15i(64, 'About', 'Version: v'&'1.0.0-alpha'&@CRLF& 'Website: easy265file.blogspot.com'&@CRLF& 'Developed by gileli121@gmail.com / gil900'&@CRLF&@CRLF& 'NO WARRANTY ON ANY DAMAGE!' )
Case $i7
GUICtrlSetState($i7,128)
_19w()
Case -3, $hy
_1ai()
Case $ek
If Not $dn[0][0] Then Return MsgBox(64,Null,'Please add at least 1 video',0,$ej)
_19f()
Case $el
Local $rs, $rt,$ru,$rv,$rw
$rs = WinGetPos($ej)
If Not @error Then
$rt = $rs[0]
$ru = $rs[1]
$rv = $rs[2]
$rs[3] -= $ev
If $et Then
$rw = $rs[3]*(380/621)
$et = 0
Else
$rw = $rs[3]*(621/380)
$et = 1
EndIf
$rw = Round($rw)+$ev
Local $rx = _161()[1]
$9d = $ru+$rw
If $9d > $rx Then
$ru -= $9d-$rx
If $ru < 0 Then
$rw += $ru
$ru = 0
EndIf
EndIf
Else
If $et Then
$rw = 380+$ev
$rv = 797+$eu
$et = 0
Else
$rw = 621+$ev
$rv = 797+$eu
$et = 1
EndIf
$rt =(@DesktopWidth/2)-($rv/2)
$ru =(@DesktopHeight/2)-($rw/2)
EndIf
_16o()
GUIRegisterMsg(0x0005, '')
WinMove($ej,'',$rt,$ru,$rv,$rw)
If $et Then
If $gy Then
_16s(False,False)
_18o()
Else
_16s(False,True)
EndIf
Else
_18n()
_16s(False,False)
EndIf
_16v()
_17v()
GUIRegisterMsg(0x0005, '_16h')
EndSwitch
If $et Then _18t()
Case $hm
_19b()
EndSwitch
If TimerDiff($rr) >= 250 Then
GUISwitch($f2)
_17b()
GUISwitch($ga)
_18e()
GUISwitch($ej)
$rr = TimerInit()
EndIf
_1ag()
EndFunc
Func _1ai()
_17u()
_16r()
GUIDelete($ej)
_16e()
_18j()
_16m()
_n0()
Exit
EndFunc
