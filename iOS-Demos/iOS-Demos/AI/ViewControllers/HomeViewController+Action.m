//
//  HomeViewController+Action.m
//  iOS-Demos
//
//  Created by Chieh on 2025/5/25.
//

#import "HomeViewController+Action.h"
#import "SettingPopupView.h"
#import "BaseFoundation.h"
#import "CWViewsFoundation.h"

@implementation HomeViewController (Action)

- (void)showSettingPopup {
    [SettingPopupView showInView:self.view];
}

- (void)takePhotosVC {
    NSLog(@"当前网络不可用: %@", [GlobalToolHandler sharedInstance].networkStatus);
    if (![GlobalToolHandler sharedInstance].networkAvailable) {
        [self showNetworkAlert];
        return;
    }
    [GlobalToolHandler clearGlobalModel];
    TakePhotosViewController *vc = [TakePhotosViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpConclusionVC {
    [GlobalToolHandler updateGlobalModel:[GlobalModel fetchLastGlobalModel]];
    if ([GlobalToolHandler fetchGlobalModel]) {
        [GlobalToolHandler pushConclusionVC];
        return;
    };
    [CenterToastView showWithText:@"并无历史数据"];
}

- (void)showNetworkAlert {
    // 弹窗提示
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"手机网络不可用，请确保App网络设置为「无线局域网与蜂窝数据」"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    // 按钮1：取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    // 按钮2：去设置
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"去设置"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:settingsAction];
    // 需要找到当前顶层VC来present
    UIViewController *rootVC = [UIApplication sharedApplication].windows.firstObject.rootViewController;
    while (rootVC.presentedViewController) {
        rootVC = rootVC.presentedViewController;
    }
    [rootVC presentViewController:alert animated:YES completion:nil];
}

@end
