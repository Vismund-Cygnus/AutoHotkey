KeywordList()
{
    static chmPath := StrReplace(A_AhkPath, "exe", "chm")
        
        ,  groups := { 0: "Directives", 1: "BIVs"        , 2: "Functions", 3: "Flow"
                     , 4: "Operators" , 5: "Declarations", 6: "Commands"}
    
    rootPath := FileExist(chmPath) ? "ms-its:" chmPath "::" : "https://autohotkey.com"

    index := ComObjCreate("MSXML2.XMLHTTP.3.0")

    index.Open("GET", rootPath "/docs/static/source/data_index.js", true)

    index.Send()
    
    Loop, Parse, % RegExReplace(index.ResponseText, "\R\s+"), [
        if RegExMatch(A_LoopField, "^""([^""]+)"",""[^""]+"",(\d+)", line)
            groups[groups[line2]] .= line1 "`n"
            
    return groups
}