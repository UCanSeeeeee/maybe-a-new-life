//
//  PanelBStyle.h
//  iOS-Demos
//
//  Created by Chieh on 2025/6/7.
//

#import <UIKit/UIKit.h>

@class PanelBDetailModel;

NS_ASSUME_NONNULL_BEGIN

/// 风格定位面板 - 显示风格分析和推荐
@interface PanelBStyle : UIView

// MARK: - Data
@property (nonatomic, strong, nullable) PanelBDetailModel *styleAnalysisData;

// MARK: - Public Methods
/// 加载并显示风格定位内容
- (void)loadAndDisplayContent;

@end

NS_ASSUME_NONNULL_END
