# flutter_gallery

A plugin that allows you to pick multiple media both image and video.

## Getting Started

### request permission

You can also request permission on android/ios but this as been handled by the plugin.

```dart
var result = await PhotoManager.requestPermission();
if (result) {
    // success
} else {
    // fail
    /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
}
```

Pick a GIF:

```dart
import 'package:flutter_gallery/flutter_gallery.dart';
import 'package:photo_manager/photo_manager.dart';

final _results = await FlutterGallery.pickGallery(
                context: context,
                title: widget?.title,
                color: Colors.red
              );
```

## iOS config

### iOS plist config

Because the album is a privacy privilege, you need user permission to access it. You must to modify the `Info.plist` file in Runner project.

like next

```xml
    <key>NSPhotoLibraryUsageDescription</key>
    <string>App requires permission to your gallery to access photos and videos</string>
```

xcode like image
![in xcode](https://raw.githubusercontent.com/CaiJingLong/some_asset/master/flutter_photo2.png)

In ios11+, if you want to save or delete asset, you also need add `NSPhotoLibraryAddUsageDescription` to plist.

### enabling localized system albums names

By default iOS will retrieve system album names only in English whatever the device's language currently set.
To change this you need to open the ios project of your flutter app using xCode

![in xcode](https://raw.githubusercontent.com/CaiJingLong/some_asset/master/iosFlutterProjectEditinginXcode.png)

Select the project "Runner" and in the localizations table, click on the + icon

![in xcode](https://raw.githubusercontent.com/CaiJingLong/some_asset/master/iosFlutterAddLocalization.png)

Select the adequate language(s) you want to retrieve localized strings.
Validate the popup screen without any modification
Close xCode
Rebuild your flutter project
Now, the system albums should be displayed according to the device's language


## android config

### about androidX

Google recommends completing all support-to-AndroidX migrations in 2019. Documentation is also provided.

This library has been migrated in version 0.2.2, but it brings a problem. Sometimes your upstream library has not been migrated yet. At this time, you need to add an option to deal with this problem.

The complete migration method can be consulted [gitbook](https://caijinglong.gitbooks.io/migrate-flutter-to-androidx/content/).

### Android Q (android10 , API 29)

Now, the android part of the plugin uses api 29 to compile the plugin, so your android sdk environment must contain api 29 (androidQ).

AndroidQ has a new privacy policy, users can't access the original file.

If your compileSdkVersion and targetSdkVersion are both below 28, you can use `PhotoManager.forceOldApi` to force the old api to access the album. If you are not sure about this part, don't call this method. And, I recommand you add `android:requestLegacyExternalStorage="true"` to your `AndroidManifest.xml`, just like next.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="top.kikt.imagescannerexample">

    <application
        android:name="io.flutter.app.FlutterApplication"
        android:label="image_scanner_example"
        android:requestLegacyExternalStorage="true"
        android:icon="@mipmap/ic_launcher">
    </application>
</manifest>

```

### Android R (android 11, API30)

Unlike androidQ, this version of `requestLegacyExternalStorage` is invalid, but I still recommend that you add this attribute to make it easier to use the old API on android29 of android device.

### glide

Android native use glide to create image thumb bytes, version is 4.11.0.

If your other android library use the library, and version is not same, then you need edit your android project's build.gradle.

```gradle
rootProject.allprojects {

    subprojects {
        project.configurations.all {
            resolutionStrategy.eachDependency { details ->
                if (details.requested.group == 'com.github.bumptech.glide'
                        && details.requested.name.contains('glide')) {
                    details.useVersion '4.11.0'
                }
            }
        }
    }
}
```

And, if you want to use ProGuard, you can see the [ProGuard of Glide](https://github.com/bumptech/glide#proguard).

## common issues

### ios build error

if your flutter print like the log. see [stackoverflow](https://stackoverflow.com/questions/27776497/include-of-non-modular-header-inside-framework-module)

```bash
Xcode's output:
↳
    === BUILD TARGET Runner OF PROJECT Runner WITH CONFIGURATION Debug ===
    The use of Swift 3 @objc inference in Swift 4 mode is deprecated. Please address deprecated @objc inference warnings, test your code with “Use of deprecated Swift 3 @objc inference” logging enabled, and then disable inference by changing the "Swift 3 @objc Inference" build setting to "Default" for the "Runner" target.
    === BUILD TARGET Runner OF PROJECT Runner WITH CONFIGURATION Debug ===
    While building module 'photo_manager' imported from /Users/cai/IdeaProjects/flutter/sxw_order/ios/Runner/GeneratedPluginRegistrant.m:9:
    In file included from <module-includes>:1:
    In file included from /Users/cai/IdeaProjects/flutter/sxw_order/build/ios/Debug-iphonesimulator/photo_manager/photo_manager.framework/Headers/photo_manager-umbrella.h:16:
    /Users/cai/IdeaProjects/flutter/sxw_order/build/ios/Debug-iphonesimulator/photo_manager/photo_manager.framework/Headers/MD5Utils.h:5:9: error: include of non-modular header inside framework module 'photo_manager.MD5Utils': '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator11.2.sdk/usr/include/CommonCrypto/CommonDigest.h' [-Werror,-Wnon-modular-include-in-framework-module]
    #import <CommonCrypto/CommonDigest.h>
            ^
    1 error generated.
    /Users/cai/IdeaProjects/flutter/sxw_order/ios/Runner/GeneratedPluginRegistrant.m:9:9: fatal error: could not build module 'photo_manager'
    #import <photo_manager/ImageScannerPlugin.h>
     ~~~~~~~^
    2 errors generated.
```

## Acknowledgements
This plugin depends on the [photo_manager](https://pub.dartlang.org/packages/photo_manager).
