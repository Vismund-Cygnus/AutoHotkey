InList(haystack, needles*)
{
    for i, needle in (needles.Count() = 1 ? StrSplit(needles[1], ",") : needles)
        if (haystack = needle)
            return true
}