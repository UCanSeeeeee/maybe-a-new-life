//
//  PanelDSummary.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/7.
//

#import "PanelDSummary.h"

@interface PanelDSummary ()
@property (nonatomic, strong) UIImageView *ageImageView;
@property (nonatomic, strong) UILabel *scoreTitleLabel;
@property (nonatomic, strong) UILabel *styleLabel;
@property (nonatomic, strong) UILabel *summaryLabel;
@end

@implementation PanelDSummary

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.width = kScreenWidth;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    self.ageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70 * 15 / 21.0)];
    [self addSubview:self.ageImageView];
    
    UILabel *scoreTitleLabel = [[UILabel alloc] init];
    scoreTitleLabel.text = @"肌龄妆感";
    scoreTitleLabel.font = [UIFont systemFontOfSize:12];
    scoreTitleLabel.textColor = [UIColor colorWithHexString:@"#262626"];
    [self addSubview:scoreTitleLabel];
    self.scoreTitleLabel = scoreTitleLabel;

    // d-1 推荐风格
    UILabel *styleLabel = [[UILabel alloc] init];
    styleLabel.text = @"清冷娇憨感，适合自然钓系妆容";
    styleLabel.font = [UIFont boldSystemFontOfSize:17];
    styleLabel.textColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1];
    [self addSubview:styleLabel];
    self.styleLabel = styleLabel;

    // d-2 面部特征总结
    UILabel *summaryLabel = [[UILabel alloc] init];
    summaryLabel.text = @"你的脸型为：菱形脸；三庭：中庭偏长，下庭尖窄，冷热气质交融；五官量感：中等偏精致";
    summaryLabel.font = [UIFont systemFontOfSize:12];
    summaryLabel.textColor = [UIColor colorWithHexString:@"#262626"];
    summaryLabel.numberOfLines = 2;
    [self addSubview:summaryLabel];
    self.summaryLabel = summaryLabel;
}

- (void)loadViewWithModel:(Summary *)model {
    self.ageImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"age_%@", model.makeup_age]];
    self.styleLabel.text = model.recommended_style;
    self.summaryLabel.text = model.facial_feature_summary;
    
    self.ageImageView.left = 21;

    [self.scoreTitleLabel sizeToFit];
    self.scoreTitleLabel.centerX = self.ageImageView.centerX;
    self.scoreTitleLabel.top = self.ageImageView.bottom + 2;
    
    self.styleLabel.top = 11.5;
    self.styleLabel.left = self.ageImageView.right + 5;
    self.styleLabel.width = self.width - 23 - self.summaryLabel.left;
    [self.styleLabel sizeToFit];
    
    self.summaryLabel.top = self.styleLabel.bottom + 6;
    self.summaryLabel.left = self.styleLabel.left;
    self.summaryLabel.width = self.width - 23 - self.summaryLabel.left;
    [self.summaryLabel sizeToFit];
    
    self.height = MAX(self.summaryLabel.bottom, self.scoreTitleLabel.bottom);
}

@end
