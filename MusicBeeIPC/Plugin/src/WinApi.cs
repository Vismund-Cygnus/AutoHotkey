using System;
using System.Runtime.InteropServices;

namespace MusicBeePlugin
{
    public partial class IPCInterface
    {
        // Constants
        public const int WM_USER     = 0x0400,
                         WM_COPYDATA = 0x004A,
                         WM_CLOSE    = 0x0010;


        public const int SW_HIDE            = 0,
                         SW_SHOWNORMAL      = 1,
                         SW_NORMAL          = 1,
                         SW_SHOWMINIMIZED   = 2,
                         SW_SHOWMAXIMIZED   = 3,
                         SW_MAXIMIZE        = 3,
                         SW_SHOWNOACTIVATE  = 4,
                         SW_SHOW            = 5,
                         SW_MINIMIZE        = 6,
                         SW_SHOWMINNOACTIVE = 7,
                         SW_SHOWNA          = 8,
                         SW_RESTORE         = 9;

        public static readonly IntPtr HWND_NOTOPMOST  = new IntPtr(-2),
                                      HWND_TOPMOST    = new IntPtr(-1),
                                      HWND_TOP        = new IntPtr(0),
                                      HWND_BOTTOM     = new IntPtr(1);

        public const int SWP_NOSIZE         = 0x0001,
                         SWP_NOMOVE         = 0x0002,
                         SWP_NOZORDER       = 0x0004,
                         SWP_NOREDRAW       = 0x0008,
                         SWP_NOACTIVATE     = 0x0010,
                         SWP_DRAWFRAME      = 0x0020,
                         SWP_FRAMECHANGED   = 0x0020,
                         SWP_SHOWWINDOW     = 0x0040,
                         SWP_HIDEWINDOW     = 0x0080,
                         SWP_NOCOPYBITS     = 0x0100,
                         SWP_NOOWNERZORDER  = 0x0200,
                         SWP_NOREPOSITION   = 0x0200,
                         SWP_NOSENDCHANGING = 0x0400,
                         SWP_DEFERERASE     = 0x2000,
                         SWP_ASYNCWINDOWPOS = 0x4000;

        // Structs
        [StructLayout(LayoutKind.Sequential)]
        public struct COPYDATASTRUCT
        {
            public IntPtr dwData;
            public UInt32 cbData;
            public IntPtr lpData;
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct WINDOWPLACEMENT
        {
            public int length;
            public int flags;
            public int showCmd;
            public System.Drawing.Point ptMinPosition;
            public System.Drawing.Point ptMaxPosition;
            public System.Drawing.Rectangle rcNormalPosition;
        }

        // Imports
        [DllImport("user32.dll")]
        public static extern IntPtr SendMessage(IntPtr hwnd, uint wMsg, UIntPtr wParam, IntPtr lParam);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool GetWindowRect(IntPtr hwnd, out System.Drawing.Rectangle lpRect);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool GetWindowPlacement(IntPtr hWnd, ref WINDOWPLACEMENT lpwndpl);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool SetWindowPlacement(IntPtr hWnd, ref WINDOWPLACEMENT lpwndpl);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, int uFlags);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool SetForegroundWindow(IntPtr hWnd);
    }
}
