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

@interface PanelAFace ()
@property (nonatomic, strong) PanelAFaceModel *dataModel;
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
    self.viewsContainer.left = 0;
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
    self.titleLabel.font = [UIFont systemFontOfSize:FontSize(11)];
    self.titleLabel.text = @"面部分析";
    [self.titleLabel sizeToFit];
    [self.viewsContainer addSubview:self.titleLabel];
    self.titleLabel.centerY = self.titleImageView.centerY;
    self.titleLabel.left = self.titleImageView.right + 3;
}

- (void)loadView {
    GlobalModel *tempModel = GlobalToolHandler.fetchGlobalModel;
    self.dataModel = tempModel.panelAFaceModel;
    NSLog(@"chieh A %@", self.dataModel);
    UILabel *summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewsContainer.width - 32, 24)];
    [self.viewsContainer addSubview:summaryLabel];
    summaryLabel.text = [NSString stringWithFormat:@"%@+%@", tempModel.conclusionModel.fetchFaceStyleString, self.dataModel.faceFeatures];
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

    // 面型与轮廓标题
    UILabel *shapeTitleLabel = [[UILabel alloc] init];
    [bgContainer addSubview:shapeTitleLabel];
    shapeTitleLabel.text = @"1. 脸型与轮廓";
    shapeTitleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
    shapeTitleLabel.textColor = [UIColor colorWithHexString:@"#262626"];
    [shapeTitleLabel sizeToFit];
    shapeTitleLabel.top = 16;
    shapeTitleLabel.left = 12;

    NSString *tempString = @"biao";
    switch (tempModel.conclusionModel.faceStyle.integerValue) {
        case 1:
            tempString = @"chang";
            break;
        case 2:
            tempString = @"yuan";
            break;
        case 3:
            tempString = @"chang";
            break;
        case 4:
            tempString = @"li";
            break;
        case 5:
            tempString = @"gua";
            break;
        case 6:
            tempString = @"ling";
            break;
        case 0:
        default:
            break;
    }
    UIImageView *faceImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"face_%@", tempString]]];
    [bgContainer addSubview:faceImage];
    faceImage.size = CGSizeMake(105, 105);
    faceImage.left = 20;
    faceImage.top = shapeTitleLabel.bottom + 13;
    
    UILabel *shapeDetailLabel = [[UILabel alloc] init];
    [bgContainer addSubview:shapeDetailLabel];
    shapeDetailLabel.text = [NSString stringWithFormat:@"偏%@", tempModel.conclusionModel.fetchFaceStyleString];
    shapeDetailLabel.font = [UIFont boldSystemFontOfSize:FontSize(13)];
    shapeDetailLabel.top = faceImage.top + 5;
    shapeDetailLabel.left = faceImage.right + 9;
    shapeDetailLabel.width = bgContainer.width - shapeDetailLabel.left - 16.5;
    [shapeDetailLabel sizeToFit];
    
    UILabel *shapeDetailLabel2 = [[UILabel alloc] init];
    [bgContainer addSubview:shapeDetailLabel2];
    shapeDetailLabel2.numberOfLines = 4;
    shapeDetailLabel2.top = shapeDetailLabel.bottom + 8;
    shapeDetailLabel2.left = faceImage.right + 9;
    shapeDetailLabel2.width = bgContainer.width - shapeDetailLabel2.left - 16.5;
    
    // 设置文本和行间距
    NSString *detailText = tempModel.conclusionModel.fetchFaceStyleConclusionString;
    if (detailText && detailText.length > 0) {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:detailText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = LineSpacing(3);
        paragraphStyle.alignment = NSTextAlignmentLeft;
        [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, detailText.length)];
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FontSize(13)] range:NSMakeRange(0, detailText.length)];
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#262626"] range:NSMakeRange(0, detailText.length)];
        shapeDetailLabel2.attributedText = attributedText;
    } else {
        shapeDetailLabel2.text = detailText;
        shapeDetailLabel2.font = [UIFont systemFontOfSize:FontSize(13)];
    }
    [shapeDetailLabel2 sizeToFit];

    // 五官标题
    UILabel *featuresTitleLabel = [[UILabel alloc] init];
    [bgContainer addSubview:featuresTitleLabel];
    featuresTitleLabel.text = @"2. 五官特点";
    featuresTitleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
    featuresTitleLabel.textColor = [UIColor colorWithHexString:@"#262626"];
    [featuresTitleLabel sizeToFit];
    featuresTitleLabel.top = faceImage.bottom + 18;
    featuresTitleLabel.left = 12;
    
    PanelAItems *eyesView = [PanelAItems new];
    [bgContainer addSubview:eyesView];
    [eyesView loadViewWithTitle:@"眼睛" andContent:self.dataModel.eyes andImage:[UIImage imageNamed:@"senses_eyes"]];
    eyesView.top = featuresTitleLabel.bottom + 13;
    eyesView.left = 20;
    PanelAItems *noseView = [PanelAItems new];
    [bgContainer addSubview:noseView];
    [noseView loadViewWithTitle:@"鼻子" andContent:self.dataModel.nose andImage:[UIImage imageNamed:@"senses_nose"]];
    noseView.top = eyesView.top;
    noseView.left = eyesView.right + 11;

    PanelAItems *eyebrowsView = [PanelAItems new];
    [bgContainer addSubview:eyebrowsView];
    [eyebrowsView loadViewWithTitle:@"眼睛" andContent:self.dataModel.eyebrows andImage:[UIImage imageNamed:@"senses_eyebrows"]];
    eyebrowsView.top = eyesView.bottom + 11;
    eyebrowsView.left = 20;
    
    PanelAItems *mouthView = [PanelAItems new];
    [bgContainer addSubview:mouthView];
    [mouthView loadViewWithTitle:@"嘴唇" andContent:self.dataModel.lips andImage:[UIImage imageNamed:@"senses_mouth"]];
    mouthView.top = eyebrowsView.top;
    mouthView.left = eyebrowsView.right + 11;
    
    bgContainer.height = mouthView.bottom + 12;
    self.viewsContainer.height = bgContainer.bottom + 4;
    self.size = self.viewsContainer.size;
}

@end
