SendMessage(hwnd, msg, wp:=0, lp:=0)
{
    return DllCall("SendMessage", "Ptr", hwnd, "UInt", msg, "Ptr", wp, "Ptr", lp, "Ptr")
}