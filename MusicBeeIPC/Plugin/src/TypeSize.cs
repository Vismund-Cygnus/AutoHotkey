using System;
using System.Runtime.InteropServices;

namespace MusicBeePlugin
{
    public partial class IPCInterface
    {
        private int sizeofInt32  = Marshal.SizeOf(typeof(Int32));
        private int sizeofDouble = Marshal.SizeOf(typeof(double));
    }
}