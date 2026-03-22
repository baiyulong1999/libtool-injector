# LibTool Injector Module

这是一个LSPosed模块，用于将libTool.so动态注入到《猎魔村物语》(com.superplanet.evilhunter)游戏中。

## 功能
- 自动检测目标游戏进程 (com.superplanet.evilhunter)
- 将libTool.so库注入到目标进程中
- 提供稳定的游戏修改功能

## 技术细节
- 基于LSPosed/Xposed框架
- 使用Native Hook技术
- 支持Android 5.0-13 (API 21-33)

## 构建
使用GitHub Actions自动构建：
```yaml
name: Build LSPosed Module APK

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    
    - name: Set up JDK 11
      uses: actions/setup-java@v3
      with:
        java-version: '11'
        distribution: 'temurin'

    - name: Setup Android SDK
      uses: android-actions/setup-android@v2
      with:
        packages: tools platform-tools build-tools-34.0.0 platforms-android-34
        
    - name: Build APK
      run: |
        export ANDROID_HOME=$ANDROID_SDK_ROOT
        ./gradlew assembleDebug

    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: libtool-injector-debug-apk
        path: app/build/outputs/apk/debug/app-debug.apk
```

## 安装说明

1. 将构建好的APK安装到Android设备
2. 在LSPosed管理器中启用模块
3. 重启设备使模块生效
4. 启动《猎魔村物语》游戏即可生效

## 注意事项

- 此模块仅适用于已root的Android设备
- 需要LSPosed框架支持
- 使用此模块可能违反游戏服务条款，请谨慎使用