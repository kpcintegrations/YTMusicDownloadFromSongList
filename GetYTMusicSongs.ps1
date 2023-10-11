#Sets up oauth.json file from Youtube, Creates a playlist, Adds Songs From Txt File, Downloads YT Videos, Converts To mp3s, Then add's ID3 Tags and CoverArt"
if (!("$PSScriptRoot\oauth.json")) {
ytmusicapi oauth --file "$PSScriptRoot\oauth.json"
}
else {
python "$PSScriptRoot\makedlplaylist.py"
}
$playlistObject = Get-Content -Path "$PSScriptRoot\playlist.json" | ConvertFrom-Json
New-Item -Path "$PSScriptRoot\VideoDownloads\" -ItemType Directory -Force
New-Item -Path "$PSScriptRoot\CoverArt\" -ItemType Directory -Force
foreach ($playlist in $playlistObject.tracks) {
    $Artist = $playlist.artists.name
    if ($Artist.Count -gt 1){
        $ArtistParsed = $Artist -join " & "
    }
    else {
        $ArtistParsed = $Artist
    }
    $Title = $playlist.title
    $Album = $playlist.album.name
    $CoverArt = $playlist.thumbnails.url[0] -replace "h[0-9]+\-","h750-" -replace "w[0-9]+\-","w750-"
    $VideoId = $playlist.videoId
    Invoke-WebRequest -Uri $CoverArt -OutFile "$PSScriptRoot\CoverArt\$ArtistParsed - $Title - $Album.png"
. "$PSScriptRoot\youtubedr\youtubedr.exe" download -d "$PSScriptRoot\VideoDownloads\" -o "$ArtistParsed - $Title - $Album.mp4" -m "mp4" -q "hd720" "https://www.youtube.com/watch?v=$VideoId"
}
$videoDLed = Get-ChildItem -Path "$PSScriptRoot\VideoDownloads\" -File
$videoPaths = $videoDLed.FullName
New-Item -Path "$PSScriptRoot\ConvertedMp3s\" -ItemType Directory -Force
foreach ($path in $videoPaths) {
    $Filename = Split-Path -Path $path -LeafBase
    if ($Filename -notlike "youtube*") {
    & ffmpeg -i $path -b:a 320k "$PSScriptRoot\ConvertedMp3s\$Filename.mp3"
}
}
Install-Module -Name AudioWorks.Commands -Scope AllUsers -Force
Import-Module -Name AudioWorks.Commands
$Songs = Get-ChildItem -Path "$PSScriptRoot\ConvertedMp3s\" -File
foreach ($song in $Songs) {
    $songBaseName = $song.BaseName
    $infoList = $songBaseName -split " - "
    $Artist = $infoList[0]
    $Title = $infoList[1]
    $Album = $infoList[2]
    $CoverArt = Get-Item -Path "$PSScriptRoot\CoverArt\$songBaseName.png"
    $AWCoverArtFile = Get-AudioCoverArt -Path "$CoverArt"
    Get-AudioFile -Path $song.FullName | Set-AudioMetadata -Title $Title -Artist $Artist -Album $Album -CoverArt $AWCoverArtFile -PassThru | Save-AudioMetadata
    Rename-Item -Path $song.FullName -NewName "$Artist - $Title.mp3"
}