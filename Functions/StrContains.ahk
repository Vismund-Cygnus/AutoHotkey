StrContains(haystack, needles*) {
    for i, needle in (needles.Count() = 1 ? StrSplit(needles[1], ",") : needles)
        if ( InStr(haystack, needle) )
            return true
}