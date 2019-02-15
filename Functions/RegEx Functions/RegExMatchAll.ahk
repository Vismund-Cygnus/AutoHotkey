/*
    NumberOfMatches := RegExMatchAll(Haystack, NeedleRegex, OutputArray, [Flags := 0x0], [StartingPosition := 1])

    - Haystack
        - The string whose content is searched.
    
    - regex
        - The pattern to search for, which is a Perl-compatible regular expression (PCRE). 
    
    - OutputArray
        - The output variable in which to store the resulting array
    
    - Flags - Can be any combination of the following numbers:
    
        - 0x0 : OutputArray will be structured by subpattern and then by match
                - i.e. matches[subpattern][matchNumber]
                - If no subpatterns, matches will be stored in 'matches[0][matchNumber]'

        - 0x1 : OutputArray will be ordered by match and then by subpattern
                - i.e. matches[matchNumber][subpattern]
                - If no subpatterns, matches will be stored in 'matches[matchNumber][0]'
        
        - 0x2 : Instead of storing a string value at 'matches[x][y]' the function
                will store an array in which the first key is the value and the
                second key is the offset of the value within Haystack.
                    - i.e. matches[x][y][1] and matches[x][y][2]
                
    - StartingPosition
        - The character position within Haystack from which to start the search
*/

; Example:

count := RegExMatchAll("a1b2c3", "(\D)(?<digit>\d)", matches)

for subpattern, match in matches {
    for #, string in match {
        out .= "matches[" # ", " subpattern "] =  " string "`n"
    }
    out .= "`n"
}

MsgBox, % out
return

RegExMatchAll(haystack, regex, ByRef outArray, flags := 0x0, startingPosition := 1) {
    outArray      := []
    groupByMatch  := (flags & 0x1)    
    offsetCapture := (flags & 0x2)
    
    offset += startingPosition
    
    searchFlags := RegExOptions(regex, "O")
    
    while (offset := RegExMatch(haystack, searchFlags ")" regex, matches, offset)) {
        matchNumber := A_Index
        
        root   := groupByMatch ? matchNumber : 0
        nested := groupByMatch ? 0 : matchNumber
        
        if (offsetCapture)
            matchVal := [matches[0], InStr(haystack, matches[0])]
        else matchVal := matches[0]
        
        OutArray[root, nested] := matchVal
        
        While (matches[A_Index]) {
            captureGroup := A_Index

            root   := groupByMatch ? matchNumber : captureGroup
            nested := groupByMatch ? captureGroup : matchNumber

            if (offsetCapture)
                groupVal := [matches[captureGroup], InStr(haystack, matches[captureGroup])]
            else groupVal := matches[captureGroup]
            
            OutArray[root, nested] := groupVal
            
            if (groupName := matches.Name(captureGroup)) {
                root   := groupByMatch ? matchNumber : groupName
                nested := groupByMatch ? groupName : matchNumber
                outArray[root, nested] := groupVal
            }
        }
        
        offset += matches.Len(0)
    }

    return matchNumber
}