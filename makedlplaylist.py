""""Module To Create Playlist Of Music To Download"""
import json
from pathlib import Path
from ytmusicapi import YTMusic


oauth_path = Path(__file__).parent / "oauth.json"

ytmusic = YTMusic(oauth_path)

playlist_id = ytmusic.create_playlist("Music To Download","Music To Be Downloaded")

songs_to_dl = Path(__file__).parent / "songlist.txt"

songs_to_dl_list = songs_to_dl.read_text().splitlines()

search_results_list = []

for song in songs_to_dl_list:
    song_parts_list = song.split(" - ")
    search_results = ytmusic.search(song,"songs")
    if search_results[0]["title"].lower().strip() == song_parts_list[1].lower().strip():
        search_results_list.append(search_results)
    else:
        print(f"Song '{song}' Not Found On Youtube Music")

for result in search_results_list:
    ytmusic.add_playlist_items(playlist_id, [result[0]["videoId"]])

playlistdl = ytmusic.get_playlist(playlist_id)

jsondump = json.dumps(playlistdl)

file = Path(__file__).parent / "playlist.json"

file.write_text(jsondump)
