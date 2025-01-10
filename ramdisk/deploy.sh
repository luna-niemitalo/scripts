cp restore-ramdisk.service ~/.config/systemd/user/
cp sync-ramdisk.service ~/.config/systemd/user/
cp watch-and-sync.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable restore-ramdisk.service
systemctl --user enable sync-ramdisk.service
systemctl --user enable watch-and-sync.service

chmod +x restore_ramdisk.sh
chmod +x sync_ramdisk.sh
chmod +x watch_and_sync.sh
