#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
global $sPortQry = @ScriptDir & '\PortQry.exe'
If Not FileExists($sPortQry) Then
	m($sPortQry & '  Does not exist!')
	Exit
EndIf

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Port Query GUI", 498, 79, 192, 124)
$txtServer = GUICtrlCreateInput("", 64, 16, 217, 21)
$txtPort = GUICtrlCreateInput("", 64, 40, 121, 21)
$Label1 = GUICtrlCreateLabel("Server", 16, 16, 35, 17)
$Label2 = GUICtrlCreateLabel("Port#", 16, 48, 30, 17)
$btnCheckPort = GUICtrlCreateButton("Check Port", 328, 24, 75, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnCheckPort
			Local $sServer = GUICtrlRead($txtServer)
			Local $sPort = GUICtrlRead($txtPort)
			If $sServer <> '' And $sPort <> '' Then
				m(dosreturn('ping ' & $sServer & ' -n 1'))
				m(dosreturn($sPortQry & ' -n "' & $sServer & '" -e ' & $sPort))
			Else
				m('Must put something in server and port')
			EndIf
	EndSwitch
WEnd

Func m($ttl, $txt = "", $timeout = 0)
	If $ttl <> "" And $txt = "" Then
		MsgBox(0, "", $ttl, $timeout)
	Else
		MsgBox(0, $ttl, $txt, $timeout)
	EndIf
EndFunc   ;==>m

Func dosreturn($cmd)
	Local $return = rundos($cmd, -1)
	Return StdoutRead($return[1])
EndFunc   ;==>dosreturn

Func rundos($sCommand, $sWait = 0, $sWindow = @SW_HIDE) ;sShowflag can take @sw_hide, @sw_maximize, @sw_minimize
	Local $sShowhide
	Switch $sWindow
		Case 5 ;@sw_show
			$sShowhide = " /k "
		Case 0 ;@SW_HIDE
			$sShowhide = " /c "
		Case Else
			$sShowhide = " /k "
	EndSwitch
	Local $sPID = Run(@ComSpec & $sShowhide & $sCommand, "", $sWindow, 0x4 + 0x2), _
			$sResult
	Switch $sWait ;inside the switch, Run returns the PID of the process, if process doesn't exist then returns 0
		Case -1 ; -1 to fix being able to choose from case 1.
			$sResult = ProcessWaitClose($sPID) ;processwaitclose will wait for infinity for process to finish
		Case 0.01 To 999999999999999999 ;0.01 is 10ms+, and if you could somehow say infinity...
			$sResult = ProcessWaitClose($sPID, $sWait) ;in seconds
	EndSwitch
	Local $sReturn[2]
	$sReturn[0] = $sResult
	$sReturn[1] = $sPID
	Return $sReturn ;returns the PID of run, and result of processwaitclose (1 = success, 0 = failure, if the PID was invalid from run, then @extended flag will be used)
EndFunc   ;==>rundos
