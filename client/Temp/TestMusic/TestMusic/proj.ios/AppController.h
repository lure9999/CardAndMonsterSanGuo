#import <UIKit/UIKit.h>
#import "CCVideoPlayer.h"

@class RootViewController;

@interface AppController : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootViewController    *viewController;
}


- (void)playVideo;


@end

