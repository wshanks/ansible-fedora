#!/bin/bash
defaults="roles/host/defaults/main.yml"
if [[ ! -f "$defaults" ]]; then
    echo "Could not find defaults file ($defaults). Wrong working directory?" >&2
    exit 1
fi

read -r -d '' PYCODE <<'EOF'
import json
import re
import sys

releases = json.loads(sys.stdin.read())
releases = [r['tag_name'][1:] for r in releases if re.match('v[\d+\.]+$', r['tag_name'])]
release = max(releases, key=lambda x: tuple(int(p) for p in x.split('.')))
print(release)
EOF

docker_version="$(curl -L https://api.github.com/repos/moby/moby/releases | python -c "$PYCODE")"

sed -i "s/^docker_version\:.*/docker_version: '$docker_version'/" "$defaults"
echo "Docker version is ${docker_version}"
