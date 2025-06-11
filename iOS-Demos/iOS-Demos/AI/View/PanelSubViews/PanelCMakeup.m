//
//  PanelCMakeup.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/7.
//

#import "PanelCMakeup.h"
#import "PanelCItems.h"

@interface PanelCMakeup ()
@property (nonatomic, strong) UIView *viewsContainer;
@property (nonatomic, strong) UIView *titleImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation PanelCMakeup

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.width = kScreenWidth - 32;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.viewsContainer = [UIView new];
    self.viewsContainer.size = CGSizeMake(kScreenWidth - 32, 1000);
    self.viewsContainer.left = 16;
    self.viewsContainer.backgroundColor = [UIColor colorWithHexString:@"#FFF6EB"];
    self.viewsContainer.layer.cornerRadius = 20;
    [self addSubview:self.viewsContainer];
    self.titleImageView = [UIView new];
    self.titleImageView.size = CGSizeMake(6, 6);
    self.titleImageView.top = 22.5;
    self.titleImageView.left = 16;
    self.titleImageView.backgroundColor = [UIColor colorWithHexString:@"#EB9731"];
    self.titleImageView.layer.cornerRadius = 3;
    [self.viewsContainer addSubview:self.titleImageView];
    
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    self.titleLabel.text = @"妆容推荐";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#EB9731"];
    [self.titleLabel sizeToFit];
    [self.viewsContainer addSubview:self.titleLabel];
    self.titleLabel.centerY = self.titleImageView.centerY;
    self.titleLabel.left = self.titleImageView.right + 3;
}

- (void)loadViewWithModel:(MakeupRecommendation *)model {
    UILabel *summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewsContainer.width - 32, 24)];
    [self.viewsContainer addSubview:summaryLabel];
    summaryLabel.text = @"通勤约会「清冷白开水妆」";
    summaryLabel.font = [UIFont boldSystemFontOfSize:14];
    summaryLabel.textColor = [UIColor blackColor];
    [summaryLabel sizeToFit];
    summaryLabel.top = self.titleLabel.bottom + 3;
    summaryLabel.left = self.titleImageView.left;
    
    UIView *bgContainer = [UIView new];
    bgContainer.backgroundColor = UIColor.whiteColor;
    bgContainer.layer.cornerRadius = 16;
    [self.viewsContainer addSubview:bgContainer];
    bgContainer.width = self.viewsContainer.width - 8;
    bgContainer.height = 600;
    bgContainer.left = 4;
    bgContainer.top = summaryLabel.bottom + 8;
    
    PanelCItems *itemA = [PanelCItems new];
    itemA.width = bgContainer.width;
    [bgContainer addSubview:itemA];
    [itemA loadViewWithModel:model.daily_date_makeup.contour andImagePrefix:@"contour_" andTitle:@"1. 修容"];
    itemA.top = 16;
    PanelCItems *itemB = [PanelCItems new];
    itemB.width = bgContainer.width;
    [bgContainer addSubview:itemB];
    [itemB loadViewWithModel:model.daily_date_makeup.eye_makeup andImagePrefix:@"eye_" andTitle:@"2. 眼妆"];
    itemB.top = itemA.bottom;
    PanelCItems *itemC = [PanelCItems new];
    itemC.width = bgContainer.width;
    [bgContainer addSubview:itemC];
    [itemC loadViewWithModel:model.daily_date_makeup.eyebrow_makeup andImagePrefix:@"eyebrow_" andTitle:@"3. 眉妆"];
    itemC.top = itemB.bottom;
    PanelCItems *itemD = [PanelCItems new];
    itemD.width = bgContainer.width;
    [bgContainer addSubview:itemD];
    [itemD loadViewWithModel:model.daily_date_makeup.lip_makeup andImagePrefix:@"lip_" andTitle:@"4. 唇妆"];
    itemD.top = itemC.bottom;
    PanelCItems *itemE = [PanelCItems new];
    itemE.width = bgContainer.width;
    [bgContainer addSubview:itemE];
    [itemE loadViewWithModel:model.daily_date_makeup.blush andImagePrefix:@"blush_" andTitle:@"5. 腮红"];
    itemE.top = itemD.bottom;

    bgContainer.height = itemE.bottom + 12;
    self.viewsContainer.height = bgContainer.bottom + 4;
    self.size = self.viewsContainer.size;
}

@end
