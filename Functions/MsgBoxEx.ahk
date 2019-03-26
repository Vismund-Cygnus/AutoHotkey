MsgBoxEx(text := "", title := "", options := 0x0) {
    static buttonsRgx := [ "OC|O/C|OKCancel"      , "ARI|A/R/I|AbortRetryIgnore"
                         , "YNC|Y/N/C|YesNoCancel", "YN|Y/N|YesNo"
                         , "RC|R/C|RetryCancel"   , "CTC|C/T/C|CancelTryAgainContinue" ]
    for _, o in StrSplit(RegExReplace(options, "\h+", " "), " ") {
        if !(buttons) {
            for i, rgx in buttonsRgx {
                if (o ~= "i)" rgx) {
                    options += i
                    buttons := true
                    break
                }
            }
        }
        if !(icon) {
            for i, str in ["Iconx", "Icon?", "Icon!", "Iconi"] {
                if (o = str) {
                    options += Format("0x{:}", i * 10)
                    icon := true
                    break
                }
            }
        }
        if !(default) {
            for i, str in ["Default2", "Default3", "Default4"] {
                if (o = str) {
                    options += Format("0x{:}", i * 100)
                    default := true
                    break
                }
            }
        }
        if !(modal) {
            for i, n in [0x1000, 0x2000, 0x40000] {
                if (o = n) {
                    options += o
                    modal := true
                    break
                }
            }
        }
        if (o = 0x4000) || (o = 0x80000) || (o = 0x100000) {
            options += o
            continue
        }
        if (SubStr(o, 1, 5) = "Owner") {
            owner := SubStr(o, 6)
            continue
        }
        if (SubStr(o, 1, 1) = "T") {
            timeout := 1000 * SubStr(o, 2)
            continue
        }
    }
    title := title ? title : A_ScriptName
    f := Func("MsgBoxClose").Bind(title)
    SetTimer, % f, % -timeout
    r := DllCall("MessageBox", "Ptr", owner, "Str", text, "Str", title, "UInt", options)
    return ["Ok","Cancel","Abort","Retry","Ignore","Yes","No","","","TryAgain","Continue"][r]
}

MsgBoxClose(title) {
    DllCall("PostMessage", "Ptr", WinExist(title " ahk_class #32770 ahk_exe AutoHotkey.exe"), "UInt", 0x112, "Ptr", 0xF060, "Ptr", 0)
}