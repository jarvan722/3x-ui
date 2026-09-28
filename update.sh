#!/bin/bash
set -euo pipefail
[[ $EUID -ne 0 ]] && { echo "错误：请使用 root 权限运行。"; exit 1; }
TAG="${XUI_UPDATE_TAG:-}"
[[ -z "$TAG" ]] && TAG="$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/MHSanaei/3x-ui/releases/latest | sed -E 's#.*/tag/([^/]+).*#\1#')"
[[ -z "$TAG" ]] && { echo "错误：无法获取最新版本。"; exit 1; }
[[ "$TAG" == "dev" ]] && TAG="dev-latest"
arch(){ case "$(uname -m)" in x86_64|x64|amd64) echo amd64;; i*86|x86) echo 386;; armv8*|armv8|arm64|aarch64) echo arm64;; armv7*|armv7|arm) echo armv7;; armv6*|armv6) echo armv6;; armv5*|armv5) echo armv5;; s390x) echo s390x;; *) echo "错误：不支持的 CPU 架构。"; exit 1;; esac; }
A="$(arch)"; tmp="/tmp/3x-ui-update-$$"; mkdir -p "$tmp"; trap 'rm -rf "$tmp"' EXIT
url="https://github.com/MHSanaei/3x-ui/releases/download/${TAG}/x-ui-linux-${A}.tar.gz"; echo "正在下载 3X-UI ${TAG}……"; curl -fL --retry 5 -o "$tmp/x-ui.tar.gz" "$url"
systemctl stop x-ui 2>/dev/null || true; rm -rf /usr/local/x-ui; mkdir -p /usr/local; tar -xzf "$tmp/x-ui.tar.gz" -C /usr/local; chmod +x /usr/local/x-ui/x-ui /usr/local/x-ui/bin/xray-linux-* /usr/local/x-ui/x-ui.sh 2>/dev/null || true
if [[ -f /usr/local/x-ui/x-ui.service ]]; then cp -f /usr/local/x-ui/x-ui.service /etc/systemd/system/x-ui.service; elif [[ -f /usr/local/x-ui/x-ui.service.debian ]]; then cp -f /usr/local/x-ui/x-ui.service.debian /etc/systemd/system/x-ui.service; fi
curl -fL --retry 5 -o /usr/bin/x-ui https://raw.githubusercontent.com/jarvan722/3x-ui/main/x-ui.sh; chmod +x /usr/bin/x-ui; systemctl daemon-reload; systemctl enable x-ui >/dev/null 2>&1 || true; systemctl restart x-ui; echo "3X-UI 更新完成，中文管理菜单已同步。"
