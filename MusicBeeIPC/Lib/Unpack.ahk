;----------------------------------------------------------;
;- MusicBeeIPCSDK AHK v2.0.0                              -;
;- Copyright © Kerli Low 2014                             -;
;- This file is licensed under the                        -;
;- BSD 2-Clause License                                   -;
;- See LICENSE_MusicBeeIPCSDK for more information.       -;
;----------------------------------------------------------;

; --------------------------------------------------------------------------------
; All strings are encoded in UTF-16 little endian
; --------------------------------------------------------------------------------

; --------------------------------------------------------------------------------
; -Int32:  Byte count of string
; -byte[]: String data
; this.Free lr after use
; --------------------------------------------------------------------------------
Unpack_s(ByRef lr, ByRef string_1)
{
    string_1 := ""
    
    mmf := this.OpenMmf(lr)
    if !mmf
        return MB_False
        
    view := this.MapMmfView(mmf, lr, ptr)
    if !view
    {
        this.CloseMmf(mmf)
        return MB_False
    }
    
    byteCount := NumGet(ptr+0, 0, "Int")
    ptr += this.SIZEOFINT
        
    if byteCount > 0
        string_1 := StrGet(ptr, byteCount // this.SIZEOFWCHAR, "UTF-16")
    
    this.UnmapMmfView(view)
    
    this.CloseMmf(mmf)
    
    return true
}

; --------------------------------------------------------------------------------
; -Int32:  Number of strings
; -Int32:  Byte count of string
; -byte[]: String data
; -Int32:  Byte count of string
; -byte[]: String data
; -...
; this.Free lr after use
; --------------------------------------------------------------------------------
Unpack_sa(Byref lr, ByRef strings)
{
    strings := Array()
    
    mmf := this.OpenMmf(lr)
    if !mmf
        return False
        
    view := this.MapMmfView(mmf, lr, ptr)
    if !view
    {
        this.CloseMmf(mmf)
        return False
    }
    
    strCount := NumGet(ptr+0, 0, "Int")
    ptr += this.SIZEOFINT
    
    strings.SetCapacity(strCount)
    
    Loop % strCount
    {
        byteCount := NumGet(ptr+0, 0, "Int")
        ptr += this.SIZEOFINT
        
        if byteCount > 0
        {
            strings.Insert(StrGet(ptr, byteCount // this.SIZEOFWCHAR, "UTF-16"))
            ptr += byteCount
        }
    }
    
    this.UnmapMmfView(view)
    
    this.CloseMmf(mmf)
    
    return True
}

; --------------------------------------------------------------------------------
; -Int32: 32 bit integer
; -Int32: 32 bit integer
; this.Free lr after use
; --------------------------------------------------------------------------------
Unpack_ii(Byref lr, ByRef int32_1, ByRef int32_2)
{
    int32_1 := int32_2 := 0
    
    mmf := this.OpenMmf(lr)
    if !mmf
        return False
        
    view := this.MapMmfView(mmf, lr, ptr)
    if !view
    {
        this.CloseMmf(mmf)
        return False
    }
    
    int32_1 := NumGet(ptr+0, 0, "Int")
    ptr += this.SIZEOFINT
    
    int32_2 := NumGet(ptr+0, 0, "Int")
    
    this.UnmapMmfView(view)
    
    this.CloseMmf(mmf)
    
    return True
}

; --------------------------------------------------------------------------------
; -Int32: Number of integers
; -Int32: 32 bit integer
; -Int32: 32 bit integer
; -...
; this.Free lr after use
; --------------------------------------------------------------------------------
Unpack_ia(Byref lr, ByRef int32s)
{
    int32s := Array()
    
    mmf := this.OpenMmf(lr)
    if !mmf
        return False
        
    view := this.MapMmfView(mmf, lr, ptr)
    if !view
    {
        this.CloseMmf(mmf)
        return False
    }
    
    int32Count := NumGet(ptr+0, 0, "Int")
    ptr += this.SIZEOFINT
    
    int32s.SetCapacity(int32Count)
    
    Loop % int32Count
    {
        int32s.Insert(NumGet(ptr+0, 0, "Int"))
        ptr += this.SIZEOFINT
    }
    
    this.UnmapMmfView(view)
    
    this.CloseMmf(mmf)
    
    return True
}


OpenMmf(ByRef lr)
{
    ; FILE_MAP_READ = 0x0004 = 4
    ; FALSE = 0
    return (!lr ? False : DllCall("OpenFileMapping", "UInt", 4, "Int", 0, "Str", "mbipc_mmf_" NumGet(lr, 0, "UShort"), "Ptr"))
}

CloseMmf(mmf)
{
    DllCall("CloseHandle", UInt, mmf)
}

MapMmfView(mmf, ByRef lr, ByRef ptr)
{
    ; FILE_MAP_READ = 0x0004 = 4
    view := DllCall("MapViewOfFile", UInt, mmf, UInt, 4, UInt, 0, UInt, 0, UInt, 0, UInt)
    
    ptr := view + NumGet(lr, this.SIZEOFSHORT, "UShort") + this.SIZEOFLONG
    
    return view
}

UnmapMmfView(view)
{
    DllCall("UnmapViewOfFile", UInt, view)
}

GetLResult(el)
{
    if el = FAIL
        return False
        
    VarSetCapacity(lr, this.SIZEOFINT, 0)
    
    NumPut(el, lr, 0, "Int")
    ; ListVars
    ; Pause
    return lr

}
