#import "FlutterMediaPickerPlugin.h"
#import <flutter_media_picker/flutter_media_picker-Swift.h>

@implementation FlutterMediaPickerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterMediaPickerPlugin registerWithRegistrar:registrar];
}
@end
