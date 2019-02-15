RegExEscape(string, delimiter := "") {
    
    for _, char in StrSplit(delimiter "\!#$()*+-.:<=>?[]^{|}")
        string := StrReplace(string, char, "\" char)
    
    return string
}