; All parameters optional.

; x1, y1, x2, y2 - 4 coordinates of the square you want captured
;                - If omitted, it'll capture the active window

; filePath       - Filename to save the screenshot at
;                - If omitted, image will be copied to your clipboard

; nircmd         - Path to the nircmd.exe file.
;                - If omitted, exe will be downloaded into A_WorkingDir

; delay          - Delay in ms before screenshot is captured
;                - If omitted, capture will be instant

SaveScreenShot(x1 := "", y1 := "", x2 := "", y2 := "", filePath := "", nircmd := "", delay := 0)
{
    static q := """", s := " "

    if !nircmd
    {
        if !FileExist("nircmd.exe")
        {
            zipFile := A_WorkingDir "\nircmd.zip"

            if !FileExist(zipFile)
                UrlDownloadToFile, % "http://www.nirsoft.net/utils/nircmd" . ["-x64"][A_Is64bitOS] . ".zip", % zipFile

            shell := ComObjCreate("Shell.Application")

            for item in shell.NameSpace(zipFile).items
                shell.NameSpace(A_WorkingDir).CopyHere(item, 4|16)
        }

        nircmd := A_WorkingDir "\nircmd.exe"
    }

    filePath := filePath ? filePath : "*clipboard*"

    RunWait, % q nircmd q s "cmdwait" s delay (x1 && y1 && x2 && y2
                                            ? s "savescreenshot"    s q filePath q s x1 s y1 s x2 s y2
                                            : s "savescreenshotwin" s q filePath q)

    return
}