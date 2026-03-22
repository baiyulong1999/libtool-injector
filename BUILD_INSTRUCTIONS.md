# LibTool Injector 模块构建说明

由于当前环境限制，无法直接在Windows上构建Android项目，以下是几种构建方案：

## 方案一：使用Android Studio（推荐）

### 在Windows上安装Android Studio
1. 下载Android Studio安装包：
   - 访问 https://developer.android.com/studio
   - 下载最新的Windows版本

2. 安装Android Studio
   - 将其安装到D:\AndroidStudio目录
   - 安装时确保勾选以下组件：
     * Android SDK
     * Android SDK Platform-Tools
     * Android SDK Build-Tools
     * Android Virtual Device

3. 构建项目
   - 打开Android Studio
   - 选择 "Open an existing Android Studio project"
   - 导航到 C:\Users\Administrator\Desktop\龙虾用\libtool-injector 目录
   - 等待项目同步完成
   - 点击菜单 "Build" -> "Build Bundle(s) / APK(s)" -> "Build APK(s)"
   - 构建完成后，点击 "locate" 链接找到生成的APK文件

## 方案二：使用命令行工具

如果您有Android SDK环境，可以在项目目录下运行：

```bash
# 设置环境变量
export ANDROID_HOME=/path/to/android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# 构建项目
./gradlew assembleRelease
```

## 方案三：使用在线构建服务

1. 将项目上传到GitHub
2. 使用GitHub Actions进行构建
3. 在项目根目录添加 `.github/workflows/build.yml` 文件：

```yaml
name: Build APK

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: Setup JDK 11
      uses: actions/setup-java@v2
      with:
        distribution: 'temurin'
        java-version: '11'

    - name: Grant execute permission for gradlew
      run: chmod +x gradlew

    - name: Build APK
      run: ./gradlew assembleRelease

    - name: Upload APK
      uses: actions/upload-artifact@v2
      with:
        name: app-release
        path: app/build/outputs/apk/release/app-release.apk
```

## 方案四：使用Docker构建

如果您有Docker环境，可以使用以下命令：

```bash
# 拉取Android构建镜像
docker pull reactnativecommunity/react-native-android

# 运行构建容器
docker run -it -v $(pwd):/project reactnativecommunity/react-native-android bash

# 在容器内构建
cd /project
./gradlew assembleRelease
```

## 重要提醒

- 在构建前，请确认libTool.so文件已放置在正确位置
- 确认AndroidManifest.xml中的包名是正确的(com.superplanet.evilhunter)
- 检查xposed_init文件指向正确的Hook类
- Release版本的APK通常位于 build/outputs/apk/release/ 目录下

## 模块安装步骤

1. 将生成的APK安装到Android设备
2. 打开LSPosed管理器
3. 启用LibTool Injector模块
4. 重启设备
5. 在LSPosed中确认模块已激活到目标应用(com.superplanet.evilhunter)

## 故障排除

如果模块无法正常工作：
1. 检查LSPosed日志
2. 确认目标游戏包名正确
3. 验证libTool.so文件完整性
4. 确保LSPosed框架版本兼容