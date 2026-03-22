.class public Lme/miku/libtool/hook/MainHook;
.super Ljava/lang/Object;
.source "MainHook.java"

# interfaces
.implements Lde/robv/android/xposed/IXposedHookLoadPackage;


# direct methods
.method public constructor <init>()V
    .registers 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end-method


# virtual methods
.method public handleLoadPackage(Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V
    .registers 4
    .param p1, "lpparam"    # Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;

    const-string v0, "com.game.target"  # Replace with target game package name

    iget-object v1, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->packageName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0

    if-eqz v0, :cond_1

    # Hook the application
    const-string v0, "android.app.Application"
    invoke-static {v0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;
    move-result-object v0

    const-string v1, "onCreate" 
    invoke-static {v0, v1}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)V

    :cond_1
    return-void
.end-method