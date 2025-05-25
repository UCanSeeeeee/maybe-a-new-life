//
//  HomeViewController+Action.m
//  iOS-Demos
//
//  Created by Chieh on 2025/5/25.
//

#import "HomeViewController+Action.h"
#import "SettingPopupView.h"

@implementation HomeViewController (Action)

- (void)showSettingPopup {
    [SettingPopupView showInView:self.view];
}

@end
