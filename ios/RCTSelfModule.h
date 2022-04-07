#import <React/RCTEventEmitter.h>

@protocol RCTSelfModuleDelegate <NSObject>
- (void)didReceiveMessage:(id)sender
                  message:(NSString *)message;
- (void)didReceiveError:(id)sender
                message:(NSString *)message;
@end

@interface RCTSelfModule : RCTEventEmitter
@property (nonatomic, strong) NSNumber *threadId;
@property (nonatomic, weak) id<RCTSelfModuleDelegate> delegate;
- (void)postMessage:(NSString *)message;
@end
