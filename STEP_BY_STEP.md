# 上传到GitHub并构建模块 - 逐步指南

## 第一步：在GitHub上创建仓库
1. 访问 https://github.com 并登录
2. 点击右上角的 "+" 号，选择 "New repository"
3. 输入仓库名称，如 "libtool-injector-module"
4. 选择 "Public" 或 "Private"
5. 不要勾选 "Initialize this repository with a README"
6. 点击 "Create repository"

## 第二步：上传项目到GitHub
双击运行 "upload_to_github.bat" 文件
1. 当提示输入仓库URL时，输入您刚创建的仓库地址
   例如：https://github.com/您的用户名/libtool-injector-module.git
2. 脚本将自动完成上传过程

## 第三步：在GitHub上创建Actions工作流
上传完成后，请按以下步骤操作：

1. 访问您的GitHub仓库
2. 点击 "Add file" -> "New file"
3. 文件名输入：`.github/workflows/build.yml`
4. 粘贴以下内容：

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
        cache: gradle

    - name: Setup Android SDK
      uses: android-actions/setup-android@v2
      with:
        packages: tools platform-tools build-tools-34.0.0 platforms-android-34
        
    - name: Build Debug APK
      run: |
        export ANDROID_HOME=$ANDROID_SDK_ROOT
        ./gradlew assembleDebug

    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: libtool-injector-debug-apk
        path: app/build/outputs/apk/debug/app-debug.apk
```

5. 点击 "Commit new file"

## 第四步：触发构建
1. 提交工作流文件后，GitHub会自动触发构建
2. 点击仓库顶部的 "Actions" 标签页查看构建进度
3. 构建完成后，可在 "Artifacts" 中下载APK

## 第五步：安装和使用
1. 下载构建好的APK文件
2. 安装到Android设备
3. 在LSPosed管理器中启用模块
4. 重启设备
5. 启动《猎魔村物语》享受增强功能