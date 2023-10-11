# YTMusicDownloadFromSongList
A Script that will check Youtube Music for songs listed in songslist.txt and return mp3 files with correct ID3 tags and CoverArt.
# Instructions
1. Clone Repo To Any Directory.
2. Edit songslist.txt to add songs to search on Youtube Music in the format of "Artist - Song Name" with each artist and song on a different line. (Make sure the song name is the exact name on Youtube Music under the songs category[Case Insensitive])
3. Open Windows Terminal with PowerShell 7 profile, or run PowerShell 7 directly if you don't like Windows Terminal.
4. Run the GetYTMusicSong.ps1 by dot sourcing it. So type in [. "Path To GetYTMusic.ps1"] without the brackets.
5. On initial run it will open a browser window to have you log into your Youtube/Google account. Hit continue, select the google account you'd like to use if you have multiple, then select allow. Go back to the PowerShell/Window Terminal and hit enter to continue. This will create a file called oauth.json in the repo directory.
6. Wait for the script to complete.
7. Check ConvertedMp3s folder for final tagged w/ coverart mp3 files.
# On Second Run
1. Delete the VideoDownloads, CoverArt, and ConvertedMp3s folders.
2. Delete the playlist.json file.
3. Change the contents of songslist.txt to something different.
4. Delete the "Music To Download" playlist from music.youtube.com
5. Run GetYTMusicSongs.ps1 again following the same instructions as above.
# Requirements
- Python3 must be installed with pip3. It is need to install ytmusicapi library and run the python script of this repo. If script does not detect pip3 it will download Python 3.12 from winget and install it.
- You might have to remove previous versions of python from the User and System PATH Environment Variables, and or disable the app execution alias in Win 10/11 under Settings App>Apps>Advanced App Settings>App Execution Aliases for python and python3.
- If you have newer versions of some libraries installed already it might throw errors. Please report those here under Issues Tab. I'll leave you to figure out how to get around that. Easiest way is to completely uninstall Python and reinstall before running this script.
- Must have ffmpeg installed and added to PATH Environment Variable.
# Upcoming Features Possibly
- Ability to Download by Artist - Album Title in albumslist.txt
- Auto Installation of ffmpeg
- Parameters to .ps1 script to allow for custom actions.
# Warnings
I have no idea if this method is legal or not so use at your own risk.
# Credits
This uses the python library ytmusicapi, and the cli exe youtubedr. Props to those devs.
