//
//  PanelAFace.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/7.
//

#import "PanelAFace.h"
#import "PanelAItems.h"
#import "BaseFoundation.h"
#import "GlobalModel.h"

// MARK: - Constants
static const CGFloat kPanelCornerRadius = 20.0;           // 面板圆角
static const CGFloat kPanelHorizontalMargin = 32.0;       // 面板水平边距
static const CGFloat kTitleIndicatorSize = 6.0;           // 标题指示器尺寸
static const CGFloat kTitleIndicatorTopMargin = 22.5;     // 标题指示器顶部边距
static const CGFloat kTitleIndicatorLeftMargin = 16.0;    // 标题指示器左边距
static const CGFloat kTitleLeftSpacing = 3.0;             // 标题左间距
static const CGFloat kSummaryTopSpacing = 3.0;            // 摘要顶部间距
static const CGFloat kContentContainerTopSpacing = 8.0;   // 内容容器顶部间距
static const CGFloat kContentContainerCornerRadius = 16.0; // 内容容器圆角
static const CGFloat kContentContainerHorizontalMargin = 4.0; // 内容容器水平边距
static const CGFloat kSectionTopMargin = 16.0;            // 区块顶部边距
static const CGFloat kSectionLeftMargin = 12.0;           // 区块左边距
static const CGFloat kFaceImageSize = 105.0;              // 脸型图片尺寸
static const CGFloat kFaceImageTopSpacing = 13.0;         // 脸型图片顶部间距
static const CGFloat kFaceImageLeftMargin = 20.0;         // 脸型图片左边距
static const CGFloat kFaceDetailLeftSpacing = 9.0;        // 脸型详情左间距
static const CGFloat kFaceDetailTopOffset = 5.0;          // 脸型详情顶部偏移
static const CGFloat kFaceDetailBottomSpacing = 8.0;      // 脸型详情底部间距
static const CGFloat kFeaturesTopSpacing = 18.0;          // 五官区块顶部间距
static const CGFloat kFeatureItemsTopSpacing = 13.0;      // 五官项目顶部间距
static const CGFloat kFeatureItemsHorizontalSpacing = 11.0; // 五官项目水平间距
static const CGFloat kContentBottomMargin = 12.0;         // 内容底部边距
static const CGFloat kContainerBottomMargin = 4.0;        // 容器底部边距
static const CGFloat kInitialContainerHeight = 1000.0;    // 初始容器高度

// MARK: - Colors
static NSString * const kPanelBackgroundColor = @"#F3F2FF";  // 面板背景色
static NSString * const kTitleIndicatorColor = @"#8980FF";   // 标题指示器颜色
static NSString * const kContentTextColor = @"#262626";      // 内容文字颜色

@interface PanelAFace ()

// MARK: - UI Components
@property (nonatomic, strong) UIView *panelContainer;        // 面板容器
@property (nonatomic, strong) UIView *titleIndicator;       // 标题指示器
@property (nonatomic, strong) UILabel *panelTitleLabel;     // 面板标题
@property (nonatomic, strong) UILabel *summaryLabel;        // 摘要标签
@property (nonatomic, strong) UIView *contentContainer;     // 内容容器


@end

@implementation PanelAFace

// MARK: - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUserInterface];
    }
    return self;
}

// MARK: - Public Methods
- (void)loadAndDisplayContent {
    [self loadFaceAnalysisData];
    [self setupSummaryContent];
    [self setupFaceShapeAnalysis];
    [self setupFacialFeaturesAnalysis];
    [self updateContainerSize];
}

// MARK: - Setup Methods
- (void)setupUserInterface {
    [self setupPanelContainer];
    [self setupTitleSection];
}

- (void)setupPanelContainer {
    self.panelContainer = [[UIView alloc] init];
    self.panelContainer.size = CGSizeMake(kScreenWidth - kPanelHorizontalMargin, kInitialContainerHeight);
    self.panelContainer.left = 0;
    self.panelContainer.backgroundColor = [UIColor colorWithHexString:kPanelBackgroundColor];
    self.panelContainer.layer.cornerRadius = kPanelCornerRadius;
    [self addSubview:self.panelContainer];
}

- (void)setupTitleSection {
    // 标题指示器
    self.titleIndicator = [[UIView alloc] init];
    self.titleIndicator.size = CGSizeMake(kTitleIndicatorSize, kTitleIndicatorSize);
    self.titleIndicator.top = kTitleIndicatorTopMargin;
    self.titleIndicator.left = kTitleIndicatorLeftMargin;
    self.titleIndicator.backgroundColor = [UIColor colorWithHexString:kTitleIndicatorColor];
    self.titleIndicator.layer.cornerRadius = kTitleIndicatorSize / 2;
    [self.panelContainer addSubview:self.titleIndicator];
    
    // 面板标题
    self.panelTitleLabel = [[UILabel alloc] init];
    self.panelTitleLabel.font = [UIFont systemFontOfSize:FontSize(11)];
    self.panelTitleLabel.text = @"面部分析";
    self.panelTitleLabel.textColor = [UIColor colorWithHexString:kContentTextColor];
    [self.panelTitleLabel sizeToFit];
    [self.panelContainer addSubview:self.panelTitleLabel];
    self.panelTitleLabel.centerY = self.titleIndicator.centerY;
    self.panelTitleLabel.left = self.titleIndicator.right + kTitleLeftSpacing;
}

// MARK: - Data Loading
- (void)loadFaceAnalysisData {
    GlobalModel *globalModel = GlobalToolHandler.fetchGlobalModel;
    self.faceAnalysisData = globalModel.panelAFaceModel;
}

- (void)setupSummaryContent {
    GlobalModel *globalModel = GlobalToolHandler.fetchGlobalModel;
    
    self.summaryLabel = [[UILabel alloc] init];
    NSString *summaryText = [NSString stringWithFormat:@"%@+%@", 
                           globalModel.conclusionModel.fetchFaceStyleString, 
                           self.faceAnalysisData.faceFeatures];
    self.summaryLabel.text = summaryText;
    self.summaryLabel.font = [UIFont boldSystemFontOfSize:FontSize(14)];
    self.summaryLabel.textColor = [UIColor blackColor];
    [self.summaryLabel sizeToFit];
    self.summaryLabel.top = self.panelTitleLabel.bottom + kSummaryTopSpacing;
    self.summaryLabel.left = self.titleIndicator.left;
    [self.panelContainer addSubview:self.summaryLabel];
    
    [self setupContentContainer];
}

- (void)setupContentContainer {
    self.contentContainer = [[UIView alloc] init];
    self.contentContainer.backgroundColor = [UIColor whiteColor];
    self.contentContainer.layer.cornerRadius = kContentContainerCornerRadius;
    self.contentContainer.width = self.panelContainer.width - (kContentContainerHorizontalMargin * 2);
    self.contentContainer.left = kContentContainerHorizontalMargin;
    self.contentContainer.top = self.summaryLabel.bottom + kContentContainerTopSpacing;
    [self.panelContainer addSubview:self.contentContainer];
}

- (void)setupFaceShapeAnalysis {
    GlobalModel *globalModel = GlobalToolHandler.fetchGlobalModel;
    
    // 脸型分析标题
    UILabel *shapeAnalysisTitle = [[UILabel alloc] init];
    shapeAnalysisTitle.text = @"1. 脸型与轮廓";
    shapeAnalysisTitle.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
    shapeAnalysisTitle.textColor = [UIColor colorWithHexString:kContentTextColor];
    [shapeAnalysisTitle sizeToFit];
    shapeAnalysisTitle.top = kSectionTopMargin;
    shapeAnalysisTitle.left = kSectionLeftMargin;
    [self.contentContainer addSubview:shapeAnalysisTitle];
    
    // 脸型图片
    NSString *faceImageName = [self faceImageNameForStyle:globalModel.conclusionModel.faceStyle.integerValue];
    UIImageView *faceShapeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:faceImageName]];
    faceShapeImage.size = CGSizeMake(kFaceImageSize, kFaceImageSize);
    faceShapeImage.left = kFaceImageLeftMargin;
    faceShapeImage.top = shapeAnalysisTitle.bottom + kFaceImageTopSpacing;
    [self.contentContainer addSubview:faceShapeImage];
    
    // 脸型描述
    UILabel *faceShapeLabel = [[UILabel alloc] init];
    faceShapeLabel.text = [NSString stringWithFormat:@"偏%@", globalModel.conclusionModel.fetchFaceStyleString];
    faceShapeLabel.font = [UIFont boldSystemFontOfSize:FontSize(13)];
    faceShapeLabel.textColor = [UIColor colorWithHexString:kContentTextColor];
    faceShapeLabel.top = faceShapeImage.top + kFaceDetailTopOffset;
    faceShapeLabel.left = faceShapeImage.right + kFaceDetailLeftSpacing;
    faceShapeLabel.width = self.contentContainer.width - faceShapeLabel.left - kSectionLeftMargin;
    [faceShapeLabel sizeToFit];
    [self.contentContainer addSubview:faceShapeLabel];
    
    // 脸型详细描述
    UILabel *faceShapeDetail = [[UILabel alloc] init];
    faceShapeDetail.numberOfLines = 4;
    faceShapeDetail.top = faceShapeLabel.bottom + kFaceDetailBottomSpacing;
    faceShapeDetail.left = faceShapeImage.right + kFaceDetailLeftSpacing;
    faceShapeDetail.width = self.contentContainer.width - faceShapeDetail.left - kSectionLeftMargin;
    
    // 设置脸型详细描述文本和行间距
    NSString *detailText = globalModel.conclusionModel.fetchFaceStyleConclusionString;
    if (detailText && detailText.length > 0) {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:detailText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = LineSpacing(3);
        paragraphStyle.alignment = NSTextAlignmentLeft;
        [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, detailText.length)];
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FontSize(13)] range:NSMakeRange(0, detailText.length)];
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:kContentTextColor] range:NSMakeRange(0, detailText.length)];
        faceShapeDetail.attributedText = attributedText;
    } else {
        faceShapeDetail.text = detailText;
        faceShapeDetail.font = [UIFont systemFontOfSize:FontSize(13)];
        faceShapeDetail.textColor = [UIColor colorWithHexString:kContentTextColor];
    }
    [faceShapeDetail sizeToFit];
    [self.contentContainer addSubview:faceShapeDetail];
}

- (void)setupFacialFeaturesAnalysis {
    // 五官特点标题
    UILabel *featuresTitle = [[UILabel alloc] init];
    featuresTitle.text = @"2. 五官特点";
    featuresTitle.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
    featuresTitle.textColor = [UIColor colorWithHexString:kContentTextColor];
    [featuresTitle sizeToFit];
    
    // 计算位置（基于脸型分析的最后一个元素）
    UIView *lastFaceShapeView = self.contentContainer.subviews.lastObject;
    featuresTitle.top = lastFaceShapeView.bottom + kFeaturesTopSpacing;
    featuresTitle.left = kSectionLeftMargin;
    [self.contentContainer addSubview:featuresTitle];
    
    // 五官特点项目
    [self setupFeatureItemsStartingFromY:featuresTitle.bottom + kFeatureItemsTopSpacing];
}

- (void)setupFeatureItemsStartingFromY:(CGFloat)startY {
    // 眼睛
    PanelAItems *eyesItem = [[PanelAItems alloc] init];
    [eyesItem loadViewWithTitle:@"眼睛" 
                     andContent:self.faceAnalysisData.eyes 
                       andImage:[UIImage imageNamed:@"senses_eyes"]];
    eyesItem.top = startY;
    eyesItem.left = kFaceImageLeftMargin;
    [self.contentContainer addSubview:eyesItem];
    
    // 鼻子
    PanelAItems *noseItem = [[PanelAItems alloc] init];
    [noseItem loadViewWithTitle:@"鼻子" 
                     andContent:self.faceAnalysisData.nose 
                       andImage:[UIImage imageNamed:@"senses_nose"]];
    noseItem.top = eyesItem.top;
    noseItem.left = eyesItem.right + kFeatureItemsHorizontalSpacing;
    [self.contentContainer addSubview:noseItem];
    
    // 眉毛
    PanelAItems *eyebrowsItem = [[PanelAItems alloc] init];
    [eyebrowsItem loadViewWithTitle:@"眉毛" 
                         andContent:self.faceAnalysisData.eyebrows 
                           andImage:[UIImage imageNamed:@"senses_eyebrows"]];
    eyebrowsItem.top = eyesItem.bottom + kFeatureItemsHorizontalSpacing;
    eyebrowsItem.left = kFaceImageLeftMargin;
    [self.contentContainer addSubview:eyebrowsItem];
    
    // 嘴唇
    PanelAItems *lipsItem = [[PanelAItems alloc] init];
    [lipsItem loadViewWithTitle:@"嘴唇" 
                     andContent:self.faceAnalysisData.lips 
                       andImage:[UIImage imageNamed:@"senses_mouth"]];
    lipsItem.top = eyebrowsItem.top;
    lipsItem.left = eyebrowsItem.right + kFeatureItemsHorizontalSpacing;
    [self.contentContainer addSubview:lipsItem];
    
    // 更新内容容器高度
    CGFloat contentHeight = lipsItem.bottom + kContentBottomMargin;
    self.contentContainer.height = contentHeight;
}

- (void)updateContainerSize {
    self.panelContainer.height = self.contentContainer.bottom + kContainerBottomMargin;
    self.size = self.panelContainer.size;
}

// MARK: - Helper Methods
- (NSString *)faceImageNameForStyle:(NSInteger)faceStyle {
    switch (faceStyle) {
        case 1:
        case 3:
            return @"face_chang";
        case 2:
            return @"face_yuan";
        case 4:
            return @"face_li";
        case 5:
            return @"face_gua";
        case 6:
            return @"face_ling";
        case 0:
        default:
            return @"face_biao";
    }
}

// MARK: - Legacy Methods (for backward compatibility)
- (void)loadView {
    [self loadAndDisplayContent];
}

@end
