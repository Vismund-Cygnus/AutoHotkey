using System;
using System.Runtime.InteropServices;
using System.Drawing;
using System.Windows.Forms;
using System.Collections.Generic;
using System.Threading;

namespace MusicBeePlugin
{
    public partial class Plugin
    {
        private MusicBeeApiInterface mbApi;
        private PluginInfo about = new PluginInfo();

        private IPCInterface ipcInterface;
        Thread interfaceThread;

        public PluginInfo Initialise(IntPtr apiInterfacePtr)
        {
            mbApi = new MusicBeeApiInterface();
            mbApi.Initialise(apiInterfacePtr);

            about.PluginInfoVersion = PluginInfoVersion;
            about.Name = "MusicBeeIPC";
            about.Description = "Enables controlling MusicBee with Windows Messages";
            about.TargetApplication = "General";
            about.Author = "Kerli Low";
            about.Type = PluginType.General;
            about.VersionMajor = 2;
            about.VersionMinor = 0;
            about.Revision = 1;
            about.MinInterfaceVersion = MinInterfaceVersion;
            about.MinApiRevision = MinApiRevision;
            about.ReceiveNotifications = 0;
            about.ConfigurationPanelHeight = 0;   // not implemented yet: height in pixels that musicbee should reserve in a panel for config settings. When set, a handle to an empty panel will be passed to the Configure function

            interfaceThread = new Thread(RunIPCInterface);
            interfaceThread.Start();

            return about;
        }

        public bool Configure(IntPtr panelHandle)
        {
            About about = new About();
            about.Show();
            return true;
        }
       
        // called by MusicBee when the user clicks Apply or Save in the MusicBee Preferences screen.
        // its up to you to figure out whether anything has changed and needs updating
        public void SaveSettings()
        {
            // save any persistent settings in a sub-folder of this path
            string dataPath = mbApi.Setting_GetPersistentStoragePath();
        }

        // MusicBee is closing the plugin (plugin is being disabled by user or MusicBee is shutting down)
        public void Close(PluginCloseReason reason)
        {
            ipcInterface.Close();
            Application.Exit();
            interfaceThread.Join();
        }

        // uninstall this plugin - clean up any persisted files
        public void Uninstall()
        {
        }

        // receive event notifications from MusicBee
        // you need to set about.ReceiveNotificationFlags = PlayerEvents to receive all notifications, and not just the startup event
        public void ReceiveNotification(string sourceFileUrl, NotificationType type)
        {
            // perform some action depending on the notification type
        }

        public void RunIPCInterface()
        {
            ipcInterface = new MusicBeePlugin.IPCInterface(ref mbApi);

            Application.Run();
        }
    }
}