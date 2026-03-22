# LSPosed Module for libTool.so Injection

## Overview
This is an LSPosed module designed to inject libTool.so into the game "Hunter Village Story" (com.superplanet.evilhunter).

## Build Status
⚠️ **Note**: GitHub Actions automated build is currently failing due to complex Android SDK setup requirements. Please use the manual build method below.

## Manual Build Instructions

Since the automated build is having issues, please follow these manual steps to build the module:

### Prerequisites
- Android Studio installed
- Android SDK with build-tools 34.0.0
- Java JDK 11 or 17

### Steps
1. Clone this repository
2. Open the project in Android Studio
3. Ensure all dependencies are properly configured
4. Build the project: Build → Build Bundle(s) / APK(s) → Build APK

## Alternative Solution
If you continue to have build issues, you can download a pre-built compatible LSPosed module template from trusted sources and modify it to include your specific hooks for libTool.so injection.

## Module Configuration
- Target Package: `com.superplanet.evilhunter`
- Xposed API Level: 93+
- Minimum Android Version: 5.0 (API 21)

## Installation
1. Install the built APK on your device
2. Enable the module in LSPosed Manager
3. Reboot your device
4. The module will automatically inject libTool.so into the target game

## Troubleshooting
- If the module doesn't appear in LSPosed Manager, check that the AndroidManifest.xml has the correct Xposed metadata
- If injection fails, verify the game package name matches exactly
- Check LSPosed logs for any error messages