#import <React/RCTEventEmitter.h>
#import <React/RCTBridge.h>
#import <React/RCTBridgeDelegate.h>
#import <React/RCTBundleURLProvider.h>

#import "RCTSelfModule.h"

@interface RCTWebWorkerModule : RCTEventEmitter <RCTBridgeDelegate, RCTSelfModuleDelegate>
@end
