SendDelay(keys*)
{
    for _, v in keys
    {
        if RegexMatch(v, "i)^{sleep\s*\K\d+(?=}$)", ms)
            sleep, ms
        else Send, %v%    
    }
}