//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_onnxruntime/FlutterOnnxruntimePlugin.h>)
#import <flutter_onnxruntime/FlutterOnnxruntimePlugin.h>
#else
@import flutter_onnxruntime;
#endif

#if __has_include(<sqflite_darwin/SqflitePlugin.h>)
#import <sqflite_darwin/SqflitePlugin.h>
#else
@import sqflite_darwin;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FlutterOnnxruntimePlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterOnnxruntimePlugin"]];
  [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
}

@end
