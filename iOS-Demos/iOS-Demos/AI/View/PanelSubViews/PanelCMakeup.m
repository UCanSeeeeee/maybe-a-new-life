//
//  PanelCMakeup.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/7.
//

#import "PanelCMakeup.h"
#import "PanelCItems.h"
#import "BaseFoundation.h"
#import "GlobalModel.h"
#import "PanelCRecommandModel.h"

@interface PanelCMakeup ()
@property (nonatomic, strong) PanelCRecommandModel *dataModel;
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
    self.viewsContainer.left = 0;
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
    self.titleLabel.font = [UIFont systemFontOfSize:FontSize(11)];
    self.titleLabel.text = @"妆容推荐";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#EB9731"];
    [self.titleLabel sizeToFit];
    [self.viewsContainer addSubview:self.titleLabel];
    self.titleLabel.centerY = self.titleImageView.centerY;
    self.titleLabel.left = self.titleImageView.right + 3;
}

- (void)loadView {
    GlobalModel *tempModel = GlobalToolHandler.fetchGlobalModel;
    self.dataModel = tempModel.panelCRecommandModel;
    NSLog(@"chieh C %@", self.dataModel);
    
    UILabel *summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewsContainer.width - 32, 24)];
    [self.viewsContainer addSubview:summaryLabel];
    summaryLabel.text = self.dataModel.recommandStyle;
    summaryLabel.font = [UIFont boldSystemFontOfSize:FontSize(14)];
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
    [itemA loadViewWithTitle:@"1. 修容" imageStr:[NSString stringWithFormat:@"contour_%ld", self.dataModel.contourType.integerValue] values:self.dataModel.contourValues];
    itemA.top = 16;
    
    PanelCItems *itemBA = [PanelCItems new];
    itemBA.width = bgContainer.width;
    [bgContainer addSubview:itemBA];
    [itemBA loadViewWithTitle:@"2. 眼影" imageStr:[NSString stringWithFormat:@"shadowcolor_%ld", self.dataModel.eyeshadowColorType.integerValue] values:self.dataModel.eyeshadowValues];
    itemBA.top = itemA.bottom;
    
    PanelCItems *itemB = [PanelCItems new];
    itemB.width = bgContainer.width;
    [bgContainer addSubview:itemB];
    [itemB loadViewWithTitle:@"3. 眼妆" imageStr:[NSString stringWithFormat:@"eye_%ld", self.dataModel.eyeShapeType.integerValue] values:self.dataModel.eyeshapeValues];
    itemB.top = itemBA.bottom;
    
    PanelCItems *itemC = [PanelCItems new];
    itemC.width = bgContainer.width;
    [bgContainer addSubview:itemC];
    [itemC loadViewWithTitle:@"4. 眉妆" imageStr:[NSString stringWithFormat:@"eyebrow_%ld", self.dataModel.eyebrowStyleType.integerValue] values:self.dataModel.eyebrowValues];
    itemC.top = itemB.bottom;
    PanelCItems *itemD = [PanelCItems new];
    itemD.width = bgContainer.width;
    [bgContainer addSubview:itemD];
    [itemD loadViewWithTitle:@"5. 唇妆" imageStr:[NSString stringWithFormat:@"lip_%ld", self.dataModel.lipType.integerValue] values:self.dataModel.lipValues];
    itemD.top = itemC.bottom;
    PanelCItems *itemE = [PanelCItems new];
    itemE.width = bgContainer.width;
    [bgContainer addSubview:itemE];
    [itemE loadViewWithTitle:@"6. 腮红" imageStr:[NSString stringWithFormat:@"blush_%ld", self.dataModel.blushType.integerValue] values:self.dataModel.blushValues];
    itemE.top = itemD.bottom;

    bgContainer.height = itemE.bottom + 12;
    self.viewsContainer.height = bgContainer.bottom + 4;
    self.size = self.viewsContainer.size;
}

// MARK: - Public Methods
- (void)loadAndDisplayContent {
    [self loadView]; // 调用原有实现
}

@end
