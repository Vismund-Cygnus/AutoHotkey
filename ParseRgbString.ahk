ParseRgbString(rgb)
{
    array := StrSplit(rgb, ",")
    
    return { "r": Trim(array[1]), "g": Trim(array[2]), "b": Trim(array[3]) }
}