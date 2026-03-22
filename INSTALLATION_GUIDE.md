# LibTool Injector 模块安装与使用指南

## 概述
这是一个LSPosed模块，用于将libTool.so动态注入到目标游戏中。该模块会自动检测指定的游戏包名并在游戏启动时注入native库。

## 安装前准备

1. 确保您的Android设备已root
2. 已安装LSPosed框架
3. 已准备好目标游戏的包名（如 com.game.hunter_village）
4. 确保libTool.so文件位于 `/sdcard/龙虾用/libTool.so`

## 安装步骤

### 方法一：直接安装APK模块（推荐）

1. 使用Android Studio或命令行构建模块：
   ```bash
   cd /path/to/libtool-injector
   ./gradlew assembleRelease
   ```

2. 在LSPosed管理器中安装生成的APK文件

3. 编辑AndroidManifest.xml文件，将其中的`com.game.target`替换为目标游戏的实际包名

4. 重启设备使模块生效

### 方法二：手动配置

1. 将整个libtool-injector文件夹推送至Android设备
2. 修改module_config.json中的目标包名
3. 确保libTool.so文件存在于指定路径
4. 在LSPosed中启用模块并重启

## 配置说明

### 目标游戏包名设置
编辑AndroidManifest.xml文件中的以下部分：
```xml
<meta-data
    android:name="xposedscope"
    android:value="com.game.target" />
```
将`com.game.target`替换为实际的游戏包名。

常见获取游戏包名的方法：
- 使用ADB命令: `adb shell pm list packages | grep [游戏名称关键词]`
- 使用第三方应用市场查看
- 在手机设置的应用管理中查找

### 库文件路径
默认情况下，模块会从以下路径查找libTool.so：
- `/sdcard/龙虾用/libTool.so`

如果需要更改路径，请修改MainHook.java中的EXTERNAL_LIB_PATH常量。

## 故障排除

### 模块未生效
1. 检查LSPosed是否已正确安装并激活
2. 确认模块已在LSPosed中启用
3. 检查目标游戏包名是否正确
4. 重启设备

### 库加载失败
1. 确认libTool.so文件存在且完整
2. 检查文件权限是否正确
3. 查看Xposed日志以获取详细错误信息

### 游戏崩溃
1. 某些游戏可能有防修改机制
2. 尝试关闭游戏的完整性验证功能
3. 检查libTool.so是否与目标架构匹配（arm64-v8a, armeabi-v7a等）

## 注意事项

- 使用此模块可能违反游戏的服务条款，请谨慎使用
- 确保备份原始游戏数据
- 仅在合法授权的测试环境中使用
- 某些游戏可能会检测到Xposed模块并限制功能

## 日志查看

可通过以下方式查看模块运行状态：
```bash
adb logcat | grep "LibTool-Injector"
```

## 技术原理

该模块基于Xposed框架，在目标应用的Application.onCreate()方法执行时，
将libTool.so动态加载到进程中，从而实现对游戏行为的修改。