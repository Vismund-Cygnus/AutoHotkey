;----------------------------------------------------------;
;- MusicBeeIPCSDK AHK v2.0.0                              -;
;- Copyright © Kerli Low 2014                             -;
;- This file is licensed under the                        -;
;- BSD 2-Clause License                                   -;
;- See LICENSE_MusicBeeIPCSDK for more information.       -;
;----------------------------------------------------------;

; MBError
this.MBE_Error                   := 0
this.MBE_NoError                 := 1
this.MBE_CommandNotRecognized    := 2

; MBRepeatMode
this.MBRM_None   := 0
this.MBRM_All    := 1
this.MBRM_One    := 2
   
; MBReplayGainMode
this.MBRGM_Off   := 0
this.MBRGM_Track := 1
this.MBRGM_Album := 2
this.MBRGM_Smart := 3

; MBFileProperty
this.MBFP_Url                    := 2
this.MBFP_Kind                   := 4
this.MBFP_Format                 := 5
this.MBFP_Size                   := 7
this.MBFP_Channels               := 8
this.MBFP_SampleRate             := 9
this.MBFP_Bitrate                := 10
this.MBFP_DateModified           := 11
this.MBFP_DateAdded              := 12
this.MBFP_LastPlayed             := 13
this.MBFP_PlayCount              := 14
this.MBFP_SkipCount              := 15
this.MBFP_Duration               := 16
this.MBFP_NowPlayingListIndex    := 78  ; only has meaning when called from NowPlayingList_* commands
this.MBFP_ReplayGainTrack        := 94
this.MBFP_ReplayGainAlbum        := 95

; MBMetaData
this.MBMD_TrackTitle     := 65
this.MBMD_Album          := 30
this.MBMD_AlbumArtist    := 31       ; displayed album artist
this.MBMD_AlbumArtistRaw := 34       ; stored album artist
this.MBMD_Artist         := 32       ; displayed artist
this.MBMD_MultiArtist    := 33       ; individual artists separated by a null char
this.MBMD_PrimaryArtist  := 19       ; first artist from multi-artist tagged file otherwise displayed artist
this.MBMD_Artists                  := 144
this.MBMD_ArtistsWithArtistRole    := 145
this.MBMD_ArtistsWithPerformerRole := 146
this.MBMD_ArtistsWithGuestRole     := 147
this.MBMD_ArtistsWithRemixerRole   := 148
this.MBMD_Artwork        := 40
this.MBMD_BeatsPerMin    := 41
this.MBMD_Composer       := 43       ; displayed composer
this.MBMD_MultiComposer  := 89       ; individual composers separated by a null char
this.MBMD_Comment        := 44
this.MBMD_Conductor      := 45
this.MBMD_Custom1        := 46
this.MBMD_Custom2        := 47
this.MBMD_Custom3        := 48
this.MBMD_Custom4        := 49
this.MBMD_Custom5        := 50
this.MBMD_Custom6        := 96
this.MBMD_Custom7        := 97
this.MBMD_Custom8        := 98
this.MBMD_Custom9        := 99
this.MBMD_Custom10       := 128
this.MBMD_Custom11       := 129
this.MBMD_Custom12       := 130
this.MBMD_Custom13       := 131
this.MBMD_Custom14       := 132
this.MBMD_Custom15       := 133
this.MBMD_Custom16       := 134
this.MBMD_DiscNo         := 52
this.MBMD_DiscCount      := 54
this.MBMD_Encoder        := 55
this.MBMD_Genre          := 59
this.MBMD_Genres         := 103
this.MBMD_GenreCategory  := 60
this.MBMD_Grouping       := 61
this.MBMD_Keywords       := 84
this.MBMD_HasLyrics      := 63
this.MBMD_Lyricist       := 62
this.MBMD_Lyrics         := 114
this.MBMD_Mood           := 64
this.MBMD_Occasion       := 66
this.MBMD_Origin         := 67
this.MBMD_Publisher      := 73
this.MBMD_Quality        := 74
this.MBMD_Rating         := 75
this.MBMD_RatingLove     := 76
this.MBMD_RatingAlbum    := 104
this.MBMD_Tempo          := 85
this.MBMD_TrackNo        := 86
this.MBMD_TrackCount     := 87
this.MBMD_Virtual1       := 109
this.MBMD_Virtual2       := 110
this.MBMD_Virtual3       := 111
this.MBMD_Virtual4       := 112
this.MBMD_Virtual5       := 113
this.MBMD_Virtual6       := 122
this.MBMD_Virtual7       := 123
this.MBMD_Virtual8       := 124
this.MBMD_Virtual9       := 125
this.MBMD_Virtual10      := 135
this.MBMD_Virtual11      := 136
this.MBMD_Virtual12      := 137
this.MBMD_Virtual13      := 138
this.MBMD_Virtual14      := 139
this.MBMD_Virtual15      := 140
this.MBMD_Virtual16      := 141
this.MBMD_Year           := 88

; MBLibraryCategory
this.MBLC_Music       := 0
this.MBLC_Audiobook   := 1
this.MBLC_Video       := 2
this.MBLC_Inbox       := 4

; MBDataType
this.MBDT_String      := 0
this.MBDT_Number      := 1
this.MBDT_DateTime    := 2
this.MBDT_Rating      := 3

; MBLyricsType
this.MBLT_NotSpecified    := 0
this.MBLT_Synchronised    := 1
this.MBLT_UnSynchronised  := 2

; MBPlayButtonType
this.MBPBT_PreviousTrack   := 0
this.MBPBT_PlayPause       := 1
this.MBPBT_NextTrack       := 2
this.MBPBT_Stop            := 3

; MBPlaylistFormat
this.MBPF_Unknown     := 0
this.MBPF_M3u         := 1
this.MBPF_Xspf        := 2
this.MBPF_Asx         := 3
this.MBPF_Wpl         := 4
this.MBPF_Pls         := 5
this.MBPF_Auto        := 7
this.MBPF_M3uAscii    := 8
this.MBPF_AsxFile     := 9
this.MBPF_Radio       := 10
this.MBPF_M3uExtended := 11
this.MBPF_Mbp         := 12

; MBMusicBeeVersion
this.MBMBV_v2_0 := 0
this.MBMBV_v2_1 := 1
this.MBMBV_v2_2 := 2
this.MBMBV_v2_3 := 3

; MBCommand
this.MBC_PlayPause                           := 100      ; this.WM_USER
this.MBC_Play                                := 101      ; this.WM_USER
this.MBC_Pause                               := 102      ; this.WM_USER
this.MBC_Stop                                := 103      ; this.WM_USER
this.MBC_StopAfterCurrent                    := 104      ; this.WM_USER
this.MBC_PreviousTrack                       := 105      ; this.WM_USER
this.MBC_NextTrack                           := 106      ; this.WM_USER
this.MBC_StartAutoDj                         := 107      ; this.WM_USER
this.MBC_EndAutoDj                           := 108      ; this.WM_USER
this.MBC_GetPlayState                        := 109      ; this.WM_USER
this.MBC_GetPosition                         := 110      ; this.WM_USER
this.MBC_SetPosition                         := 111      ; this.WM_USER
this.MBC_GetVolume                           := 112      ; this.WM_USER
this.MBC_SetVolume                           := 113      ; this.WM_USER
this.MBC_GetVolumep                          := 114      ; this.WM_USER
this.MBC_SetVolumep                          := 115      ; this.WM_USER
this.MBC_GetVolumef                          := 116      ; this.WM_USER
this.MBC_SetVolumef                          := 117      ; this.WM_USER
this.MBC_GetMute                             := 118      ; this.WM_USER
this.MBC_SetMute                             := 119      ; this.WM_USER
this.MBC_GetShuffle                          := 120      ; this.WM_USER
this.MBC_SetShuffle                          := 121      ; this.WM_USER
this.MBC_GetRepeat                           := 122      ; this.WM_USER
this.MBC_SetRepeat                           := 123      ; this.WM_USER
this.MBC_GetEqualiserEnabled                 := 124      ; this.WM_USER
this.MBC_SetEqualiserEnabled                 := 125      ; this.WM_USER
this.MBC_GetDspEnabled                       := 126      ; this.WM_USER
this.MBC_SetDspEnabled                       := 127      ; this.WM_USER
this.MBC_GetScrobbleEnabled                  := 128      ; this.WM_USER
this.MBC_SetScrobbleEnabled                  := 129      ; this.WM_USER
this.MBC_ShowEqualiser                       := 130      ; this.WM_USER
this.MBC_GetAutoDjEnabled                    := 131      ; this.WM_USER
this.MBC_GetStopAfterCurrentEnabled          := 132      ; this.WM_USER
this.MBC_SetStopAfterCurrentEnabled          := 133      ; this.WM_USER
this.MBC_GetCrossfade                        := 134      ; this.WM_USER
this.MBC_SetCrossfade                        := 135      ; this.WM_USER
this.MBC_GetReplayGainMode                   := 136      ; this.WM_USER
this.MBC_SetReplayGainMode                   := 137      ; this.WM_USER
this.MBC_QueueRandomTracks                   := 138      ; this.WM_USER
this.MBC_GetDuration                         := 139      ; this.WM_USER
this.MBC_GetFileUrl                          := 140      ; this.WM_USER
this.MBC_GetFileProperty                     := 141      ; this.WM_USER
this.MBC_GetFileTag                          := 142      ; this.WM_USER
this.MBC_GetLyrics                           := 143      ; this.WM_USER
this.MBC_GetDownloadedLyrics                 := 144      ; this.WM_USER
this.MBC_GetArtwork                          := 145      ; this.WM_USER
this.MBC_GetArtworkUrl                       := 146      ; this.WM_USER
this.MBC_GetDownloadedArtwork                := 147      ; this.WM_USER
this.MBC_GetDownloadedArtworkUrl             := 148      ; this.WM_USER
this.MBC_GetArtistPicture                    := 149      ; this.WM_USER
this.MBC_GetArtistPictureUrls                := 150      ; this.WM_USER
this.MBC_GetArtistPictureThumb               := 151      ; this.WM_USER
this.MBC_IsSoundtrack                        := 152      ; this.WM_USER
this.MBC_GetSoundtrackPictureUrls            := 153      ; this.WM_USER
this.MBC_GetCurrentIndex                     := 154      ; this.WM_USER
this.MBC_GetNextIndex                        := 155      ; this.WM_USER
this.MBC_IsAnyPriorTracks                    := 156      ; this.WM_USER
this.MBC_IsAnyFollowingTracks                := 157      ; this.WM_USER
this.MBC_PlayNow                             := 158      ; this.WM_COPYDATA
this.MBC_QueueNext                           := 159      ; this.WM_COPYDATA
this.MBC_QueueLast                           := 160      ; this.WM_COPYDATA
this.MBC_RemoveAt                            := 161      ; this.WM_USER
this.MBC_ClearNowPlayingList                 := 162      ; this.WM_USER
this.MBC_MoveFiles                           := 163      ; this.WM_COPYDATA
this.MBC_ShowNowPlayingAssistant             := 164      ; this.WM_USER
this.MBC_GetShowTimeRemaining                := 165      ; this.WM_USER
this.MBC_GetShowRatingTrack                  := 166      ; this.WM_USER
this.MBC_GetShowRatingLove                   := 167      ; this.WM_USER
this.MBC_GetButtonEnabled                    := 168      ; this.WM_USER
this.MBC_Jump                                := 169      ; this.WM_USER
this.MBC_Search                              := 170      ; this.WM_COPYDATA
this.MBC_SearchFirst                         := 171      ; this.WM_COPYDATA
this.MBC_SearchIndices                       := 172      ; this.WM_COPYDATA
this.MBC_SearchFirstIndex                    := 173      ; this.WM_COPYDATA
this.MBC_SearchAndPlayFirst                  := 174      ; this.WM_COPYDATA
this.MBC_NowPlayingList_GetListFileUrl       := 200      ; this.WM_COPYDATA
this.MBC_NowPlayingList_GetFileProperty      := 201      ; this.WM_COPYDATA
this.MBC_NowPlayingList_GetFileTag           := 202      ; this.WM_COPYDATA
this.MBC_NowPlayingList_QueryFiles           := 203      ; this.WM_COPYDATA
this.MBC_NowPlayingList_QueryGetNextFile     := 204      ; this.WM_USER
this.MBC_NowPlayingList_QueryGetAllFiles     := 205      ; this.WM_USER
this.MBC_NowPlayingList_QueryFilesEx         := 206      ; this.WM_COPYDATA
this.MBC_NowPlayingList_PlayLibraryShuffled  := 207      ; this.WM_USER
this.MBC_NowPlayingList_GetItemCount         := 208      ; this.WM_USER
this.MBC_Playlist_GetName                    := 300      ; this.WM_COPYDATA
this.this.MBC_Playlist_GetType                    := 301      ; this.WM_COPYDATA
this.this.MBC_Playlist_IsInList                   := 302      ; this.WM_COPYDATA
this.this.MBC_Playlist_QueryPlaylists             := 303      ; this.WM_USER
this.this.MBC_Playlist_QueryGetNextPlaylist       := 304      ; this.WM_USER
this.this.MBC_Playlist_QueryFiles                 := 305      ; this.WM_COPYDATA
this.this.MBC_Playlist_QueryGetNextFile           := 306      ; this.WM_USER
this.this.MBC_Playlist_QueryGetAllFiles           := 307      ; this.WM_USER
this.this.MBC_Playlist_QueryFilesEx               := 308      ; this.WM_COPYDATA
this.MBC_Playlist_CreatePlaylist             := 309      ; this.WM_COPYDATA
this.MBC_Playlist_DeletePlaylist             := 310      ; this.WM_COPYDATA
this.this.MBC_Playlist_SetFiles                   := 311      ; this.WM_COPYDATA
this.MBC_Playlist_AppendFiles                := 312      ; this.WM_COPYDATA
this.this.MBC_Playlist_RemoveAt                   := 313      ; this.WM_COPYDATA
this.this.MBC_Playlist_MoveFiles                  := 314      ; this.WM_COPYDATA
this.this.MBC_Playlist_PlayNow                    := 315      ; this.WM_COPYDATA
this.MBC_Playlist_GetItemCount               := 316      ; this.WM_COPYDATA
this.MBC_Library_GetFileProperty             := 400      ; this.WM_COPYDATA
this.MBC_Library_GetFileTag                  := 401      ; this.WM_COPYDATA
this.MBC_Library_SetFileTag                  := 402      ; this.WM_COPYDATA
this.MBC_Library_CommitTagsToFile            := 403      ; this.WM_COPYDATA
this.MBC_Library_GetLyrics                   := 404      ; this.WM_COPYDATA
this.MBC_Library_GetArtwork                  := 405      ; this.WM_COPYDATA
this.MBC_Library_GetArtworkUrl               := 406      ; this.WM_COPYDATA
this.MBC_Library_GetArtistPicture            := 407      ; this.WM_COPYDATA
this.MBC_Library_GetArtistPictureUrls        := 408      ; this.WM_COPYDATA
this.MBC_Library_GetArtistPictureThumb       := 409      ; this.WM_COPYDATA
this.MBC_Library_AddFileToLibrary            := 410      ; this.WM_COPYDATA
this.MBC_Library_QueryFiles                  := 411      ; this.WM_COPYDATA
this.MBC_Library_QueryGetNextFile            := 412      ; this.WM_USER
this.MBC_Library_QueryGetAllFiles            := 413      ; this.WM_USER
this.MBC_Library_QueryFilesEx                := 414      ; this.WM_COPYDATA
this.MBC_Library_QuerySimilarArtists         := 415      ; this.WM_COPYDATA
this.MBC_Library_QueryLookupTable            := 416      ; this.WM_COPYDATA
this.MBC_Library_QueryGetLookupTableValue    := 417      ; this.WM_COPYDATA
this.MBC_Library_GetItemCount                := 418      ; this.WM_USER
this.MBC_Library_Jump                        := 419      ; this.WM_USER
this.MBC_Library_Search                      := 420      ; this.WM_COPYDATA
this.MBC_Library_SearchFirst                 := 421      ; this.WM_COPYDATA
this.MBC_Library_SearchIndices               := 422      ; this.WM_COPYDATA
this.MBC_Library_SearchFirstIndex            := 423      ; this.WM_COPYDATA
this.MBC_Library_SearchAndPlayFirst          := 424      ; this.WM_COPYDATA
this.MBC_Setting_GetFieldName                := 700      ; this.WM_COPYDATA
this.MBC_Setting_GetDataType                 := 701      ; this.WM_COPYDATA
this.MBC_Window_GetHandle                    := 800      ; this.WM_USER
this.MBC_Window_Close                        := 801      ; this.WM_USER
this.MBC_Window_Restore                      := 802      ; this.WM_USER
this.MBC_Window_Minimize                     := 803      ; this.WM_USER
this.MBC_Window_Maximize                     := 804      ; this.WM_USER
this.MBC_Window_Move                         := 805      ; this.WM_USER
this.MBC_Window_Resize                       := 806      ; this.WM_USER
this.MBC_Window_BringToFront                 := 807      ; this.WM_USER
this.MBC_Window_GetPosition                  := 808      ; this.WM_USER
this.MBC_Window_GetSize                      := 809      ; this.WM_USER
this.MBC_FreeLRESULT                         := 900      ; this.WM_USER
this.MBC_MusicBeeVersion                     := 995      ; this.WM_USER
this.MBC_PluginVersion                       := 996      ; this.WM_USER
this.MBC_Test                                := 997      ; this.WM_USER      For debugging purposes
this.MBC_MessageBox                          := 998      ; this.WM_COPYDATA  For debugging purposes
this.MBC_Probe                               := 999      ; this.WM_USER      To test MusicBeeIPC hwnd is valid

; Window Message
this.WM_USER     := 0x0400
this.WM_COPYDATA := 0x004A
