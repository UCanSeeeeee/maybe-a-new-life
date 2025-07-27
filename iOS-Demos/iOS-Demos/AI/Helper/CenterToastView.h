//
//  CenterToastView.h
//  iOS-Demos
//
//  Created by Chieh on 2025/7/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CenterToastView : UIView

/// 快速显示文本提示，自动添加到keyWindow
+ (instancetype)showWithText:(NSString *)text;

/// 手动隐藏toast
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
