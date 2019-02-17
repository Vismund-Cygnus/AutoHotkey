using System;
using System.Runtime.InteropServices;
using System.ComponentModel;
using System.Windows.Forms;
using System.Reflection;

namespace MusicBeePlugin
{
    [System.Security.Permissions.PermissionSet(System.Security.Permissions.SecurityAction.Demand, Name = "FullTrust")]
    public partial class IPCInterface : NativeWindow
    {
        private Plugin.MusicBeeApiInterface mbApi;

        private SharedMemoryMgr smm;

        public IPCInterface(ref Plugin.MusicBeeApiInterface mbApi)
        {
            CreateParams cp = new CreateParams();
            cp.Caption = "MusicBee IPC Interface";
            cp.ClassName = null;
            cp.X = 0;
            cp.Y = 0;
            cp.Width = 0;
            cp.Height = 0;
            cp.Style = 0;
            cp.Parent = IntPtr.Zero;

            try
            {
                this.CreateHandle(cp);
            }
            catch (OutOfMemoryException e)
            {
                MessageBox.Show("Out of memory.",
                                "MusicBee IPC Error",  MessageBoxButtons.OK, MessageBoxIcon.Error);
                throw (e);
            }
            catch (Win32Exception e)
            {
                MessageBox.Show("Could not create specific window:\n" + e.Message,
                                "MusicBee IPC Error",  MessageBoxButtons.OK, MessageBoxIcon.Error);
                throw (e);
            }
            catch (InvalidOperationException e)
            {
                MessageBox.Show("Handle is already assigned.",
                                "MusicBee IPC Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                throw (e);
            }

            this.mbApi = mbApi;

            try
            {
                smm = new SharedMemoryMgr();
            }
            catch (Exception e)
            {
                MessageBox.Show("Failed to create Memory-Mapped File",
                                "MusicBee IPC Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                throw (e);
            }
        }

        ~IPCInterface()
        {
            Close();
        }

        public void Close()
        {
            if (Handle != IntPtr.Zero)
                DestroyHandle();
        }

        [System.Security.Permissions.PermissionSet(System.Security.Permissions.SecurityAction.Demand, Name = "FullTrust")]
        protected override void WndProc(ref Message m)
        {
            switch (m.Msg)
            {
                case WM_USER:
                    {
                        switch ((Command)m.WParam)
                        {
                            case Command.PlayPause:
                                m.Result = ToErrorIntPtr(mbApi.Player_PlayPause());
                                break;

                            case Command.Play:
                                if (mbApi.Player_GetPlayState() == Plugin.PlayState.Playing)
                                    m.Result = ToErrorIntPtr(mbApi.Player_SetPosition(0));
                                else
                                    m.Result = ToErrorIntPtr(mbApi.Player_PlayPause());
                                break;

                            case Command.Pause:
                                if (mbApi.Player_GetPlayState() == Plugin.PlayState.Playing)
                                    m.Result = ToErrorIntPtr(mbApi.Player_PlayPause());
                                else
                                    m.Result = (IntPtr)Error.NoError;
                                break;

                            case Command.Stop:
                                m.Result = ToErrorIntPtr(mbApi.Player_Stop());
                                break;

                            case Command.StopAfterCurrent:
                                m.Result = ToErrorIntPtr(mbApi.Player_StopAfterCurrent());
                                break;

                            case Command.PreviousTrack:
                                m.Result = ToErrorIntPtr(mbApi.Player_PlayPreviousTrack());
                                break;

                            case Command.NextTrack:
                                m.Result = ToErrorIntPtr(mbApi.Player_PlayNextTrack());
                                break;

                            case Command.StartAutoDj:
                                m.Result = ToErrorIntPtr(mbApi.Player_StartAutoDj());
                                break;

                            case Command.EndAutoDj:
                                m.Result = ToErrorIntPtr(mbApi.Player_EndAutoDj());
                                break;

                            case Command.GetPlayState:
                                m.Result = (IntPtr)mbApi.Player_GetPlayState();
                                break;

                            case Command.GetPosition:
                                m.Result = (IntPtr)mbApi.Player_GetPosition();
                                break;

                            case Command.SetPosition:
                                m.Result = ToErrorIntPtr(mbApi.Player_SetPosition((int)m.LParam));
                                break;

                            case Command.GetVolume:
                                m.Result = (IntPtr)(mbApi.Player_GetVolume() * 100);
                                break;

                            case Command.SetVolume:
                                m.Result = ToErrorIntPtr(mbApi.Player_SetVolume((float)m.LParam / 100.0f));
                                break;

                            case Command.GetVolumep:
                                m.Result = (IntPtr)(mbApi.Player_GetVolume() * 10000);
                                break;

                            case Command.SetVolumep:
                                m.Result = ToErrorIntPtr(mbApi.Player_SetVolume((float)m.LParam / 10000.0f));
                                break;

                            case Command.GetVolumef:
                                m.Result = (IntPtr)(new FloatInt(mbApi.Player_GetVolume())).i;
                                break;

                            case Command.SetVolumef:
                                m.Result = ToErrorIntPtr(mbApi.Player_SetVolume((new FloatInt((int)m.LParam)).f));
                                break;

                            case Command.GetMute:
                                m.Result = ToIntPtr(mbApi.Player_GetMute());
                                break;

                            case Command.SetMute:
                                m.Result = ToErrorIntPtr(mbApi.Player_SetMute(ToBool(m.LParam)));
                                break;

                            case Command.GetShuffle:
                                m.Result = ToIntPtr(mbApi.Player_GetShuffle());
                                break;

                            case Command.SetShuffle:
                                m.Result = ToErrorIntPtr(mbApi.Player_SetShuffle(ToBool(m.LParam)));
                                break;

                            case Command.GetRepeat:
                                m.Result = (IntPtr)mbApi.Player_GetRepeat();
                                break;

                            case Command.SetRepeat:
                                m.Result = ToErrorIntPtr(mbApi.Player_SetRepeat((Plugin.RepeatMode)m.LParam));
                                break;

                            case Command.GetEqualiserEnabled:
                                m.Result = ToIntPtr(mbApi.Player_GetEqualiserEnabled());
                                break;

                            case Command.SetEqualiserEnabled:
                                m.Result = ToErrorIntPtr(mbApi.Player_SetEqualiserEnabled(ToBool(m.LParam)));
                                break;

                            case Command.GetDspEnabled:
                                m.Result = ToIntPtr(mbApi.Player_GetDspEnabled());
                                break;

                            case Command.SetDspEnabled:
                                m.Result = ToErrorIntPtr(mbApi.Player_SetDspEnabled(ToBool(m.LParam)));
                                break;

                            case Command.GetScrobbleEnabled:
                                m.Result = ToIntPtr(mbApi.Player_GetScrobbleEnabled());
                                break;

                            case Command.SetScrobbleEnabled:
                                m.Result = ToErrorIntPtr(mbApi.Player_SetScrobbleEnabled(ToBool(m.LParam)));
                                break;

                            case Command.ShowEqualiser:
                                m.Result = ToErrorIntPtr(mbApi.Player_ShowEqualiser());
                                break;

                            case Command.GetAutoDjEnabled:
                                m.Result = ToIntPtr(mbApi.Player_GetAutoDjEnabled());
                                break;

                            case Command.GetStopAfterCurrentEnabled:
                                m.Result = ToIntPtr(mbApi.Player_GetStopAfterCurrentEnabled());
                                break;

                            case Command.SetStopAfterCurrentEnabled:
                                if (mbApi.Player_GetStopAfterCurrentEnabled() != ToBool(m.LParam))
                                    m.Result = ToErrorIntPtr(mbApi.Player_StopAfterCurrent());
                                else
                                    m.Result = (IntPtr)Error.NoError;
                                break;

                            case Command.GetCrossfade:
                                m.Result = ToIntPtr(mbApi.Player_GetCrossfade());
                                break;

                            case Command.SetCrossfade:
                                m.Result = ToErrorIntPtr(mbApi.Player_SetCrossfade(ToBool(m.LParam)));
                                break;

                            case Command.GetReplayGainMode:
                                m.Result = (IntPtr)mbApi.Player_GetReplayGainMode();
                                break;

                            case Command.SetReplayGainMode:
                                m.Result = ToErrorIntPtr(mbApi.Player_SetReplayGainMode((Plugin.ReplayGainMode)m.LParam));
                                break;

                            case Command.QueueRandomTracks:
                                m.Result = (IntPtr)mbApi.Player_QueueRandomTracks((int)m.LParam);
                                break;

                            case Command.GetDuration:
                                m.Result = (IntPtr)mbApi.NowPlaying_GetDuration();
                                break;

                            case Command.GetFileUrl:
                                m.Result = Pack(mbApi.NowPlaying_GetFileUrl());
                                break;

                            case Command.GetFileProperty:
                                m.Result = Pack(mbApi.NowPlaying_GetFileProperty((Plugin.FilePropertyType)m.LParam));
                                break;

                            case Command.GetFileTag:
                                m.Result = Pack(mbApi.NowPlaying_GetFileTag((Plugin.MetaDataType)m.LParam));
                                break;

                            case Command.GetLyrics:
                                m.Result = Pack(mbApi.NowPlaying_GetLyrics());
                                break;

                            case Command.GetDownloadedLyrics:
                                m.Result = Pack(mbApi.NowPlaying_GetDownloadedLyrics());
                                break;

                            case Command.GetArtwork:
                                m.Result = Pack(mbApi.NowPlaying_GetArtwork());
                                break;

                            case Command.GetArtworkUrl:
                                m.Result = Pack(mbApi.NowPlaying_GetArtworkUrl());
                                break;

                            case Command.GetDownloadedArtwork:
                                m.Result = Pack(mbApi.NowPlaying_GetDownloadedArtwork());
                                break;

                            case Command.GetDownloadedArtworkUrl:
                                m.Result = Pack(mbApi.NowPlaying_GetDownloadedArtworkUrl());
                                break;

                            case Command.GetArtistPicture:
                                m.Result = Pack(mbApi.NowPlaying_GetArtistPicture((int)m.LParam));
                                break;

                            case Command.GetArtistPictureUrls:
                                {
                                    string[] urls = null;
                                    if (mbApi.NowPlaying_GetArtistPictureUrls(ToBool(m.LParam), ref urls))
                                        m.Result = Pack(urls);
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.GetArtistPictureThumb:
                                m.Result = Pack(mbApi.NowPlaying_GetArtistPictureThumb());
                                break;

                            case Command.IsSoundtrack:
                                m.Result = ToIntPtr(mbApi.NowPlaying_IsSoundtrack());
                                break;

                            case Command.GetSoundtrackPictureUrls:
                                {
                                    string[] urls = null;
                                    if (mbApi.NowPlaying_GetSoundtrackPictureUrls(ToBool(m.LParam), ref urls))
                                        m.Result = Pack(urls);
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.GetCurrentIndex:
                                m.Result = (IntPtr)mbApi.NowPlayingList_GetCurrentIndex();
                                break;

                            case Command.GetNextIndex:
                                m.Result = (IntPtr)mbApi.NowPlayingList_GetNextIndex((int)m.LParam);
                                break;

                            case Command.IsAnyPriorTracks:
                                m.Result = ToIntPtr(mbApi.NowPlayingList_IsAnyPriorTracks());
                                break;

                            case Command.IsAnyFollowingTracks:
                                m.Result = ToIntPtr(mbApi.NowPlayingList_IsAnyFollowingTracks());
                                break;

                            case Command.RemoveAt:
                                m.Result = ToErrorIntPtr(mbApi.NowPlayingList_RemoveAt((int)m.LParam));
                                break;

                            case Command.ClearNowPlayingList:
                                m.Result = ToErrorIntPtr(mbApi.NowPlayingList_Clear());
                                break;

                            case Command.ShowNowPlayingAssistant:
                                m.Result = ToErrorIntPtr(mbApi.MB_ShowNowPlayingAssistant());
                                break;

                            case Command.GetShowTimeRemaining:
                                m.Result = ToIntPtr(mbApi.Player_GetShowTimeRemaining());
                                break;

                            case Command.GetShowRatingTrack:
                                m.Result = ToIntPtr(mbApi.Player_GetShowRatingTrack());
                                break;

                            case Command.GetShowRatingLove:
                                m.Result = ToIntPtr(mbApi.Player_GetShowRatingLove());
                                break;

                            case Command.GetButtonEnabled:
                                m.Result = ToIntPtr(mbApi.Player_GetButtonEnabled((Plugin.PlayButtonType)m.LParam));
                                break;

                            case Command.Jump:
                                {
                                    int index = (int)m.LParam;

                                    string[] listFiles = null;

                                    mbApi.NowPlayingList_QueryFilesEx(null, ref listFiles);

                                    if (index < listFiles.Length)
                                        m.Result = ToErrorIntPtr(mbApi.NowPlayingList_PlayNow(listFiles[index]));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.NowPlayingList_GetListFileUrl:
                                m.Result = Pack(mbApi.NowPlayingList_GetListFileUrl((int)m.LParam));
                                break;

                            case Command.NowPlayingList_QueryGetNextFile:
                                m.Result = Pack(mbApi.NowPlayingList_QueryGetNextFile());
                                break;

                            case Command.NowPlayingList_QueryGetAllFiles:
                                m.Result = Pack(mbApi.NowPlayingList_QueryGetAllFiles());
                                break;

                            case Command.NowPlayingList_PlayLibraryShuffled:
                                m.Result = ToErrorIntPtr(mbApi.NowPlayingList_PlayLibraryShuffled());
                                break;

                            case Command.NowPlayingList_GetItemCount:
                                {
                                    string[] listFiles = null;

                                    mbApi.NowPlayingList_QueryFilesEx(null, ref listFiles);

                                    m.Result = (IntPtr)listFiles.Length;
                                }
                                break;

                            case Command.Playlist_QueryPlaylists:
                                m.Result = ToErrorIntPtr(mbApi.Playlist_QueryPlaylists());
                                break;

                            case Command.Playlist_QueryGetNextPlaylist:
                                m.Result = Pack(mbApi.Playlist_QueryGetNextPlaylist());
                                break;

                            case Command.Playlist_QueryGetNextFile:
                                m.Result = Pack(mbApi.Playlist_QueryGetNextFile());
                                break;

                            case Command.Playlist_QueryGetAllFiles:
                                m.Result = Pack(mbApi.Playlist_QueryGetAllFiles());
                                break;

                            case Command.Library_QueryGetNextFile:
                                m.Result = Pack(mbApi.Library_QueryGetNextFile());
                                break;

                            case Command.Library_QueryGetAllFiles:
                                m.Result = Pack(mbApi.Library_QueryGetAllFiles());
                                break;

                            case Command.Library_GetItemCount:
                                {
                                    string[] listFiles = null;

                                    mbApi.Library_QueryFilesEx(null, ref listFiles);

                                    m.Result = (IntPtr)listFiles.Length;
                                }
                                break;

                            case Command.Library_Jump:
                                {
                                    int index = (int)m.LParam;

                                    string[] listFiles = null;

                                    mbApi.Library_QueryFilesEx(null, ref listFiles);

                                    if (index < listFiles.Length)
                                        m.Result = ToErrorIntPtr(mbApi.NowPlayingList_PlayNow(listFiles[index]));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.Setting_GetFieldName:
                                m.Result = Pack(mbApi.Setting_GetFieldName((Plugin.MetaDataType)m.LParam));
                                break;

                            case Command.Setting_GetDataType:
                                m.Result = (IntPtr)mbApi.Setting_GetDataType((Plugin.MetaDataType)m.LParam);
                                break;

                            case Command.Window_GetHandle:
                                m.Result = mbApi.MB_GetWindowHandle();
                                break;

                            case Command.Window_Close:
                                m.Result = ToErrorIntPtr(SendMessage(mbApi.MB_GetWindowHandle(), WM_CLOSE, UIntPtr.Zero, IntPtr.Zero));
                                break;

                            case Command.Window_Restore:
                                m.Result = ToErrorIntPtr(RestoreWindow());
                                break;

                            case Command.Window_Minimize:
                                m.Result = ToErrorIntPtr(MinimizeWindow());
                                break;

                            case Command.Window_Maximize:
                                m.Result = ToErrorIntPtr(MaximizeWindow());
                                break;

                            case Command.Window_BringToFront:
                                m.Result = ToErrorIntPtr(BringWindowToFront());
                                break;

                            case Command.Window_GetPosition:
                                {
                                    System.Drawing.Rectangle rect;
                                    if (GetWinRect(out rect))
                                        m.Result = Pack(rect.X, rect.Y);
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Window_GetSize:
                                {
                                    System.Drawing.Rectangle rect;
                                    if (GetWinRect(out rect))
                                        m.Result = Pack(rect.Width, rect.Height);
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.FreeLRESULT:
                                FreeLRESULT(m.LParam);
                                m.Result = (IntPtr)Error.NoError;
                                break;

                            case Command.MusicBeeVersion:
                                m.Result = (IntPtr)mbApi.MusicBeeVersion;
                                break;

                            case Command.PluginVersion:
                                m.Result = Pack(typeof(IPCInterface).Assembly.GetName().Version.ToString());
                                break;

                            case Command.Test:
                                MessageBox.Show("Test", "MusicBee IPC");
                                m.Result = (IntPtr)Error.NoError;
                                break;

                            case Command.Probe:
                                m.Result = (IntPtr)Error.NoError;
                                break;

                            default:
                                m.Result = (IntPtr)Error.CommandNotRecognized;
                                break;
                        }
                    }
                    break;

                case WM_COPYDATA:
                    {
                        COPYDATASTRUCT cds = new COPYDATASTRUCT();
                        cds = (COPYDATASTRUCT)Marshal.PtrToStructure(m.LParam, typeof(COPYDATASTRUCT));

                        switch ((Command)m.WParam)
                        {
                            case Command.PlayNow:
                                {
                                    string sourceFileUrl;
                                    if (Unpack(cds, out sourceFileUrl))
                                        m.Result = ToErrorIntPtr(mbApi.NowPlayingList_PlayNow(sourceFileUrl));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.QueueNext:
                                {
                                    string sourceFileUrl;
                                    if (Unpack(cds, out sourceFileUrl))
                                        m.Result = ToErrorIntPtr(mbApi.NowPlayingList_QueueNext(sourceFileUrl));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.QueueLast:
                                {
                                    string sourceFileUrl;
                                    if (Unpack(cds, out sourceFileUrl))
                                        m.Result = ToErrorIntPtr(mbApi.NowPlayingList_QueueLast(sourceFileUrl));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.MoveFiles:
                                {
                                    int[] fromIndices;
                                    int toIndex;
                                    if (Unpack(cds, out fromIndices, out toIndex))
                                        m.Result = ToErrorIntPtr(mbApi.NowPlayingList_MoveFiles(fromIndices, toIndex));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.Search:
                                {
                                    string query, comparison;
                                    string[] fields;

                                    if (Unpack(cds, out query, out comparison, out fields))
                                    {
                                        string[] filenames = null;
                                        if (mbApi.NowPlayingList_QueryFilesEx(GenQuery(fields, comparison, query), ref filenames))
                                            m.Result = Pack(filenames);
                                        else
                                            m.Result = IntPtr.Zero;
                                    }
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.SearchFirst:
                                {
                                    m.Result = IntPtr.Zero;

                                    string query, comparison;
                                    string[] fields;

                                    if (Unpack(cds, out query, out comparison, out fields))
                                    {
                                        if (mbApi.NowPlayingList_QueryFiles(GenQuery(fields, comparison, query)))
                                            m.Result = Pack(mbApi.NowPlayingList_QueryGetNextFile());
                                    }
                                }
                                break;

                            case Command.SearchIndices:
                                {
                                    m.Result = (IntPtr)(-1);

                                    string query, comparison;
                                    string[] fields;

                                    if (Unpack(cds, out query, out comparison, out fields))
                                    {
                                        string[] filenames = null;
                                        if (mbApi.NowPlayingList_QueryFilesEx(GenQuery(fields, comparison, query), ref filenames))
                                        {
                                            int[] indices = new int[filenames.Length];

                                            if (filenames.Length > 0)
                                            {
                                                string[] listFiles = null;

                                                mbApi.NowPlayingList_QueryFilesEx(null, ref listFiles);

                                                for (int i = 0; i < filenames.Length; i++)
                                                    indices[i] = Array.FindIndex(listFiles, s => s.Equals(filenames[i], StringComparison.CurrentCultureIgnoreCase));
                                            }

                                            m.Result = Pack(indices);
                                        }
                                    }
                                }
                                break;

                            case Command.SearchFirstIndex:
                                {
                                    m.Result = (IntPtr)(-1);

                                    string query, comparison;
                                    string[] fields;

                                    if (Unpack(cds, out query, out comparison, out fields))
                                    {
                                        if (mbApi.NowPlayingList_QueryFiles(GenQuery(fields, comparison, query)))
                                        {
                                            string filename = mbApi.NowPlayingList_QueryGetNextFile();
                                            if (filename.Length > 0)
                                            {
                                                string[] listFiles = null;

                                                mbApi.NowPlayingList_QueryFilesEx(null, ref listFiles);

                                                m.Result = (IntPtr)Array.FindIndex(listFiles, s => s.Equals(filename, StringComparison.CurrentCultureIgnoreCase));
                                            }
                                        }
                                    }
                                }
                                break;

                            case Command.SearchAndPlayFirst:
                                {
                                    m.Result = (IntPtr)Error.Error;

                                    string query, comparison;
                                    string[] fields;

                                    if (Unpack(cds, out query, out comparison, out fields))
                                    {
                                        if (mbApi.NowPlayingList_QueryFiles(GenQuery(fields, comparison, query)))
                                        {
                                            mbApi.NowPlayingList_PlayNow(mbApi.NowPlayingList_QueryGetNextFile());

                                            m.Result = (IntPtr)Error.NoError;
                                        }
                                    }
                                }
                                break;

                            case Command.NowPlayingList_GetFileProperty:
                                {
                                    int index, type;
                                    if (Unpack(cds, out index, out type))
                                    {
                                        string fileProperty = mbApi.NowPlayingList_GetFileProperty(index, (Plugin.FilePropertyType)type);
                                        m.Result = Pack(fileProperty);
                                    }
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.NowPlayingList_GetFileTag:
                                {
                                    int index, field;
                                    if (Unpack(cds, out index, out field))
                                    {
                                        string fileTag = mbApi.NowPlayingList_GetFileTag(index, (Plugin.MetaDataType)field);
                                        m.Result = Pack(fileTag);
                                    }
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.NowPlayingList_QueryFiles:
                                {
                                    string query;
                                    if (Unpack(cds, out query))
                                        m.Result = ToErrorIntPtr(mbApi.NowPlayingList_QueryFiles(query));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.NowPlayingList_QueryFilesEx:
                                {
                                    string query;
                                    if (Unpack(cds, out query))
                                    {
                                        string[] files = null;
                                        if (mbApi.NowPlayingList_QueryFilesEx(query, ref files))
                                            m.Result = Pack(files);
                                        else
                                            m.Result = IntPtr.Zero;
                                    }
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.Playlist_GetName:
                                {
                                    string playlistUrl;
                                    if (Unpack(cds, out playlistUrl))
                                        m.Result = Pack(mbApi.Playlist_GetName(playlistUrl));
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Playlist_GetType:
                                {
                                    string playlistUrl;
                                    if (Unpack(cds, out playlistUrl))
                                        m.Result = (IntPtr)mbApi.Playlist_GetType(playlistUrl);
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Playlist_IsInList:
                                {
                                    string playlistUrl, filename;
                                    if (Unpack(cds, out playlistUrl, out filename))
                                        m.Result = ToIntPtr(mbApi.Playlist_IsInList(playlistUrl, filename));
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Playlist_QueryFiles:
                                {
                                    string playlistUrl;
                                    if (Unpack(cds, out playlistUrl))
                                        m.Result = ToErrorIntPtr(mbApi.Playlist_QueryFiles(playlistUrl));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.Playlist_QueryFilesEx:
                                {
                                    string playlistUrl;
                                    if (Unpack(cds, out playlistUrl))
                                    {
                                        string[] files = null;
                                        if (mbApi.Playlist_QueryFilesEx(playlistUrl, ref files))
                                            m.Result = Pack(files);
                                        else
                                            m.Result = IntPtr.Zero;
                                    }
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Playlist_CreatePlaylist:
                                {
                                    string folderName, playlistName;
                                    string[] filenames;
                                    if (Unpack(cds, out folderName, out playlistName, out filenames))
                                        m.Result = Pack(mbApi.Playlist_CreatePlaylist(folderName, playlistName, filenames));
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Playlist_DeletePlaylist:
                                {
                                    string playlistUrl;
                                    if (Unpack(cds, out playlistUrl))
                                        m.Result = ToErrorIntPtr(mbApi.Playlist_DeletePlaylist(playlistUrl));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.Playlist_SetFiles:
                                {
                                    string playlistUrl;
                                    string[] filenames;
                                    if (Unpack(cds, out playlistUrl, out filenames))
                                        m.Result = ToErrorIntPtr(mbApi.Playlist_SetFiles(playlistUrl, filenames));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.Playlist_AppendFiles:
                                {
                                    string playlistUrl;
                                    string[] filenames;
                                    if (Unpack(cds, out playlistUrl, out filenames))
                                        m.Result = ToErrorIntPtr(mbApi.Playlist_AppendFiles(playlistUrl, filenames));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.Playlist_RemoveAt:
                                {
                                    string playlistUrl;
                                    int index;
                                    if (Unpack(cds, out playlistUrl, out index))
                                        m.Result = ToErrorIntPtr(mbApi.Playlist_RemoveAt(playlistUrl, index));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.Playlist_MoveFiles:
                                {
                                    string playlistUrl;
                                    int[] fromIndices;
                                    int toIndex;
                                    if (Unpack(cds, out playlistUrl, out fromIndices, out toIndex))
                                        m.Result = ToErrorIntPtr(mbApi.Playlist_MoveFiles(playlistUrl, fromIndices, toIndex));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.Playlist_PlayNow:
                                {
                                    string playlistUrl;
                                    if (Unpack(cds, out playlistUrl))
                                        m.Result = ToErrorIntPtr(mbApi.Playlist_PlayNow(playlistUrl));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.Playlist_GetItemCount:
                                {
                                    string playlistUrl;
                                    if (Unpack(cds, out playlistUrl))
                                    {
                                        string[] listFiles = null;

                                        mbApi.Playlist_QueryFilesEx(playlistUrl, ref listFiles);

                                        m.Result = (IntPtr)listFiles.Length;
                                    }
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Library_GetFileProperty:
                                {
                                    string sourceFileUrl;
                                    int type;
                                    if (Unpack(cds, out sourceFileUrl, out type))
                                    {
                                        string fileProperty = mbApi.Library_GetFileProperty(sourceFileUrl, (Plugin.FilePropertyType)type);
                                        m.Result = Pack(fileProperty);
                                    }
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Library_GetFileTag:
                                {
                                    string sourceFileUrl;
                                    int field;
                                    if (Unpack(cds, out sourceFileUrl, out field))
                                    {
                                        string fileProperty = mbApi.Library_GetFileTag(sourceFileUrl, (Plugin.MetaDataType)field);
                                        m.Result = Pack(fileProperty);
                                    }
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Library_SetFileTag:
                                {
                                    string sourceFileUrl, value;
                                    int field;
                                    if (Unpack(cds, out sourceFileUrl, out field, out value))
                                        m.Result = ToErrorIntPtr(mbApi.Library_SetFileTag(sourceFileUrl, (Plugin.MetaDataType)field, value));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.Library_CommitTagsToFile:
                                {
                                    string sourceFileUrl;
                                    if (Unpack(cds, out sourceFileUrl))
                                        m.Result = ToErrorIntPtr(mbApi.Library_CommitTagsToFile(sourceFileUrl));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.Library_GetLyrics:
                                {
                                    string sourceFileUrl;
                                    int type;
                                    if (Unpack(cds, out sourceFileUrl, out type))
                                        m.Result = Pack(mbApi.Library_GetLyrics(sourceFileUrl, (Plugin.LyricsType)type));
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Library_GetArtwork:
                                {
                                    string sourceFileUrl;
                                    int index;
                                    if (Unpack(cds, out sourceFileUrl, out index))
                                        m.Result = Pack(mbApi.Library_GetArtwork(sourceFileUrl, index));
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Library_GetArtworkUrl:
                                {
                                    string sourceFileUrl;
                                    int index;
                                    if (Unpack(cds, out sourceFileUrl, out index))
                                        m.Result = Pack(mbApi.Library_GetArtworkUrl(sourceFileUrl, index));
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Library_GetArtistPicture:
                                {
                                    string artistName;
                                    int fadingPercent, fadingColor;
                                    if (Unpack(cds, out artistName, out fadingPercent, out fadingColor))
                                        m.Result = Pack(mbApi.Library_GetArtistPicture(artistName, fadingPercent, fadingColor));
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Library_GetArtistPictureUrls:
                                {
                                    string artistName;
                                    bool localOnly;
                                    if (Unpack(cds, out artistName, out localOnly))
                                    {
                                        string[] urls = null;
                                        if (mbApi.Library_GetArtistPictureUrls(artistName, localOnly, ref urls))
                                            m.Result = Pack(urls);
                                        else
                                            m.Result = IntPtr.Zero;
                                    }
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Library_GetArtistPictureThumb:
                                {
                                    string artistName;
                                    if (Unpack(cds, out artistName))
                                        m.Result = Pack(mbApi.Library_GetArtistPictureThumb(artistName));
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Library_AddFileToLibrary:
                                {
                                    string sourceFileUrl;
                                    int category;
                                    if (Unpack(cds, out sourceFileUrl, out category))
                                        m.Result = Pack(mbApi.Library_AddFileToLibrary(sourceFileUrl, (Plugin.LibraryCategory)category));
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Library_QueryFiles:
                                {
                                    string query;
                                    if (Unpack(cds, out query))
                                        m.Result = ToErrorIntPtr(mbApi.Library_QueryFiles(query));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.Library_QueryFilesEx:
                                {
                                    string query;
                                    if (Unpack(cds, out query))
                                    {
                                        string[] files = null;
                                        if (mbApi.Library_QueryFilesEx(query, ref files))
                                            m.Result = Pack(files);
                                        else
                                            m.Result = IntPtr.Zero;
                                    }
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Library_QuerySimilarArtists:
                                {
                                    string artistName;
                                    double minimumArtistSimilarityRating;
                                    if (Unpack(cds, out artistName, out minimumArtistSimilarityRating))
                                        m.Result = Pack(mbApi.Library_QuerySimilarArtists(artistName, minimumArtistSimilarityRating));
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Library_QueryLookupTable:
                                {
                                    string keyTags, valueTags, query;
                                    if (Unpack(cds, out keyTags, out valueTags, out query))
                                        m.Result = ToErrorIntPtr(mbApi.Library_QueryLookupTable(keyTags, valueTags, query));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.Library_QueryGetLookupTableValue:
                                {
                                    string key;
                                    if (Unpack(cds, out key))
                                        m.Result = Pack(mbApi.Library_QueryGetLookupTableValue(key));
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Library_Search:
                                {
                                    string query, comparison;
                                    string[] fields;

                                    if (Unpack(cds, out query, out comparison, out fields))
                                    {
                                        string[] filenames = null;
                                        if (mbApi.Library_QueryFilesEx(GenQuery(fields, comparison, query), ref filenames))
                                            m.Result = Pack(filenames);
                                        else
                                            m.Result = IntPtr.Zero;
                                    }
                                    else
                                        m.Result = IntPtr.Zero;
                                }
                                break;

                            case Command.Library_SearchFirst:
                                {
                                    m.Result = IntPtr.Zero;

                                    string query, comparison;
                                    string[] fields;

                                    if (Unpack(cds, out query, out comparison, out fields))
                                    {
                                        if (mbApi.Library_QueryFiles(GenQuery(fields, comparison, query)))
                                            m.Result = Pack(mbApi.Library_QueryGetNextFile());
                                    }
                                }
                                break;

                            case Command.Library_SearchIndices:
                                {
                                    m.Result = (IntPtr)(-1);

                                    string query, comparison;
                                    string[] fields;

                                    if (Unpack(cds, out query, out comparison, out fields))
                                    {
                                        string[] filenames = null;
                                        if (mbApi.Library_QueryFilesEx(GenQuery(fields, comparison, query), ref filenames))
                                        {
                                            int[] indices = new int[filenames.Length];

                                            if (filenames.Length > 0)
                                            {
                                                string[] listFiles = null;

                                                mbApi.Library_QueryFilesEx(null, ref listFiles);

                                                for (int i = 0; i < filenames.Length; i++)
                                                    indices[i] = Array.FindIndex(listFiles, s => s.Equals(filenames[i], StringComparison.CurrentCultureIgnoreCase));
                                            }

                                            m.Result = Pack(indices);
                                        }
                                    }
                                }
                                break;

                            case Command.Library_SearchFirstIndex:
                                {
                                    m.Result = (IntPtr)(-1);

                                    string query, comparison;
                                    string[] fields;

                                    if (Unpack(cds, out query, out comparison, out fields))
                                    {
                                        if (mbApi.Library_QueryFiles(GenQuery(fields, comparison, query)))
                                        {
                                            string filename = mbApi.Library_QueryGetNextFile();
                                            if (filename.Length > 0)
                                            {
                                                string[] listFiles = null;

                                                mbApi.Library_QueryFilesEx(null, ref listFiles);

                                                m.Result = (IntPtr)Array.FindIndex(listFiles, s => s.Equals(filename, StringComparison.CurrentCultureIgnoreCase));
                                            }
                                        }
                                    }
                                }
                                break;

                            case Command.Library_SearchAndPlayFirst:
                                {
                                    m.Result = (IntPtr)Error.Error;

                                    string query, comparison;
                                    string[] fields;

                                    if (Unpack(cds, out query, out comparison, out fields))
                                    {
                                        if (mbApi.Library_QueryFiles(GenQuery(fields, comparison, query)))
                                        {
                                            mbApi.NowPlayingList_PlayNow(mbApi.Library_QueryGetNextFile());

                                            m.Result = (IntPtr)Error.NoError;
                                        }
                                    }
                                }
                                break;

                            case Command.Window_Move:
                                {
                                    int x, y;
                                    if (Unpack(cds, out x, out y))
                                        m.Result = ToErrorIntPtr(MoveWindow(x, y));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            case Command.Window_Resize:
                                {
                                    int w, h;
                                    if (Unpack(cds, out w, out h))
                                        m.Result = ToErrorIntPtr(ResizeWindow(w, h));
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;
                                
                            case Command.MessageBox:
                                {
                                    string text, caption;
                                    if (Unpack(cds, out text, out caption))
                                    {
                                        MessageBox.Show(text, caption);
                                        m.Result = (IntPtr)Error.NoError;
                                    }
                                    else
                                        m.Result = (IntPtr)Error.Error;
                                }
                                break;

                            default:
                                m.Result = (IntPtr)Error.CommandNotRecognized;
                                break;
                        }
                    }
                    break;

                default:
                    DefWndProc(ref m);
                    break;
            }
        }
    }
}
