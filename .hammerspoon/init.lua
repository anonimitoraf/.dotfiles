local spaces = require("hs.spaces")

-- Switch alacritty
hs.hotkey.bind({'command'}, 'return', function ()
  local APP_NAME = 'Alacritty'
  function moveWindow(alacritty, space, mainScreen)
    -- move to main space
    local win = nil
    while win == nil do
      win = alacritty:mainWindow()
    end
    print(win)
    print(space)
    print(win:screen())
    print(mainScreen)
    local fullScreen = not win:isStandard()
    if fullScreen then
      hs.eventtap.keyStroke('cmd', 'return', 0, alacritty)
    end
    winFrame = win:frame()
    scrFrame = mainScreen:fullFrame()
    print(winFrame)
    print(scrFrame)
    winFrame.w = scrFrame.w
    winFrame.y = scrFrame.y
    winFrame.x = scrFrame.x
    print(winFrame)
    win:setFrame(winFrame, 0)
    print(win:frame())
    -- win:spacesMoveTo(space)
    spaces.moveWindowToSpace(win, space)
    if fullScreen then
      hs.eventtap.keyStroke('cmd', 'return', 0, alacritty)
    end
    win:focus()
  end
  local alacritty = hs.application.get(APP_NAME)
  if alacritty ~= nil and alacritty:isFrontmost() then
    print("Hiding alacritty")
    alacritty:hide()
  else
    -- local space = spaces.activeSpace()
    local space = spaces.focusedSpace()
    -- local mainScreen = hs.screen.find(spaces.mainScreenUUID())
    local mainScreen = hs.screen.mainScreen()
    if alacritty == nil and hs.application.launchOrFocus(APP_NAME) then
      local appWatcher = nil
      print('create app watcher')
      appWatcher = hs.application.watcher.new(function(name, event, app)
        print(name)
        print(event)
        if event == hs.application.watcher.launched and name == APP_NAME then
          app:hide()
          moveWindow(app, space, mainScreen)
          appWatcher:stop()
        end
      end)
      print('start watcher')
      appWatcher:start()
    end
    if alacritty ~= nil then
      moveWindow(alacritty, space, mainScreen)
    end
  end
end)

-- bind hotkey
hs.hotkey.bind({'cmd'}, 'l', function()
  -- get the focused window
  local win = hs.window.focusedWindow()
  -- get the screen where the focused window is displayed, a.k.a. current screen
  local screen = win:screen()
  -- compute the unitRect of the focused window relative to the current screen
  -- and move the window to the next screen setting the same unitRect
  win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
end)

hs.hotkey.bind({'cmd'}, 'f', function()
  -- get the focused window
  local win = hs.window.focusedWindow()
  win:maximize()
end)

-- Clipboard manager
hs.hotkey.bind({'ctrl', 'shift'}, 'q', function()
    local winBefore = hs.window.focusedWindow()
    local task = hs.task.new(
      '/opt/homebrew/bin/emacsclient',
      function(exitCode, stdout, stderr)
        winBefore:focus()
      end,
      { '--eval', '(clippo)' }
    )
    task:start()
end)

-- Auto-focus emacsclient when created
local wf=hs.window.filter
local wf_emacs = wf.new{'Emacs'}
wf_emacs:subscribe(wf.windowCreated, function(window)
    window:focus()
end)
