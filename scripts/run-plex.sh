docker run -d \
  --name=plex \
  -p 32400:32400 \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Australia/Melbourne \
  -e VERSION=docker \
  -v /mnt/8tb/library:/config \
  -v /mnt/8tb/tv-series:/tv \
  -v /mnt/8tb/movies:/movies \
  -v /mnt/8tb/torrents:/torrents \
  --restart unless-stopped \
  lscr.io/linuxserver/plex:latest
