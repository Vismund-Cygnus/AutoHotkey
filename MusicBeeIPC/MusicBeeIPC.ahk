;----------------------------------------------------------;
;- MusicBeeIPCSDK AHK v2.0.0                              -;
;- Copyright © Kerli Low 2014                             -;
;- This file is licensed under the                        -;
;- BSD 2-Clause License                                   -;
;- See LICENSE_MusicBeeIPCSDK for more information.       -;
;----------------------------------------------------------;

class MusicBeeIPC {
    __New() {
        static init := new MusicBeeIPC

		if (init)
			return init

        className := this.__Class
        %className% := this

        #include %A_LineFile%\..\Lib\Enums.ahk
        #include %A_LineFile%\..\Lib\Constants.ahk
        DetectHiddenWindows, On
        
        return this
    }

    #include %A_LineFile%\..\Lib\Pack.ahk
    #include %A_LineFile%\..\Lib\Unpack.ahk

    GetHwndIPC() {
        O_DetectHiddenWindows := A_DetectHiddenWindows
        DetectHiddenWindows, On
        hwnd :=  WinExist("MusicBee IPC Interface")
        DetectHiddenWindows, % O_DetectHiddenWindows
        return hwnd
    }
    Probe() {
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Probe, "Ptr", 0, "Ptr")
        return (r <> this.MBE_Error)
    }
    PlayPause() {
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_PlayPause, "Ptr", 0, "Ptr")
        state := this.GetPlayState()
        return state = 3 ? 1 : 6 ? 0 : state
    }
    Play() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Play, "Ptr", 0, "Ptr")
    }
    Pause() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Pause, "Ptr", 0, "Ptr")
    }
    Stop() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Stop, "Ptr", 0, "Ptr")
    }
    StopAfterCurrent() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_StopAfterCurrent, "Ptr", 0, "Ptr")
    }
    PreviousTrack() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_PreviousTrack, "Ptr", 0, "Ptr")
    }
    NextTrack() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_NextTrack, "Ptr", 0, "Ptr")
    }
    StartAutoDj() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_StartAutoDj, "Ptr", 0, "Ptr")
    }
    EndAutoDj() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_EndAutoDj, "Ptr", 0, "Ptr")
    }
    GetPlayState() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetPlayState, "Ptr", 0, "Ptr")
    }
    GetPlayStateStr() {
        return {0: "Undefined", 1: "Loading", 3: "Playing", 6: "Paused", 7: "Stopped"}[this.GetPlayState()]
    }
    GetPosition() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetPosition, "Ptr", 0, "Ptr")
    }
    SetPosition(position) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_SetPosition, "Ptr", position, "Ptr")
    }
    GetVolume() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetVolume, "Ptr", 0, "Ptr")
    }
    SetVolume(volume) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_SetVolume, "Ptr", volume, "Ptr")
    }
    GetVolumep() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetVolumep, "Ptr", 0, "Ptr")
    }
    SetVolumep(volume) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_SetVolumep, "Ptr", volume, "Ptr")
    }
    GetVolumef() {
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetVolumef, "Ptr", 0, "Ptr")
        VarSetCapacity(i, this.SIZEOFINT)
        NumPut(r, i, 0, "UInt")
        f := NumGet(i, 0, "Float")
        return f
    }
    SetVolumef(volume) {
        VarSetCapacity(f, this.SIZEOFFLOAT)
        NumPut(volume, f, 0, "Float")
        i := NumGet(f, 0, "UInt")
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_SetVolumef, "Ptr", i, "Ptr")
    }
    GetMute() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetMute, "Ptr", 0, "Ptr")
    }
    SetMute(mute) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_SetMute, "Ptr", mute, "Ptr")
    }
    GetShuffle() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetShuffle, "Ptr", 0, "Ptr")
    }
    SetShuffle(shuffle) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_SetShuffle, "Ptr", shuffle, "Ptr")
    }
    GetRepeat() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetRepeat, "Ptr", 0, "Ptr")
    }
    SetRepeat(repeat) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_SetRepeat, "Ptr", repeat, "Ptr")
    }
    GetEqualiserEnabled() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetEqualiserEnabled, "Ptr", 0, "Ptr")
    }
    SetEqualiserEnabled(enabled) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_SetEqualiserEnabled, "Ptr", enabled, "Ptr")
    }
    GetDspEnabled() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetDspEnabled, "Ptr", 0, "Ptr")
    }
    SetDspEnabled(enabled) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_SetDspEnabled, "Ptr", enabled, "Ptr")
    }
    GetScrobbleEnabled() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetScrobbleEnabled, "Ptr", 0, "Ptr")
    }
    SetScrobbleEnabled(enabled) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_SetScrobbleEnabled, "Ptr", enabled, "Ptr")
    }
    ShowEqualiser() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_ShowEqualiser, "Ptr", 0, "Ptr")
    }
    GetAutoDjEnabled() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetAutoDjEnabled, "Ptr", 0, "Ptr")
    }
    GetStopAfterCurrentEnabled() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetStopAfterCurrentEnabled, "Ptr", 0, "Ptr")
    }
    SetStopAfterCurrentEnabled(enabled) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_SetStopAfterCurrentEnabled, "Ptr", enabled, "Ptr")
    }
    GetCrossfade() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetCrossfade, "Ptr", 0, "Ptr")
    }
    SetCrossfade(crossfade) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_SetCrossfade, "Ptr", crossfade, "Ptr")
    }
    GetReplayGainMode() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetReplayGainMode, "Ptr", 0, "Ptr")
    }
    SetReplayGainMode(mode) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_SetReplayGainMode, "Ptr", mode, "Ptr")
    }
    QueueRandomTracks(count) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_QueueRandomTracks, "Ptr", count, "Ptr")
    }
    GetDuration() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetDuration, "Ptr", 0, "Ptr")
    }
    GetFileUrl() {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetFileUrl, "Ptr", 0, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", 0, "Ptr")
        return r
    }
    GetFileProperty(fileProperty) {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetFileProperty, "Ptr", fileProperty, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    GetFileTag(field) {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetFileTag, "Ptr", field, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    GetLyrics() {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetLyrics, "Ptr", 0, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    GetDownloadedLyrics() {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetDownloadedLyrics, "Ptr", 0, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    GetArtwork() {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetArtwork, "Ptr", 0, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    GetArtworkUrl() {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetArtworkUrl, "Ptr", 0, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    GetDownloadedArtwork() {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetDownloadedArtwork, "Ptr", 0, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    GetDownloadedArtworkUrl() {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetDownloadedArtworkUrl, "Ptr", 0, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    GetArtistPicture(fadingPercent) {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetArtistPicture, "Ptr", fadingPercent, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    GetArtistPictureUrls(localOnly, ByRef urls) {
        r := this.MBE_Error
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetArtistPictureUrls, "Ptr", localOnly, "Ptr")
        if (this.Unpack_sa(this.GetLResult(el), urls))
            r := this.MBE_NoError
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    GetArtistPictureThumb() {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetArtistPictureThumb, "Ptr", 0, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    IsSoundtrack() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_IsSoundtrack, "Ptr", 0, "Ptr")
    }
    GetSoundtrackPictureUrls(localOnly, ByRef urls) {
        r := this.MBE_Error
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetSoundtrackPictureUrls, "Ptr", localOnly, "Ptr")
        if (this.Unpack_sa(this.GetLResult(el), urls))
            r := this.MBE_NoError
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    GetCurrentIndex() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetCurrentIndex, "Ptr", 0, "Ptr")
    }
    GetNextIndex(offset) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetNextIndex, "Ptr", offset, "Ptr")
    }
    IsAnyPriorTracks() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_IsAnyPriorTracks, "Ptr", 0, "Ptr")
    }
    IsAnyFollowingTracks() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_IsAnyFollowingTracks, "Ptr", 0, "Ptr")
    }
    PlayNow(ByRef fileurl) {
        this.Pack_s(cds, data, fileurl)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_PlayNow, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    QueueNext(ByRef fileurl) {
        this.Pack_s(cds, data, fileurl)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_QueueNext, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    QueueLast(ByRef fileurl) {
        this.Pack_s(cds, data, fileurl)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_QueueLast, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    ClearNowPlayingList() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_ClearNowPlayingList, "Ptr", 0, "Ptr")
    }
    RemoveAt(index) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_RemoveAt, "Ptr", index, "Ptr")
    }
    MoveFiles(ByRef fromIndices, toIndex) {
        this.Pack_iai(cds, data, fromIndices, toIndex)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_MoveFiles, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    ShowNowPlayingAssistant() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_ShowNowPlayingAssistant, "Ptr", 0, "Ptr")
    }
    GetShowTimeRemaining() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetShowTimeRemaining, "Ptr", 0, "Ptr")
    }
    GetShowRatingTrack() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetShowRatingTrack, "Ptr", 0, "Ptr")
    }
    GetShowRatingLove() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetShowRatingLove, "Ptr", 0, "Ptr")
    }
    GetButtonEnabled(button) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_GetButtonEnabled, "Ptr", button, "Ptr")
    }
    Jump(index) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Jump, "Ptr", index, "Ptr")
    }
    Search(ByRef query, ByRef result) {
        return this.SearchEx(query, "Contains", ["ArtistPeople", "Title", "Album"], result)
    }
    SearchEx(ByRef query, ByRef comparison, ByRef fields, ByRef result) {
        r := this.MBE_Error
        this.Pack_sssa(cds, data, query, comparison, fields)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Search, "Ptr", &cds, "Ptr")
        if (this.Unpack_sa(this.GetLResult(el), result))
            r := this.MBE_NoError
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    SearchFirst(ByRef query) {
        return this.SearchFirstEx(query, "Contains", ["ArtistPeople", "Title", "Album"])
    }
    SearchFirstEx(ByRef query, ByRef comparison, ByRef fields) {
        this.Pack_sssa(cds, data, query, comparison, fields)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_SearchFirst, "Ptr", &cds, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    SearchIndices(ByRef query, ByRef result) {
        return this.SearchIndicesEx(query, "Contains", ["ArtistPeople", "Title", "Album"], result)
    }
    SearchIndicesEx(ByRef query, ByRef comparison, ByRef fields, ByRef result) {
        r := this.MBE_Error
        this.Pack_sssa(cds, data, query, comparison, fields)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_SearchIndices, "Ptr", &cds, "Ptr")
        if (this.Unpack_ia(this.GetLResult(el), result))
            r := this.MBE_NoError
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    SearchFirstIndex(ByRef query) {
        return this.SearchFirstIndexEx(query, "Contains", ["ArtistPeople", "Title", "Album"])
    }
    SearchFirstIndexEx(ByRef query, ByRef comparison, ByRef fields) {
        this.Pack_sssa(cds, data, query, comparison, fields)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_SearchFirstIndex, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    SearchAndPlayFirst(ByRef query) {
        return this.SearchAndPlayFirstEx(query, "Contains", ["ArtistPeople", "Title", "Album"])
    }
    SearchAndPlayFirstEx(ByRef query, ByRef comparison, ByRef fields) {
        this.Pack_sssa(cds, data, query, comparison, fields)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_SearchAndPlayFirst, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    NowPlayingList_GetListFileUrl(index) {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_NowPlayingList_GetListFileUrl, "Ptr", index, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    NowPlayingList_GetFileProperty(index, fileProperty) {
        this.Pack_i(cds, data, index, fileProperty)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_NowPlayingList_GetFileProperty, "Ptr", &cds, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    NowPlayingList_GetFileTag(index, field) {
        this.Pack_i(cds, data, index, field)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_NowPlayingList_GetFileTag, "Ptr", &cds, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    NowPlayingList_QueryFiles(ByRef query) {
        this.Pack_s(cds, data, query)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_NowPlayingList_QueryFiles, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    NowPlayingList_QueryGetNextFile() {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_NowPlayingList_QueryGetNextFile, "Ptr", 0, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    NowPlayingList_QueryGetAllFiles() {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_NowPlayingList_QueryGetAllFiles, "Ptr", 0, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    NowPlayingList_QueryFilesEx(ByRef query, ByRef result) {
        r := this.MBE_Error
        this.Pack_s(cds, data, query)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_NowPlayingList_QueryFilesEx, "Ptr", &cds, "Ptr")
        if (this.Unpack_sa(this.GetLResult(el), result))
            r := this.MBE_NoError
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    NowPlayingList_PlayLibraryShuffled() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_NowPlayingList_PlayLibraryShuffled, "Ptr", 0, "Ptr")
    }
    NowPlayingList_GetItemCount() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_NowPlayingList_GetItemCount, "Ptr", 0, "Ptr")
    }
    Playlist_GetName(ByRef playlistUrl) {
        this.Pack_s(cds, data, playlistUrl)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Playlist_GetName, "Ptr", &cds, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Playlist_GetType(ByRef playlistUrl) {
        this.Pack_s(cds, data, playlistUrl)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.this.MBC_Playlist_GetType, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Playlist_IsInList(ByRef playlistUrl, ByRef filename) {
        this.Pack_s(cds, data, playlistUrl, filename)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.this.MBC_Playlist_IsInList, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Playlist_QueryPlaylists() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.this.MBC_Playlist_QueryPlaylists, "Ptr", 0, "Ptr")
    }
    Playlist_QueryGetNextPlaylist() {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.this.MBC_Playlist_QueryGetNextPlaylist, "Ptr", 0, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    Playlist_QueryFiles(ByRef playlistUrl) {
        this.Pack_s(cds, data, playlistUrl)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.this.MBC_Playlist_QueryFiles, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Playlist_QueryGetNextFile() {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.this.MBC_Playlist_QueryGetNextFile, "Ptr", 0, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    Playlist_QueryGetAllFiles() {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.this.MBC_Playlist_QueryGetAllFiles, "Ptr", 0, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    Playlist_QueryFilesEx(ByRef playlistUrl, ByRef result) {
        r := this.MBE_Error
        this.Pack_s(cds, data, playlistUrl)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.this.MBC_Playlist_QueryFilesEx, "Ptr", &cds, "Ptr")
        if (this.Unpack_sa(this.GetLResult(el), result))
            r := this.MBE_NoError
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Playlist_CreatePlaylist(ByRef folderName, ByRef playlistName, ByRef filenames) {
        this.Pack_sssa(cds, data, folderName, playlistName, filenames)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Playlist_CreatePlaylist, "Ptr", &cds, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Playlist_DeletePlaylist(ByRef playlistUrl) {
        this.Pack_s(cds, data, playlistUrl)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Playlist_DeletePlaylist, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Playlist_SetFiles(ByRef playlistUrl, ByRef filenames) {
        this.Pack_ssa(cds, data, playlistUrl, filenames)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.this.MBC_Playlist_SetFiles, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Playlist_AppendFiles(ByRef playlistUrl, ByRef filenames) {
        this.Pack_ssa(cds, data, playlistUrl, filenames)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Playlist_AppendFiles, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Playlist_RemoveAt(ByRef playlistUrl, index) {
        this.Pack_si(cds, data, playlistUrl, index)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.this.MBC_Playlist_RemoveAt, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Playlist_MoveFiles(ByRef playlistUrl, ByRef fromIndices, toIndex) {
        this.Pack_siai(cds, data, playlistUrl, fromIndices, toIndex)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.this.MBC_Playlist_MoveFiles, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Playlist_PlayNow(ByRef playlistUrl) {
        this.Pack_s(cds, data, playlistUrl)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.this.MBC_Playlist_PlayNow, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Playlist_GetItemCount(ByRef playlistUrl) {
        this.Pack_s(cds, data, playlistUrl)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Playlist_GetItemCount, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_GetFileProperty(fileUrl, fileProperty) {
        this.Pack_si(cds, data, fileUrl, fileProperty)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_GetFileProperty, "Ptr", &cds, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_GetFileTag(fileUrl, field) {
        this.Pack_si(cds, data, fileUrl, field)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_GetFileTag, "Ptr", &cds, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_SetFileTag(ByRef fileUrl, field, ByRef value) {
        this.Pack_sis(cds, data, fileUrl, field, value)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_SetFileTag, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_CommitTagsToFile(ByRef fileUrl) {
        this.Pack_s(cds, data, fileUrl)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_CommitTagsToFile, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_GetLyrics(ByRef fileUrl) {
        this.Pack_s(cds, data, fileUrl)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_GetLyrics, "Ptr", &cds, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_GetArtwork(ByRef fileUrl, index) {
        this.Pack_si(cds, data, fileUrl, index)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_GetArtwork, "Ptr", &cds, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_GetArtworkUrl(ByRef fileUrl, index) {
        this.Pack_si(cds, data, fileUrl, index)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_GetArtworkUrl, "Ptr", &cds, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_GetArtistPicture(ByRef artistName, fadingPercent, fadingColor) {
        this.Pack_si(cds, data, artistName, fadingPercent, fadingColor)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_GetArtistPicture, "Ptr", &cds, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_GetArtistPictureUrls(ByRef artistName, localOnly, ByRef urls) {
        r := this.MBE_Error
        this.Pack_sb(cds, data, artistName, localOnly)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_GetArtistPictureUrls, "Ptr", &cds, "Ptr")
        if (this.Unpack_sa(this.GetLResult(el), urls))
            r := this.MBE_NoError
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_GetArtistPictureThumb(ByRef artistName) {
        this.Pack_s(cds, data, artistName)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_GetArtistPictureThumb, "Ptr", &cds, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_AddFileToLibrary(ByRef fileUrl, category) {
        this.Pack_si(cds, data, fileUrl, category)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_AddFileToLibrary, "Ptr", &cds, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_QueryFiles(ByRef query) {
        this.Pack_s(cds, data, query)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_QueryFiles, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_QueryGetNextFile() {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Library_QueryGetNextFile, "Ptr", 0, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    Library_QueryGetAllFiles() {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Library_QueryGetAllFiles, "Ptr", 0, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    Library_QueryFilesEx(ByRef query, ByRef result) {
        r := this.MBE_Error
        this.Pack_s(cds, data, query)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_QueryFilesEx, "Ptr", &cds, "Ptr")
        if (this.Unpack_sa(this.GetLResult(el), result))
            r := this.MBE_NoError
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_QuerySimilarArtists(ByRef artistName, minimumArtistSimilarityRating) {
        this.Pack_sd(cds, data, artistName, minimumArtistSimilarityRating)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_QuerySimilarArtists, "Ptr", &cds, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_QueryLookupTable(ByRef keyTags, ByRef valueTags, ByRef query) {
        this.Pack_s(cds, data, keyTags, valueTags, query)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_QueryLookupTable, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_QueryGetLookupTableValue(ByRef key) {
        this.Pack_s(cds, data, key)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_QueryGetLookupTableValue, "Ptr", &cds, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_Jump(index) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Library_Jump, "Ptr", index, "Ptr")
    }
    Library_Search(ByRef query, ByRef result) {
        return this.Library_SearchEx(query, "Contains", ["ArtistPeople", "Title", "Album"], result)
    }
    Library_SearchEx(ByRef query, ByRef comparison, ByRef fields, ByRef result) {
        r := this.MBE_Error
        this.Pack_sssa(cds, data, query, comparison, fields)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_Search, "Ptr", &cds, "Ptr")
        if (this.Unpack_sa(this.GetLResult(el), result))
            r := this.MBE_NoError
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_SearchFirst(ByRef query) {
        return this.Library_SearchFirstEx(query, "Contains", ["ArtistPeople", "Title", "Album"])
    }
    Library_SearchFirstEx(ByRef query, ByRef comparison, ByRef fields) {
        this.Pack_sssa(cds, data, query, comparison, fields)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_SearchFirst, "Ptr", &cds, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_SearchIndices(ByRef query, ByRef result) {
        return this.Library_SearchIndicesEx(query, "Contains", ["ArtistPeople", "Title", "Album"], result)
    }
    Library_SearchIndicesEx(ByRef query, ByRef comparison, ByRef fields, ByRef result) {
        r := this.MBE_Error
        this.Pack_sssa(cds, data, query, comparison, fields)
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_SearchIndices, "Ptr", &cds, "Ptr")
        if (this.Unpack_ia(this.GetLResult(el), result))
            r := this.MBE_NoError
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_SearchFirstIndex(ByRef query) {
        return this.Library_SearchFirstIndexEx(query, "Contains", ["ArtistPeople", "Title", "Album"])
    }
    Library_SearchFirstIndexEx(ByRef query, ByRef comparison, ByRef fields) {
        this.Pack_sssa(cds, data, query, comparison, fields)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_SearchFirstIndex, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Library_SearchAndPlayFirst(ByRef query) {
        return this.Library_SearchAndPlayFirstEx(query, "Contains", ["ArtistPeople", "Title", "Album"])
    }
    Library_SearchAndPlayFirstEx(ByRef query, ByRef comparison, ByRef fields) {
        this.Pack_sssa(cds, data, query, comparison, fields)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Library_SearchAndPlayFirst, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Setting_GetFieldName(field) {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Setting_GetFieldName, "Ptr", field, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    Setting_GetDataType(field) {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Setting_GetDataType, "Ptr", field, "Ptr")
    }
    Window_GetHandle() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Window_GetHandle, "Ptr", 0, "Ptr")
    }
    Window_Close() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Window_Close, "Ptr", 0, "Ptr")
    }
    Window_Restore() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Window_Restore, "Ptr", 0, "Ptr")
    }
    Window_Minimize() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Window_Minimize, "Ptr", 0, "Ptr")
    }
    Window_Maximize() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Window_Maximize, "Ptr", 0, "Ptr")
    }
    Window_Move(x, y) {
        this.Pack_i(cds, data, x, y)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Window_Move, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Window_Resize(w, h) {
        this.Pack_i(cds, data, w, h)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_Window_Resize, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
    Window_BringToFront() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Window_BringToFront, "Ptr", 0, "Ptr")
    }
    Window_GetPosition(ByRef x, ByRef y) {
        r := this.MBE_Error
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Window_GetPosition, "Ptr", 0, "Ptr")
        if (this.Unpack_ii(this.GetLResult(el), x, y))
            r := this.MBE_NoError
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    Window_GetSize(ByRef w, ByRef h) {
        r := this.MBE_Error
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Window_GetSize, "Ptr", 0, "Ptr")
        if (this.Unpack_ii(this.GetLResult(el), w, h))
            r := this.MBE_NoError
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    GetMusicBeeVersion() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_MusicBeeVersion, "Ptr", 0, "Ptr")
    }
    GetMusicBeeVersionStr() {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_MusicBeeVersion, "Ptr", 0, "Ptr")
        if (el = this.MBMBV_v2_0)
            return "2.0"
        else if (el = this.MBMBV_v2_1)
            return "2.1"
        else if (el = this.MBMBV_v2_2)
            return "2.2"
        else if (el = this.MBMBV_v2_3)
            return "2.3"
        else
            return "Unknown"
    }
    GetPluginVersionStr() {
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_PluginVersion, "Ptr", 0, "Ptr")
        this.Unpack_s(this.GetLResult(el), r)
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        return r
    }
    GetPluginVersion(ByRef major, ByRef minor) {
        r := this.MBE_Error
        el := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_PluginVersion, "Ptr", 0, "Ptr")
        if (this.Unpack_s(this.GetLResult(el), v))
            r := this.MBE_NoError
        DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_FreeLRESULT, "Ptr", el, "Ptr")
        if (r = this.MBE_NoError)
        {
            StringSplit, arr, v, .
            if (arr0 < 2)
                r := MB_Error
            else
            {
                major := arr1
                minor := arr2
            }
        }
        return r
    }
    Test() {
        return DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_USER, "Ptr", this.MBC_Test, "Ptr", 0, "Ptr")
    }
    MessageBox(ByRef text, ByRef caption) {
        this.Pack_s(cds, data, text, caption)
        r := DllCall("SendMessage", "Ptr", this.GetHwndIPC(), "UInt", this.WM_COPYDATA, "Ptr", this.MBC_MessageBox, "Ptr", &cds, "Ptr")
        this.Free(cds, data)
        return r
    }
}