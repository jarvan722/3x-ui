# 3X-UI 中文增强版

基于官方 MHSanaei/3x-ui 的中文增强分支。

## 特点

- 使用官方 3X-UI Release 二进制，保持官方核心功能。
- Web 面板继续使用官方内置简体中文。
- `x-ui` 本身就是中文管理命令，不是额外的 `x-ui-zh` 包装器。
- 主菜单及 SSL、Cloudflare、IP 限制、防火墙、SSH 转发、PostgreSQL、BBR、Geo、测速等子菜单中文化。
- 更新后自动重新安装本仓库的中文 `x-ui` 管理脚本。
- 保留上游 GPL-3.0 许可证与归属。

## 一键安装

```bash
bash <(curl -Ls https://raw.githubusercontent.com/jarvan722/3x-ui/main/install.sh)
```

安装完成后直接执行：

```bash
x-ui
```

## 指定版本

```bash
bash <(curl -Ls https://raw.githubusercontent.com/jarvan722/3x-ui/main/install.sh) v3.7.0
```

## 更新

```bash
x-ui update
```

## 上游

官方项目：MHSanaei/3x-ui

本项目：jarvan722/3x-ui

License：GPL-3.0
