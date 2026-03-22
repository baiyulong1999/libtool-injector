# 手动构建LSPosed模块指南

## 为什么需要手动构建
由于GitHub Actions环境中的Android SDK配置复杂性，自动化构建遇到了困难。手动构建是最可靠的方法。

## 使用Android Studio构建

### 第一步：安装Android Studio
1. 访问 https://developer.android.com/studio 并下载Android Studio
2. 安装Android Studio并启动

### 第二步：导入项目
1. 打开Android Studio
2. 选择 "Open an existing Android Studio project"
3. 导航到 `C:\Users\Administrator\Desktop\龙虾用\libtool-injector` 目录
4. 选择该项目并等待同步完成

### 第三步：配置项目
如果Android Studio提示缺少SDK或依赖项，按照提示安装：
1. 确保安装了Android SDK 34
2. 确保安装了build-tools 34.0.0
3. 确保项目使用Java 11或17

### 第四步：构建APK
1. 在Android Studio顶部菜单中，选择 "Build"
2. 选择 "Build Bundle(s) / APK(s)"
3. 选择 "Build APK(s)"
4. 构建完成后，点击 "locate" 链接找到APK文件

## 替代方法：使用命令行（如果已安装Android SDK）

如果您已安装Android SDK和Gradle，可以在项目目录中运行：

```bash
# 确保环境变量设置正确
export ANDROID_HOME=/path/to/android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# 构建项目
./gradlew assembleDebug
```

## 构建产物位置
构建完成后，APK文件将位于：
- `app/build/outputs/apk/debug/app-debug.apk`

## 模块安装
1. 将构建的APK安装到您的Android设备
2. 打开LSPosed Manager
3. 启用"LibTool Injector"模块
4. 重启设备
5. 模块将自动在"猎魔村物语"(com.superplanet.evilhunter)中注入libTool.so

## 注意事项
- 确保您的设备已root并安装了LSPosed框架
- 某些游戏可能会检测到Xposed模块并限制功能
- 仅在合法授权的情况下使用此模块