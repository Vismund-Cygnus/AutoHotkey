; Credit to GeekDude for making this suck less
; https://discordapp.com/channels/115993023636176902/461179682419900427/539272946212929537

BIV_Values()
{
    chmPath := StrReplace(A_AhkPath, "exe", "chm")
    
    rootPath := FileExist(chmPath) ? "ms-its:" chmPath "::" : "https://autohotkey.com"
    
    index := ComObjCreate("MSXML2.XMLHTTP.3.0")
    
    index.Open("GET", rootPath "/docs/static/source/data_index.js", true)
    
    index.Send()

    a := StrSplit(index.ResponseText, "[""A_"), a.RemoveAt(1)

    For i, line in a
        if RegExMatch("A_" line, "m)A_[^""\s]+(?=.*$)", var)
            if (%var% && !(var = "LoopField"))
                BIVs .= var " = " %var% "`r`n"

    return SubStr(BIVs, 1, -2)
}