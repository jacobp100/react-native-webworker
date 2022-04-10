#import "RCTWebWorkerModule.h"
#import <React/RCTDevSettings.h>
#include <stdlib.h>

#import <React/RCTAppSetupUtils.h>

#define RCT_NEW_ARCH_ENABLED 1

#if RCT_NEW_ARCH_ENABLED
#import <React/CoreModulesPlugins.h>
#import <React/RCTCxxBridgeDelegate.h>
#import <ReactCommon/RCTTurboModuleManager.h>

@interface RCTWebWorkerModule () <RCTCxxBridgeDelegate, RCTTurboModuleManagerDelegate>
@end
#endif

@implementation RCTWebWorkerModule {
  NSMutableDictionary<NSNumber *, RCTBridge *> *_threads;
  NSURL *_threadUrl;
}

RCT_EXPORT_MODULE();

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

- (instancetype)init
{
  if (self = [super init]) {
    _threads = [NSMutableDictionary new];
  }
  return self;
}

- (void)invalidate {
  for (NSNumber *threadId in _threads) {
    RCTBridge *threadBridge = _threads[threadId];
    [threadBridge invalidate];
  }

  [_threads removeAllObjects];
  _threads = nil;

  [super invalidate];
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"message", @"error"];
}

RCT_EXPORT_METHOD(startThread:(nonnull NSNumber *)threadId
                  name:(NSString *)name)
{
  // There's no nice way create an RCTBridge with a delegate and bundle URL
  // However, it reads the bundle URL at init, and will retain the previous
  // bundle URL if the delegate returns nil
  _threadUrl = [RCTBundleURLProvider.sharedSettings jsBundleURLForBundleRoot:name];
  NSLog(@"THREAD %@", _threadUrl);
  RCTBridge *threadBridge = [[RCTBridge alloc] initWithDelegate:self
                                                  launchOptions:nil];
  _threadUrl = nil;

  // Ensure shaking device doesn't open additional dev menus
  [[threadBridge moduleForClass:RCTDevSettings.class]
   setIsShakeToShowDevMenuEnabled:NO];

  RCTSelfModule *threadSelf = [threadBridge moduleForClass:RCTSelfModule.class];
  threadSelf.threadId = threadId;
  threadSelf.delegate = self;

  _threads[threadId] = threadBridge;
}

RCT_EXPORT_METHOD(stopThread:(nonnull NSNumber *)threadId)
{
  RCTBridge *threadBridge = _threads[threadId];
  if (threadBridge == nil) {
    return;
  }

  [threadBridge invalidate];
  [_threads removeObjectForKey:threadId];
}

RCT_EXPORT_METHOD(postThreadMessage:(nonnull NSNumber *)threadId
                  message:(NSString *)message)
{
  RCTBridge *threadBridge = _threads[threadId];
  if (threadBridge == nil) {
    NSLog(@"Thread is Nil. abort posting to thread with id %@", threadId);
    return;
  }

  RCTSelfModule *threadSelf = [threadBridge moduleForClass:RCTSelfModule.class];
  [threadSelf postMessage:message];
}

- (void)didReceiveMessage:(RCTSelfModule *)sender
                  message:(NSString *)message
{
  id body = @{
    @"id": sender.threadId,
    @"message": message,
  };
  [self sendEventWithName:@"message"
                     body:body];
}

- (void)didReceiveError:(RCTSelfModule *)sender
                message:(NSString *)message
{
  id body = @{
    @"id": sender.threadId,
    @"message": message,
  };
  [self sendEventWithName:@"error"
                     body:body];
}


- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  return _threadUrl;
}

#if RCT_NEW_ARCH_ENABLED

#pragma mark - RCTCxxBridgeDelegate

- (std::unique_ptr<facebook::react::JSExecutorFactory>)jsExecutorFactoryForBridge:(RCTBridge *)bridge
{
  RCTTurboModuleManager *turboModuleManager = [[RCTTurboModuleManager alloc]
                                               initWithBridge:bridge
                                               delegate:self
                                               jsInvoker:bridge.jsCallInvoker];
  return RCTAppSetupDefaultJsExecutorFactory(bridge, turboModuleManager);
}

#pragma mark RCTTurboModuleManagerDelegate

- (Class)getModuleClassFromName:(const char *)name
{
  return RCTCoreModulesClassProvider(name);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const std::string &)name
                                                      jsInvoker:(std::shared_ptr<facebook::react::CallInvoker>)jsInvoker
{
  return nullptr;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const std::string &)name
                                                     initParams:
                                                         (const facebook::react::ObjCTurboModule::InitParams &)params
{
  return nullptr;
}

- (id<RCTTurboModule>)getModuleInstanceFromClass:(Class)moduleClass
{
  return RCTAppSetupDefaultModuleFromClass(moduleClass);
}

#endif

@end
