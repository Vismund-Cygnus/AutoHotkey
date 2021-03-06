; Modified from https://www.autohotkey.com/docs/commands/Run.htm#Examples
ExecScript(Script, Wait := true)
{
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec("C:\Program Files\AutoHotkey\AutoHotkeyU32.exe /ErrorStdOut * ")
    exec.StdIn.Write("FileAppend % (" script "), *")
    exec.StdIn.Close()

    if Wait
        return exec.StdOut.ReadAll()
}