# 百问

网页模型聚合桌面 AI 客户端（内测版）。

> 本仓库仅用于发布安装包，不含源代码。

## 下载安装

### macOS（Apple Silicon）

终端粘贴执行（自动下载并安装到「应用程序」，完成后自动打开；命令行下载的安装包不带隔离标记，装好直接能开）：

```bash
curl -L -o baiwen.dmg https://github.com/harry-zhangkai/baiwen/releases/download/v0.1.0/baiwen-0.1.0-mac-arm64.dmg && hdiutil attach -nobrowse -quiet baiwen.dmg && rm -rf /Applications/baiwen.app && cp -R /Volumes/baiwen*/baiwen.app /Applications/ && hdiutil detach /Volumes/baiwen* -quiet && rm baiwen.dmg && open /Applications/baiwen.app
```

### macOS（Intel）

```bash
curl -L -o baiwen.dmg https://github.com/harry-zhangkai/baiwen/releases/download/v0.1.0/baiwen-0.1.0-mac-x64.dmg && hdiutil attach -nobrowse -quiet baiwen.dmg && rm -rf /Applications/baiwen.app && cp -R /Volumes/baiwen*/baiwen.app /Applications/ && hdiutil detach /Volumes/baiwen* -quiet && rm baiwen.dmg && open /Applications/baiwen.app
```

### Windows x64

下载安装程序：[baiwen-0.1.0-win-x64-setup.exe](https://github.com/harry-zhangkai/baiwen/releases/download/v0.1.0/baiwen-0.1.0-win-x64-setup.exe)

双击运行，按提示选择安装目录，完成安装。
