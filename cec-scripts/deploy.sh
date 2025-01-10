mkdir -p /usr/local/bin/scripts/
cp cec-screen.service /etc/systemd/system
cp cec-suspend.service /etc/systemd/system
cp cec-suspend.sh /usr/local/bin/scripts
cp cec-wakeup.service /etc/systemd/system
cp cec-wakeup.sh /usr/local/bin/scripts
chmod +x /usr/local/bin/scripts/cec-suspend.sh
chmod +x /usr/local/bin/scripts/cec-wakeup.sh

systemctl daemon-reload
systemctl enable cec-screen.service
systemctl enable cec-suspend.service
systemctl enable cec-wakeup.service
