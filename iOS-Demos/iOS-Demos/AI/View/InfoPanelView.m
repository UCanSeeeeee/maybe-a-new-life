//
//  InfoPanelView.m
//  iOS-Demos
//
//  Created by Chieh on 2025/5/29.
//

#import "InfoPanelView.h"
#import "BaseFoundation.h"

// MARK: - Constants
static const CGFloat kPanelVerticalSpacing = 10.0;  // 面板间垂直间距
static const CGFloat kInitialContainerHeight = 1000.0;  // 初始容器高度

@interface InfoPanelView ()

@end

@implementation InfoPanelView

// MARK: - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInitialLayout];
        [self setupSubPanels];
    }
    return self;
}

// MARK: - Setup Methods
- (void)setupInitialLayout {
    self.width = kScreenWidth;
    self.height = kInitialContainerHeight;
}

- (void)setupSubPanels {
    // 创建面部分析面板
    self.faceAnalysisPanel = [PanelAFace new];
    [self addSubview:self.faceAnalysisPanel];
    
    // 创建风格定位面板
    self.styleGuidePanel = [PanelBStyle new];
    [self addSubview:self.styleGuidePanel];
    
    // 创建妆容推荐面板
    self.makeupRecommendPanel = [PanelCMakeup new];
    [self addSubview:self.makeupRecommendPanel];
}

// MARK: - Public Methods
- (void)loadAndLayoutPanels {
    [self loadFaceAnalysisPanel];
    [self loadStyleGuidePanel];
    [self loadMakeupRecommendPanel];
    [self updateContainerHeight];
}

// MARK: - Private Methods
- (void)loadFaceAnalysisPanel {
    [self.faceAnalysisPanel loadAndDisplayContent];
    self.faceAnalysisPanel.centerX = self.width / 2.0;
    self.faceAnalysisPanel.top = 0;
}

- (void)loadStyleGuidePanel {
    [self.styleGuidePanel loadAndDisplayContent];
    self.styleGuidePanel.centerX = self.width / 2.0;
    self.styleGuidePanel.top = self.faceAnalysisPanel.bottom + kPanelVerticalSpacing;
}

- (void)loadMakeupRecommendPanel {
    [self.makeupRecommendPanel loadAndDisplayContent];
    self.makeupRecommendPanel.centerX = self.width / 2.0;
    self.makeupRecommendPanel.top = self.styleGuidePanel.bottom + kPanelVerticalSpacing;
}

- (void)updateContainerHeight {
    self.height = self.makeupRecommendPanel.bottom + SafeAreaBottomHeight;
}

// MARK: - Deprecated Methods
- (void)loadView {
    // 为了保持向后兼容性，调用新方法
    [self loadAndLayoutPanels];
}

// MARK: - Legacy Property Getters (for backward compatibility)
- (PanelAFace *)faceView {
    return self.faceAnalysisPanel;
}

- (PanelBStyle *)styleView {
    return self.styleGuidePanel;
}

- (PanelCMakeup *)makeupView {
    return self.makeupRecommendPanel;
}

@end
