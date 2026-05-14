# Nusgmon Alert - Data Usage Alert

#### A simple Linux bash script for `cron` to send data usage alert notifications (download/upload), for both X11 & Wayland.

### Dependencies

- [nusgmon](https://github.com/LUCKYS1NGHH/nusgmon) — records data usage (MUST)
- [libnotify](https://gitlab.gnome.org/GNOME/libnotify) — provides `notify-send` (possibly already installed)

---

### Install

```bash
git clone --depth=1 https://github.com/LUCKYS1NGHH/nusgmon-alert.sh
cd nusgmon-alert.sh
sudo cp nusgmon-alert.sh /usr/local/bin/nusgmon-alert.sh
sudo chmod +x /usr/local/bin/nusgmon-alert.sh
mkdir -p ~/.local/share/nusgmon-alert
cp -r icons ~/.local/share/nusgmon-alert
```

### Cronjob setup
`crontab -e`

> [!NOTE]
> First arg: `down` (default) or `up`
>
> Second arg: `MB` (default) or `GB`

```bash
# check download every 2 min (default)
*/2 * * * * /usr/local/bin/nusgmon-alert.sh

# check upload in GB every 2 min
*/2 * * * * /usr/local/bin/nusgmon-alert.sh up
```

---

### Reporting issues

If you are facing any issue with it, Please open GitHub issue with relevant details.
