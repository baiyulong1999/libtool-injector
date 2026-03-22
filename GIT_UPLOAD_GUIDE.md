# Git上传项目到GitHub详细指南

## 准备工作
首先，您需要安装Git工具：
1. 访问 https://git-scm.com/download/win
2. 下载并安装Git for Windows
3. 安装完成后重启命令提示符

## 步骤2：上传项目文件到GitHub

### 1. 打开命令提示符（CMD）
按Win+R，输入cmd，然后回车

### 2. 导航到项目目录
```cmd
cd /d "C:\Users\Administrator\Desktop\龙虾用\libtool-injector"
```

### 3. 初始化Git仓库
```cmd
git init
```

### 4. 添加所有文件到暂存区
```cmd
git add .
```

### 5. 创建初始提交
```cmd
git commit -m "Initial commit with LSPosed module code"
```

### 6. 添加远程仓库地址
将下方URL替换成您创建的GitHub仓库地址：
```cmd
git remote add origin https://github.com/您的用户名/您的仓库名.git
```

例如，如果您的用户名是"testuser"，仓库名是"libtool-injector-module"：
```cmd
git remote add origin https://github.com/testuser/libtool-injector-module.git
```

### 7. 推送代码到GitHub
```cmd
git branch -M main
git push -u origin main
```

如果出现认证错误，您可能需要：
- 使用个人访问令牌代替密码（推荐）
- 或者使用SSH密钥认证

## 步骤3：创建GitHub Actions工作流文件

有两种方法可以创建工作流文件：

### 方法一：使用网页端（推荐）

1. 登录GitHub并进入您的仓库
2. 点击仓库页面上方的 "Add file" 下拉菜单
3. 选择 "New file"
4. 文件名输入：`.github/workflows/build.yml`
   注意：必须以 `.github/workflows/` 开头
5. 在内容区域粘贴以下内容：

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

    - name: Setup Android SDK
      uses: android-actions/setup-android@v2
      with:
        packages: tools platform-tools build-tools-34.0.0 platforms-android-34
        
    - name: Create standard Android project structure
      run: |
        mkdir -p app/src/main/java/me/miku/libtool/hook
        mkdir -p app/src/main/res/values
        
    - name: Copy source files to correct location
      run: |
        # Copy Java files
        cp -r src/main/java/me/miku/libtool/hook/*.java app/src/main/java/me/miku/libtool/hook/
        
        # Create basic res/values/strings.xml
        mkdir -p app/src/main/res/values
        echo '<?xml version="1.0" encoding="utf-8"?>' > app/src/main/res/values/strings.xml
        echo '<resources>' >> app/src/main/res/values/strings.xml
        echo '    <string name="app_name">LibTool Injector</string>' >> app/src/main/res/values/strings.xml
        echo '</resources>' >> app/src/main/res/values/strings.xml
        
        # Create basic layout file
        mkdir -p app/src/main/res/layout
        touch app/src/main/res/layout/activity_main.xml
        
    - name: Create app/build.gradle
      run: |
        cat > app/build.gradle << 'EOF'
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
EOF

    - name: Create app/src/main/AndroidManifest.xml
      run: |
        cat > app/src/main/AndroidManifest.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="me.miku.libtool.injector">

    <application
        android:label="LibTool Injector"
        android:icon="@mipmap/ic_launcher">
        
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        
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
EOF

    - name: Create gradle.properties
      run: |
        cat > gradle.properties << 'EOF'
// Project-wide Gradle settings.
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
android.enableJetifier=true
EOF

    - name: Create settings.gradle
      run: |
        cat > settings.gradle << 'EOF'
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
EOF

    - name: Grant execute permission for gradlew
      run: chmod +x gradlew || true

    - name: Build Debug APK
      run: |
        export ANDROID_HOME=$ANDROID_SDK_ROOT
        if [ -f "./gradlew" ]; then
          ./gradlew assembleDebug
        else
          echo "gradlew not found, using standard gradle"
          gradle assembleDebug
        fi

    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: libtool-injector-debug-apk
        path: app/build/outputs/apk/debug/app-debug.apk
EOF

6. 在页面底部，点击 "Commit new file" 按钮

### 方法二：使用命令行

如果您更喜欢使用命令行，可以按以下步骤操作：

1. 在本地项目目录中创建工作流目录：
```cmd
mkdir -p .github\workflows
```

2. 创建build.yml文件：
```cmd
notepad .github\workflows\build.yml
```

3. 在打开的记事本中粘贴上面的YAML内容，然后保存并关闭

4. 提交并推送工作流文件：
```cmd
git add .github/workflows/build.yml
git commit -m "Add GitHub Actions workflow"
git push origin main
```

## 验证上传是否成功

1. 刷新GitHub仓库页面
2. 您应该能看到所有项目文件都已上传
3. 在仓库根目录应该能看到 `.github` 文件夹（可能需要刷新页面）
4. 点击仓库顶部的 "Actions" 标签页，应该能看到工作流已就绪

## 触发构建

当您推送包含工作流文件的提交后，GitHub Actions会自动触发构建。您也可以手动触发：

1. 点击仓库顶部的 "Actions" 标签页
2. 在左侧选择 "Build LSPosed Module APK" 工作流
3. 点击 "Run workflow" 按钮

构建通常需要3-5分钟完成，完成后您可以在 "Artifacts" 部分下载构建好的APK文件。