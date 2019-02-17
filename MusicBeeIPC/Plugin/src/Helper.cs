using System;
using System.Runtime.InteropServices;
using System.Xml.Linq;

namespace MusicBeePlugin
{
    public partial class IPCInterface
    {
        private Error ToError(bool b)
        {
            return b ? Error.NoError : Error.Error;
        }

        private IntPtr ToErrorIntPtr(bool b)
        {
            return b ? (IntPtr)Error.NoError : (IntPtr)Error.Error;
        }

        private IntPtr ToErrorIntPtr(IntPtr lResult)
        {
            return lResult == IntPtr.Zero ? (IntPtr)Error.NoError : (IntPtr)Error.Error;
        }

        private IntPtr ToIntPtr(bool b)
        {
            return b ? (IntPtr)Bool.True : (IntPtr)Bool.False;
        }

        private bool ToBool(IntPtr i)
        {
            return i == (IntPtr)Bool.False ? false : true;
        }

        private bool ToBool(int i)
        {
            return i == (int)Bool.False ? false : true;
        }

        private string GenQuery(string[] fields, string comparison, string query)
        {
            XElement conditions = new XElement("Conditions", new XAttribute("CombineMethod", "Any"));

            foreach (string field in fields)
            {
                XElement condition = new XElement("Condition",
                                                  new XAttribute("Field", field),
                                                  new XAttribute("Comparison", comparison),
                                                  new XAttribute("Value", query));

                conditions.Add(condition);
            }

            return conditions.ToString();
        }

        private bool GetWinPlacement(out WINDOWPLACEMENT placement)
        {
            placement = new WINDOWPLACEMENT();
            placement.length = Marshal.SizeOf(placement);
            return GetWindowPlacement(mbApi.MB_GetWindowHandle(), ref placement);
        }

        private bool GetWinRect(out System.Drawing.Rectangle rect)
        {
            rect = new System.Drawing.Rectangle();

            if (!GetWindowRect(mbApi.MB_GetWindowHandle(), out rect))
                return false;

            return true;
        }

        private bool RestoreWindow()
        {
            WINDOWPLACEMENT wndpl;

            if (!GetWinPlacement(out wndpl))
                return false;

            wndpl.showCmd = SW_RESTORE;

            return SetWindowPlacement(mbApi.MB_GetWindowHandle(), ref wndpl);
        }

        private bool MinimizeWindow()
        {
            WINDOWPLACEMENT wndpl;

            if (!GetWinPlacement(out wndpl))
                return false;

            wndpl.showCmd = SW_MINIMIZE;

            return SetWindowPlacement(mbApi.MB_GetWindowHandle(), ref wndpl);
        }

        private bool MaximizeWindow()
        {
            WINDOWPLACEMENT wndpl;

            if (!GetWinPlacement(out wndpl))
                return false;

            wndpl.showCmd = SW_MAXIMIZE;

            return SetWindowPlacement(mbApi.MB_GetWindowHandle(), ref wndpl);
        }

        private bool MoveWindow(int x, int y)
        {
            return SetWindowPos(mbApi.MB_GetWindowHandle(), IntPtr.Zero, x, y, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
        }

        private bool ResizeWindow(int w, int h)
        {
            return SetWindowPos(mbApi.MB_GetWindowHandle(), IntPtr.Zero, 0, 0, w, h, SWP_NOMOVE | SWP_NOZORDER);
        }

        private bool BringWindowToFront()
        {
            if (!RestoreWindow())
                return false;

            return SetForegroundWindow(mbApi.MB_GetWindowHandle());
        }
    }
}
