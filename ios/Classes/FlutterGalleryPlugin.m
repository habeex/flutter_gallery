#import "FlutterGalleryPlugin.h"
#if __has_include(<flutter_gallery/flutter_gallery-Swift.h>)
#import <flutter_gallery/flutter_gallery-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_gallery-Swift.h"
#endif

@implementation FlutterGalleryPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterGalleryPlugin registerWithRegistrar:registrar];
}
@end
