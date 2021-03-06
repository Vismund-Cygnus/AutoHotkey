WinGet(subCommand, wintitle := "A", wintext := "", excludeTitle := "", excludeText := "") {
    WinGet, o, % subCommand, % wintitle, % wintext, % excludeTitle, % excludeText
    if (subCommand = "List") {
        list := []
        Loop, % o
            list.Push(o%A_Index%)
        return list
    } else if (SubCommand ~= "i)ControlList(Hwnd)?") {
        return StrSplit(o, "`n")
    } else return o
}