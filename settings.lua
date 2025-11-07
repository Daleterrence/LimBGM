local settings = {}
-- List of song IDs the addon will choose from randomly to play when you change floors. You can see the full list of song IDs and titles in 'lib/id-title-map.lua'.
settings.song_ids = { 26, 30, 35, 36, 37, 46, 47, 49, 50, 52, 53, 55, 57, 62, 64, 65, 70, 74, 75, 85, 86, 87, 88, 89, 90, 101, 102, 103, 115, 119, 125, 129, 136, 137, 138, 139, 142, 143, 144, 146, 186, 187, 191, 192, 193, 195, 196, 198, 215, 216, 217, 218, 219, 220, 223, 226, 246, 247, 249, 250 }
-- Whether to show a chat message when the BGM changes to indicate what song is now playing.
settings.show_now_playing = false

return settings
