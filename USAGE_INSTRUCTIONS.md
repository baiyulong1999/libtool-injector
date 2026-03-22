# LibTool Injector 使用说明

## 模块概述
这是一个LSPosed模块，用于将libTool.so动态注入到《猎魔村物语》(com.superplanet.evilhunter)游戏中。

## 安装步骤

### 第一步：构建模块
1. 确保您的电脑已安装Android Studio或Gradle
2. 双击运行 `build_apk.bat` 脚本构建模块
3. 构建完成后，APK文件将生成在 `build/outputs/apk/release/` 目录中

### 第二步：安装到Android设备
1. 将生成的APK文件传输到Android设备
2. 使用文件管理器安装APK文件

### 第三步：在LSPosed中启用模块
1. 打开LSPosed管理器应用
2. 点击"模块"标签页
3. 找到"LibTool Injector"模块并点击
4. 点击"启用"按钮
5. 在弹出的对话框中选择目标应用："com.superplanet.evilhunter"
6. 返回主界面，点击"软重启"或重启设备

### 第四步：验证模块是否生效
1. 打开LSPosed管理器
2. 查看"日志"页面，观察是否有相关日志输出
3. 启动《猎魔村物语》游戏，如果模块正常工作，应该能看到相关注入成功的日志

## 故障排除

### 模块不生效
- 确认LSPosed框架已正确安装并激活
- 确认模块已在LSPosed中启用
- 确认已将"com.superplanet.evilhunter"添加到模块的作用域中
- 重启设备后再试

### 游戏崩溃
- 某些游戏版本可能存在兼容性问题
- 尝试关闭游戏的完整性验证
- 检查libTool.so是否与设备架构匹配

### 库加载失败
- 确认 `/sdcard/龙虾用/libTool.so` 文件存在且完整
- 检查文件权限是否正确
- 查看LSPosed日志获取详细错误信息

## 验证方法

模块正常工作时，会在LSPosed日志中看到类似信息：
```
LibTool Injector: Hooking into com.superplanet.evilhunter
LibTool Injector: Successfully injected libTool.so into com.superplanet.evilhunter
```

## 注意事项

- 使用此模块需要已root的Android设备
- 需要LSPosed框架支持（不是普通的Xposed）
- 请确保libTool.so文件与目标设备的CPU架构匹配
- 某些安全软件可能会阻止模块运行
- 使用此模块可能违反游戏服务条款，请谨慎使用