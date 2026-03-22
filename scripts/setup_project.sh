#!/bin/bash

# Create project structure
mkdir -p app/src/main/java/me/miku/libtool/hook
mkdir -p app/src/main/res/values
mkdir -p app/src/main/res/layout

# Create MainHook.java
cat > app/src/main/java/me/miku/libtool/hook/MainHook.java << 'EOF_JAVA'
package me.miku.libtool.hook;

import android.util.Log;
import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

public class MainHook implements IXposedHookLoadPackage {
    private static final String TAG = "LibTool-Injector";
    
    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) throws Throwable {
        if (!lpparam.packageName.equals("com.superplanet.evilhunter")) {
            return;
        }
        
        Log.d(TAG, "Hooking into target app: " + lpparam.packageName);
        
        XposedHelpers.findAndHookMethod("android.app.Application", lpparam.classLoader, 
            "onCreate", new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(XC_MethodHook.MethodHookParam param) throws Throwable {
                    Log.d(TAG, "Application onCreate called, injection logic would go here");
                    
                    // Actual injection code would go here
                    try {
                        // Load the native library
                        System.loadLibrary("tool");
                        Log.d(TAG, "Successfully loaded native library");
                    } catch (UnsatisfiedLinkError e) {
                        Log.e(TAG, "Failed to load native library: " + e.getMessage());
                    }
                }
            });
    }
}
EOF_JAVA

# Create AndroidManifest.xml
cat > app/src/main/AndroidManifest.xml << 'EOF_MANIFEST'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="me.miku.libtool.injector">

    <application
        android:label="LibTool Injector"
        android:icon="@mipmap/ic_launcher">
        
        <activity
            android:name="androidx.appcompat.app.AppCompatActivity"
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
EOF_MANIFEST

# Create app-level build.gradle
cat > app/build.gradle << 'EOF_GRADLE'
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
        debug {
            minifyEnabled false
            signingConfig signingConfigs.debug
        }
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            signingConfig signingConfigs.debug
        }
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    compileOnly 'de.robv.android.xposed:api:82'
}
EOF_GRADLE

# Create root build.gradle
cat > build.gradle << 'EOF_ROOT'
plugins {
    id 'com.android.application' version '7.4.2' apply false
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
EOF_ROOT

# Create gradle.properties
cat > gradle.properties << 'EOF_PROP'
// Project-wide Gradle settings.
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
android.enableJetifier=true
EOF_PROP

# Create settings.gradle
cat > settings.gradle << 'EOF_SETTINGS'
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
    }
}
rootProject.name = "LibTool Injector"
include ':app'
EOF_SETTINGS

# Create basic res files
mkdir -p app/src/main/res/values
cat > app/src/main/res/values/strings.xml << 'EOF_STRINGS'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">LibTool Injector</string>
</resources>
EOF_STRINGS

echo "Project setup completed successfully!"