SetBatchLines, -1
SetWinDelay, -1
SetControlDelay, -1
SetKeyDelay, -1

Font := [ "S30 CWhite", "Consolas" ]
TextOpts := "YP WP HP BackgroundTrans Center v"
ProgOpts := "0x200 +CGray YP X+1 HP WP +BackgroundGray vProg"

Gui, Temp:Font, % Font[1], % Font[2]
Gui, Temp:Add, Edit, vTmp, -
tmp := GuiControlPos("Tmp", "Temp:")
Gui, Temp:Destroy

Gui, OSD:New, -Caption +AlwaysOnTop +LastFound +HwndhOSD +OwnDialogs
Gui, OSD:Default
Gui, Font, % Font[1], % Font[2]
Gui, Margin, 4, 4
Gui, Color, F0F0F0

; First row ---------------------------------------------------------------------------------------
Gui, Add, Progress, % "0x200 +CGray YM X+1 +BackgroundGray vProgQ H" tmp.H " W" tmp.W, 100
Gui, Add, Text, % TextOpts "Q", Q
for e, key in StrSplit("WERTYUIOP") {
	Gui, Add, Progress, % ProgOpts key, 100
	Gui, Add, Text, % TextOpts key , %key%
}
; Second row --------------------------------------------------------------------------------------
Q := GuiControlPos("ProgQ", "OSD:")
Gui, Add, Progress, % "0x200 +CGray Y+1 X" Q.x + (Q.W * 0.5) " HP WP vProgA +BackgroundGray", 100
Gui, Add, Text, % TextOpts "A", A
for e, key in StrSplit("SDFGHJKL") {
	Gui, Add, Progress, % ProgOpts key, 100
	Gui, Add, Text, % TextOpts key, %key%
}
; Third row ---------------------------------------------------------------------------------------
A := GuiControlPos("ProgA", "OSD:")
Gui, Add, Progress, % "0x200 +CGray Y+1 X" A.x + 1 + (A.W * 1) " HP WP vProgZ +BackgroundGray" , 100
Gui, Add, Text, % TextOpts "Z", Z
for e, key in StrSplit("XCVBNM") {
	Gui, Add, Progress, % ProgOpts key, 100
	Gui, Add, Text, % TextOpts key, %key%
}
; Space bar ---------------------------------------------------------------------------------------
X := GuiControlPos("ProgX", "OSD:")
Gui, Add, Progress, % "0x200 +CGray Y+1 X" (X.X + (0.5*X.w)) " HP W" tmpW * 4 " vProgSpace +BackgroundGray" , 100
Gui, Add, Text, % TextOpts "Space", ________
Hotkey, IfWinExist, ahk_id %hOSD%
Loop, 26 {
	Hotkey, % "~*" Chr(A_Index + 64), OSD
	Hotkey, % "~*" Chr(A_Index + 64) " Up", OSD
}
Hotkey, % "~*Space", OSD
Hotkey, % "~*Space Up", OSD
Gui, Show, Hide
WinGetPos, , , ww, wh
WinSet, TransColor, F0F0F0
Gui, Show, % "NA X" (A_ScreenWidth - ww - 50) " Y" (A_ScreenHeight - wh - 50)
OnMessage(0x200, "WM_MOUSEMOVE")
OnMessage(0x201, "WM_LBUTTON")
OnMessage(0x202, "WM_LBUTTON")
return
WM_MOUSEMOVE(wParam, lParam, msg, hwnd) {
    static lastHwnd, h
    if (hwnd != h) {
        Gui, OSD:Default
        GuiControlGet, key, Name, % hwnd
        GuiControlGet, last, Name, % h
        key := SubStr(key, 5)
        last := SubStr(last, 5)
        GuiControl, % (wParam & 0x1 ? "+CGreen" : "+CSilver") " +BackgroundBlack", Prog%key%
        GuiControl, +CGray +BackgroundGray, Prog%last%
        Gui, Font, Underline
        GuiControl, Font, %key%
        Gui, Font, Norm
        GuiControl, Font, %last%
        h := hwnd
    }
}
WM_LBUTTON(wParam, lParam, msg, hwnd) {
    Gui, OSD:Default
    GuiControlGet, key, Name, % hwnd
    key := SubStr(key, 5)
    GuiControl, % (msg = 0x201 ? "+CGreen +BackgroundBlack" : "+CGray +BackgroundGray"), Prog%key%
    Gui, Font, % (msg = 0x201 ? "Underline" : "Norm")
    GuiControl, Font, %key%
    GuiControl, MoveDraw, %key%
}
OSD() {
    Gui, OSD:Default
    if RegExMatch(A_ThisHotkey, "~\*(\w+)( Up)?", hk) {
        GuiControl, % (!hk2 ? "+CGreen +BackgroundBlack" : "+CGray +BackgroundGray"), Prog%hk1%
        Gui, Font, % (!hk2 ? "Underline " : "Norm ") Font[1], % Font[2]
        GuiControl, Font, %hk1%
        GuiControl, MoveDraw, %hk1%
    }
    return
}
GuiControlPos(v, Gui := "") {
    GuiControlGet, %v%, %Gui%Pos
    return { "X": %v%X, "Y": %v%Y, "W": %v%W, "H": %v%H }
}