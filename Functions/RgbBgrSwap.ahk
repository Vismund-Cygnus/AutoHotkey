RgbBgrSwap(n)
{
    return (0xff & (n >> 16)) << 0 | (0xff & (n >>  8)) << 8 | (0xff & (n >>  0)) << 16
}