@echo off
echo 正在构建 LibTool Injector 模块 APK...

REM 检查是否安装了gradle
where gradle >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo 错误: 未找到Gradle，请先安装Gradle或Android Studio
    pause
    exit /b 1
)

REM 构建release版本
echo 开始构建...
gradle assembleRelease

if %ERRORLEVEL% equ 0 (
    echo.
    echo 构建成功！
    echo APK文件位置: build\outputs\apk\release\
    dir build\outputs\apk\release\
    echo.
    echo 请将生成的APK文件安装到您的Android设备上
    echo 然后在LSPosed管理器中启用该模块并重启设备
) else (
    echo 构建失败，请检查错误信息
)

pause