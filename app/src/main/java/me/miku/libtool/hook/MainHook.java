package me.miku.libtool.hook;

import android.content.Context;
import android.util.Log;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage.LoadPackageParam;

public class MainHook implements IXposedHookLoadPackage {

    private static final String TAG = "LibTool-Injector";
    private static final String LIB_NAME = "libTool.so";
    private static final String EXTERNAL_LIB_PATH = "/sdcard/龙虾用/libTool.so"; // 外部libTool.so路径

    @Override
    public void handleLoadPackage(LoadPackageParam lpparam) throws Throwable {
        // 替换为实际的游戏包名，例如：com.example.game
        if (!lpparam.packageName.equals("com.superplanet.evilhunter")) {
            return;
        }

        Log.d(TAG, "LibTool Injector: Hooking into target app: " + lpparam.packageName);

        XposedHelpers.findAndHookMethod("android.app.Application", lpparam.classLoader, 
            "onCreate", new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(XC_MethodHook.MethodHookParam param) throws Throwable {
                    Log.d(TAG, "LibTool Injector: Application onCreate called, attempting to inject native library");
                    
                    boolean success = injectLibTool(lpparam.classLoader);
                    if (success) {
                        Log.d(TAG, "LibTool Injector: Successfully injected libTool.so into " + lpparam.packageName);
                    } else {
                        Log.e(TAG, "LibTool Injector: Failed to inject libTool.so into " + lpparam.packageName);
                    }
                }
            });
    }

    private boolean injectLibTool(ClassLoader classLoader) {
        try {
            // 尝试从外部存储复制libTool.so到应用私有目录
            File libFile = copyLibToolToAppDir();
            if (libFile != null && libFile.exists()) {
                // 加载库
                System.load(libFile.getAbsolutePath());
                Log.i(TAG, "LibTool Injector: Successfully loaded libTool.so from: " + libFile.getAbsolutePath());
                return true;
            } else {
                Log.e(TAG, "LibTool Injector: Could not locate libTool.so for injection");
                return false;
            }
        } catch (Exception e) {
            Log.e(TAG, "LibTool Injector: Error injecting libTool.so: " + e.getMessage(), e);
            return false;
        }
    }

    private File copyLibToolToAppDir() {
        try {
            // 获取应用私有目录下的lib文件夹
            Context context = (Context) XposedHelpers.callStaticMethod(
                XposedHelpers.findClass("android.app.ActivityThread", null),
                "currentApplication"
            );
            
            if (context == null) {
                Log.e(TAG, "LibTool Injector: Could not get application context");
                return null;
            }

            File libDir = new File(context.getFilesDir(), "native_libs");
            if (!libDir.exists()) {
                libDir.mkdirs();
            }

            File libFile = new File(libDir, LIB_NAME);

            // 首先尝试从外部存储路径复制（/sdcard/龙虾用/libTool.so）
            File externalLibFile = new File(EXTERNAL_LIB_PATH);
            if (externalLibFile.exists()) {
                copyFile(externalLibFile, libFile);
                Log.d(TAG, "LibTool Injector: Copied libTool.so from external storage: " + EXTERNAL_LIB_PATH);
            } else {
                // 如果外部路径不存在，则尝试从模块APK内部复制
                // 这需要在APK构建时将libTool.so打包进去
                Log.w(TAG, "LibTool Injector: External libTool.so not found, looking for internal resource");
                // 注意：在实际APK中，你需要将libTool.so作为asset或resource打包
            }

            return libFile;
        } catch (Exception e) {
            Log.e(TAG, "LibTool Injector: Error preparing libTool.so: " + e.getMessage(), e);
            return null;
        }
    }

    private void copyFile(File source, File dest) throws IOException {
        try (InputStream is = new FileInputStream(source);
             OutputStream os = new FileOutputStream(dest)) {
            
            byte[] buffer = new byte[4096];
            int length;
            while ((length = is.read(buffer)) > 0) {
                os.write(buffer, 0, length);
            }
        }
    }
}