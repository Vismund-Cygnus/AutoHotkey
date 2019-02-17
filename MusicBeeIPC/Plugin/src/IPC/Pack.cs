using System;
using System.IO;

namespace MusicBeePlugin
{
    public partial class IPCInterface
    {
        // --------------------------------------------------------------------------------
        // All strings are encoded in UTF-16 little endian
        // --------------------------------------------------------------------------------

        public void FreeLRESULT(IntPtr lr)
        {
            smm.Free(lr);
        }

        // --------------------------------------------------------------------------------
        // -Int32:  Byte count of string
        // -byte[]: String data
        // Free the returned LRESULT after use
        // --------------------------------------------------------------------------------
        public IntPtr Pack(string s)
        {
            if (s != null && s.Length > 0)
            {
                int byteCount = System.Text.Encoding.Unicode.GetByteCount(s);

                if (byteCount == 0)
                    return IntPtr.Zero;

                try
                {
                    IntPtr lr = smm.Alloc(sizeofInt32 + byteCount);

                    if (lr == IntPtr.Zero)
                        return IntPtr.Zero;

                    BinaryWriter writer = smm.GetWriter(lr);

                    writer.Write(byteCount);

                    byte[] bytes = System.Text.Encoding.Unicode.GetBytes(s);

                    writer.Write(bytes, 0, byteCount);

                    return lr;
                }
                catch
                {
                    return IntPtr.Zero;
                }
            }

            return IntPtr.Zero;
        }

        // --------------------------------------------------------------------------------
        // -Int32:  Number of strings
        // -Int32:  Byte count of string
        // -byte[]: String data
        // -Int32:  Byte count of string
        // -byte[]: String data
        // -...
        // Free the returned LRESULT after use
        // --------------------------------------------------------------------------------
        public IntPtr Pack(string[] strings)
        {
            try
            {
                long cb = sizeofInt32;

                foreach (string s in strings)
                {
                    cb += sizeofInt32;
                    if (s != null)
                        cb += System.Text.Encoding.Unicode.GetByteCount(s);
                }

                IntPtr lr = smm.Alloc(cb);

                if (lr == IntPtr.Zero)
                    return IntPtr.Zero;

                BinaryWriter writer = smm.GetWriter(lr);

                writer.Write(strings.Length);

                int byteCount = 0;

                foreach (string s in strings)
                {
                    if (s == null || s.Length == 0)
                        byteCount = 0;
                    else
                        byteCount = System.Text.Encoding.Unicode.GetByteCount(s);

                    writer.Write(byteCount);

                    if (byteCount > 0)
                    {
                        byte[] bytes = System.Text.Encoding.Unicode.GetBytes(s);

                        writer.Write(bytes, 0, byteCount);
                    }
                }

                return lr;
            }
            catch
            {
                return IntPtr.Zero;
            }
        }

        // --------------------------------------------------------------------------------
        // -Int32: 32 bit integer
        // -Int32: 32 bit integer
        // -...
        // Free the returned LRESULT after use
        // --------------------------------------------------------------------------------
        public IntPtr Pack(int int32_1, int int32_2)
        {
            try
            {
                IntPtr lr = smm.Alloc(sizeofInt32 * 2);

                if (lr == IntPtr.Zero)
                    return IntPtr.Zero;

                BinaryWriter writer = smm.GetWriter(lr);

                writer.Write(int32_1);
                writer.Write(int32_2);

                return lr;
            }
            catch
            {
                return IntPtr.Zero;
            }
        }

        // --------------------------------------------------------------------------------
        // -Int32: Number of integers
        // -Int32: 32 bit integer
        // -Int32: 32 bit integer
        // -...
        // Free the returned LRESULT after use
        // --------------------------------------------------------------------------------
        public IntPtr Pack(int[] int32s)
        {
            try
            {
                IntPtr lr = smm.Alloc(sizeofInt32 * (int32s.Length + 1));

                if (lr == IntPtr.Zero)
                    return IntPtr.Zero;

                BinaryWriter writer = smm.GetWriter(lr);

                writer.Write(int32s.Length);

                foreach (int int32 in int32s)
                    writer.Write(int32);

                return lr;
            }
            catch
            {
                return IntPtr.Zero;
            }
        }
    }
}