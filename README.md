# 百问

网页模型聚合桌面 AI 客户端（内测版）。

> 本仓库仅用于发布安装包，不含源代码。

## 下载

前往 [Releases](https://github.com/harry-zhangkai/baiwen/releases) 页面，按平台下载：

| 平台 | 文件 |
|---|---|
| macOS（Apple Silicon） | `baiwen-*-mac-arm64.dmg` |
| macOS（Intel） | `baiwen-*-mac-x64.dmg` |
| Windows x64 | `baiwen-*-win-x64-setup.exe` |

## macOS 安装提示

若打开时提示 **「“百问”已损坏，无法打开」**，这是 macOS 对未签名应用的拦截（应用本身没有问题），任选其一：

- 终端执行一次：`xattr -cr /Applications/百问.app`，之后正常打开；
- 或改用命令行下载安装包（这种方式不带隔离标记，装好直接能开）：

  ```bash
  curl -L -o baiwen.dmg https://github.com/harry-zhangkai/baiwen/releases/download/v0.1.0/baiwen-0.1.0-mac-arm64.dmg
  ```
