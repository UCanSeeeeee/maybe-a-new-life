//
//  PanelCMakeup.h
//  iOS-Demos
//
//  Created by Chieh on 2025/6/7.
//

#import <UIKit/UIKit.h>

@class PanelCMakeupModel;

NS_ASSUME_NONNULL_BEGIN

/// 妆容推荐面板 - 显示妆容建议和推荐
@interface PanelCMakeup : UIView

// MARK: - Data
@property (nonatomic, strong, nullable) PanelCMakeupModel *makeupRecommendationData;

// MARK: - Public Methods
/// 加载并显示妆容推荐内容
- (void)loadAndDisplayContent;

@end

NS_ASSUME_NONNULL_END
