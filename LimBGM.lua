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

_addon.name = 'LimBGM'
_addon.author = 'DTR'
_addon.version = '0.1.0'
_addon.commands = { 'limbgm', 'lm' }

require('strings')
require('luau')
local packets = require('packets')
local res = require('resources')

local settings = require('settings')
local setbgm = require('lib.setbgm')
local song_map = require('lib.id-title-map').songs


math.randomseed(os.time())

local register_event = windower.register_event
local add_to_chat = windower.add_to_chat
local get_info = windower.ffxi.get_info
local last_song_id = nil
local pending_bgm_change = false
local prefix = ('['):color(210)..('LimBGM'):color(220)..('] '):color(210)

local function get_song_name(song_id)
    return song_map[song_id] or 'Unknown'
end

local function pick_random_song()
    local list = settings.song_ids or {}
    if #list == 0 then
        add_to_chat(167, prefix .. 'Settings.lua file has not been read correctly; skipping BGM change.')
        return nil
    end
    local idx = math.random(#list)
    return list[idx]
end

local function change_bgm(song_id)
    song_id = song_id or pick_random_song()
    if not song_id then return end

    if song_id ~= 0 and song_id == last_song_id then
        local alt = pick_random_song()
        if alt and alt ~= song_id then song_id = alt end
    end

    pending_bgm_change = true

    local ok, err = setbgm.set(song_id)
    if ok then
        last_song_id = song_id
        if settings.show_now_playing and song_id ~= 0 then
            add_to_chat(211, prefix .. get_song_name(song_id) .. ' is now playing.')
        end
    else
        add_to_chat(167,
            prefix ..
            'Invalid song ID detected! Failed to set BGM for song ID ' .. song_id .. ' (' .. get_song_name(song_id) ..
            ')')
    end

    coroutine.schedule(function()
        pending_bgm_change = false
    end, 5)
end

local lobby_areas = {
    { x = -608, y = -600,            z = 0 },
    { x = 608,  y = -600,            z = 0 },
    { x = 580,  y = 86.000007629395, z = 0 },
}

local function is_lobby_area(x, y, z)
    for _, lobby in ipairs(lobby_areas) do
        if math.abs(x - lobby.x) < 1 and
            math.abs(y - lobby.y) < 1 and
            math.abs(z - lobby.z) < 1 then
            return true
        end
    end
    return false
end

local function register_warp_handlers()
    register_event('outgoing chunk', function(id, data, modified, injected, blocked)
        if id == 0x05C then
            local zone_id = get_info().zone

            if zone_id == 37 or zone_id == 38 then
                local p = packets.parse('outgoing', data)
                local x = p['X']
                local y = p['Y']
                local z = p['Z']

                if is_lobby_area(x, y, z) then
                    change_bgm(0)
                else
                    change_bgm()
                end
            end
        end
    end)
end

windower.register_event('load', function()
    add_to_chat(211, prefix .. _addon.name .. ' v' .. _addon.version .. ' loaded successfully!')
    register_warp_handlers()
end)

windower.register_event('incoming chunk', function(id, data, modified, injected, blocked)
    if id == 0x05F and pending_bgm_change then
        return true
    end
end)

windower.register_event('addon command', function(cmd, ...)
    cmd = (cmd or ''):lower()
    if cmd == 'skip' then
        change_bgm()
    elseif cmd == 'last' then
        if last_song_id then
            add_to_chat(211, prefix .. 'Last song ID and title: ' .. last_song_id ..
            ' (' .. get_song_name(last_song_id) .. ')')
        else
            add_to_chat(167, prefix .. 'No song has been set yet!')
        end
    elseif cmd == 'list' then
        local song_list = {}
        for _, id in ipairs(settings.song_ids) do
            table.insert(song_list, id .. ' (' .. get_song_name(id) .. ')')
        end
        add_to_chat(211, prefix .. 'Configured song IDs: ' .. table.concat(song_list, ', '))
    elseif cmd == 'playing' then
        settings.show_now_playing = not settings.show_now_playing
        local status = settings.show_now_playing and 'enabled' or 'disabled'
        add_to_chat(211, prefix .. '"Now playing" notifications are now ' .. status .. '.')
    else
        add_to_chat(211, prefix..'Commands: //limbgm or //lm')
        add_to_chat(211, prefix..'skip - Rerolls which song is currently playing.')
        add_to_chat(211, prefix..'list - Displays configured song IDs, and titles.')
        add_to_chat(211, prefix..'last - Displays the last song that was playing.')
        add_to_chat(211, prefix..'playing - Toggles "Now playing" notifications.')
    end
end)

return {
    change_bgm = change_bgm,
    pick_random_song = pick_random_song,
}

