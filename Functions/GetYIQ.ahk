GetYIQ(n)
{
    r := 0xff & (n >> 16)
    g := 0xff & (n >>  8)
    b := 0xff & (n >>  0)

    return ((( (r*299) + (g*587) + (b*114) ) / 1000) >= 128) ? "Black" : "White"
}