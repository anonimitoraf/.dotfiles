set $mod Mod1

new_window pixel 1
new_float normal

hide_edge_borders none

bindsym $mod+u border none
bindsym $mod+y border pixel 1
# bindsym $mod+n border normal

font pango:Ubuntu Mono, FontAwesome 15

# --- Title bar icons
for_window [class="(?i)firefox"] title_format "<tt></tt><span foreground='#FF6611'>  </span><tt> </tt>%title"
for_window [class="(.*)chrome(.*)"] title_format "<tt></tt><span foreground='#367dd0'>  </span><tt> </tt>%title"
for_window [class="(.*)terminal(.*)"] title_format "<tt></tt><span foreground='#00FF00' background='#000000'>  </span><tt> </tt>%title"
for_window [class="Slack"] title_format "<tt></tt><span foreground='#875656' >  </span><tt> </tt>%title"
for_window [class="azuredatastudio"] title_format "<tt></tt><span foreground='#FFBF00'>  </span><tt> </tt>%title"
for_window [class="Medis"] title_format "<tt></tt><span foreground='#CC0000'>  </span><tt> </tt>%title"
for_window [class="Emacs"] title_format "<tt></tt><span foreground='#9d40ff'>  </span><tt> </tt>%title"
for_window [class="copyq"] title_format "<tt></tt><span foreground='#ffffff'>  </span><tt> </tt>%title"
# ---

floating_modifier $mod

bindsym $mod+Return exec alacritty

# Window kill command
bindsym $mod+Shift+q kill

# start and show program launcher
bindsym $mod+d exec --no-startup-id rofi -rnow -run-command "bash -i -c '{cmd}'" -show run

# change focus
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# workspace back and forth (with/without active container)
workspace_auto_back_and_forth yes
bindsym $mod+b workspace back_and_forth
bindsym $mod+Shift+b move container to workspace back_and_forth; workspace back_and_forth

# split orientation
# bindsym $mod+p split h;exec notify-send 'tile horizontally'
# bindsym $mod+o split v;exec notify-send 'tile vertically'
bindsym $mod+p split horizontal
bindsym $mod+o split vertical
bindsym $mod+q split toggle

# toggle fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+x layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# toggle sticky
bindsym $mod+Shift+s sticky toggle

# focus the parent container
bindsym $mod+a focus parent

# move the currently focused window to the scratchpad
bindsym $mod+Shift+minus move scratchpad

# Show the next scratchpad window or hide the focused scratchpad window.
# If there are multiple scratchpad windows, this command cycles through them.
bindsym $mod+minus scratchpad show

# navigate workspaces next / previous
bindsym $mod+Ctrl+Right workspace next
bindsym $mod+Ctrl+Left workspace prev

# workspaces
set $ws1 1
set $ws2 2
set $ws3 3
set $ws4 4
set $ws5 5
set $ws6 6
set $ws7 7
set $ws8 8
set $ws9 9

# switch to workspace
bindsym $mod+1 workspace $ws1
bindsym $mod+2 workspace $ws2
bindsym $mod+3 workspace $ws3
bindsym $mod+4 workspace $ws4
bindsym $mod+5 workspace $ws5
bindsym $mod+6 workspace $ws6
bindsym $mod+7 workspace $ws7
bindsym $mod+8 workspace $ws8
bindsym $mod+9 workspace $ws9

# Move focused container to workspace
bindsym $mod+Ctrl+1 move container to workspace $ws1
bindsym $mod+Ctrl+2 move container to workspace $ws2
bindsym $mod+Ctrl+3 move container to workspace $ws3
bindsym $mod+Ctrl+4 move container to workspace $ws4
bindsym $mod+Ctrl+5 move container to workspace $ws5
bindsym $mod+Ctrl+6 move container to workspace $ws6
bindsym $mod+Ctrl+7 move container to workspace $ws7
bindsym $mod+Ctrl+8 move container to workspace $ws8
bindsym $mod+Ctrl+9 move container to workspace $ws9

# Move to workspace with focused container
bindsym $mod+Shift+1 move container to workspace $ws1; workspace $ws1
bindsym $mod+Shift+2 move container to workspace $ws2; workspace $ws2
bindsym $mod+Shift+3 move container to workspace $ws3; workspace $ws3
bindsym $mod+Shift+4 move container to workspace $ws4; workspace $ws4
bindsym $mod+Shift+5 move container to workspace $ws5; workspace $ws5
bindsym $mod+Shift+6 move container to workspace $ws6; workspace $ws6
bindsym $mod+Shift+7 move container to workspace $ws7; workspace $ws7
bindsym $mod+Shift+8 move container to workspace $ws8; workspace $ws8
bindsym $mod+Shift+9 move container to workspace $ws9; workspace $ws9

# Open specific applications in floating mode
for_window [title="alsamixer"] floating enable border pixel 1
for_window [class="Calamares"] floating enable border normal
for_window [class="Clipgrab"] floating enable
for_window [title="File Transfer*"] floating enable
for_window [class="Galculator"] floating enable border pixel 1
for_window [class="GParted"] floating enable border normal
for_window [title="i3_help"] floating enable sticky enable border normal
for_window [class="Lightdm-gtk-greeter-settings"] floating enable
for_window [class="Lxappearance"] floating enable sticky enable border normal
for_window [class="Manjaro-hello"] floating enable
for_window [class="Manjaro Settings Manager"] floating enable border normal
for_window [title="MuseScore: Play Panel"] floating enable
for_window [class="Nitrogen"] floating enable sticky enable border normal
for_window [class="Oblogout"] fullscreen enable
for_window [class="octopi"] floating enable
for_window [title="About Pale Moon"] floating enable
for_window [class="Pamac-manager"] floating enable
for_window [class="Pavucontrol"] floating enable
for_window [class="qt5ct"] floating enable sticky enable border normal
for_window [class="Qtconfig-qt4"] floating enable sticky enable border normal
for_window [class="Simple-scan"] floating enable border normal
for_window [class="(?i)System-config-printer.py"] floating enable border normal
for_window [class="Skype"] floating enable border normal
for_window [class="Thus"] floating enable border normal
for_window [class="Timeset-gui"] floating enable border normal
for_window [class="(?i)virtualbox"] floating enable border normal
for_window [class="Xfburn"] floating enable
for_window [class="^chromium-browser$"] floating disable, move window to workspace current
for_window [class="^Google-chrome$"] floating disable, move window to workspace current

# switch to workspace with urgent window automatically
for_window [urgent=latest] focus

# reload the configuration file
bindsym $mod+Shift+c reload

# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
# bindsym $mod+Shift+r restart

# exit i3 (logs you out of your X session)
# bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"

# Set shut down, restart and locking features
bindsym $mod+0 mode "$mode_system"
set $mode_system (l)ock, (e)xit, switch_(u)ser, (s)uspend, (h)ibernate, (r)eboot, (Shift+s)hutdown
mode "$mode_system" {
    bindsym l exec --no-startup-id i3exit lock, mode "default"
    bindsym s exec --no-startup-id i3exit suspend, mode "default"
    bindsym u exec --no-startup-id i3exit switch_user, mode "default"
    bindsym e exec --no-startup-id i3exit logout, mode "default"
    bindsym h exec --no-startup-id i3exit hibernate, mode "default"
    bindsym r exec --no-startup-id i3exit reboot, mode "default"
    bindsym Shift+s exec --no-startup-id i3exit shutdown, mode "default"

    # exit system mode: "Enter" or "Escape"
    bindsym Return mode "default"
    bindsym Escape mode "default"
}

# Resize window (you can also use the mouse for that)
bindsym $mod+r mode "resize"
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode
        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym j resize shrink width 5 px or 5 ppt
        bindsym k resize grow height 5 px or 5 ppt
        bindsym l resize shrink height 5 px or 5 ppt
        bindsym semicolon resize grow width 5 px or 5 ppt

        # same bindings, but for the arrow keys
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        # exit resize mode: Enter or Escape
        bindsym Return mode "default"
        bindsym Escape mode "default"
}

# Autostart applications
exec --no-startup-id nitrogen --restore; sleep 1; compton -b
exec --no-startup-id nm-applet
exec --no-startup-id pamac-tray
exec_always --no-startup-id dunst
exec_always --no-startup-id greenclip daemon
exec_always --no-startup-id ~/.screenlayout/default.sh
exec_always --no-startup-id ff-theme-util
exec_always --no-startup-id fix_xcursor
exec_always --no-startup-id sudo ~/vendor-software/pentablet/pentablet
exec_always --no-startup-id xfce4-clipman

# Theme colors
# class                 border  backgr. text    indicator   child_border
client.focused          #ffffff #1f1f1f #c6c6c6 #ffffff     #ffffff
client.focused_inactive #1f1f1f #1f1f1f #c6c6c6 #1f1f1f     #1f1f1f
client.urgent           #b30000 #1f1f1f #c6c6c6 #b30000     #b30000
client.placeholder      #c6c6c6 #1f1f1f #c6c6c6 #c6c6c6     #c6c6c6

# client.background #1E272B

# Gaps
gaps inner 10
gaps outer -4

smart_gaps on

# Press $mod+Shift+g to enter the gap mode. Choose o or i for modifying outer/inner gaps. Press one of + / - (in-/decrement for current workspace) or 0 (remove gaps for current workspace). If you also press Shift with these keys, the change will be global for all workspaces.
set $mode_gaps Gaps: (o) outer, (i) inner
set $mode_gaps_outer Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)
set $mode_gaps_inner Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)
bindsym $mod+Shift+g mode "$mode_gaps"

mode "$mode_gaps" {
        bindsym o      mode "$mode_gaps_outer"
        bindsym i      mode "$mode_gaps_inner"
        bindsym Return mode "default"
        bindsym Escape mode "default"
}
mode "$mode_gaps_inner" {
        bindsym plus  gaps inner current plus 5
        bindsym minus gaps inner current minus 5
        bindsym 0     gaps inner current set 0

        bindsym Shift+plus  gaps inner all plus 5
        bindsym Shift+minus gaps inner all minus 5
        bindsym Shift+0     gaps inner all set 0

        bindsym Return mode "default"
        bindsym Escape mode "default"
}
mode "$mode_gaps_outer" {
        bindsym plus  gaps outer current plus 5
        bindsym minus gaps outer current minus 5
        bindsym 0     gaps outer current set 0

        bindsym Shift+plus  gaps outer all plus 5
        bindsym Shift+minus gaps outer all minus 5
        bindsym Shift+0     gaps outer all set 0

        bindsym Return mode "default"
        bindsym Escape mode "default"
}

# set power-manager and volume control
exec --no-startup-id mate-power-manager

# bindsym XF86AudioRaiseVolume exec --no-startup-id amixer -c 0 -q set Master 2dB+ unmute
# bindsym XF86AudioLowerVolume exec --no-startup-id amixer -c 0 -q set Master 2db- unmute
# bindsym XF86AudioMute exec --no-startup-id amixer -q set Master toggle

# touchpad on and off controller on laptop with Fn+<touchpad control functional key>
bindsym XF86TouchpadOn exec --no-startup-id synclient Touchpadoff=0
bindsym XF86TouchpadOff exec --no-startup-id synclient Touchpadoff=1

# exec scripts
exec --no-startup-id xmodmap /home/anonimito/.capsEsc
exec --no-startup-id hsetroot -solid "#FFFFFF"
exec --no-startup-id /home/anonimito/.dropbox-dist/dropboxd

## Volume control

# Path to volume control, without trailing slash
set $volumepath ~/foss/i3-volume

# Command for the status line (used with -t, requires -u)
#   ie: i3blocks, i3status
set $statuscmd i3status

# Signal used to update the status line (used with -u, requires -t)
#   i3blocks uses SIGRTMIN+10 by default
#   i3status uses SIGUSR1 by default
set $statussig SIGUSR1

# Amount to increase/decrease volume as a percentage (used with -i, -d)
set $volumestep 5

# alsa-utils settings when not using pulseaudio-utils
#
# To configure a default card, see https://www.alsa-project.org/main/index.php/Asoundrc
#
# Card number to control. (used with -a and -c)
#   If not specified, i3-volume will let `amixer` use a default.
#   List cards: aplay -l
#set $alsacard 1

# Uncomment to use alsa-utils (append "-c $alsacard" without quotes to override default card)
#bindsym XF86AudioRaiseVolume exec $volumepath/volume -anp -i $volumestep -t $statuscmd -u $statussig
#bindsym XF86AudioLowerVolume exec $volumepath/volume -anp -d $volumestep -t $statuscmd -u $statussig
#bindsym XF86AudioMute        exec $volumepath/volume -amn -t $statuscmd -u $statussig

# pulseaudio-utils settings when not using alsa-utils
#
# Symbolic name for sink (numeric index not supported) (used with -s $sinkname)
#   Recommended: comment out this setting and omit the -s option to use default sink
#   List sink names: pacmd list-sinks | awk -F "[<>]" '/^\s+name: <.*>/{print $2}'
#set $sinkname alsa_output.pci-0000_00_1b.0.analog-stereo

# Using pulseaudio-utils (append "-s $sinkname" without quotes to override default sink)
bindsym XF86AudioRaiseVolume exec $volumepath/volume -np -i $volumestep -t $statuscmd -u $statussig
bindsym XF86AudioLowerVolume exec $volumepath/volume -np -d $volumestep -t $statuscmd -u $statussig
bindsym XF86AudioMute        exec $volumepath/volume -mn -t $statuscmd -u $statussig

# switching between windows
bindsym $mod+Tab exec wmctrl -i -a $(wmctrl -l | dmenu -p "Choose a window to switch to: " -l 10 | cut -d " " -f1) 

# custom shortcuts
bindsym $mod+v exec code
bindsym $mod+c exec google-chrome
bindsym $mod+e exec emacs
bindsym $mod+n exec emacsclient --eval "(emacs-everywhere)"
bindsym $mod+z exec 1password
# bindsym Print exec flameshot gui
bindsym Print exec xfce4-screenshooter --region --clipboard
bindsym Ctrl+Shift+q exec rofi -modi "clipboard:greenclip print" -show clipboard -run-command '{cmd}'

for_window [class="copyq"] move container to scratchpad
for_window [class="pentablet"] move container to scratchpad
# for_window [class="Shutter"] move container to scratchpad

bindsym XF86MonBrightnessUp exec xbacklight -inc 10 # increase screen brightness
bindsym XF86MonBrightnessDown exec xbacklight -dec 10 # decrease screen brightness

mode "passthrough" {
    bindsym Mod1+Alt_L mode "default"
}
bindsym Mod1+Alt_L mode "passthrough"

# resize window (you can also use the mouse for that)

bar {
  status_command i3status
}
