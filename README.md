### Install latest docker for Debian 12

```bash
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove $pkg; done
apt-get update --yes && apt-get install ca-certificates curl --yes
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update --yes
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin --yes

```

### Copy group policy

```bash
cp etc/docker/daemon.json /etc/docker/daemon.json
systemctl restart docker
```

### Run

```bash
docker compose up --build -d
```

### Check status after running

```bash
docker exec -it systemd systemctl status entrypoint
```

```
● entrypoint.service - Post-entrypoint Script
     Loaded: loaded (/etc/systemd/system/entrypoint.service; enabled; preset: enabled)
     Active: active (exited) since Mon 2025-01-27 19:36:55 UTC; 20s ago
    Process: 37 ExecStart=/entrypoint.sh (code=exited, status=0/SUCCESS)
   Main PID: 37 (code=exited, status=0/SUCCESS)

Jan 27 19:36:55 e116e8eab55f systemd[1]: Starting entrypoint.service - Post-entrypoint Script...
Jan 27 19:36:55 e116e8eab55f entrypoint.sh[37]: Some installations
Jan 27 19:36:55 e116e8eab55f entrypoint.sh[37]: Entrypoint successfull init
Jan 27 19:36:55 e116e8eab55f entrypoint.sh[37]: Entrypoint already init
Jan 27 19:36:55 e116e8eab55f entrypoint.sh[37]: Add running what you want after this
Jan 27 19:36:55 e116e8eab55f systemd[1]: entrypoint.service: Child 37 belongs to entrypoint.service.
Jan 27 19:36:55 e116e8eab55f systemd[1]: entrypoint.service: Main process exited, code=exited, status=0/SUCCESS (success)
Jan 27 19:36:55 e116e8eab55f systemd[1]: entrypoint.service: Changed start -> exited
Jan 27 19:36:55 e116e8eab55f systemd[1]: entrypoint.service: Job 56 entrypoint.service/start finished, result=done
Jan 27 19:36:55 e116e8eab55f systemd[1]: Finished entrypoint.service - Post-entrypoint Script.
```

We see

```
Jan 27 19:36:55 e116e8eab55f entrypoint.sh[37]: Some installations
Jan 27 19:36:55 e116e8eab55f entrypoint.sh[37]: Entrypoint successfull init
Jan 27 19:36:55 e116e8eab55f entrypoint.sh[37]: Entrypoint already init
Jan 27 19:36:55 e116e8eab55f entrypoint.sh[37]: Add running what you want after this
```

### Restart compose

```bash
docker compose restart
docker exec -it systemd systemctl status entrypoint
```

```
● entrypoint.service - Post-entrypoint Script
     Loaded: loaded (/etc/systemd/system/entrypoint.service; enabled; preset: enabled)
     Active: active (exited) since Mon 2025-01-27 19:40:28 UTC; 12s ago
    Process: 37 ExecStart=/entrypoint.sh (code=exited, status=0/SUCCESS)
   Main PID: 37 (code=exited, status=0/SUCCESS)

Jan 27 19:40:28 8d67a2979217 systemd[1]: entrypoint.service: Changed dead -> start
Jan 27 19:40:28 8d67a2979217 systemd[1]: Starting entrypoint.service - Post-entrypoint Script...
Jan 27 19:40:28 8d67a2979217 (point.sh)[37]: entrypoint.service: Executing: /entrypoint.sh
Jan 27 19:40:28 8d67a2979217 entrypoint.sh[37]: Entrypoint already init
Jan 27 19:40:28 8d67a2979217 entrypoint.sh[37]: Add running what you want after this
Jan 27 19:40:28 8d67a2979217 systemd[1]: entrypoint.service: Child 37 belongs to entrypoint.service.
Jan 27 19:40:28 8d67a2979217 systemd[1]: entrypoint.service: Main process exited, code=exited, status=0/SUCCESS (success)
Jan 27 19:40:28 8d67a2979217 systemd[1]: entrypoint.service: Changed start -> exited
Jan 27 19:40:28 8d67a2979217 systemd[1]: entrypoint.service: Job 56 entrypoint.service/start finished, result=done
Jan 27 19:40:28 8d67a2979217 systemd[1]: Finished entrypoint.service - Post-entrypoint Script.
```

```
Jan 27 19:40:28 8d67a2979217 entrypoint.sh[37]: Entrypoint already init
Jan 27 19:40:28 8d67a2979217 entrypoint.sh[37]: Add running what you want after this
```

Installation already do in previous step

### Customization

Change ./entrypoint.sh

```bash
#!/bin/bash
if [ ! -f "/ok" ]; then
     # INSTALL IN THIS WHAT NEED SYSTEMD IN INSTALLATION
     echo "Some installations" && \
     touch /ok && \
     echo "Entrypoint successfull init"
fi
echo "Entrypoint already init"
echo "Add running what you want after this"
# RUN YOU CUSTOM PROCESS WITHOUT SYSTEMD
```
