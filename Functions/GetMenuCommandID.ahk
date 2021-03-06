    ; HOW TO USE
    ; Hover your mouse over a standard Windows menu item
    ; Press the 'control' key
    ; Fill in the appropriate hwnd for your program, i.e. 'WinActive("ahk_class Notepad")`
    ; Now you can programmatically select menu items
    
    ; Sample output (with hwnd filled in)
    ; DllCall("PostMessage", "Ptr", WinActive("ahk_class Notepad"), "UInt", 0x111, "Ptr", 27, "Ptr", 0)

    ~LCtrl::
      VarSetCapacity(POINT, 8)
 
    , VarSetCapacity(lpClassName, 513, 0)

    , DllCall("GetCursorPos", "Ptr", &POINT)
        
    , hwnd :=  DllCall("WindowFromPoint", "Ptr", NumGet(POINT), "Ptr")
    
    , DllCall("GetClassName", "Ptr", hwnd, "Ptr", &lpClassName, "Int", 513)
    
    , VarSetCapacity(lpClassName, -1)
    
    if (lpClassName = "#32768")
    {
          hMenu := DllCall("SendMessage", "Ptr", hwnd, "UInt", MN_GETHMENU := 0x01E1, "Ptr", 0, "Ptr", 0)

        , item := DllCall("MenuItemFromPoint", "Ptr", 0, "Ptr", hMenu, "Ptr", NumGet(POINT), "Int")
        
        , id :=  DllCall("GetMenuItemID", "Ptr", hMenu, "Int", item, "Int")
        
        Clipboard = DllCall("PostMessage", "Ptr", YourProgramHwndHere, "UInt", 0x111, "Ptr", %id%, "Ptr", 0)
        
        MsgBox, PostMessage command copied to clipboard.
    }
    return