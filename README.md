# cp_m3u
A simple Fish script to copy all audio files from an M3U playlist.

## Installation

Put the `cp_m3u.fish` script into `~/.config/fish/functions/` or where ever your Fish installation is configured to put function scripts.

## Usage

Run `cp_m3u --help` in a [Fish shell](https://fishshell.com/) for a short list of commands.

**This script will override files without asking, so beware of typos or copy-pasta!**

- To copy audio files from a playlist to the current working directory, run:
  ```fish
  cp_m3u path/to/playlist.m3u
  ```
- To copy audio files from a playlist into a specific directory, run:
  ```fish
  cp_m3u -o path/to/out_dir path/to/playlist.m3u
  cp_m3u --out_dir=path/to/out_dir path/to/playlist.m3u
  ```
- To convert your audio files from FLAC to MP3 while copying, run:
  ```fish
  cp_m3u -m path/to/playlist.m3u
  cp_m3u --flac_to_mp3 path/to/playlist.m3u
  ```
  This feature needs `ffmpeg` to be installed.
- Of course, the args can be combined:
  ```fish
  cp_m3u -m -o path/to/out_dir path/to/playlist.m3u
  ```
- You can copy files from multiple playlists in one go:
  ```
  cp_m3u playlist_1.m3u playlist_2.m3u playlist_3.m3u
  ```
  
## Contributing

I welcome bug fixes but will likely ignore feature requests. This script is specialised for my personal use cases, which is moving a bunch of heavy best-of playlists full of FLAC files to my little 8GiB MP3 player.
