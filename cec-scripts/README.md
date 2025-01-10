# Systemd CEC (Ubuntu)


Scripts to control CEC suspend and wakeup along with systemd suspend and wakeup


## Deployment
Copy scripts to following places

```
/usr/local/bin/scripts/cec-suspend.sh
/usr/local/bin/scripts/cec-wakeup.sh
```
And the service files to 
```
/etc/systemd/system/cec-suspend.service
/etc/systemd/system/cec-wakeup.service
```
