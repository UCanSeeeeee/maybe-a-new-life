//
//  PanelBItems.h
//  iOS-Demos
//
//  Created by Chieh on 2025/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PanelBItems : UIView

@property (nonatomic, strong) UILabel *titleLabel;

/// 设置标题 & 是否高亮
- (void)configureWithTitle:(NSString *)title highlighted:(BOOL)isHighlighted highlightColor:(UIColor *)highlightColor;

@end

NS_ASSUME_NONNULL_END
