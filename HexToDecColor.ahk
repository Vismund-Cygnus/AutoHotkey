HexToDecColor(hex)
{
	return Format("{:i},{:i},{:i}", 0xff & (hex >> 16)
								,	0xff & (hex >>  8)
								,	0xff & (hex >>  0))
}