require('pack')

local M = {}

local music_types = {
    [0]='Idle (Day)',
    [1]='Idle (Night)',
    [2]='Battle (Solo)',
    [3]='Battle (Party)',
    [4]='Chocobo',
    [5]='Death',
    [6]='Mog House',
    [7]='Fishing'
}

local function valid_song(id)
    return type(id) == 'number' and id >= 0 and id <= 900
end

function M.set(song_id, music_type)
    if not valid_song(song_id) then
        return false, 'invalid song id'
    end
    
    if music_type then
        local m = tonumber(music_type)
        if not music_types[m] then
            return false, 'invalid music type'
        end
        windower.packets.inject_incoming(0x05F, string.pack('IHH', 0x45F, m, song_id))
    else
        for mt=0,7 do
            windower.packets.inject_incoming(0x05F, string.pack('IHH', 0x45F, mt, song_id))
        end
    end
    
    return true
end

return M