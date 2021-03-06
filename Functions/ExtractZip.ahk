ExtractZip(zipPath, cleanup := false)
{
    SplitPath, zipPath, fileName, dir, ext, fileNameNoExt
    
    extractDir := StrReplace(zipPath, "." ext)
    
    FileCreateDir, % extractDir
    
    shell := ComObjCreate("Shell.Application")

    for item in shell.NameSpace(zipPath).items
        shell.NameSpace(extractDir).CopyHere(item, 4|16)
        
    if (cleanup = true)
        FileRecycle, % zipPath
    
    return extractDir
}