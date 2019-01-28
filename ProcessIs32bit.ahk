ProcessIs32bit(hwnd)
{
    if !(A_Is64bitOS)
        return true

    if (A_PtrSize = 8)
    {
        WinGet, p, PID, % "ahk_id " hwnd

        shell := ComObjCreate("WScript.Shell")

        exec := shell.Exec("C:\Program Files\AutoHotkey\AutoHotkeyU32.exe /ErrorStdOut *")
        
        expression =
        ( LTrim Join
            (hProc := DllCall("OpenProcess", "UInt", 0x400, "Int", 0, "UInt", %p%, "Ptr"))
                   && DllCall("IsWow64Process", "Ptr", hProc, "Int*", Wow64Process)
                   && DllCall("CloseHandle", "Ptr", hProc)
                   ? Wow64Process
                   : -1
        )

        exec.StdIn.Write("FileAppend, % (" expression "), *")

        exec.StdIn.Close()

        return exec.StdOut.ReadAll()
    }
    
    else
    {
        WinGet, p, PID, % "ahk_id " hwnd
        
        return (hProc := DllCall("OpenProcess", "UInt", 0x400, "Int", 0, "UInt", p, "Ptr"))
                      && DllCall("IsWow64Process", "Ptr", hProc, "Int*", Wow64Process)
                      && DllCall("CloseHandle", "Ptr", hProc))
                      ? Wow64Process
                      : -1
    }
}