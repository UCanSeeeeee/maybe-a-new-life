//
//  PanelAFace.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/7.
//

#import "PanelAFace.h"
#import "PanelAItems.h"

@interface PanelAFace ()

@property (nonatomic, strong) UIView *viewsContainer;
@property (nonatomic, strong) UIView *titleImageView;
@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation PanelAFace

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.viewsContainer = [UIView new];
    self.viewsContainer.size = CGSizeMake(kScreenWidth - 32, 1000);
    self.viewsContainer.left = 16;
    self.viewsContainer.backgroundColor = [UIColor colorWithHexString:@"#F3F2FF"];
    self.viewsContainer.layer.cornerRadius = 20;
    [self addSubview:self.viewsContainer];
    self.titleImageView = [UIView new];
    self.titleImageView.size = CGSizeMake(6, 6);
    self.titleImageView.top = 22.5;
    self.titleImageView.left = 16;
    self.titleImageView.backgroundColor = [UIColor colorWithHexString:@"#8980FF"];
    self.titleImageView.layer.cornerRadius = 3;
    [self.viewsContainer addSubview:self.titleImageView];
    
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    self.titleLabel.text = @"面部分析";
    [self.titleLabel sizeToFit];
    [self.viewsContainer addSubview:self.titleLabel];
    self.titleLabel.centerY = self.titleImageView.centerY;
    self.titleLabel.left = self.titleImageView.right + 3;
}

- (void)loadViewWithModel:(FaceAnalysis *)model {
    
    UILabel *summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewsContainer.width - 32, 24)];
    [self.viewsContainer addSubview:summaryLabel];
    summaryLabel.text = model.face_shape_and_contour;
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

    // 面型与轮廓标题
    UILabel *shapeTitleLabel = [[UILabel alloc] init];
    [bgContainer addSubview:shapeTitleLabel];
    shapeTitleLabel.text = @"1. 脸型与轮廓";
    shapeTitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    shapeTitleLabel.textColor = [UIColor colorWithHexString:@"#262626"];
    [shapeTitleLabel sizeToFit];
    shapeTitleLabel.top = 16;
    shapeTitleLabel.left = 12;

    NSString *tempString = @"biao";
    if ([model.keywords_summary containsString:@"菱"]) {
        tempString = @"ling";
    } else if ([model.keywords_summary containsString:@"长"]) {
        tempString = @"chang";
    } else if ([model.keywords_summary containsString:@"方"]) {
        tempString = @"fang";
    } else if ([model.keywords_summary containsString:@"瓜"]) {
        tempString = @"gua";
    } else if ([model.keywords_summary containsString:@"圆"]) {
        tempString = @"yuan";
    } else if ([model.keywords_summary containsString:@"梨"]) {
        tempString = @"li";
    }
    UIImageView *faceImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"face_%@", tempString]]];
    [bgContainer addSubview:faceImage];
    faceImage.size = CGSizeMake(105, 105);
    faceImage.left = 20;
    faceImage.top = shapeTitleLabel.bottom + 13;
    
    UILabel *shapeDetailLabel = [[UILabel alloc] init];
    [bgContainer addSubview:shapeDetailLabel];
    shapeDetailLabel.text = model.keywords_summary;
    shapeDetailLabel.font = [UIFont boldSystemFontOfSize:13];
    shapeDetailLabel.top = faceImage.top + 5;
    shapeDetailLabel.left = faceImage.right + 9;
    shapeDetailLabel.width = bgContainer.width - shapeDetailLabel.left - 16.5;
    [shapeDetailLabel sizeToFit];
    
    UILabel *shapeDetailLabel2 = [[UILabel alloc] init];
    [bgContainer addSubview:shapeDetailLabel2];
    shapeDetailLabel2.text = model.keywords_summary_2;
    shapeDetailLabel2.numberOfLines = 4;
    shapeDetailLabel2.font = [UIFont systemFontOfSize:13];
    shapeDetailLabel2.top = shapeDetailLabel.bottom + 8;
    shapeDetailLabel2.left = faceImage.right + 9;
    shapeDetailLabel2.width = bgContainer.width - shapeDetailLabel2.left - 16.5;
    [shapeDetailLabel2 sizeToFit];

    // 五官标题
    UILabel *featuresTitleLabel = [[UILabel alloc] init];
    [bgContainer addSubview:featuresTitleLabel];
    featuresTitleLabel.text = @"2. 五官特点";
    featuresTitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    featuresTitleLabel.textColor = [UIColor colorWithHexString:@"#262626"];
    [featuresTitleLabel sizeToFit];
    featuresTitleLabel.top = faceImage.bottom + 18;
    featuresTitleLabel.left = 12;
    
    PanelAItems *eyesView = [PanelAItems new];
    [bgContainer addSubview:eyesView];
    [eyesView loadViewWithTitle:@"眼睛" andContent:model.facial_features.eyes andImage:[UIImage imageNamed:@"senses_eyes"]];
    eyesView.top = featuresTitleLabel.bottom + 13;
    eyesView.left = 20;
    PanelAItems *noseView = [PanelAItems new];
    [bgContainer addSubview:noseView];
    [noseView loadViewWithTitle:@"鼻子" andContent:model.facial_features.nose andImage:[UIImage imageNamed:@"senses_nose"]];
    noseView.top = eyesView.top;
    noseView.left = eyesView.right + 11;

    PanelAItems *eyebrowsView = [PanelAItems new];
    [bgContainer addSubview:eyebrowsView];
    [eyebrowsView loadViewWithTitle:@"眼睛" andContent:model.facial_features.eyebrows andImage:[UIImage imageNamed:@"senses_eyebrows"]];
    eyebrowsView.top = eyesView.bottom + 11;
    eyebrowsView.left = 20;
    
    PanelAItems *mouthView = [PanelAItems new];
    [bgContainer addSubview:mouthView];
    [mouthView loadViewWithTitle:@"嘴唇" andContent:model.facial_features.lips andImage:[UIImage imageNamed:@"senses_mouth"]];
    mouthView.top = eyebrowsView.top;
    mouthView.left = eyebrowsView.right + 11;
    
    bgContainer.height = mouthView.bottom + 12;
    self.viewsContainer.height = bgContainer.bottom + 4;
    self.size = self.viewsContainer.size;
}

@end
