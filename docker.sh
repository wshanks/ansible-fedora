mkdir -p $HOME/.local/docker/bin
# STABLE_LATEST="24.0.7"
STABLE_LATEST="$(curl https://download.docker.com/linux/static/stable/x86_64/ | grep -P -o 'href="docker-(\d.*)\.tgz"' | sed 's/.*docker-\(.*\)\.tgz.*/\1/' | sort | tail -1)"
curl -L \
    -o docker.tgz \
    "https://download.docker.com/linux/static/stable/x86_64/docker-${STABLE_LATEST}.tgz" | \
    tar -C $HOME/.local/docker/bin --strip-components=1 xf docker.tgz
curl -L \
    -o rootless.tgz \
    "https://download.docker.com/linux/static/stable/x86_64/docker-rootless-extras-${STABLE_LATEST}.tgz" | \
    tar -C $HOME/.local/docker/bin --strip-components=1 xf rootless.tgz



unit_file="${HOME}/.config/systemd/user/docker.service"
BIN="${HOME}/.local/docker/bin"
cat <<- EOT > "${unit_file}"
    [Unit]
    Description=Docker Application Container Engine (Rootless)
    Documentation=https://docs.docker.com/go/rootless/

    [Service]
    Environment=PATH=$BIN:/sbin:/usr/sbin:$PATH
    ExecStart=$BIN/dockerd-rootless.sh
    ExecReload=/bin/kill -s HUP \$MAINPID
    TimeoutSec=0
    RestartSec=2
    Restart=always
    StartLimitBurst=3
    StartLimitInterval=60s
    LimitNOFILE=infinity
    LimitNPROC=infinity
    LimitCORE=infinity
    TasksMax=infinity
    Delegate=yes
    Type=notify
    NotifyAccess=all
    KillMode=mixed

    [Install]
    WantedBy=default.target
EOT
systemctl --user enable --now docker.service
