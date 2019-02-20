class NppSci    
{
    ; - Internal methods -------------------------------------------------------
    __New() {
        static init := new NppSci
        if (init)
            return init
        className := this.__Class
        %className% := this
        this.WM_USER := 1024
        this.MAX_PATH := 520
        this.NPPMSG := this.WM_USER + 1000
        this.RUNCOMMAND_USER := this.WM_USER + 3000

        this.hwndNpp := this.GetNppHwnd()
        this.hwndSci := this.GetSciHwnd()

        this.LangType := ["TEXT", "PHP", "C", "CPP", "CS", "OBJC", "JAVA", "RC", "HTML", "XML", "MAKEFILE", "PASCAL", "BATCH", "INI", "ASCII", "USER", "ASP", "SQL", "VB", "JS", "CSS", "PERL", "PYTHON", "LUA", "TEX", "FORTRAN", "BASH", "FLASH", "NSIS", "TCL", "LISP", "SCHEME", "ASM", "DIFF", "PROPS", "PS", "RUBY", "SMALLTALK", "VHDL", "KIX", "AU3", "CAML", "ADA", "VERILOG", "MATLAB", "HASKELL", "INNO", "SEARCHRESULT", "CMAKE", "YAML", "COBOL", "GUI4CLI", "D", "POWERSHELL", "R", "JSP", "COFFEESCRIPT", "JSON", "JAVASCRIPT", "FORTRAN_77", "BAANC", "SREC", "IHEX", "TEHEX", "SWIFT", "ASN1", "AVS", "BLITZBASIC", "PUREBASIC", "FREEBASIC", "CSOUND", "ERLANG", "ESCRIPT", "FORTH", "LATEX", "MMIXAL", "NIMROD", "NNCRONTAB", "OSCRIPT", "REBOL", "REGISTRY", "RUST", "SPICE", "TXT2TAGS", "VISUALPROLOG", "EXTERNAL"]
        this.winVer := ["UNKNOWN", "WIN32S", "95", "98", "ME", "NT", "W2K", "XP", "S2003", "XPX64", "VISTA", "WIN7", "WIN8", "WIN81", "WIN10"]
        this.Platform ["UNKNOWN", "X86", "X64", "IA64"]
    }

    __Delete() {
        if (this.hProc) {
            return this.CloseProcess()
        }
    }

    OpenBuffer(bytes) {
        return DllCall("VirtualAllocEx", "Ptr", this.hProc, "Ptr", 0
                                       , "Ptr", bytes     ,"UInt", 0x1000
                                       ,"UInt", 0x4, "Ptr")
    }

    CloseBuffer(address) {
        return DllCall("VirtualFreeEx", "Ptr", this.hProc,  "Ptr", address
                                      , "Ptr", 0         , "UInt", 0x8000)
    }

    ReadBuffer(address, bytes, encoding := "UTF-16") {
        VarSetCapacity(localBuffer, bytes)
        DllCall("ReadProcessMemory", "Ptr", this.hProc , "Ptr", address
                                   , "Ptr", &localBuffer, "Ptr", bytes
                                   , "Ptr", 0)
        localBuffer := StrGet(&localbuffer, bytes, encoding)
        return localBuffer
    }

    WriteBuffer(string, address := 0, encoding := "") {
        bufferSize := StrPut(string, encoding)
        if (address = 0)
            return bufferSize
        VarSetCapacity(buffer, bufferSize)
        StrPut(string, &buffer, encoding)
        return DllCall("WriteProcessMemory", "Ptr", this.hProc,"Ptr", address
                                           , "Ptr", &buffer,  "UInt", bufferSize
                                           , "UInt", 0)
    }

    OpenProcess() {
        return DllCall("OpenProcess", "UInt", 0x8|0x10|0x20, "Int", false
                                    , "UInt", this.GetProcessID() , "Ptr")
    }

    GetProcessID() {
        VarSetCapacity(PID, 4, 0)
        DllCall("GetWindowThreadProcessId", "Ptr", this.hwndNpp, "Ptr", &PID)
        return NumGet(&PID, "UInt")
    }

    CloseProcess() {
        if (DllCall("CloseHandle", "Ptr", this.hProc))
            return !(this.hProc := "")
        else return false
    }

    GetNppHwnd() {
        return WinActive("ahk_class Notepad++ ahk_exe Notepad++.exe")
    }

    GetSciHwnd() {
        Loop, % this.GetCurrentScintilla() + 1
            hSci := DllCall("FindWindowEx", "Ptr", this.hwndNpp, "Ptr", hSci
                                          , "Str", "Scintilla",  "Ptr", 0
                                          , "Ptr")

        return hSci
    }

    SendMsg(hwnd, msg, wP := 0, lP := 0) {
        return DllCall("SendMessage"
                     , "Ptr", hwnd, "UInt", msg, "Ptr", wP, "Ptr", lP, "Ptr")
    }

    PostMsg(hwnd, msg, wP := 0, lP := 0) {
        return DllCall("PostMessage"
                     , "Ptr", hwnd, "UInt", msg, "Ptr", wP, "Ptr", lP)
     }
;-- Notepad++ methods ----------------------------------------------------------
    ; returns '0' for 'MAIN_VIEW' or '1' for 'SUB_VIEW'
    GetCurrentScintilla() {
        bufferBytes := 4
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.SendMsg(this.hwndNpp, this.NPPMSG + 4, bufferBytes, bufferAddress)
        stringresult := this.ReadBuffer(bufferAddress, bufferBytes)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
        return NumGet(&stringresult, "UInt")
    }

    GetCurrentLangType() {
        bufferBytes := 4
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.SendMsg(this.hwndNpp, this.NPPMSG + 5, bufferBytes, bufferAddress)
        stringresult := this.ReadBuffer(bufferAddress, bufferBytes)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
        return this.LangType[ NumGet(&stringresult, "UInt") + 1 ]
    }

    ; pass '0' for PRIMARY_VIEW or '1' for "SUB_VIEW"
    GetNbOpenFiles(view := -1) {
        return this.SendMsg(this.hwndNpp, this.NPPMSG + 7, ,view)
    }

    ; pass '0' for PRIMARY_VIEW or '1' for "SUB_VIEW"
    GetOpenFileNames(whichView := "") {
        fileNames := []
        if (whichView != 1) {
            nbOpenFiles := this.GetNbOpenFiles(1)
            Loop, %nbOpenFiles% {
                ID := this.GetBufferIdFromPos(A_Index - 1, 0)
                fileNames.Push(this.GetFullPathFromBufferId(ID))
            }
        }
        if (whichView != 0) {
            nbOpenFiles := this.GetNbOpenFiles(2)
            Loop, %nbOpenFiles% {
                ID := this.GetBufferIdFromPos(A_Index - 1, 1)
                fileNames.Push(this.GetFullPathFromBufferId(ID))
            }
        }
        return fileNames
    }

    GetFullPathFromBufferID(bufferID) {
        bufferBytes := this.MAX_PATH
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.SendMsg(this.hwndNpp, this.NPPMSG + 58, bufferID, bufferAddress)
        stringresult := this.ReadBuffer(bufferAddress, bufferBytes)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
        return stringresult
    }

    ; index and view are 0-based
    GetBufferIDFromPos(index := 0, view := 0) {
        return this.SendMsg(this.hwndNpp, this.NPPMSG + 59, index, view)
    }

    GetFullCurrentPath() {
        bufferBytes := this.MAX_PATH
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.SendMsg(this.hwndNpp, this.RUNCOMMAND_USER + 1, bufferBytes, bufferAddress)
        stringresult := this.ReadBuffer(bufferAddress, bufferBytes)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
        return stringresult
    }

    GetCurrentDirectory() {
        bufferBytes := this.MAX_PATH
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.SendMsg(this.hwndNpp, this.RUNCOMMAND_USER + 2, bufferBytes, bufferAddress)
        stringresult := this.ReadBuffer(bufferAddress, bufferBytes)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
        return stringresult
    }

    GetFileName() {
        bufferBytes := this.MAX_PATH
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.SendMsg(this.hwndNpp, this.RUNCOMMAND_USER + 3, bufferBytes, bufferAddress)
        stringresult := this.ReadBuffer(bufferAddress, bufferBytes)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
        return stringresult
    }

    GetNamePart() {
        bufferBytes := this.MAX_PATH
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.SendMsg(this.hwndNpp, this.RUNCOMMAND_USER + 4, bufferBytes, bufferAddress)
        stringresult := this.ReadBuffer(bufferAddress, bufferBytes)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
        return stringresult
    }

    GetExtPart() {
        bufferBytes := this.MAX_PATH
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.SendMsg(this.hwndNpp, this.RUNCOMMAND_USER + 5, bufferBytes, bufferAddress)
        stringresult := this.ReadBuffer(bufferAddress, bufferBytes)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
        return stringresult
    }

    GetCurrentWord() {
        bufferBytes := this.MAX_PATH
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.SendMsg(this.hwndNpp, this.RUNCOMMAND_USER + 6, bufferBytes, bufferAddress)
        stringresult := this.ReadBuffer(bufferAddress, bufferBytes)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
        return stringresult
    }

    GetNppDirectory() {
        bufferBytes := this.MAX_PATH
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.SendMsg(this.hwndNpp, this.RUNCOMMAND_USER + 7, bufferBytes, bufferAddress)
        stringresult := this.ReadBuffer(bufferAddress, bufferBytes)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
        return stringresult
    }

    GetFileNameatCursor() {
        bufferBytes := this.MAX_PATH
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.SendMsg(this.hwndNpp, this.RUNCOMMAND_USER + 11, bufferBytes, bufferAddress)
        stringresult := this.ReadBuffer(bufferAddress, bufferBytes)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
        return stringresult
    }

    GetCurrentLine() {
        return this.SendMsg(this.hwndNpp, this.RUNCOMMAND_USER + 8)
    }

    GetCurrentColumn() {
        return this.SendMsg(this.hwndNpp, this.RUNCOMMAND_USER + 9)
    }

    GetNppFullFilePath() {
        bufferBytes := this.MAX_PATH
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.SendMsg(this.hwndNpp, this.RUNCOMMAND_USER + 10, bufferBytes, bufferAddress)
        stringresult := this.ReadBuffer(bufferAddress, bufferBytes)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
        return stringresult
    }

;-- Scintilla methods ----------------------------------------------------------
    ; Add text to the document at current position.
    ; If included, only the first 'length' characters are added
    AddText(text, length := false) {
        encoding := "CP" this.GetCodePage()
        bufferBytes := this.WriteBuffer(text, , encoding)
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.WriteBuffer(text, bufferAddress, encoding)
        if (length = false)
            length := StrLen(text)
        this.SendMsg(this.hwndSci, 2001, length, bufferAddress)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
    }

    ; Insert string at a position.
    InsertText(pos, text) {
        encoding := "CP" this.GetCodePage()
        bufferBytes := this.WriteBuffer(text, , encoding)
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.WriteBuffer(text, bufferAddress, encoding)
        this.SendMsg(this.hwndSci, 2003, pos, bufferAddress)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
    }

    ; Delete all text in the document.
    ClearAll() {
        return this.PostMsg(this.hwndSci, 2004)
    }

    ; Returns the number of bytes in the document.
    GetLength() {
        return this.SendMsg(this.hwndSci, 2006) 
    }

    ; Returns the character byte at the position.
    GetCharAt(pos) {
        return this.SendMsg(this.hwndSci, 2007, pos)
    }

    ; Returns the position of the caret.
    GetCurrentPos() {
        return this.SendMsg(this.hwndSci, 2008)
    }

    ; Returns the position of the opposite end of the selection to the caret.
    GetAnchor() {
        return this.SendMsg(this.hwndSci, 2009)
    }

    ; # Redoes the next action on the undo history.
    Redo() {
        this.PostMsg(this.hwndSci, 2011)
    }

    ; # Choose between collecting actions into the undo history and discarding them.
    SetUndoCollection(collectUndo) {
        return this.PostMsg(this.hwndSci, 2012, collectUndo)
    }

    ; # Select all the text in the document.
    SelectAll() {
        return this.PostMsg(this.hwndSci, 2013)
    }

    ; # Are there any redoable actions in the undo history?
    CanRedo() {
        return this.SendMsg(this.hwndSci, 2016)
    }

    ; # Set caret to start of a line and ensure it is visible.
    ; fun void GotoLine=p2024(int line,)
    GotoLine(line) {
        return
    }

    ; # Set caret to a position and ensure it is visible.
    ; fun void GotoPos=p2025(position pos,)
    GotoPos(pos) {
        return
    }

    ; # Set the selection anchor to a position. The anchor is the opposite end of the selection from the caret.
    ; set void SetAnchor=p2026(position posAnchor,)
    SetAnchor(posAnchor) {
        return
    }

    ; # Retrieve the text of the line containing the caret. Returns the index of the caret on the line. Result is NUL-terminated.
    GetCurLine() {
        bufferBytes := this.SendMsg(this.hwndSci, 2027) + 1
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.SendMsg(this.hwndSci, 2027, , bufferAddress)
        encoding := "CP" this.GetCodePage()
        stringresult := this.ReadBuffer(bufferAddress, bufferBytes, encoding)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
        return stringresult
    }
    
    ; # Start a sequence of actions that is undone and redone as a unit.
    ; # May be nested.
    BeginUndoAction() {
        return this.PostMsg(this.hwndSci, 2078)
    }

    ; # End a sequence of actions that is undone and redone as a unit.
    EndUndoAction() {
        return this.PostMsg(this.hwndSci, 2079)
    }

    ; # Retrieve indentation size.
    GetIndent() {
        return this.SendMsg(this.hwndSci, 2123)
    }

    ; # Change the indentation of a line to a number of columns.
    SetLineIndentation(line, indentSize) {
        return this.PostMsg(this.hwndSci, 2126, line, indentSize)
    }

    ; # Retrieve the number of columns that a line is indented.
    GetLineIndentation(line) {
        return this.SendMsg(this.hwndSci, 2127, line)
    }

    ; # Retrieve the column number of a position, taking tab width into account.
    ; get int GetColumn=s2129(position pos,)
    GetColumn(pos) {
        return
    }

    ; # Get the position after the last visible characters on a line.
    ; get position GetLineEndPosition=s2136(int line,)
    GetLineEndPosition(line) {
        return
    }

    ; Get the code page used to interpret the bytes of the document as characters.
    GetCodePage() {
        return this.SendMsg(this.hwndSci, 2137)
    }

    ; # Sets the position of the caret.
    ; set void SetCurrentPos=p2141(position pos,)
    SetCurrentPos(pos) {
        return
    }

    ; # Sets the position that starts the selection - this becomes the anchor.
    ; set void SetSelectionStart=p2142(position pos,)
    SetSelectionStart(pos) {
        return
    }

    ; # Returns the position at the start of the selection.
    ; get position GetSelectionStart=s2143(,)
    GetSelectionStart() {
        return
    }

    ; # Sets the position that ends the selection - this becomes the currentPosition.
    ; set void SetSelectionEnd=p2144(position pos,)
    SetSelectionEnd(pos) {
        return
    }

    ; # Returns the position at the end of the selection.
    ; get position GetSelectionEnd=s2145(,)
    GetSelectionEnd() {
        return
    }

    ; # Retrieve the display line at the top of the display.
    ; get int GetFirstVisibleLine=s2152(,)
    GetFirstVisibleLine() {
        return
    }

    ; # Retrieve the contents of a line. Returns the length of the line.
    ; fun int GetLine=r2153(int line, stringresult text)
    GetLine(line, text) {
        return
    }

    ; # Returns the number of lines in the document. There is always at least one.
    ; get int GetLineCount=s2154(,)
    GetLineCount() {
        return
    }

    ; Retrieve the selected text.
    GetSelText() {
        bufferBytes := this.SendMsg(this.hwndSci, 2161) + 1
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.SendMsg(this.hwndSci, 2161, bufferBytes, bufferAddress)
        encoding := "CP" this.GetCodePage()
        stringresult := this.ReadBuffer(bufferAddress, bufferBytes, encoding)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
        return stringresult
    }

    ; Replace the selected text with the argument text.
    ReplaceSel(text) {
        encoding := "CP" this.GetCodePage()
        bufferBytes := this.WriteBuffer(text, encoding)
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.WriteBuffer(text, bufferAddress, encoding)
        this.SendMsg(this.hwndSci, 2170, , bufferAddress)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
        return
    }

    ; # Replace the contents of the document with the argument text.
    ; fun void SetText=w2181(, string text)
    SetText(text) {
        return
    }

    ; # Retrieve all the text in the document.
    GetText() {
        bufferBytes := this.GetTextLength() + 1
        this.hProc := this.OpenProcess()
        bufferAddress := this.OpenBuffer(bufferBytes)
        this.SendMsg(this.hwndSci, 2182, bufferBytes, bufferAddress)
        encoding := "CP" this.GetCodePage()
        stringresult := this.ReadBuffer(bufferAddress, bufferBytes, encoding)
        this.CloseBuffer(bufferAddress)
        this.CloseProcess()
        return stringresult
    }

    ; # Retrieve the number of characters in the document.
    GetTextLength() {
        return this.SendMsg(this.hwndSci, 2183)
    }

    ; # Append a string to the end of the document without changing the selection.
    ; fun void AppendText=w2282(int length, string text)
    AppendText(length, text) {
        return
    }

    ; # Move caret down one line.
    LineDown() {
        return this.PostMsg(this.hwndSci, 2300)
    }

    ; # Move caret down one line extending selection to new caret position.
    LineDownExtend() {
        return this.PostMsg(this.hwndSci, 2301)
    }

    ; # Move caret up one line.
    LineUp() {
        return this.PostMsg(this.hwndSci, 2302)
    }

    ; # Move caret up one line extending selection to new caret position.
    LineUpExtend() {
        return this.PostMsg(this.hwndSci, 2303)
    }

    ; # Move caret left one character.
    CharLeft() {
        return this.PostMsg(this.hwndSci, 2304)
    }

    ; # Move caret left one character extending selection to new caret position.
    CharLeftExtend() {
        return this.PostMsg(this.hwndSci, 2305)
    }

    ; # Move caret right one character.
    CharRight() {
        return this.PostMsg(this.hwndSci, 2306)
    }

    ; # Move caret right one character extending selection to new caret position.
    CharRightExtend() {
        return this.PostMsg(this.hwndSci, 2307)
    }

    ; # Move caret left one word.
    WordLeft() {
        return this.PostMsg(this.hwndSci, 2308)
    }

    ; # Move caret left one word extending selection to new caret position.
    WordLeftExtend() {
        return this.PostMsg(this.hwndSci, 2309)
    }

    ; # Move caret right one word.
    WordRight() {
        return this.PostMsg(this.hwndSci, 2310)
    }

    ; # Move caret right one word extending selection to new caret position.
    WordRightExtend() {
        return this.PostMsg(this.hwndSci, 2311)
    }

    ; # Move caret to first position on line.
    Home() {
        return this.PostMsg(this.hwndSci, 2312)
    }

    ; # Move caret to first position on line extending selection to new caret position.
    HomeExtend() {
        return this.PostMsg(this.hwndSci, 2313)
    }

    ; # Move caret to last position on line.
    LineEnd() {
        return this.PostMsg(this.hwndSci, 2314)
    }

    ; # Move caret to last position on line extending selection to new caret position.
    LineEndExtend() {
        return this.PostMsg(this.hwndSci, 2315)
    }

    ; # Move caret to first position in document.
    DocumentStart() {
        return this.PostMsg(this.hwndSci, 2316)
    }

    ; # Move caret to first position in document extending selection to new caret position.
    DocumentStartExtend() {
        return this.PostMsg(this.hwndSci, 2317)
    }

    ; # Move caret to last position in document.
    DocumentEnd() {
        return this.PostMsg(this.hwndSci, 2318)
    }

    ; # Move caret to last position in document extending selection to new caret position.
    DocumentEndExtend() {
        return this.PostMsg(this.hwndSci, 2319)
    }

    ; # Move caret one page up.
    PageUp() {
        return this.PostMsg(this.hwndSci, 2320)
    }

    ; # Move caret one page up extending selection to new caret position.
    PageUpExtend() {
        return this.PostMsg(this.hwndSci, 2321)
    }

    ; # Move caret one page down.
    PageDown() {
        return this.PostMsg(this.hwndSci, 2322)
    }

    ; # Move caret one page down extending selection to new caret position.
    PageDownExtend() {
        return this.PostMsg(this.hwndSci, 2323)
    }

    ; # Switch from insert to overtype mode or the reverse.
    EditToggleOvertype() {
        return this.PostMsg(this.hwndSci, 2324)
    }

    ; # Cancel any modes such as call tip or auto-completion list display.
    Cancel() {
        return this.PostMsg(this.hwndSci, 2325)
    }

    ; # Delete the selection or if no selection, the character before the caret.
    DeleteBack() {
        return this.PostMsg(this.hwndSci, 2326)
    }

    ; # If selection is empty or all on one line replace the selection with a tab character.
    ; # If more than one line selected, indent the lines.
    Tab() {
        return this.PostMsg(this.hwndSci, 2327)
    }

    ; # Dedent the selected lines.
    BackTab() {
        return this.PostMsg(this.hwndSci, 2328)
    }

    ; # Insert a new line, may use a CRLF, CR or LF depending on EOL mode.
    NewLine() {
        return this.PostMsg(this.hwndSci, 2329)
    }

    ; # Insert a Form Feed character.
    FormFeed() {
        return this.PostMsg(this.hwndSci, 2330)
    }

    ; # Move caret to before first visible character on line.
    ; # If already there move to first character on line.
    VCHome() {
        return this.PostMsg(this.hwndSci, 2331)
    }

    ; # Like VCHome but extending selection to new caret position.
    VCHomeExtend() {
        return this.PostMsg(this.hwndSci, 2332)
    }

    ; # Magnify the displayed text by increasing the sizes by 1 point.
    ZoomIn() {
        return this.PostMsg(this.hwndSci, 2333)
    }

    ; # Make the displayed text smaller by decreasing the sizes by 1 point.
    ZoomOut() {
        return this.PostMsg(this.hwndSci, 2334)
    }

    ; # Delete the word to the left of the caret.
    DelWordLeft() {
        return this.PostMsg(this.hwndSci, 2335)
    }

    ; # Delete the word to the right of the caret.
    DelWordRight() {
        return this.PostMsg(this.hwndSci, 2336)
    }

    ; # Delete the word to the right of the caret, but not the trailing non-word characters.
    DelWordRightEnd() {
        return this.PostMsg(this.hwndSci, 2518)
    }

    ; # Cut the line containing the caret.
    LineCut() {
        return this.PostMsg(this.hwndSci, 2337)
    }

    ; # Delete the line containing the caret.
    LineDelete() {
        return this.PostMsg(this.hwndSci, 2338)
    }

    ; # Switch the current line with the previous.
    LineTranspose() {
        return this.PostMsg(this.hwndSci, 2339)
    }

    ; # Duplicate the current line.
    LineDuplicate() {
        return this.PostMsg(this.hwndSci, 2404)
    }

    ; # Transform the selection to lower case.
    LowerCase() {
        return this.PostMsg(this.hwndSci, 2340)
    }

    ; # Transform the selection to upper case.
    UpperCase() {
        return this.PostMsg(this.hwndSci, 2341)
    }

    ; # Scroll the document down, keeping the caret visible.
    LineScrollDown() {
        return this.PostMsg(this.hwndSci, 2342)
    }

    ; # Scroll the document up, keeping the caret visible.
    LineScrollUp() {
        return this.PostMsg(this.hwndSci, 2343)
    }

    ; # Delete the selection or if no selection, the character before the caret.
    ; # Will not delete the character before at the start of a line.
    DeleteBackNotLine() {
        return this.PostMsg(this.hwndSci, 2344)
    }

    ; # Move caret to first position on display line.
    HomeDisplay() {
        return this.PostMsg(this.hwndSci, 2345)
    }

    ; # Move caret to first position on display line extending selection to
    ; # new caret position.
    HomeDisplayExtend() {
        return this.PostMsg(this.hwndSci, 2346)
    }

    ; # Move caret to last position on display line.
    LineEndDisplay() {
        return this.PostMsg(this.hwndSci, 2347)
    }

    ; # Move caret to last position on display line extending selection to new
    ; # caret position.
    LineEndDisplayExtend() {
        return this.PostMsg(this.hwndSci, 2348)
    }

    ; # These are like their namesakes Home(Extend)?, LineEnd(Extend)?, VCHome(Extend)?
    ; # except they behave differently when word-wrap is enabled:
    ; # They go first to the start / end of the display line, like (Home|LineEnd)Display
    ; # The difference is that, the cursor is already at the point, it goes on to the start
    ; # or end of the document line, as appropriate for (Home|LineEnd|VCHome)(Extend)?.
    HomeWrap() {
        return this.PostMsg(this.hwndSci, 2349)
    }
    HomeWrapExtend() {
        return this.PostMsg(this.hwndSci, 2450)
    }
    LineEndWrap() {
        return this.PostMsg(this.hwndSci, 2451)
    }
    LineEndWrapExtend() {
        return this.PostMsg(this.hwndSci, 2452)
    }
    VCHomeWrap() {
        return this.PostMsg(this.hwndSci, 2453)
    }
    VCHomeWrapExtend() {
        return this.PostMsg(this.hwndSci, 2454)
    }

    ; Set the zoom level.
    ; This number of points is added to the size of all fonts.
    ; It may be positive to magnify or negative to reduce.
    SetZoom(zoom) {
        return this.PostMsg(this.hwndSci, 2373, zoom)
    }

    ; Retrieve the zoom level.
    GetZoom() {
        return this.SendMsg(this.hwndSci, 2374)
    }

    ; Move caret between paragraphs (delimited by empty lines).
    ParaDown() {
        return this.PostMsg(this.hwndSci, 2413)
    }

    ; Move caret between paragraphs (delimited by empty lines).
    ParaDownExtend() {
        return this.PostMsg(this.hwndSci, 2414)
    }

    ; Move caret between paragraphs (delimited by empty lines).
    ParaUp() {
        return this.PostMsg(this.hwndSci, 2415)
    }

    ; Move caret between paragraphs (delimited by empty lines).
    ParaUpExtend() {
        return this.PostMsg(this.hwndSci, 2416)
    }

    ; # Set caret to a position, while removing any existing selection.
    SetEmptySelection(pos) {
        return this.PostMsg(this.hwndSci, 2556, pos)
    }

    ; # Count characters between two positions.
    CountCharacters(startPos, endPos) {
        return this.SendMsg(this.hwndSci, 2633, startPos, endPos)
    }

    ; # Delete a range of text in the document.
    DeleteRange(pos, deleteLength) {
        return this.PostMsg(this.hwndSci, 2645, pos, deleteLength)
    }
}