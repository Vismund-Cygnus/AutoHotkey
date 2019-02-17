using System;
using System.Runtime.InteropServices;

namespace MusicBeePlugin
{
    public partial class IPCInterface
    {
        // --------------------------------------------------------------------------------
        // All strings are encoded in UTF-16 little endian
        // --------------------------------------------------------------------------------

        // --------------------------------------------------------------------------------
        // -Int32: 32 bit integer
        // -Int32: 32 bit integer
        // --------------------------------------------------------------------------------
        [System.Security.Permissions.PermissionSet(System.Security.Permissions.SecurityAction.Demand, Name = "FullTrust")]
        public bool Unpack(COPYDATASTRUCT cds, out int int32_1, out int int32_2)
        {
            int32_1 = 0;
            int32_2 = 0;

            if (cds.cbData < sizeofInt32 * 2)
                return false;

            try
            {
                int32_1 = Marshal.ReadInt32(cds.lpData);
                int32_2 = Marshal.ReadInt32(cds.lpData, sizeofInt32);
                return true;
            }
            catch
            {
                return false;
            }
        }

        // --------------------------------------------------------------------------------
        // -Int32:  Byte count of string
        // -byte[]: String data
        // --------------------------------------------------------------------------------
        [System.Security.Permissions.PermissionSet(System.Security.Permissions.SecurityAction.Demand, Name = "FullTrust")]
        public bool Unpack(COPYDATASTRUCT cds, out string string_1)
        {
            string_1 = "";

            if (cds.cbData < sizeofInt32)
                return false;

            try
            {
                IntPtr ptr = cds.lpData;

                int byteCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                byte[] bytes;

                if (byteCount > 0)
                {
                    bytes = new byte[byteCount];

                    Marshal.Copy(ptr, bytes, 0, byteCount);

                    string_1 = System.Text.Encoding.Unicode.GetString(bytes);
                }

                return true;
            }
            catch
            {
                return false;
            }
        }

        // --------------------------------------------------------------------------------
        // -Int32:  Byte count of string
        // -byte[]: String data
        // -Int32:  Byte count of string
        // -byte[]: String data
        // --------------------------------------------------------------------------------
        [System.Security.Permissions.PermissionSet(System.Security.Permissions.SecurityAction.Demand, Name = "FullTrust")]
        public bool Unpack(COPYDATASTRUCT cds, out string string_1, out string string_2)
        {
            string_1 = "";
            string_2 = "";

            if (cds.cbData < sizeofInt32 * 2)
                return false;

            try
            {
                IntPtr ptr = cds.lpData;

                int byteCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                byte[] bytes;

                if (byteCount > 0)
                {
                    bytes = new byte[byteCount];

                    Marshal.Copy(ptr, bytes, 0, byteCount);

                    string_1 = System.Text.Encoding.Unicode.GetString(bytes);

                    ptr += byteCount;
                }

                byteCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                if (byteCount > 0)
                {
                    bytes = new byte[byteCount];

                    Marshal.Copy(ptr, bytes, 0, byteCount);

                    string_2 = System.Text.Encoding.Unicode.GetString(bytes);
                }

                return true;
            }
            catch
            {
                return false;
            }
        }

        // --------------------------------------------------------------------------------
        // -Int32:  Byte count of string
        // -byte[]: String data
        // -Int32:  Byte count of string
        // -byte[]: String data
        // -Int32:  Byte count of string
        // -byte[]: String data
        // --------------------------------------------------------------------------------
        [System.Security.Permissions.PermissionSet(System.Security.Permissions.SecurityAction.Demand, Name = "FullTrust")]
        public bool Unpack(COPYDATASTRUCT cds, out string string_1, out string string_2, out string string_3)
        {
            string_1 = "";
            string_2 = "";
            string_3 = "";

            if (cds.cbData < sizeofInt32 * 3)
                return false;

            try
            {
                IntPtr ptr = cds.lpData;

                int byteCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                byte[] bytes;

                if (byteCount > 0)
                {
                    bytes = new byte[byteCount];

                    Marshal.Copy(ptr, bytes, 0, byteCount);

                    string_1 = System.Text.Encoding.Unicode.GetString(bytes);

                    ptr += byteCount;
                }

                byteCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                if (byteCount > 0)
                {
                    bytes = new byte[byteCount];

                    Marshal.Copy(ptr, bytes, 0, byteCount);

                    string_2 = System.Text.Encoding.Unicode.GetString(bytes);

                    ptr += byteCount;
                }

                byteCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                if (byteCount > 0)
                {
                    bytes = new byte[byteCount];

                    Marshal.Copy(ptr, bytes, 0, byteCount);

                    string_2 = System.Text.Encoding.Unicode.GetString(bytes);
                }

                return true;
            }
            catch
            {
                return false;
            }
        }

        // --------------------------------------------------------------------------------
        // -Int32:  Byte count of string
        // -byte[]: String data
        // -Int32:  32 bit integer
        // --------------------------------------------------------------------------------
        [System.Security.Permissions.PermissionSet(System.Security.Permissions.SecurityAction.Demand, Name = "FullTrust")]
        public bool Unpack(COPYDATASTRUCT cds, out string string_1, out int int32_1)
        {
            string_1 = "";
            int32_1 = 0;

            if (cds.cbData < sizeofInt32 * 2)
                return false;

            try
            {
                IntPtr ptr = cds.lpData;

                int byteCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                byte[] bytes;

                if (byteCount > 0)
                {
                    bytes = new byte[byteCount];

                    Marshal.Copy(ptr, bytes, 0, byteCount);

                    string_1 = System.Text.Encoding.Unicode.GetString(bytes);

                    ptr += byteCount;
                }

                int32_1 = Marshal.ReadInt32(ptr);

                return true;
            }
            catch
            {
                return false;
            }
        }
        
        // --------------------------------------------------------------------------------
        // -Int32:  Byte count of string
        // -byte[]: String data
        // -Int32:  Bool
        // --------------------------------------------------------------------------------
        [System.Security.Permissions.PermissionSet(System.Security.Permissions.SecurityAction.Demand, Name = "FullTrust")]
        public bool Unpack(COPYDATASTRUCT cds, out string string_1, out bool bool_1)
        {
            string_1 = "";
            bool_1 = false;

            if (cds.cbData < sizeofInt32 * 2)
                return false;

            try
            {
                IntPtr ptr = cds.lpData;

                int byteCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                byte[] bytes;

                if (byteCount > 0)
                {
                    bytes = new byte[byteCount];

                    Marshal.Copy(ptr, bytes, 0, byteCount);

                    string_1 = System.Text.Encoding.Unicode.GetString(bytes);

                    ptr += byteCount;
                }

                bool_1 = Marshal.ReadInt32(ptr) == (int)Bool.False ? false : true;

                return true;
            }
            catch
            {
                return false;
            }
        }

        // --------------------------------------------------------------------------------
        // -Int32:  Byte count of string
        // -byte[]: String data
        // -double: 64-bit floating-point value
        // --------------------------------------------------------------------------------
        [System.Security.Permissions.PermissionSet(System.Security.Permissions.SecurityAction.Demand, Name = "FullTrust")]
        public bool Unpack(COPYDATASTRUCT cds, out string string_1, out double double_1)
        {
            string_1 = "";
            double_1 = 0.0;

            if (cds.cbData < sizeofInt32 + sizeofDouble)
                return false;

            try
            {
                IntPtr ptr = cds.lpData;

                int byteCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                byte[] bytes;

                if (byteCount > 0)
                {
                    bytes = new byte[byteCount];

                    Marshal.Copy(ptr, bytes, 0, byteCount);

                    string_1 = System.Text.Encoding.Unicode.GetString(bytes);

                    ptr += byteCount;
                }

                double[] buffer = new double[1];

                Marshal.Copy(ptr, buffer, 0, 1);

                double_1 = buffer[0];

                return true;
            }
            catch
            {
                return false;
            }
        }

        // --------------------------------------------------------------------------------
        // -Int32:  Byte count of string
        // -byte[]: String data
        // -Int32:  32 bit integer
        // -Int32:  32 bit integer
        // --------------------------------------------------------------------------------
        [System.Security.Permissions.PermissionSet(System.Security.Permissions.SecurityAction.Demand, Name = "FullTrust")]
        public bool Unpack(COPYDATASTRUCT cds, out string string_1, out int int32_1, out int int32_2)
        {
            string_1 = "";
            int32_1 = 0;
            int32_2 = 0;

            if (cds.cbData < sizeofInt32 * 3)
                return false;

            try
            {
                IntPtr ptr = cds.lpData;

                int byteCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                byte[] bytes;

                if (byteCount > 0)
                {
                    bytes = new byte[byteCount];

                    Marshal.Copy(ptr, bytes, 0, byteCount);

                    string_1 = System.Text.Encoding.Unicode.GetString(bytes);

                    ptr += byteCount;
                }

                int32_1 = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                int32_2 = Marshal.ReadInt32(ptr);

                return true;
            }
            catch
            {
                return false;
            }
        }

        // --------------------------------------------------------------------------------
        // -Int32:  Byte count of string
        // -byte[]: String data
        // -Int32:  32 bit integer
        // -Int32:  Byte count of string
        // -byte[]: String data
        // --------------------------------------------------------------------------------
        [System.Security.Permissions.PermissionSet(System.Security.Permissions.SecurityAction.Demand, Name = "FullTrust")]
        public bool Unpack(COPYDATASTRUCT cds, out string string_1, out int int32_1, out string string_2)
        {
            string_1 = "";
            int32_1 = 0;
            string_2 = "";

            if (cds.cbData < sizeofInt32 * 3)
                return false;

            try
            {
                IntPtr ptr = cds.lpData;

                int byteCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                byte[] bytes;

                if (byteCount > 0)
                {
                    bytes = new byte[byteCount];

                    Marshal.Copy(ptr, bytes, 0, byteCount);

                    string_1 = System.Text.Encoding.Unicode.GetString(bytes);

                    ptr += byteCount;
                }

                int32_1 = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                byteCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                if (byteCount > 0)
                {
                    bytes = new byte[byteCount];

                    Marshal.Copy(ptr, bytes, 0, byteCount);

                    string_2 = System.Text.Encoding.Unicode.GetString(bytes);
                }

                return true;
            }
            catch
            {
                return false;
            }
        }

        // --------------------------------------------------------------------------------
        // -Int32:  Number of integers in integer array
        // -Int32:  integer in integer array
        // -Int32:  integer in integer array
        // -...
        // -Int32:  32 bit integer
        // --------------------------------------------------------------------------------
        [System.Security.Permissions.PermissionSet(System.Security.Permissions.SecurityAction.Demand, Name = "FullTrust")]
        public bool Unpack(COPYDATASTRUCT cds, out int[] int32s_1, out int int32_1)
        {
            int32s_1 = null;
            int32_1 = 0;

            if (cds.cbData < sizeofInt32 * 2)
                return false;

            try
            {
                IntPtr ptr = cds.lpData;

                int intCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                if (intCount > 0)
                {
                    int32s_1 = new int[intCount];

                    for (int i = 0; i < intCount; i++)
                    {
                        int32s_1[i] = Marshal.ReadInt32(ptr);
                        ptr += sizeofInt32;
                    }
                }

                int32_1 = Marshal.ReadInt32(ptr);

                return true;
            }
            catch
            {
                return false;
            }
        }

        // --------------------------------------------------------------------------------
        // -Int32:  Byte count of string
        // -byte[]: String data
        // -Int32:  Number of integers in integer array
        // -Int32:  integer in integer array
        // -Int32:  integer in integer array
        // -...
        // -Int32:  32 bit integer
        // --------------------------------------------------------------------------------
        [System.Security.Permissions.PermissionSet(System.Security.Permissions.SecurityAction.Demand, Name = "FullTrust")]
        public bool Unpack(COPYDATASTRUCT cds, out string string_1, out int[] int32s_1, out int int32_1)
        {
            string_1 = "";
            int32s_1 = null;
            int32_1 = 0;

            if (cds.cbData < sizeofInt32 * 3)
                return false;

            try
            {
                IntPtr ptr = cds.lpData;

                int byteCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                byte[] bytes;

                if (byteCount > 0)
                {
                    bytes = new byte[byteCount];

                    Marshal.Copy(ptr, bytes, 0, byteCount);

                    string_1 = System.Text.Encoding.Unicode.GetString(bytes);

                    ptr += byteCount;
                }

                int intCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                if (intCount > 0)
                {
                    int32s_1 = new int[intCount];

                    for (int i = 0; i < intCount; i++)
                    {
                        int32s_1[i] = Marshal.ReadInt32(ptr);
                        ptr += sizeofInt32;
                    }
                }

                int32_1 = Marshal.ReadInt32(ptr);

                return true;
            }
            catch
            {
                return false;
            }
        }

        // --------------------------------------------------------------------------------
        // -Int32:  Byte count of string
        // -byte[]: String data
        // -Int32:  Number of strings in string array
        // -Int32:  Byte count of string in string array
        // -byte[]: String data in string array
        // -Int32:  Byte count of string in string array
        // -byte[]: String data in string array
        // -...
        // --------------------------------------------------------------------------------
        [System.Security.Permissions.PermissionSet(System.Security.Permissions.SecurityAction.Demand, Name = "FullTrust")]
        public bool Unpack(COPYDATASTRUCT cds, out string string_1, out string[] strings_1)
        {
            string_1 = "";
            strings_1 = null;

            if (cds.cbData < sizeofInt32 * 2)
                return false;

            try
            {
                IntPtr ptr = cds.lpData;

                int byteCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                byte[] bytes;

                if (byteCount > 0)
                {
                    bytes = new byte[byteCount];

                    Marshal.Copy(ptr, bytes, 0, byteCount);

                    string_1 = System.Text.Encoding.Unicode.GetString(bytes);

                    ptr += byteCount;
                }

                int strCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                if (strCount > 0)
                {
                    strings_1 = new string[strCount];

                    for (int i = 0; i < strCount; i++)
                    {
                        byteCount = Marshal.ReadInt32(ptr);

                        ptr += sizeofInt32;

                        if (byteCount > 0)
                        {
                            bytes = new byte[byteCount];

                            Marshal.Copy(ptr, bytes, 0, byteCount);

                            strings_1[i] = System.Text.Encoding.Unicode.GetString(bytes);

                            ptr += byteCount;
                        }
                        else
                            strings_1[i] = "";
                    }
                }

                return true;
            }
            catch
            {
                return false;
            }
        }

        // --------------------------------------------------------------------------------
        // -Int32:  Byte count of string
        // -byte[]: String data
        // -Int32:  Byte count of string
        // -byte[]: String data
        // -Int32:  Number of strings in string array
        // -Int32:  Byte count of string in string array
        // -byte[]: String data in string array
        // -Int32:  Byte count of string in string array
        // -byte[]: String data in string array
        // -...
        // --------------------------------------------------------------------------------
        [System.Security.Permissions.PermissionSet(System.Security.Permissions.SecurityAction.Demand, Name = "FullTrust")]
        public bool Unpack(COPYDATASTRUCT cds, out string string_1, out string string_2, out string[] strings_1)
        {
            string_1 = "";
            string_2 = "";
            strings_1 = null;

            if (cds.cbData < sizeofInt32 * 3)
                return false;

            try
            {
                IntPtr ptr = cds.lpData;

                int byteCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                byte[] bytes;

                if (byteCount > 0)
                {
                    bytes = new byte[byteCount];

                    Marshal.Copy(ptr, bytes, 0, byteCount);

                    string_1 = System.Text.Encoding.Unicode.GetString(bytes);

                    ptr += byteCount;
                }

                byteCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                if (byteCount > 0)
                {
                    bytes = new byte[byteCount];

                    Marshal.Copy(ptr, bytes, 0, byteCount);

                    string_2 = System.Text.Encoding.Unicode.GetString(bytes);

                    ptr += byteCount;
                }

                int strCount = Marshal.ReadInt32(ptr);

                ptr += sizeofInt32;

                if (strCount > 0)
                {
                    strings_1 = new string[strCount];

                    for (int i = 0; i < strCount; i++)
                    {
                        byteCount = Marshal.ReadInt32(ptr);

                        ptr += sizeofInt32;

                        if (byteCount > 0)
                        {
                            bytes = new byte[byteCount];

                            Marshal.Copy(ptr, bytes, 0, byteCount);

                            strings_1[i] = System.Text.Encoding.Unicode.GetString(bytes);

                            ptr += byteCount;
                        }
                        else
                            strings_1[i] = "";
                    }
                }

                return true;
            }
            catch
            {
                return false;
            }
        }
    }
}
