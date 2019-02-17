MusicBeeIPC SDK for AutoHotkey
================================================================================

I've reconfigured a bit of the original AutoHotkey code and tried to make a bit
more manageable as a class, instead of hundreds and hundreds of individual
functions and variables. Minimal testing done, but seems okay.

Instructions:
    - Download the plugin from 'Plugin\mb_IPC.dll' and move it into your plugins
      folder (e.g. C:\Program Files (x86)\MusicBee\Plugins)
      
    - Be sure to retain this folder structure:
        MusicBeeIPC\
         ├   MusicBeeIPC.ahk
         └─── Lib\
               ├ Constants.ahk
               ├ Enums.ahk
               ├ Pack.ahk
               └ Unpack.ahk
               
    - Include the MusicBeeIPC.ahk file in your script:
        #include MusicBeeIPC\MusicBeeIPC.ahk ; the full path to the .ahk file
        
    - Call your methods like so:
        MusicBeeIPC.GetFileUrl()
        
================================================================================

Original author: Kerli Low

Email: kerlilow@gmail.com

Homepage: https://getmusicbee.com/forum/index.php?topic=11492.0

Description: Control MusicBee with AutoHotkey using the MusicBeeIPC plugin.

License:
    BSD 2-Clause License (See LICENSE_MusicBeeIPCSDK.txt)
