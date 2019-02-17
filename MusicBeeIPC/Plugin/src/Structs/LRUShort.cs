using System;
using System.Runtime.InteropServices;

namespace MusicBeePlugin
{
    [StructLayout(LayoutKind.Explicit)]
    public struct LRUShort
    {
        [FieldOffset(0)]
        public IntPtr lr;
        [FieldOffset(0)]
        public ushort low;
        [FieldOffset(2)]
        public ushort high;

        public LRUShort(IntPtr ptr) { this.low = this.high = 0; this.lr = ptr; }
        public LRUShort(ushort low, ushort high) { this.lr = IntPtr.Zero;  this.low = low; this.high = high; }
    }
}
