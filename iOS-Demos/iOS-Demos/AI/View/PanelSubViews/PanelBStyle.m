//
//  PanelBStyle.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/7.
//

#import "PanelBStyle.h"
#import "PanelBItemsContainer.h"
#import "PanelBStarsCard.h"
#import "PanelBCells.h"
#import "PanelBIdeas.h"
#import "BaseFoundation.h"
#import "GlobalModel.h"
#import "PanelBDetailModel.h"
@interface PanelBStyle ()
@property (nonatomic, strong) PanelBDetailModel *dataModel;
@property (nonatomic, strong) UIView *viewsContainer;
@property (nonatomic, strong) UIView *titleImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation PanelBStyle

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
    self.viewsContainer.backgroundColor = [UIColor colorWithHexString:@"#FFF2F0"];
    self.viewsContainer.layer.cornerRadius = 20;
    [self addSubview:self.viewsContainer];
    self.titleImageView = [UIView new];
    self.titleImageView.size = CGSizeMake(6, 6);
    self.titleImageView.top = 22.5;
    self.titleImageView.left = 16;
    self.titleImageView.backgroundColor = [UIColor colorWithHexString:@"#F08170"];
    self.titleImageView.layer.cornerRadius = 3;
    [self.viewsContainer addSubview:self.titleImageView];
    
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    self.titleLabel.text = @"风格定位";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#F08170"];
    [self.titleLabel sizeToFit];
    [self.viewsContainer addSubview:self.titleLabel];
    self.titleLabel.centerY = self.titleImageView.centerY;
    self.titleLabel.left = self.titleImageView.right + 3;
}

- (void)loadView {
    GlobalModel *tempModel = GlobalToolHandler.fetchGlobalModel;
    self.dataModel = tempModel.panelBDetailModel;
    NSLog(@"chieh B %@", self.dataModel);
    UILabel *summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewsContainer.width - 32, 24)];
    [self.viewsContainer addSubview:summaryLabel];
    summaryLabel.text = self.dataModel.conclusionStyleString;
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

    PanelBItemsContainer *gridView = [[PanelBItemsContainer alloc] init];
    [bgContainer addSubview:gridView];
    [gridView setHighlightedStyle:self.dataModel.conclusionStyleString highlightColor:[UIColor colorWithHexString:@"#FFE6E0"]];
    gridView.centerX = bgContainer.width / 2.0;
    gridView.top = 22.5;
    
    PanelBStarsCard *starsCard = [[PanelBStarsCard alloc] initWithFrame:CGRectMake(0, 0, 297 * kScreenRatio, 101 * kScreenRatio)];
    [bgContainer addSubview:starsCard];
    starsCard.centerX = bgContainer.width / 2.0;
    starsCard.top = gridView.bottom + 10;
    [starsCard loadView];
    
    UILabel *shapeTitleLabel = [[UILabel alloc] init];
    [bgContainer addSubview:shapeTitleLabel];
    shapeTitleLabel.text = @"1. 重点修饰";
    shapeTitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    shapeTitleLabel.textColor = [UIColor colorWithHexString:@"#262626"];
    [shapeTitleLabel sizeToFit];
    shapeTitleLabel.top = starsCard.bottom + 16;
    shapeTitleLabel.left = 12;
    __block UIView *lastView = shapeTitleLabel;
    [self.dataModel.key_corrections enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KeyCorrectionModel *tempModel = [[KeyCorrectionModel alloc] initWithDictionary:obj error:nil];
        PanelBCells *cellA = [PanelBCells new];
        [bgContainer addSubview:cellA];
        cellA.size = CGSizeMake(self.width - 30, 0);
        cellA.left = 13;
        cellA.top = lastView.bottom + 10;
        lastView = cellA;
        [cellA loadViewWithTitle:tempModel.disadvantage andContent:tempModel.suggestion];
    }];
    
    // 五官标题
    UILabel *featuresTitleLabel = [[UILabel alloc] init];
    [bgContainer addSubview:featuresTitleLabel];
    featuresTitleLabel.text = @"2. 妆容思路";
    featuresTitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    featuresTitleLabel.textColor = [UIColor colorWithHexString:@"#262626"];
    [featuresTitleLabel sizeToFit];
    featuresTitleLabel.top = lastView.bottom + 16;
    featuresTitleLabel.left = 12;
    
    PanelBIdeas *ideasView = [[PanelBIdeas alloc] initWithFrame:CGRectMake(0, featuresTitleLabel.bottom + 8, self.width, 0)];
    [bgContainer addSubview:ideasView];
    [ideasView loadView];
    
    bgContainer.height = ideasView.bottom + 12;
    self.viewsContainer.height = bgContainer.bottom + 4;
    self.size = self.viewsContainer.size;
}


@end
