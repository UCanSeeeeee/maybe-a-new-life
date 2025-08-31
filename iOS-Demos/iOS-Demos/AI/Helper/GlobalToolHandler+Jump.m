//
//  GlobalToolHandler+Jump.m
//  iOS-Demos
//
//  Created by Chieh on 2025/8/16.
//

#import "GlobalToolHandler+Jump.h"
#import "CWViewsFoundation.h"

@implementation GlobalToolHandler (Jump)

+ (void)pushConclusionVC {
    ConclusionViewController *vc = [ConclusionViewController new];
    vc.dataModel = GlobalToolHandler.fetchGlobalModel.conclusionModel;
    
    UIWindow *keyWindow = UIApplication.sharedApplication.windows.firstObject;
    for (UIWindow *window in UIApplication.sharedApplication.windows) {
        if (window.isKeyWindow) {
            keyWindow = window;
            break;
        }
    }
    UIViewController *rootVC = keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)rootVC;
    [nav pushViewController:vc animated:YES];
}

+ (void)pushResultDetailVC {
    ResultDetailController *vc = [[ResultDetailController alloc] init];
    if (GlobalToolHandler.fetchGlobalModel.canShowPanelInfo) {
        UIWindow *keyWindow = UIApplication.sharedApplication.windows.firstObject;
        for (UIWindow *window in UIApplication.sharedApplication.windows) {
            if (window.isKeyWindow) {
                keyWindow = window;
                break;
            }
        }
        UIViewController *rootVC = keyWindow.rootViewController;
        UINavigationController *nav = (UINavigationController *)rootVC;
        [nav pushViewController:vc animated:YES];
    } else {
        [CenterToastView showWithText:@"正在分析，请稍后"];
    }
}

@end
