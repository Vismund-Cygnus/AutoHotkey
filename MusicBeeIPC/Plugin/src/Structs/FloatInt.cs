using System;
using System.Runtime.InteropServices;

namespace MusicBeePlugin
{
    [StructLayout(LayoutKind.Explicit)]
    public struct FloatInt
    {
        [FieldOffset(0)]
        public float f;
        [FieldOffset(0)]
        public int i;

        public FloatInt(float f) { this.i = 0; this.f = f; }
        public FloatInt(int i) { this.f = 0.0f; this.i = i; }
    }
}
