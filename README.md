```shell
git clone git@github.com:anonimitoraf/dotfiles.git --recurse-submodules ~/.dotfiles
```


``` shell
mkdir -p ~/personal/scripts
mkdir -p ~/.config/alacritty

sudo ln -sf ~/.dotfiles/scripts ~/personal/scripts

mkdir -p ~/.config/{dunst,i3,powerline-shell,kitty,erlang_ls}

sudo ln -sf ~/.dotfiles/.bashrc ~/.bashrc
sudo ln -sf ~/.dotfiles/.bash_utils ~/.bash_utils
sudo ln -sf ~/.dotfiles/.capsEsc ~/.capsEsc
sudo ln -sf ~/.dotfiles/.inputrc ~/.inputrc
sudo ln -sf ~/.dotfiles/dunstrc ~/.config/dunst/dunstrc
sudo ln -sf ~/.dotfiles/i3 ~/.config/i3/config
sudo ln -sf ~/.dotfiles/powerline-shell-config.json ~/.config/powerline-shell/config.json
sudo ln -sf ~/.dotfiles/greenclip.cfg ~/.config/greenclip.cfg
sudo ln -sf ~/.dotfiles/.alacritty.toml ~/.alacritty.toml
sudo ln -sf ~/.dotfiles/.alacritty.toml ~/.config/alacritty/alacritty.toml
sudo ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf
sudo ln -sf ~/.dotfiles/.tmux ~/.tmux
sudo ln -sf ~/.dotfiles/scripts/bash-powerline.sh ~/.bash-powerline.sh
sudo ln -sf ~/.dotfiles/kitty.conf ~/.config/kitty/kitty.conf

mkdir -p ~/.config/rofi
sudo ln -sf ~/.dotfiles/rofi.config.rasi ~/.config/rofi/config.rasi

mkdir -p ~/.config/i3status
sudo ln -sf ~/.dotfiles/i3status ~/.config/i3status/config

mkdir -p ~/.config/i3blocks
sudo ln -sf ~/.dotfiles/i3blocks ~/.config/i3blocks/config

sudo ln -sf ~/.dotfiles/erlang_ls.config ~/.config/erlang_ls/erlang_ls.config

mkdir -p ~/.lsp
sudo ln -sf ~/.dotfiles/clojure-lsp-config.edn ~/.lsp/config.edn
sudo ln -sf ~/.dotfiles/.zprint.edn ~/.zprint.edn

mkdir -p ~/.config/yabai
sudo ln -sf ~/.dotfiles/yabairc ~/.config/yabai/yabairc

mkdir -p ~/.config/skhd
sudo ln -sf ~/.dotfiles/skhdrc ~/.config/skhd/skhdrc

sudo ln -sf ~/.dotfiles/.aerospace.toml ~/.aerospace.toml

sudo ln -sf ~/.dotfiles/z.sh ~/z.sh

mkdir -p ~/.opencode
sudo ln -sf ~/.dotfiles/opencode.json ~/.opencode/opencode.json
sudo ln -sf ~/.dotfiles/global-instructions.md ~/.opencode/global-instructions.md

mkdir -p ~/.pi/agent
sudo ln -sf ~/.dotfiles/pi-agent-settings.json ~/.pi/agent/settings.json
sudo ln -sf ~/.dotfiles/pi-agent-themes ~/.pi/agent/themes

mkdir -p ~/.config/herdr
sudo ln -sf ~/.dotfiles/.config/herdr/config.toml ~/.config/herdr/config.toml

mkdir -p /etc/howdy
sudo install -m 644 ~/.dotfiles/howdy /etc/howdy/config.ini
sudo ~/personal/scripts/howdy-camera.sh --set
```

## Howdy (face auth for login, sudo and polkit)

Mint 22.2 / Ubuntu 24.04 ships no `howdy` package and the Launchpad PPA is stale,
so 3.0-beta is built from source. Only the config template (`howdy`) and the two
scripts in `scripts/` live in this repo; the rest is system state.

```shell
# dependencies -- there is no python3-dlib for 3.12, so use the wheel
sudo apt install meson ninja-build cmake pkg-config git curl bzip2 \
  libpam0g-dev libinih-dev libevdev-dev libpam-runtime \
  python3 python3-pip python3-dev python3-setuptools python3-wheel v4l-utils
python3 -m pip install --break-system-packages dlib-bin==20.0.1.post1

# source + the dlib models howdy expects (~31MB)
sudo git clone --depth 1 https://github.com/boltgolt/howdy /opt/howdy
sudo mkdir -p /usr/share/dlib-data
for f in dlib_face_recognition_resnet_model_v1 shape_predictor_5_face_landmarks mmod_human_face_detector; do
  sudo curl -fsSL -o "/usr/share/dlib-data/$f.dat.bz2" \
    "https://github.com/davisking/dlib-models/raw/master/$f.dat.bz2"
  sudo bunzip2 -f "/usr/share/dlib-data/$f.dat.bz2"
done

# build + install (installs pam_howdy.so and the pam-auth-update profile)
cd /opt/howdy
meson setup build --prefix=/usr --buildtype=release -Dinstall_pam_config=true \
  -Dconfig_dir=/etc/howdy -Ddlib_data_dir=/usr/share/dlib-data \
  -Dpython_path=/usr/bin/python3
meson compile -C build
sudo meson install -C build

# config: this repo's template, then let the detector fill in device_path
sudo mkdir -p /etc/howdy
sudo install -m 644 ~/.dotfiles/howdy /etc/howdy/config.ini
sudo ~/personal/scripts/howdy-camera.sh --set

# enrol a face -- exactly one face in frame, looking at the camera
sudo howdy -y add

# switch it on (login, sudo, screensaver, polkit)
sudo cp -a /etc/pam.d/common-auth /etc/pam.d/common-auth.pre-howdy
sudo pam-auth-update --enable howdy
```

Notes:

- **A missed face never locks you out.** `pam_howdy` is inserted as
  `[success=2 default=ignore]`, so a timeout falls through to `pam_unix`.
- **Verify:** `sudo ~/personal/scripts/howdy-verify.sh` — 3 attempts, prints the
  dlib distance, and tells you which config value to change.
- **Turn off:** `sudo howdy disable 1` (keeps the PAM entry, exits immediately) or
  restore `/etc/pam.d/common-auth.pre-howdy` to remove it entirely.
- **Tune:** `sudo howdy set certainty 4.5` (default `3.5` = dlib distance 0.35,
  lower is stricter), `sudo howdy set timeout 9`, `sudo howdy set dark_threshold 70`.
  `howdy set` rewrites a single line, so the file's comments survive.
- **i3 needs a polkit agent.** Without one, GUI auth prompts fail silently with
  *"Authorization requires authentication but no agent is available"* — the distro
  only autostarts agents for MATE/XFCE/Cinnamon. The i3 config starts
  `polkit-gnome-authentication-agent-1` for this reason.
- **Bitwarden** (optional): install the `.deb`, then register its polkit action so
  *Settings → Security → Unlock with system authentication* becomes available:

```shell
sudo curl -fsSL -o /usr/share/polkit-1/actions/com.bitwarden.Bitwarden.policy \
  https://raw.githubusercontent.com/bitwarden/clients/main/apps/desktop/resources/com.bitwarden.desktop.policy
```

  Unlock then flows polkit → `common-auth` → howdy; the browser extension only
  borrows the desktop app's unlock, so the desktop app has to be running.

