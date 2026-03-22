# GitHub Actions 构建设置指南

## 什么是GitHub Actions？
GitHub Actions是GitHub提供的持续集成和持续部署(CI/CD)服务，可以在云端自动构建您的项目，无需在本地安装任何开发工具。

## 如何使用GitHub Actions构建LSPosed模块

### 第一步：创建GitHub仓库
1. 访问 https://github.com 并登录您的账户
2. 点击右上角的 "+" 号，选择 "New repository"
3. 输入仓库名称，例如：`libtool-injector-module`
4. 选择 "Public" 或 "Private"
5. 不要勾选 "Initialize this repository with a README"
6. 点击 "Create repository" 按钮

### 第二步：上传项目文件到GitHub
1. 安装Git（如果尚未安装）
2. 打开命令提示符，导航到项目目录：
   ```cmd
   cd C:\Users\Administrator\Desktop\龙虾用\libtool-injector
   ```

3. 初始化本地仓库：
   ```cmd
   git init
   git add .
   ```

4. 添加远程仓库地址（将下面的URL替换为您的仓库地址）：
   ```cmd
   git remote add origin https://github.com/您的用户名/libtool-injector-module.git
   ```

5. 提交并推送代码：
   ```cmd
   git commit -m "Initial commit with LSPosed module code"
   git branch -M main
   git push -u origin main
   ```

### 第三步：创建GitHub Actions工作流文件
1. 在GitHub仓库中，点击 "Add file" -> "New file"
2. 文件名输入：`.github/workflows/build.yml`
3. 在内容区域粘贴以下内容：

```yaml
name: Build LSPosed Module APK

on:
  push:
    branches: [ main ]
  pull_request:
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

    - name: Grant execute permission for gradlew
      run: chmod +x gradlew

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

4. 点击 "Commit new file" 按钮

### 第四步：调整项目结构以适配标准Android项目
由于您的项目结构稍有不同，我们需要创建一个标准的Android项目结构。在仓库根目录创建以下文件：

#### 1. 创建 app/build.gradle 文件：
```gradle
apply plugin: 'com.android.application'

android {
    compileSdk 34

    defaultConfig {
        applicationId "me.miku.libtool.injector"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0"

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}

dependencies {
    compileOnly 'de.robv.android.xposed:api:82'
    compileOnly 'de.robv.android.xposed:api:82:sources'
}
```

#### 2. 创建 app/src/main/AndroidManifest.xml 文件：
```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="me.miku.libtool.injector">

    <application
        android:label="LibTool Injector"
        android:icon="@mipmap/ic_launcher">
        
        <meta-data
            android:name="xposedmodule"
            android:value="true" />
            
        <meta-data
            android:name="xposeddescription"
            android:value="Inject libTool.so into target game" />
            
        <meta-data
            android:name="xposedminversion"
            android:value="93" />
            
        <meta-data
            android:name="xposedscope"
            android:value="com.superplanet.evilhunter" />
    </application>
</manifest>
```

#### 3. 创建 gradle.properties 文件：
```properties
// Project-wide Gradle settings.
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
android.enableJetifier=true
```

#### 4. 创建 settings.gradle 文件：
```gradle
pluginManagement {
    repositories {
        gradlePluginPortal()
        google()
        mavenCentral()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        // Xposed API repository
        maven { url 'https://api.xposed.info/' }
    }
}
rootProject.name = "LibTool Injector"
include ':app'
```

### 第五步：触发构建
1. 完成以上文件的创建后，GitHub Actions会自动触发构建
2. 点击仓库顶部的 "Actions" 标签页
3. 您可以看到正在运行或已完成的构建任务
4. 等待构建完成（通常需要3-5分钟）

### 第六步：下载构建好的APK
1. 构建完成后，在Actions页面点击最近的构建任务
2. 找到 "Artifacts" 部分
3. 点击 "libtool-injector-debug-apk" 链接下载APK文件
4. 解压下载的ZIP文件，即可获得构建好的APK

## 重要注意事项

1. **隐私保护**：如果您担心源代码公开，可以创建私有仓库
2. **libTool.so文件**：由于版权原因，不要将libTool.so文件直接上传到GitHub
3. **构建日志**：可以在Actions页面查看详细的构建日志，以便排查问题
4. **安全性**：确保您的libTool.so文件是合法获得的，并符合相关法律法规

## 故障排除

如果构建失败：
1. 检查GitHub Actions日志中的错误信息
2. 确认所有配置文件语法正确
3. 确认项目结构符合标准Android项目格式
4. 检查是否有缺失的依赖项

通过这种方式，您就可以在云端构建LSPosed模块而无需在本地安装任何开发工具。