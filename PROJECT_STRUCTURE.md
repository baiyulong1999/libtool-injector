# LibTool Injector 项目结构

```
libtool-injector/
├── src/
│   └── main/
│       ├── java/me/miku/libtool/hook/
│       │   ├── MainHook.java          # 主要的Hook入口点
│       │   └── NativeHook.java        # Native库注入逻辑
│       └── AndroidManifest.xml       # Android应用配置
├── assets/                           # 可选：用于打包libTool.so
│   └── libTool.so
├── libs/                             # 可选：依赖库
├── build.gradle                      # Gradle构建脚本
├── settings.gradle                   # Gradle项目设置
├── gradle.properties                 # Gradle属性配置
├── xposed_init                       # Xposed模块初始化文件
├── module_config.json                # 模块配置文件
├── README.md                         # 基本使用说明
├── INSTALLATION_GUIDE.md             # 详细安装指南
├── PROJECT_STRUCTURE.md              # 当前文件
└── libTool.so                        # 待注入的原生库文件
```

## 关键文件说明

### MainHook.java
- Xposed模块的主要入口点
- 负责检测目标应用并注入libTool.so
- 包含错误处理和日志记录

### AndroidManifest.xml
- 定义模块的基本信息
- 配置Xposed相关元数据
- 设置目标应用范围

### xposed_init
- 指定Xposed模块的入口类
- 内容为: `me.miku.libtool.hook.MainHook`

### module_config.json
- 模块配置参数
- 包含目标包名、库路径等信息

## 构建说明

要将此项目构建为APK模块:

1. 确保已安装Android SDK和Gradle
2. 设置ANDROID_HOME环境变量
3. 运行以下命令:
   ```
   ./gradlew assembleRelease
   ```
4. 在build/outputs/apk/目录下获取最终的模块APK

## 部署说明

1. 将生成的APK安装到已root的Android设备
2. 在LSPosed管理器中启用模块
3. 重启设备使模块生效
4. 根据需要修改AndroidManifest.xml中的目标包名

## 维护说明

如需更新libTool.so:
1. 替换项目根目录下的libTool.so文件
2. 重新构建APK
3. 更新设备上的模块