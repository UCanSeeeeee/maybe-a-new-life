//
//  SettingPopupView.h
//  iOS-Demos
//
//  Created by Chieh on 2025/5/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingPopupView : UIView

+ (void)showInView:(UIView *)parentView;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
