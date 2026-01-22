--[[

Copyright © 2026, DTR, Seth VanHeulen
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of this addon nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

]]

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
