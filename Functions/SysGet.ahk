SysGet(subCommand, value := "")
{
    SysGet, o, % subCommand, % value

    if (subCommand = "Monitor") or (subCommand = "MonitorWorkArea")
        return { "Top": oTop, "Left": oLeft, "Bottom": oBottom, "Right": oRight }
    else return o
}