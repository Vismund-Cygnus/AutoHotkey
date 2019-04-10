RegExGrep(inArray, regex, negate := false, matchKeys := false) {
    outArray := []
    for key, val in inArray {
        if ((matchKeys ? key : val) ~= regex) {
            if !(negate) {
                outArray[key] := val
            }
        } else {
            if (negate) {
                outArray[key] := val
            }
        }
    }
    return outArray
}