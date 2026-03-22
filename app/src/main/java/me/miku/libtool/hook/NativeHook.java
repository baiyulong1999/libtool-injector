package me.miku.libtool.hook;

import android.util.Log;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage.LoadPackageParam;

public class NativeHook implements IXposedHookLoadPackage {

    private static final String TAG = "LibTool-Native";

    @Override
    public void handleLoadPackage(LoadPackageParam lpparam) throws Throwable {
        // 替换为实际的游戏包名
        if (!lpparam.packageName.equals("com.game.target")) {
            return;
        }

        Log.d(TAG, "Hooking into target app: " + lpparam.packageName);

        XposedHelpers.findAndHookMethod("android.app.Application", lpparam.classLoader, 
            "onCreate", new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(XC_MethodHook.MethodHookParam param) throws Throwable {
                    Log.d(TAG, "Application onCreate called, injecting native library");
                    
                    // 注入libTool.so
                    injectNativeLibrary(lpparam.classLoader);
                }
            });
    }

    private void injectNativeLibrary(ClassLoader classLoader) {
        try {
            // 将libTool.so复制到可执行目录
            File libFile = extractLibTool();
            if (libFile != null && libFile.exists()) {
                // 使用反射调用System.load加载库
                System.load(libFile.getAbsolutePath());
                Log.d(TAG, "Successfully loaded libTool.so from: " + libFile.getAbsolutePath());
            } else {
                Log.e(TAG, "Failed to extract libTool.so");
            }
        } catch (Exception e) {
            Log.e(TAG, "Error loading native library: " + e.getMessage(), e);
        }
    }

    private File extractLibTool() {
        try {
            // 创建临时目录用于存放libTool.so
            File tempDir = new File("/data/local/tmp/");
            if (!tempDir.exists()) {
                tempDir.mkdirs();
            }

            File libFile = new File(tempDir, "libTool.so");
            
            // 复制libTool.so到临时目录
            // 在实际实现中，你需要确保libTool.so被包含在模块中
            // 或者从其他位置复制
            
            // 这里是一个简化的示例 - 实际部署时需要将libTool.so打包进模块
            // 然后从assets或其他资源中复制出来
            Log.d(TAG, "Preparing to extract libTool.so to: " + libFile.getAbsolutePath());
            
            return libFile;
        } catch (Exception e) {
            Log.e(TAG, "Error extracting libTool.so: " + e.getMessage(), e);
            return null;
        }
    }
}