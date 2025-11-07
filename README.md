# LimBGM

Changes the music to a random battle track when changing floors in Limbus zones (Temenos/Apollyon).

## Install
1. Copy the `LimBGM` folder into `Windower/addons/`.
2. In-game, run: `//lua load limbgm`.

## Usage
- To make changes, edit `settings.lua`:
  - `song_ids`: The addon comes preconfigured with a list of battle tracks. You can find a full list of tracks with their IDs in `lib/id-title-map.lua` if you wish to change these.
  - `show_now_playing`: if true, shows "now playing" notifications in-game. This can also be done via command (see below). Is **Off** by default. 

## Commands
- `//lm skip`     — Rerolls which song is currently playing.
- `//lm list`     — Prints to chat a full list of possible song IDs and titles as configured in `settings.lua`.
- `//lm last`     — Prints to chat the last song that was playing.
- `//lm playing`  — Toggles "now playing" notifications, printed to chat when the song changes, displaying their title.

## Minimal version of SetBGM
In the lib folder there is a cut-down version of SetBGM to allow the addon to do what it does. This saves you having to also have SetBGM loaded to make use of this addon. You should avoid loading SetBGM with this addon for this reason.

## Notes
- The addon only functions in Limbus zones currently. If you have thoughts for where you'd like this addon to also work, please let me know.
- Lobby areas (entrances) do not play any music as by default, this is not a bug and is intended behaviour.
- This is probably the only release I'll do of this outside of bug fixes, any other additions would probably make it a different addon. 

## Uninstall
- `//lua unload limbgm` and remove the `LimBGM` folder from your addons directory.
