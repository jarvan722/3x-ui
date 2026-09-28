#!/bin/bash
set -euo pipefail

red='\\033[0;31m'; green='\\033[0;32m'; yellow='\\033[0;33m'; plain='\\033[0m'
[[ $EUID -ne 0 ]] && { echo -e "${red}错误：请使用 root 权限运行此脚本。${plain}"; exit 1; }

arch() {
  case "$(uname -m)" in
    x86_64|x64|amd64) echo amd64;; i*86|x86) echo 386;; armv8*|armv8|arm64|aarch64) echo arm64;; armv7*|armv7|arm) echo armv7;; armv6*|armv6) echo armv6;; armv5*|armv5) echo armv5;; s390x) echo s390x;;
    *) echo -e "${red}错误：不支持的 CPU 架构。${plain}"; exit 1;;
  esac
}
release="$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/MHSanaei/3x-ui/releases/latest | sed -E 's#.*/tag/([^/]+).*#\1#')"
[[ -z "$release" || "$release" == "https://github.com/MHSanaei/3x-ui/releases/latest" ]] && { echo -e "${red}错误：无法获取 3X-UI 最新版本，请检查网络。${plain}"; exit 1; }
[[ -n "${1:-}" ]] && release="$1"
A="$(arch)"; tmp="/tmp/3x-ui-$$"; mkdir -p "$tmp"; trap 'rm -rf "$tmp"' EXIT
url="https://github.com/MHSanaei/3x-ui/releases/download/${release}/x-ui-linux-${A}.tar.gz"
echo -e "${green}正在安装 3X-UI ${release}（架构：${A}）……${plain}"
curl -fL --retry 5 --connect-timeout 15 -o "$tmp/x-ui.tar.gz" "$url"
rm -rf /usr/local/x-ui; mkdir -p /usr/local; tar -xzf "$tmp/x-ui.tar.gz" -C /usr/local
chmod +x /usr/local/x-ui/x-ui /usr/local/x-ui/bin/xray-linux-* /usr/local/x-ui/x-ui.sh 2>/dev/null || true
if [[ -f /usr/local/x-ui/x-ui.service ]]; then cp -f /usr/local/x-ui/x-ui.service /etc/systemd/system/x-ui.service; elif [[ -f /usr/local/x-ui/x-ui.service.debian ]]; then cp -f /usr/local/x-ui/x-ui.service.debian /etc/systemd/system/x-ui.service; fi
curl -fL --retry 5 -o /usr/bin/x-ui https://raw.githubusercontent.com/jarvan722/3x-ui/main/x-ui.sh
chmod +x /usr/bin/x-ui
systemctl daemon-reload; systemctl enable x-ui >/dev/null 2>&1 || true; systemctl restart x-ui
echo; echo -e "${green}============================================${plain}"; echo -e "${green}  3X-UI 中文增强版安装完成${plain}"; echo -e "${green}  管理命令：x-ui${plain}"; echo -e "${green}  输入 x-ui 即可打开全中文管理菜单${plain}"; echo -e "${green}============================================${plain}"; echo
/usr/bin/x-ui settings 2>/dev/null || true
