RegExGrep(inArray, regex, negate := false, matchKeys := false) {
    outArray := []
    
    for key, val in inArray {
        if ((matchKeys = true ? key : val) ~= regex) {
            if (negate != true) {
                outArray[key] := val
            }
        } else {
            if (negate = true) {
                outArray[key] := val
            }
        }
    }
    
    return outArray
}