//
//  PanelDSummary.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/7.
//

#import "PanelDSummary.h"
#import "BaseFoundation.h"
#import "GlobalModel.h"

// MARK: - Constants
static const CGFloat kAgeImageWidth = 70.0;             // 年龄图标宽度
static const CGFloat kAgeImageAspectRatio = 15.0/21.0;  // 年龄图标宽高比
static const CGFloat kAgeImageLeftMargin = 21.0;        // 年龄图标左边距
static const CGFloat kContentRightMargin = 23.0;        // 内容右边距
static const CGFloat kStyleLabelLeftSpacing = 5.0;      // 风格标签左间距
static const CGFloat kScoreTitleTopSpacing = 2.0;       // 评分标题顶部间距

@interface PanelDSummary ()

// MARK: - UI Components
@property (nonatomic, strong) UIImageView *ageImageView;   // 年龄图标
@property (nonatomic, strong) UILabel *scoreTitleLabel;   // 评分标题
@property (nonatomic, strong) UILabel *styleLabel;       // 推荐风格
@property (nonatomic, strong) UILabel *summaryLabel;     // 特征总结

@end

@implementation PanelDSummary

// MARK: - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.width = kScreenWidth;
        [self setupSubviews];
    }
    return self;
}

// MARK: - Setup Methods
- (void)setupSubviews {
    [self setupAgeImageView];
    [self setupScoreTitleLabel];
    [self setupStyleLabel];
    [self setupSummaryLabel];
}

- (void)setupAgeImageView {
    CGFloat imageHeight = kAgeImageWidth * kAgeImageAspectRatio;
    self.ageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kAgeImageWidth, imageHeight)];
    [self addSubview:self.ageImageView];
}

- (void)setupScoreTitleLabel {
    self.scoreTitleLabel = [[UILabel alloc] init];
    self.scoreTitleLabel.text = @"肌龄妆感";
    self.scoreTitleLabel.font = [UIFont systemFontOfSize:FontSize(12)];
    self.scoreTitleLabel.textColor = [UIColor colorWithHexString:@"#262626"];
    [self addSubview:self.scoreTitleLabel];
}

- (void)setupStyleLabel {
    self.styleLabel = [[UILabel alloc] init];
    self.styleLabel.font = [UIFont boldSystemFontOfSize:FontSize(17)];
    self.styleLabel.textColor = [UIColor colorWithHexString:@"#262626"];
    [self addSubview:self.styleLabel];
}

- (void)setupSummaryLabel {
    self.summaryLabel = [[UILabel alloc] init];
    self.summaryLabel.font = [UIFont systemFontOfSize:FontSize(12)];
    self.summaryLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.summaryLabel.numberOfLines = 2;
    [self addSubview:self.summaryLabel];
}

// MARK: - Data Loading
- (void)loadView {
    [self loadDataFromModel];
    [self layoutSubviews];
}

- (void)loadDataFromModel {
    GlobalModel *globalModel = GlobalToolHandler.fetchGlobalModel;
    self.dataModel = globalModel.conclusionModel;
    
    // 设置数据
    self.ageImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"age_%@", self.dataModel.skinAge]];
    self.styleLabel.text = self.dataModel.recommendMakeup;
    
    // 设置summaryLabel文本和行间距
    NSString *summaryText = self.dataModel.suggestion;
    if (summaryText && summaryText.length > 0) {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:summaryText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = LineSpacing(4);
        paragraphStyle.alignment = NSTextAlignmentLeft;
        [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, summaryText.length)];
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FontSize(12)] range:NSMakeRange(0, summaryText.length)];
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#262626"] range:NSMakeRange(0, summaryText.length)];
        self.summaryLabel.attributedText = attributedText;
    } else {
        self.summaryLabel.text = summaryText;
    }
}

- (void)layoutSubviews {
    [self layoutAgeImageView];
    [self layoutScoreTitleLabel];
    [self layoutStyleLabel];
    [self layoutSummaryLabel];
    [self updateViewHeight];
}

// MARK: - Layout Methods
- (void)layoutAgeImageView {
    self.ageImageView.left = kAgeImageLeftMargin;
}

- (void)layoutScoreTitleLabel {
    [self.scoreTitleLabel sizeToFit];
    self.scoreTitleLabel.centerX = self.ageImageView.centerX;
    self.scoreTitleLabel.top = self.ageImageView.bottom + kScoreTitleTopSpacing;
}

- (void)layoutStyleLabel {
    self.styleLabel.left = self.ageImageView.right + kStyleLabelLeftSpacing;
    self.styleLabel.width = self.width - kContentRightMargin - self.styleLabel.left;
    [self.styleLabel sizeToFit];
    self.styleLabel.top = 0;
}

- (void)layoutSummaryLabel {
    self.summaryLabel.left = self.styleLabel.left;
    self.summaryLabel.width = self.width - kContentRightMargin - self.summaryLabel.left;
    [self.summaryLabel sizeToFit];
    self.summaryLabel.bottom = self.scoreTitleLabel.bottom;
}

- (void)updateViewHeight {
    self.height = MAX(self.summaryLabel.bottom, self.scoreTitleLabel.bottom);
}

@end
