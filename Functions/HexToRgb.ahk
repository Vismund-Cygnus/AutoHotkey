HexToRgb(hex)
{
    return { "r": Format("{:i}", 0xff & (hex >> 16))
            ,"g": Format("{:i}", 0xff & (hex >> 08))
            ,"b": Format("{:i}", 0xff & (hex >> 00)) }
}