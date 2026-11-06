#!/bin/bash
# Howdy live self-test: look at the camera while it runs.
# Prints the dlib distance for each attempt so you can tell "wrong" from "close".
# Run with:  sudo ~/personal/scripts/howdy-verify.sh
set -uo pipefail
export LC_ALL=C.UTF-8

CFG=/etc/howdy/config.ini
[ "$(id -u)" -eq 0 ] || { echo "run me with sudo:  sudo $0"; exit 1; }
[ -f "$CFG" ] || { echo "no $CFG - has howdy been configured?"; exit 1; }

HOWDY_DIR=$(dirname "$(ls -1 /usr/lib/*/howdy/compare.py 2>/dev/null | head -1)")
[ -n "$HOWDY_DIR" ] || { echo "cannot find howdy's compare.py (is howdy installed?)"; exit 1; }

restore() {
	# put the original config back, but drop the laptop-lid probe for desktops
	[ -f "$CFG.testbak" ] && mv -f "$CFG.testbak" "$CFG"
	sed -i 's/^abort_if_lid_closed = true/abort_if_lid_closed = false/' "$CFG"
}
trap restore EXIT

cp -a "$CFG" "$CFG.testbak"
sed -i 's/^end_report = false/end_report = true/' "$CFG"

user=${SUDO_USER:-$(logname 2>/dev/null || id -un)}

echo ">>> Look straight at the camera <<<"
sleep 2

cd "$HOWDY_DIR" || exit 1
for i in 1 2 3; do
	echo "--- attempt $i ---"
	out=$(timeout 60 python3 compare.py "$user" 2>&1)
	rc=$?
	echo "$out" | tail -10 | sed 's/^/  /'
	echo "  rc=$rc  (0=MATCH, 11=timeout, 12=no camera, 13=too dark)"
	echo "$out" | grep -o "Best certainty value: [0-9.]*" | head -1 | sed 's/^/  /'
	[ "$rc" -eq 0 ] && break
	sleep 1
done

cat <<'EOF'

How to read this:
  rc=0                  -> face auth works; the real path is what PAM uses
  rc=11 + distance 3.6+ -> borderline: howdy set certainty 4.5  (default 3.5)
  rc=11 + no distance   -> face not detected: lighting, angle, or camera busy
  rc=13                 -> too dark: raise dark_threshold in the config
  rc=12                 -> camera not found: check the USB cable / device_path
EOF
