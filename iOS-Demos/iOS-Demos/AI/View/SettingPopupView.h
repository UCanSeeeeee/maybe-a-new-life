//
//  SettingPopupView.h
//  iOS-Demos
//
//  Created by Chieh on 2025/5/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 设置弹窗视图，提供应用设置选项
@interface SettingPopupView : UIView

// MARK: - Class Methods
/// 在指定视图中显示设置弹窗
/// @param parentView 父视图
+ (void)showInParentView:(UIView *)parentView;

// MARK: - Instance Methods  
/// 关闭弹窗
- (void)dismissWithAnimation;

@end

NS_ASSUME_NONNULL_END
