GuiControlPos(v, Gui := "")
{
    GuiControlGet, %v%, %Gui%Pos
    return { "X": %v%X, "Y": %v%Y, "W": %v%W, "H": %v%H }
}