@echo off
echo.
echo **********************************************
echo        LSPosed模块上传到GitHub脚本
echo **********************************************
echo.

cd /d "C:\Users\Administrator\Desktop\龙虾用\libtool-injector"

echo 当前目录: %cd%
echo.

REM 检查是否在正确的目录
if not exist "MainHook.java" (
    if exist "app\src\main\java\me\miku\libtool\hook\MainHook.java" (
        echo 找到项目文件，当前目录正确
    ) else (
        echo 错误：未找到项目文件，请确保在正确的目录中
        pause
        exit /b 1
    )
)

echo.
set /p REPO_URL="请输入您的GitHub仓库URL (例如: https://github.com/用户名/仓库名.git): "

if "%REPO_URL%"=="" (
    echo 错误：未输入仓库URL
    pause
    exit /b 1
)

echo.
echo 正在初始化Git仓库...
git init
if %ERRORLEVEL% neq 0 (
    echo 错误：无法初始化Git仓库
    pause
    exit /b 1
)

echo.
echo 正在配置Git...
git config --global init.defaultBranch main

echo.
echo 正在添加所有文件...
git add .

echo.
echo 正在创建初始提交...
git commit -m "Initial commit with LSPosed module code"

echo.
echo 正在添加远程仓库...
git remote add origin %REPO_URL%

echo.
echo 正在推送代码到GitHub...
git branch -M main
git push -u origin main

if %ERRORLEVEL% equ 0 (
    echo.
    echo **********************************************
    echo 成功上传到GitHub！
    echo 请继续执行步骤3：创建GitHub Actions工作流文件
    echo **********************************************
) else (
    echo.
    echo 上传过程中出现错误，请检查错误信息
    echo 可能需要配置GitHub认证信息
    echo 如果遇到认证错误，请使用Personal Access Token代替密码
)

echo.
echo 按任意键退出...
pause >nul