//
//  PanelBItemsContainer.h
//  iOS-Demos
//
//  Created by Chieh on 2025/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PanelBItemsContainer : UIView

// 传入需要高亮的项名称
- (void)setHighlightedStyle:(NSString *)styleName highlightColor:(UIColor *)highlightColor;

@end

NS_ASSUME_NONNULL_END
