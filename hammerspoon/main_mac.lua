

local function key_event(key, mods, stroke, delay)
    mods = mods or {}
    delay = delay or 200
    local _key_down = hs.eventtap.event.newKeyEvent(mods, string.lower(key), true)
    local _key_up = hs.eventtap.event.newKeyEvent(mods, string.lower(key), false)
    if stroke == 0 then
      _key_down:post()
    elseif stroke == 1 then
      _key_up:post()
    elseif stroke == 3 then
      _key_up:post()
      hs.timer.usleep(delay)
      _key_down:post()
    else
      -- default to 2
      -- elseif stroke == 2 then
      _key_down:post()
      hs.timer.usleep(delay)
      _key_up:post()
    end
  end
  
  -- KEY REMAPPING
  local function key_send(key, mods, stroke)
    -- stroke: 0=down | 1=up | 2=down+up | 3=up+down
    -- mods = mods or {}
    -- stroke = stroke or 2
    -- _delay = 200
    return function()
      key_event(key, mods, stroke, 200)
      -- -- hs.alert.show("[KEY] key[" .. key .. "] stroke[" .. tostring(stroke) .. "]")
      -- if stroke == 0 then
      --   hs.eventtap.event.newKeyEvent(mods, string.lower(key), true):post()
      -- elseif stroke == 1 then
      --   hs.eventtap.event.newKeyEvent(mods, string.lower(key), false):post()
      -- elseif stroke == 3 then
      --   hs.eventtap.event.newKeyEvent(mods, string.lower(key), false):post()
      --   hs.timer.usleep(_delay)
      --   hs.eventtap.event.newKeyEvent(mods, string.lower(key), true):post()
      -- else
      --   -- default to 2
      --   -- elseif stroke == 2 then
      --   hs.eventtap.event.newKeyEvent(mods, string.lower(key), true):post()
      --   hs.timer.usleep(_delay)
      --   hs.eventtap.event.newKeyEvent(mods, string.lower(key), false):post()
      --   -- hs.alert.show("[KEY] stroke[" .. tostring(stroke) .. "] must be one of [0, 1, 2, 3]")
      -- end
    end
  end
  
  local function key_send_per_app(key, mods, stroke, app_name)
    return function()
      local win = hs.window.focusedWindow()
      local _app_name = win:application():name()
      if _app_name == app_name then
        key_event(key, mods, stroke, 200)
      end
    end
  end
  
  local function remap_key_full(mods_in, key_in, mods_out, key_out)
    hs.hotkey.bind(
      mods_in, key_in, -- in
      -- "", -- message
      key_send(key_out, mods_out, 0), -- down
      key_send(key_out, mods_out, 1), -- up
      key_send(key_out, mods_out, 3)  -- repeat
    )
  end
  
  local function remap_key_per_app(mods_in, key_in, mods_out, key_out, app_name)
    hs.hotkey.bind(
      mods_in, key_in, -- in
      -- "", -- message
      key_send_per_app(key_out, mods_out, 0, app_name), -- down
      key_send_per_app(key_out, mods_out, 1, app_name), -- up
      key_send_per_app(key_out, mods_out, 3, app_name)  -- repeat
    )
  end
  
  local function key_send_per_app(key, mods, stroke, app_name)
    return function()
      local win = hs.window.focusedWindow()
      local _app_name = win:application():name()
      if _app_name == app_name then
        key_event(key, mods, stroke, 200)
      end
    end
  end
  
  
  -- [KeychronK6]: cmd + esp -> cmd + `
  remap_key_full({'cmd'}, 'escape', {'cmd'}, '`')
  remap_key_full({'cmd', 'shift'}, 'escape', {'cmd', 'shift'}, '`')
  
  
  
  local function key_send_apps(app_keys, stroke)
    return function()
      local win = hs.window.focusedWindow()
      local _app_name = win:application():name()
      for app_name, keys in pairs(app_keys) do
        if _app_name == app_name then
          key_event(keys[2], keys[1], stroke, 100)
          break
        end
      end
    end
  end
  
  local function remap_key_apps(mods_in, key_in, app_keys)
    hs.hotkey.bind(
      mods_in, key_in, -- in
      -- "", -- message
      key_send_apps(app_keys, 0), -- down
      key_send_apps(app_keys, 1), -- up
      key_send_apps(app_keys, 3)  -- repeat
    )
  end
  
  side_scroll_keys_down = {
    ['Google Chrome'] = {{'ctrl', 'shift'}, 'tab'},
    ['Code'] = {{'ctrl'}, '-'},
    ['YouTube'] = {{}, 'left'},
    ['Spotify'] = {{'cmd', 'shift'}, 'left'},
    ['IINA'] = {{}, 'left'}
  }
  side_scroll_keys_up = {
    ['Google Chrome'] = {{'ctrl'}, 'tab'},
    ['Code'] = {{'ctrl', 'shift'}, '-'},
    ['YouTube'] = {{}, 'right'},
    ['Spotify'] = {{'cmd', 'shift'}, 'right'},
    ['IINA'] = {{}, 'right'}
  }
  remap_key_apps({}, 'pagedown', side_scroll_keys_down)
  remap_key_apps({}, 'pageup', side_scroll_keys_up)
  
  -- MouseScroll (Horizontal)
  -- Chrome: -> Tab Switching
  -- remap_key_per_app({}, 'pagedown', {'ctrl', 'shift'}, 'tab', 'Google Chrome')
  -- remap_key_per_app({}, 'pageup', {'ctrl'}, 'tab', 'Google Chrome')
  
  -- -- VSCode: -> Editor Navigate Back/Forward
  -- remap_key_per_app({}, 'pagedown', {'ctrl'}, '-', 'Code')
  -- remap_key_per_app({}, 'pageup', {'ctrl', 'shift'}, '-', 'Code')
  
  -- -- YouTube: -> Player Seek Back/Forward
  -- remap_key_per_app({}, 'pagedown', {}, 'left', 'YouTube')
  -- remap_key_per_app({}, 'pageup', {}, 'right', 'YouTube')
  
  
  
  
  -- template: notification
  hs.hotkey.bind({"cmd", "option", "ctrl"}, "W", function()
    -- hs.alert.show("Hello World!")
    hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
  end)
  
  -- window/screen info
  hs.hotkey.bind({"cmd", "option", "ctrl"}, "H", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    
    local app_name = win:application():name()
    
    hs.alert.show("[" .. app_name .. "] screen[" .. math.floor(max.w) .. "x" .. math.floor(max.h) .. "] window[" .. math.floor(f.w) .. "x" .. math.floor(f.h) .. "]")
  end)
  
  -- youtube window size test
  hs.hotkey.bind({"cmd", "option", "ctrl"}, "T", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local max = win:screen():frame()
    
    local app_name = win:application():name()
    
    zoom = 1
    hard_w = 0
    hard_h = 39
    extra_w = 16 * zoom + hard_w * (1 - zoom)
    extra_h = 207 * zoom + hard_h * (1 - zoom)
    
    _fw = f.w
    _fh = f.h
    if app_name == "YouTube" then
      -- view_w = 2560
      -- view_h = 1440 + 10
      view_w = 1536
      view_h = 1000
      if f.w == math.ceil(view_w + extra_w) then
        view_w = view_w + 16
      end
      f.w = math.ceil(view_w + extra_w)
      f.h = math.min(math.ceil(view_h + extra_h), max.h)
      f.x = max.x + (max.w - f.w) / 2
      f.y = max.y + max.h - f.h
      win:setFrame(f, 0)
      -- str_view = "view[" .. math.floor(view_w) .. "x" .. math.floor(view_h) .. "]"
      -- str_window = "window[" .. math.floor(_fw) .. "x" .. math.floor(_fh) .. "]"
      -- str_window_final = "->[" .. math.floor(f.w) .. "x" .. math.floor(f.h) .. "]"
      -- hs.alert.show("[YouTube] " .. str_view .. " | " .. str_window .. str_window_final)
    elseif app_name == "Preview" then
      if f.w == 1600 then
        -- f.w = 1728
        f.w = 1632
      else
        f.w = 1600
      end
      f.h = max.h
      f.x = max.x + (max.w - f.w) / 2
      f.y = max.y + max.h - f.h
      win:setFrame(f, 0)
    end
  end)
  
  -- youtube window sizing
  function youtube_resize(zoom)
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    
    local app_name = win:application():name()
    
    
    _fw = f.w
    _fh = f.h
    -- hs.alert.show("[" .. app_name .. "] screen[" .. math.floor(max.w) .. "x" .. math.floor(max.h) .. "] window[" .. math.floor(f.w) .. "x" .. math.floor(f.h) .. "]")
    -- hs.alert.show("screen[" .. max.w .. "x" .. max.h .. "]")
    if (app_name == "YouTube" or app_name == "Google Chrome") then
      -- 75%
      -- hs.alert.show("[" .. app_name .. "] window_xy[" .. math.floor(f.x) .. "x" .. math.floor(f.y) .. "] screen_xy[" .. math.floor(max.x) .. "x" .. math.floor(max.y) .. "]")
      
      -- max.w
      -- target res: 3072x1728
      -- 75% | window 1548x1029 | view 2048
      -- set the bounds of the front window to {_x, 0, _x + 1548, 1029}
      -- 80% | window 1549x1037 | view 1920
      --set the bounds of the front window to {_x, 0, _x + 1549, 1037}
      
      -- zoom = 1
      -- zoom = 0.8
      -- zoom = 0.75
      
      -- base UI
      -- hard_w = 0
      -- hard_h = 39
      -- extra_w = 16 * zoom + hard_w * (1 - zoom)
      -- extra_h = 207 * zoom + hard_h * (1 - zoom)
      
      -- base tweaked
      hard_w = 1
      hard_h = 39
      extra_w = 0 * zoom + hard_w
      extra_h = 0 * zoom + hard_h
      
      if max.w == 1728 then
        -- MBP16 1728 (2x)
        -- if max.h >= 1056 then
        --   -- pixel[3200x1800] window[1548x1029] pos[top]
        --   view_w = 3200 / 2
        --   view_h = 1800 / 2
        -- else
        --   -- pixel[3072x1728] window[1548x1029] pos[top]
        --   view_w = 3072 / 2
        --   view_h = 1728 / 2
        -- end
        
        -- MBP16 1728 (2x) [tweaked]
        view_w = 3456 / 2
        view_h = 1944 / 2
        
        -- f.w = 1548
        -- f.h = 1029
        f.w = math.ceil(view_w + extra_w)
        f.h = math.ceil(view_h + extra_h)
        f.x = max.x + (max.w - f.w) / 2
        f.y = max.y
        -- hs.alert.show("[YouTube] window[" .. math.floor(_fw) .. "x" .. math.floor(_fw) .. " -> " .. math.floor(f.w) .. "x" .. math.floor(f.h) .. "]")
        -- elseif max.w == 3840 then
      else
        -- default to External 4K (1x) -> view[1920x1080] pos[bottom]
        view_w = 1920
        view_h = 1080
        if f.w == view_w + math.ceil(extra_w) then
          view_w = 2560
          view_h = 1440
        end
        f.w = math.ceil(view_w + extra_w)
        f.h = math.ceil(view_h + extra_h)
        f.x = max.x + math.min(math.max(f.x + (_fw - f.w) / 2, 0), max.w - f.w)
        f.y = max.y + max.h - f.h
      end
      win:setFrame(f)
      str_view = "view[" .. math.floor(view_w) .. "x" .. math.floor(view_h) .. "]"
      str_window = "window[" .. math.floor(_fw) .. "x" .. math.floor(_fh) .. "]"
      str_window_final = "->[" .. math.floor(f.w) .. "x" .. math.floor(f.h) .. "]"
      hs.alert.show("[YouTube] " .. str_view .. " | " .. str_window .. str_window_final)
    else
      -- error("invalid operation")
    end
  end
  
  function youtube_resize_fn(zoom)
    return function()
      youtube_resize(zoom)
    end
  end
  
  hs.hotkey.bind({"cmd", "option", "ctrl"}, "Y", youtube_resize_fn(1.0))
  hs.hotkey.bind({"cmd", "option", "ctrl"}, "U", youtube_resize_fn(0.75))
  
  
  -- assuming zoom starts at 1.0
  _zoom = 1
  
  -- youtube window zoom switch
  hs.hotkey.bind({"cmd", "option", "ctrl"}, "J", function()
    -- key_event('=', {'cmd'}, 2, 50)
    -- hs.alert.show("[YouTube] zoom switch")
    -- key_event('-', {'cmd'}, 2, 50)
    if _zoom == 1 then
      key_event('-', {'cmd'}, 2, 50)
      key_event('-', {'cmd'}, 2, 50)
      key_event('-', {'cmd'}, 2, 50)
      _zoom = 0.75
      youtube_resize(_zoom)
    else
      key_event('=', {'cmd'}, 2, 50)
      key_event('=', {'cmd'}, 2, 50)
      key_event('=', {'cmd'}, 2, 50)
      _zoom = 1.0
      youtube_resize(_zoom)
    end
  end)
  
  -- promt
  hs.hotkey.bind({"cmd", "option", "ctrl"}, "D", function()
    button, message = hs.dialog.textPrompt("Main message.", "Please enter something:")    
    -- hs.messages.iMessage("+910000000000", message)
    -- hs.notify("sent")
    hs.alert.show("[Promt] button[" .. button .. "] | message[" .. message .. "]")
  end)
  
  -- promt
  hs.hotkey.bind({"cmd", "option", "ctrl"}, "B", function()
    -- local b_amp = hs.battery.amperage()
    -- local b_cap = hs.battery.capacity()
    -- local b_cyc = hs.battery.cycles()
    -- local b_charging = hs.battery.isCharging()
    -- local b_per = hs.battery.percentage()
    -- local b_wat = hs.battery.watts()
    -- hs.alert.show("[Battery] amp[" .. b_amp .. "] cap[" .. b_cap .. "] cycle[" .. b_cyc .. "] charging[" .. b_charging .. "] per[" .. b_per .. "] wat[" .. b_wat .. "]")
    -- hs.alert.show("[Battery] amp[" .. b_amp .. "] cap[" .. b_cap .. "] cycle[" .. b_cyc .. "] charging[" .. b_charging .. "] per[" .. b_per .. "]")
    
    local b_all = hs.battery.getAll()
    local b_info = {
      amperage= 1,
      cycles= "blah"
    }
    local b_keys = {
      'amperage',
      'capacity',
      'cycles',
      'isCharging',
      'percentage',
      'watts'
    }
    local b_percent = math.floor(b_all['percentage'])
    local b_charging = b_all['isCharging']
    if b_charging and b_percent > 80 then
      hs.alert.show("[BATTERY] charging at " .. b_percent .. "%")
    elseif not b_charging and b_percent <= 25 then
      hs.alert.show("[BATTERY] dis-charging at " .. b_percent .. "%")
    else
      local str_charging = "dis-charging"
      if b_charging then
        str_charging = "charging"
      end
      hs.alert.show("[BATTERY] " .. str_charging .. " at " .. b_percent .. "%")
    end
    
    -- for k, v in pairs(b_keys) do
    --   -- b_info[v] = b_all[v]
    --   hs.alert.show(v .. tostring(b_all[v]))
    -- end
    -- hs.alert.show(tostring(b_info))
    -- hs.alert.show(tostring(hs.battery.getAll()))
    -- print(b_info)
  end)
  
  
  
  
  
  
  
  
  -- HYPER
  -- A global variable for the Hyper Mode
  -- hyper_key = 'insert'
  -- hyper_key = 'home'
  hyper_key = 'end'
  hyper = hs.hotkey.modal.new({}, 'f18')
  
  -- Enter Hyper Mode when (Hyper) is pressed
  function enterHyperMode()
    hyper.triggered = false
    hyper.time_triggered = hs.timer.absoluteTime() / 1000000000
    hyper:enter()
  end
  
  -- Leave Hyper Mode when (Hyper) is pressed,
  -- send ESCAPE if no other keys are pressed.
  function exitHyperMode()
    hyper:exit()
    if not hyper.triggered then
      local time_current = hs.timer.absoluteTime() / 1000000000
      local time_elapsed = time_current - hyper.time_triggered
      -- hs.alert.show("[HYPER] elapsed[" .. time_elapsed .. "]")
      if time_elapsed <= 0.2 then
        hs.eventtap.event.newSystemKeyEvent('PLAY', true):post()
        hs.eventtap.event.newSystemKeyEvent('PLAY', false):post()
      end
      -- hs.eventtap.keyStroke({}, 'ESCAPE')
    end
  end
  
  -- Bind the Hyper key
  hyper_bind = hs.hotkey.bind({}, hyper_key, enterHyperMode, exitHyperMode)
  
  local function sendSystemKey(key)
    hs.eventtap.event.newSystemKeyEvent(key, true):post()
    hs.eventtap.event.newSystemKeyEvent(key, false):post()
  end
  
  local volume = {
    up   = function() sendSystemKey("SOUND_UP") end,
    down = function() sendSystemKey("SOUND_DOWN") end,
    mute = function() sendSystemKey("MUTE") end,
  }
  
  hyper:bind({}, 'pageup', function()
    -- hs.eventtap.keyStroke({'cmd', 'ctrl'}, 'f')
    -- hs.eventtap.keyStroke({'ctrl'}, 'right')
    -- hs.eventtap.keyStroke({}, volume.up)
    sendSystemKey("SOUND_UP")
    -- output = hs.audiodevice.defaultOutputDevice()
    -- output:setVolume(output:volume() + 10)
    hyper.triggered = true
  end)
  
  hyper:bind({}, 'pagedown', function()
    -- hs.eventtap.keyStroke({'cmd', 'ctrl'}, 'f')
    -- hs.eventtap.keyStroke({'ctrl'}, 'left')
    -- hs.eventtap.keyStroke({}, volume.down)
    sendSystemKey("SOUND_DOWN")
    -- output = hs.audiodevice.defaultOutputDevice()
    -- output:setVolume(output:volume() - 10)
    hyper.triggered = true
  end)
  
  
  -- hs.hotkey.bind({}, "f10", volume.mute)
  -- hs.hotkey.bind({}, "f11", volume.down, nil, volume.down)
  -- hs.hotkey.bind({}, "f12", volume.up, nil, volume.up)
  
  -- hs.hotkey.bind({}, "pageup", volume.up, nil, volume.up)
  -- remap_key_full({}, 'pageup', {'ctrl'}, 'tab')
  
  -- tab_switcher = hs.hotkey.new({}, 'pageup', function()
  --   -- hs.application.launchOrFocus("Firefox.app")
  --   -- hs.eventtap.keyStroke({"⌘"}, "r")
  --   key_send('tab', {'ctrl'}, 0)
  --   hs.timer.usleep(200)
  --   key_send('tab', {'ctrl'}, 1)
  --   -- tab_switcher:disable() -- does not work without this, even though it should
  -- end)
  
  -- hs.window.filter.new('Google Chrome')
  --   :subscribe(hs.window.filter.windowFocused,function() tab_switcher:enable() end)
  --   :subscribe(hs.window.filter.windowUnfocused,function() tab_switcher:disable() end)
  
  
  
  -- hs.hotkey.bind({}, "home", function()
    
  --   key_send('tab', {'ctrl'}, 0)
  --   hs.timer.usleep(200)
  --   key_send('tab', {'ctrl'}, 1)
    
  --   -- local win = hs.window.focusedWindow()
  --   -- local app_name = win:application():name()
  --   -- key_send('tab', {'ctrl'}, 2)
  --   -- if app_name == "Google Chrome" then
  --   -- end
  -- end)
  
  
  function check_battery()
    -- hyper.time_triggered = hs.timer.absoluteTime() / 1000000000
    
    local b_all = hs.battery.getAll()
    local b_keys = {
      'amperage',
      'capacity',
      'cycles',
      'isCharging',
      'percentage',
      'watts'
    }
    local b_percent = math.floor(b_all['percentage'])
    local b_charging = b_all['isCharging']
    -- ⬇️⬆️🔼🔽
    -- hs.notify.new({title="Battery", informativeText="💻🔋⚡️ battery[" .. b_percent .. "%]🔼"}):send()
    
    -- NAGGING mode (during the learning process of MacOS)
    if not b_charging then
      if b_percent <= 95 then
        hs.notify.new({title="Battery - Plug in", informativeText="💻🔋 battery[" .. b_percent .. "%]"}):send()
      end
    end
    
    -- CHECKING mode
    -- if b_charging then
    --   if b_percent >= 95 then
    --     hs.notify.new({title="Battery", informativeText="💻🔋⚡️ battery[" .. b_percent .. "%] on power"}):send()
    --   end
    -- else
    --   if b_percent < 40 then
    --     hs.notify.new({title="Battery", informativeText="💻🪫 battery[" .. b_percent .. "%]"}):send()
    --   elseif b_percent < 60 then
    --     hs.notify.new({title="Battery", informativeText="💻🔋 battery[" .. b_percent .. "%]"}):send()
    --   end
    --   -- hs.notify.new({title="Battery", informativeText="💻🔋 battery[" .. b_percent .. "%]"}):send()
    -- end
    
  end
  
  hs.timer.doEvery(300, check_battery)
  check_battery()
  -- '🔌🪫🔋⚡️💻'
  
  
  
  
  hs.hotkey.bind({"cmd", "option", "ctrl"}, "M", function()
    -- local frame = hs.mouse.getCurrentScreen():frame()
    local frame = hs.mouse.getCurrentScreen():fullFrame()
    local pos_current = hs.mouse.getRelativePosition()
    
    local txt_current = "current["..math.floor(pos_current.x).."|"..math.floor(pos_current.y).."]"
    local txt_screen = "screen["..math.floor(frame.w).."x"..math.floor(frame.h).."]"
    
    local pos_target = pos_current
    pos_target.x = 0
    pos_target.y = 0
    
    hs.mouse.setRelativePosition(pos_target)
    local txt_target = "target["..math.floor(pos_target.x).."|"..math.floor(pos_target.y).."]"
    
    hs.alert.show("[Mouse] " .. txt_screen .. " | " .. txt_current .. " -> " .. txt_target)
    
  end)
  
  
  
  local function get_window_info()
    local win = hs.window.focusedWindow()
    -- local f = win:frame()
    -- local app_name = win:application():name()
    local screen = win:screen()
    -- local max = screen:frame()
    
    return {
      window = win,
      frame = win:frame(),
      app_name = win:application():name(),
      screen = screen,
      screen_frame = screen:frame(),
      screen_full_frame = screen:fullFrame()
    }
  end
  
  
  -- function movemouse(x1,y1,x2,y2,sleep)
  --   local xdiff = x2 - x1
  --   local ydiff = y2 - y1
  --   local loop = math.floor( math.sqrt((xdiff*xdiff)+(ydiff*ydiff)) )
  --   local xinc = xdiff / loop
  --   local yinc = ydiff / loop
  --   sleep = math.floor((sleep * 1000000) / loop)
  --   for i=1,loop do
  --   x1 = x1 + xinc
  --   y1 = y1 + yinc
  --   hs.mouse.absolutePosition({x = math.floor(x1), y = math.floor(y1)})
  --   hs.timer.usleep(sleep)
  --   end
  --   hs.mouse.absolutePosition({x = math.floor(x2), y = math.floor(y2)})
  --   end
  
  local function move_mouse_circle(x0, y0, d, step, duration)
    local sleep = math.floor(duration / step * 1000000)
    for i=1, step do
      local angle = i / step * math.pi * 2
      local x = x0 + math.sin(angle) * d
      local y = y0 - math.cos(angle) * d
      hs.mouse.absolutePosition({x = math.floor(x), y = math.floor(y)})
      hs.timer.usleep(sleep)
    end
    hs.mouse.absolutePosition({x = math.floor(x0), y = math.floor(y0)})
  end
  
  local function move_mouse_check(target, current)
    
  end
  -- googlePinger = hs.timer.new(15, pingGoogle)
  -- googlePinger:start()
  
  
  hs.hotkey.bind({"cmd", "option", "ctrl"}, "B", function()
    hs.timer.usleep(2 * 1000000)
    
    local pos_start = hs.mouse.getRelativePosition()
    pos_start.x = math.floor(pos_start.x)
    pos_start.y = math.floor(pos_start.y)
    
    for i=0, 20 * 60 * 2 do
      local pos_current = hs.mouse.getRelativePosition()
      dx = math.abs(pos_current.x - pos_start.x)
      dy = math.abs(pos_current.y - pos_start.y)
      if dx >= 20 or dy >= 20 then
        break
      end
      
      key_event("a", {}, 2, 200)
      
      -- hs.timer.usleep((1 + hs.math.randomFloat()) * 1000000)
      hs.timer.usleep(3 * 1000000)
    end
  end)
  
  hs.hotkey.bind({"cmd", "option", "ctrl"}, "V", function()
    -- window_info = get_window_info()
    
    -- local app_name = "VMWare Horizon Client"
    
    -- if window_info.app_name == app_name then
      
    -- end
    
    hs.timer.usleep(2 * 1000000)
    local pos_start = hs.mouse.getRelativePosition()
    pos_start.x = math.floor(pos_start.x)
    pos_start.y = math.floor(pos_start.y)
    
    for i=0, 4 do
      local pos_current = hs.mouse.getRelativePosition()
      if i > 0 then
        if math.floor(pos_current.x) ~= pos_start.x or math.floor(pos_current.y) ~= pos_start.y then
          break
        end
      end
      move_mouse_circle(pos_start.x, pos_start.y, 80, 20, 0.5)
      hs.timer.usleep(2 * 1000000)
    end
    
  end)
  