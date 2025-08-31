//
//  FaceDetailViewController.m
//  iOS-Demos
//
//  Created by Chieh on 2025/7/19.
//

#import "ConclusionViewController.h"
#import "BaseFoundation.h"
#import "ResultDetailController.h"
#import "GlobalToolHandler.h"

@interface ConclusionViewController ()
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentContainer;

@property (nonatomic, strong) UIImageView *animateImage;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UIImageView *ageImage;

@property (nonatomic, strong) UIImageView *bottomBG;

@property (nonatomic, strong) UIButton *saveShareButton;
@property (nonatomic, strong) UIButton *fullReportButton;

// 拍照后的照片
@property (nonatomic, strong) UIImageView *photoPreviewImageView;

@end

@implementation ConclusionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"chieh Conclusion %@", self.dataModel);
    self.view.backgroundColor = [UIColor colorWithHexString:@"#8E969F"];

    self.photoPreviewImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.photoPreviewImageView.image = [GlobalToolHandler fetchGlobalModel].userPhotoImage;
    self.photoPreviewImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoPreviewImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.photoPreviewImageView];
    // 创建毛玻璃效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]; // 可以换成 ExtraLight 或 Dark
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.photoPreviewImageView.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; // 保证旋转或尺寸改变时自适应

    // 添加到 photoPreviewImageView 上
    [self.photoPreviewImageView addSubview:blurView];
    
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.contentContainer];
    
    [self.contentContainer addSubview:self.animateImage];
    [self.contentContainer addSubview:self.describeLabel];
    [self.contentContainer addSubview:self.ageImage];
    [self.contentContainer addSubview:self.bottomBG];
    [self.contentContainer addSubview:self.saveShareButton];
    [self.contentContainer addSubview:self.fullReportButton];
    
}
 
#pragma mark - 操作
- (void)closeButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)jumpToFaceDetailVC {
    [GlobalToolHandler pushResultDetailVC];
}

#pragma mark - 状态栏高度

- (CGFloat)statusBarHeight {
    if (@available(iOS 13.0, *)) {
        UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
        return keyWindow.windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

#pragma mark - 懒加载视图

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"CH_close_icon"] forState:UIControlStateNormal];
        _closeButton.frame = CGRectMake(10, 0, 40, 40);
        _closeButton.bottom = self.contentContainer.top - 8.5;
        [_closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"识别结果";
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        [_titleLabel sizeToFit];
        _titleLabel.centerX = self.view.width / 2.0;
        _titleLabel.centerY = self.closeButton.centerY;
    }
    return _titleLabel;
}

- (UIView *)contentContainer {
    if (!_contentContainer) {
        CGFloat height = 415 * kScreenRatio + kScreenRatio * 194 - 23 + 93 + SafeAreaBottomHeight;
        CGFloat top = self.view.height - height;
        _contentContainer = [[UIView alloc] initWithFrame:CGRectMake(0, top, self.view.bounds.size.width, height)];
        _contentContainer.backgroundColor = [UIColor colorWithHexString:@"#AFAC8C"];

        _contentContainer.layer.cornerRadius = 30;
        _contentContainer.layer.masksToBounds = YES;
        _contentContainer.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    }
    return _contentContainer;
}

- (UIImageView *)animateImage {
    if (!_animateImage) {
        _animateImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_dataModel.fetchAnimateStyle]];
        _animateImage.contentMode = UIViewContentModeScaleAspectFill;
        _animateImage.frame = CGRectMake(0, 0, kScreenWidth, 415 * kScreenRatio);
    }
    return _animateImage;
}

- (UILabel *)describeLabel {
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.text = _dataModel.animateDetail;
        _describeLabel.font = [UIFont systemFontOfSize:12];
        _describeLabel.textColor = [UIColor colorWithHexString:@"#262626"];
        _describeLabel.numberOfLines = 3;
        _describeLabel.textAlignment = NSTextAlignmentRight;
        _describeLabel.width = 140;
        [_describeLabel sizeToFit];
        _describeLabel.right = _animateImage.width - 25;
        _describeLabel.top = _animateImage.bottom - 82 - 57;
    }
    return _describeLabel;
}

- (UIImageView *)ageImage {
    if (!_ageImage) {
        UIImage *tempImage = [UIImage imageNamed:_dataModel.fetchAgeString];
        _ageImage = [[UIImageView alloc] initWithImage:tempImage];
        _ageImage.contentMode = UIViewContentModeScaleAspectFill;
        _ageImage.size = CGSizeMake(35 * tempImage.size.width / tempImage.size.height, 35);
        _ageImage.right = _animateImage.width - 25;
        _ageImage.bottom = _animateImage.bottom - 25;
    }
    return _ageImage;
}

- (UIImageView *)bottomBG {
    if (!_bottomBG) {
        UIImage *tempImage = [UIImage imageNamed:@"CH_conclusion_bg"];
        _bottomBG = [[UIImageView alloc] initWithImage:tempImage];
        _bottomBG.contentMode = UIViewContentModeScaleAspectFill;
        _bottomBG.size = CGSizeMake(kScreenWidth, kScreenRatio * 194);
        _bottomBG.top = self.animateImage.bottom - 23;
        UILabel *leftTitleLabel = [[UILabel alloc] init];
        leftTitleLabel.text = @"相似人物";
        leftTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        leftTitleLabel.textColor = [UIColor blackColor];
        [leftTitleLabel sizeToFit];
        leftTitleLabel.left = 58.5;
        leftTitleLabel.top = 47.5;
        UIView *leftUnderline = [[UIView alloc] init];
        leftUnderline.backgroundColor = [UIColor colorWithHexString:@"#FFA3EF"];
        leftUnderline.width = leftTitleLabel.width + 2;
        leftUnderline.height = 10;
        leftUnderline.left = leftTitleLabel.left;
        leftUnderline.bottom = leftTitleLabel.bottom;
        [_bottomBG addSubview:leftUnderline];
        [_bottomBG addSubview:leftTitleLabel];

        // ==== 左内容 ====
        UILabel *leftValueLabel = [[UILabel alloc] init];
        [_bottomBG addSubview:leftValueLabel];
        leftValueLabel.text = _dataModel.similarStar;
        leftValueLabel.font = [UIFont systemFontOfSize:12];
        leftValueLabel.textColor = [UIColor grayColor];
        [leftValueLabel sizeToFit];
        leftValueLabel.left = leftTitleLabel.left;
        leftValueLabel.top = leftTitleLabel.bottom + 4;

        // ==== 右标题 ====
        UILabel *rightTitleLabel = [[UILabel alloc] init];
        rightTitleLabel.text = @"妆容建议";
        rightTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        rightTitleLabel.textColor = [UIColor blackColor];
        [rightTitleLabel sizeToFit];
        rightTitleLabel.left = leftTitleLabel.right + 56.5;
        rightTitleLabel.top = leftTitleLabel.top;
        
        UIView *rightUnderline = [[UIView alloc] init];
        rightUnderline.backgroundColor = [UIColor colorWithHexString:@"#FFA3EF"];
        rightUnderline.width = rightTitleLabel.width + 2;
        rightUnderline.height = 10;
        rightUnderline.bottom = rightTitleLabel.bottom;
        rightUnderline.left = rightTitleLabel.left;
        [_bottomBG addSubview:rightUnderline];
        [_bottomBG addSubview:rightTitleLabel];
        

        // ==== 右内容 ====
        UILabel *rightValueLabel = [[UILabel alloc] init];
        [_bottomBG addSubview:rightValueLabel];
        rightValueLabel.text = _dataModel.recommendMakeup;
        rightValueLabel.font = [UIFont systemFontOfSize:12];
        rightValueLabel.textColor = [UIColor grayColor];
        [rightValueLabel sizeToFit];
        rightValueLabel.left = rightTitleLabel.left;
        rightValueLabel.top = rightTitleLabel.bottom + 4;

        // ==== 描述文本 ====
        UILabel *descriptionLabel = [[UILabel alloc] init];
        [_bottomBG addSubview:descriptionLabel];
        descriptionLabel.text = _dataModel.suggestion;
        descriptionLabel.font = [UIFont systemFontOfSize:12];
        descriptionLabel.textColor = [UIColor blackColor];
        descriptionLabel.numberOfLines = 4;
        descriptionLabel.width = 263;
        [descriptionLabel sizeToFit];
        descriptionLabel.left = leftTitleLabel.left;
        descriptionLabel.top = leftTitleLabel.bottom + 36;
    }
    return _bottomBG;
}

- (UIButton *)saveShareButton {
    if (!_saveShareButton) {
        _saveShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveShareButton.frame = CGRectMake(19, 0, 164.5, 58);
        _saveShareButton.bottom = self.contentContainer.height - SafeAreaBottomHeight;
        _saveShareButton.backgroundColor = [UIColor whiteColor];
        _saveShareButton.layer.cornerRadius = 24;
        _saveShareButton.layer.masksToBounds = YES;

        [_saveShareButton setTitle:@"关注我们" forState:UIControlStateNormal];
        [_saveShareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _saveShareButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];

        // 添加右侧图标（虚线圈图）
        UIImage *icon = [UIImage imageNamed:@"CH_share_icon"];
        [_saveShareButton setImage:icon forState:UIControlStateNormal];

        // 调整文字和图标间距（左文字右图）
        _saveShareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 107, 0, 0);
        _saveShareButton.titleEdgeInsets = UIEdgeInsetsMake(0, -18, 0, 18);
        [_saveShareButton addTarget:self action:@selector(jumpToShare) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveShareButton;
}

- (void)jumpToShare {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"xhsdiscover://user/63280d7800000000230254b8"] options:@{} completionHandler:nil];
}

- (UIButton *)fullReportButton {
    if (!_fullReportButton) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        _fullReportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullReportButton.frame = CGRectMake(screenWidth - 20 - 164.5, 0, 164.5, 58);
        _fullReportButton.bottom = self.contentContainer.height - SafeAreaBottomHeight;
        _fullReportButton.backgroundColor = [UIColor blackColor];
        _fullReportButton.layer.cornerRadius = 24;
        _fullReportButton.layer.masksToBounds = YES;

        [_fullReportButton setTitle:@"查看完整报告" forState:UIControlStateNormal];
        [_fullReportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _fullReportButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [_fullReportButton addTarget:self action:@selector(jumpToFaceDetailVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullReportButton;
}

@end
