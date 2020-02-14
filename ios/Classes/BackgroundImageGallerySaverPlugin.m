#import "BackgroundImageGallerySaverPlugin.h"
#if __has_include(<background_image_gallery_saver/background_image_gallery_saver-Swift.h>)
#import <background_image_gallery_saver/background_image_gallery_saver-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "background_image_gallery_saver-Swift.h"
#endif

@implementation BackgroundImageGallerySaverPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBackgroundImageGallerySaverPlugin registerWithRegistrar:registrar];
}
@end
