//
//  InfoPanelView.h
//  iOS-Demos
//
//  Created by Chieh on 2025/5/29.
//

#import <UIKit/UIKit.h>
#import "PanelAFace.h"
#import "PanelBStyle.h"
#import "PanelCMakeup.h"

NS_ASSUME_NONNULL_BEGIN

/// 详情面板容器视图，包含面部分析、风格定位、妆容推荐三个子面板
@interface InfoPanelView : UIView

// MARK: - Sub Panels
@property (nonatomic, strong) PanelAFace *faceAnalysisPanel;    // 面部分析面板
@property (nonatomic, strong) PanelBStyle *styleGuidePanel;     // 风格定位面板
@property (nonatomic, strong) PanelCMakeup *makeupRecommendPanel; // 妆容推荐面板

// MARK: - Public Methods
/// 加载并布局所有子面板
- (void)loadAndLayoutPanels;

@end

NS_ASSUME_NONNULL_END
