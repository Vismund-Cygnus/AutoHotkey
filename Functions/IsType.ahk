IsType(n, type) {
    if (type = "integer" || type = "i") {
        n := RegExReplace(n, "(^[\s\t]*[+-]?|\s*$)")
        if (!StrLen(n) || InStr(n, "."))
            return false
        return (IsType(n, "d") || IsType(n, "x")) ? "integer" : false
    }
    if (type = "float" || type = "f") {
        n := RegExReplace(n, "(^[\s\t]*[+-]?|\s*$)")
        if !(StrLen(n) && InStr(n, "."))
            return false
        return (n ~= "^(\d+\.\d*|\d*\.\d+)$") ? "float" : false
    }
    if (type = "number" || type = "n") {
        return (IsType(n, "i") || IsType(n, "f")) ? "number" : false
    }
    if (type = "digit" || type = "d") { 
        return (n ~= "^[[:digit:]]*$") ? "digit" : false    
    }
    if (type = "xdigit" || type = "x") {       
        return (n ~= "^(0x)?[[:xdigit:]]*$") ? "xdigit" : false
    }
    if (type = "alpha" || type = "ab") {
        return (n ~= "^[[:alpha:]]*$") ? "alpha" : false    
    }
    if (type = "alnum" || type = "a1") {
        return (n ~= "^[[:alnum:]]*$") ? "alnum" : false
    }
    if (type = "upper" || type = "u") {
        return (n ~= "^[A-Z]*$") ? "upper" : false
    }
    if (type = "lower" || type = "l") {
        return (n ~= "^[a-z]*$") ? "upper" : false
    }
    if (type = "space" || type = "s") {
        return (n ~= "^[ \r\n\t\v]*$") ? "space" : false
    }   
    if (type = "time" || type = "date" || type = "t" || type = "d") {
        n := RTrim(n)
        if (StrLen(n) > 14)
            return false
        o := n
        length := StrLen(n)
        if (length >= 4) {
            YYYY := SubStr(n, 1, 4)
            n := SubStr(n, 5)
            length -= 4
        } else return false
        for e, p in [ "MM", "DD", "HH24", "MI", "SS" ] {
            if (length = 0) {
                break
            }   
            else if (length = 1) {
                %p% := n
                break
            }
            else if (length > 1) {
                %p% := SubStr(n, 1, 2)
                n := SubStr(n, 3)
                length -= 2
            }
        }
        if (StrLen(o) < 5)
            MM := 1
        if (StrLen(o) < 7)
            DD := 1
        VarSetCapacity(SYSTEMTIME, 2 * 8)
        , NumPut(YYYY, SYSTEMTIME,  0, "UShort")
        , NumPut(MM, SYSTEMTIME,  2, "UShort")
        , NumPut(DD, SYSTEMTIME,  6, "UShort")
        , NumPut(HH24, SYSTEMTIME,  8, "UShort")
        , NumPut(MI, SYSTEMTIME, 10, "UShort")
        , VarSetCapacity(FILETIME, 2 * 4, 0)
        return DllCall("SystemTimeToFileTime", "Ptr", &SYSTEMTIME, "Ptr", &FILETIME) ? "time" : false
    }
}