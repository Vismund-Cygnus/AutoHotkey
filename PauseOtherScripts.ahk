PauseOtherScripts()
{
	O_DetectHiddenWindows := A_DetectHiddenWindows
	DetectHiddenWindows, On

	WinGet, list, List, ahk_class AutoHotkey

	Loop, % list
		if ((hwnd := list%A_Index%) != A_ScriptHWND)
			DllCall("PostMessage", "Ptr", hwnd, "UInt", 0x111, "Ptr", ID_FILE_PAUSE := 65403, "Ptr", 0)

	DetectHiddenWindows, % O_DetectHiddenWindows
	return
}