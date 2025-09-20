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
#import <Photos/Photos.h>

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
        NSString *text = [GlobalToolHandler formatAnimateDetailText:_dataModel.animateDetail];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = LineSpacing(4);
        paragraphStyle.alignment = NSTextAlignmentRight;
        [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FontSize(12)] range:NSMakeRange(0, text.length)];
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#262626"] range:NSMakeRange(0, text.length)];
        
        _describeLabel.attributedText = attributedText;
        _describeLabel.numberOfLines = 5;
        _describeLabel.textAlignment = NSTextAlignmentRight;
        _describeLabel.width = (kScreenWidth - 2 * 25) / 2.0;
        [_describeLabel sizeToFit];
        _describeLabel.right = self.animateImage.width - 25;
        _describeLabel.bottom = self.ageImage.top - 36;
    }
    return _describeLabel;
}

- (UIImageView *)ageImage {
    if (!_ageImage) {
        UIImage *tempImage = [UIImage imageNamed:_dataModel.fetchAgeString];
        _ageImage = [[UIImageView alloc] initWithImage:tempImage];
        _ageImage.contentMode = UIViewContentModeScaleAspectFill;
        _ageImage.size = CGSizeMake(35 * tempImage.size.width / tempImage.size.height, 35);
        _ageImage.right = self.animateImage.width - 25;
        _ageImage.bottom = self.animateImage.bottom - 25;
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
        leftUnderline.backgroundColor = [UIColor colorWithHexString:@"#FFE3FA"];
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
        leftValueLabel.font = [UIFont systemFontOfSize:FontSize(12)];
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
        rightUnderline.backgroundColor = [UIColor colorWithHexString:@"#FFE3FA"];
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
        rightValueLabel.font = [UIFont systemFontOfSize:FontSize(12)];
        rightValueLabel.textColor = [UIColor grayColor];
        [rightValueLabel sizeToFit];
        rightValueLabel.left = rightTitleLabel.left;
        rightValueLabel.top = rightTitleLabel.bottom + 4;

        // ==== 描述文本 ====
        UILabel *descriptionLabel = [[UILabel alloc] init];
        [_bottomBG addSubview:descriptionLabel];
        
        NSString *suggestionText = _dataModel.suggestion;
        NSMutableAttributedString *suggestionAttributedText = [[NSMutableAttributedString alloc] initWithString:suggestionText];
        NSMutableParagraphStyle *suggestionParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        suggestionParagraphStyle.lineSpacing = LineSpacing(9);
        suggestionParagraphStyle.alignment = NSTextAlignmentLeft;
        [suggestionAttributedText addAttribute:NSParagraphStyleAttributeName value:suggestionParagraphStyle range:NSMakeRange(0, suggestionText.length)];
        [suggestionAttributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FontSize(12)] range:NSMakeRange(0, suggestionText.length)];
        [suggestionAttributedText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, suggestionText.length)];
        
        descriptionLabel.attributedText = suggestionAttributedText;
        descriptionLabel.numberOfLines = 4;
        descriptionLabel.width = self.bottomBG.width - 2 * leftTitleLabel.left;
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

        [_saveShareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_saveShareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _saveShareButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];

        // 添加右侧图标（虚线圈图）
        UIImage *icon = [UIImage imageNamed:@"CH_share_icon"];
        [_saveShareButton setImage:icon forState:UIControlStateNormal];

        // 调整文字和图标间距（左文字右图）
        _saveShareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 107, 0, 0);
        _saveShareButton.titleEdgeInsets = UIEdgeInsetsMake(0, -18, 0, 18);
        [_saveShareButton addTarget:self action:@selector(saveInPhoteoLibrary) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveShareButton;
}

- (void)saveInPhoteoLibrary {
    // 检查相册权限
    [self checkPhotoLibraryPermissionAndSave];
}

#pragma mark - 海报生成和保存

- (void)checkPhotoLibraryPermissionAndSave {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusAuthorized) {
        [self generateAndSavePosterImage];
    } else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    [self generateAndSavePosterImage];
                } else {
                    [self showPermissionDeniedAlert];
                }
            });
        }];
    } else {
        [self showPermissionDeniedAlert];
    }
}

- (void)generateAndSavePosterImage {
    // 显示加载提示
    [self showLoadingIndicator];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *posterImage = [self createPosterImage];
            
            [self hideLoadingIndicator];
            
            if (posterImage) {
                [self savePosterImageToPhotoLibrary:posterImage];
            } else {
                [self showErrorAlert:@"生成海报失败，请重试"];
            }
        });
    });
}

- (UIImage *)createPosterImage {
    // 海报尺寸完全按照手机屏幕尺寸
    CGFloat posterWidth = kScreenWidth;
    CGFloat posterHeight = kScreenHeight;
    
    // 计算二维码区域高度：显著减少空白区域
    CGFloat qrCodeAreaHeight = posterHeight * 100.0 / 711.0; // 从127大幅调整为100，显著减少空白
    CGFloat contentAreaHeight = posterHeight - qrCodeAreaHeight;
    
    // 创建画布
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(posterWidth, posterHeight), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 1. 绘制统一背景色（与contentContainer保持一致，无分割线）
    CGContextSetFillColorWithColor(context, self.contentContainer.backgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, posterWidth, posterHeight));
    
    // 2. 绘制内容容器（无圆角版本，保持原始宽高比，不允许拉伸压缩）
    UIImage *contentImage = [self captureContentContainerWithoutCornerRadius];
    if (contentImage) {
        // 保持原始宽高比，不进行任何拉伸压缩
        CGFloat originalWidth = contentImage.size.width;
        CGFloat originalHeight = contentImage.size.height;
        
        // 如果内容图片超出内容区域，则按原始尺寸居中放置，超出部分会被裁剪
        // 如果内容图片小于内容区域，则按原始尺寸居中放置
        CGFloat contentX = (posterWidth - originalWidth) / 2;
        CGFloat contentY = (contentAreaHeight - originalHeight) / 2;
        
        // 确保内容不会绘制到二维码区域
        if (contentY + originalHeight > contentAreaHeight) {
            contentY = contentAreaHeight - originalHeight;
        }
        if (contentY < 0) {
            contentY = 0;
        }
        
        // 使用高质量绘制，避免边界锯齿
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        CGContextSetShouldAntialias(context, YES);
        [contentImage drawInRect:CGRectMake(contentX, contentY, originalWidth, originalHeight)];
        
        // 在内容图片底部边界处额外绘制一像素的背景色，确保无缝衔接
        if (contentY + originalHeight <= contentAreaHeight) {
            CGContextSetFillColorWithColor(context, self.contentContainer.backgroundColor.CGColor);
            CGContextFillRect(context, CGRectMake(0, contentY + originalHeight, posterWidth, 1));
        }
    }
    
    // 3. 绘制底部二维码区域（无分割线，与内容区域无缝衔接）
    [self drawQRCodeAreaInContext:context 
                            frame:CGRectMake(0, contentAreaHeight, posterWidth, qrCodeAreaHeight)];
    
    // 获取最终图片
    UIImage *posterImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return posterImage;
}

- (UIImage *)captureContentContainerWithoutCornerRadius {
    // 临时移除圆角
    CGFloat originalCornerRadius = self.contentContainer.layer.cornerRadius;
    CACornerMask originalMaskedCorners = self.contentContainer.layer.maskedCorners;
    
    self.contentContainer.layer.cornerRadius = 0;
    self.contentContainer.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    
    // 计算精确的截取高度：只到bottomBG的底部，确保无边界线
    CGFloat captureHeight = ceil(self.bottomBG.bottom); // 使用ceil确保像素对齐
    CGFloat containerWidth = self.contentContainer.bounds.size.width;
    
    // 创建新的画布，只绘制需要的区域
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(containerWidth, captureHeight), YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 设置背景色
    CGContextSetFillColorWithColor(context, self.contentContainer.backgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, containerWidth, captureHeight));
    
    // 设置抗锯齿和高质量渲染
    CGContextSetShouldAntialias(context, YES);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    // 分别绘制各个子视图到精确位置
    // 1. 绘制 animateImage
    if (self.animateImage && !self.animateImage.hidden) {
        CGRect animateFrame = self.animateImage.frame;
        if (animateFrame.origin.y + animateFrame.size.height <= captureHeight) {
            [self.animateImage.layer renderInContext:context];
        }
    }
    
    // 2. 绘制 describeLabel
    if (self.describeLabel && !self.describeLabel.hidden) {
        CGRect describeFrame = self.describeLabel.frame;
        if (describeFrame.origin.y + describeFrame.size.height <= captureHeight) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, describeFrame.origin.x, describeFrame.origin.y);
            [self.describeLabel.layer renderInContext:context];
            CGContextRestoreGState(context);
        }
    }
    
    // 3. 绘制 ageImage
    if (self.ageImage && !self.ageImage.hidden) {
        CGRect ageFrame = self.ageImage.frame;
        if (ageFrame.origin.y + ageFrame.size.height <= captureHeight) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, ageFrame.origin.x, ageFrame.origin.y);
            [self.ageImage.layer renderInContext:context];
            CGContextRestoreGState(context);
        }
    }
    
    // 4. 绘制 bottomBG（确保无底部横线）
    if (self.bottomBG && !self.bottomBG.hidden) {
        CGRect bottomFrame = self.bottomBG.frame;
        if (bottomFrame.origin.y < captureHeight) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, bottomFrame.origin.x, bottomFrame.origin.y);
            
            // 临时移除可能的边框
            CGFloat originalBorderWidth = self.bottomBG.layer.borderWidth;
            UIColor *originalBorderColor = [UIColor colorWithCGColor:self.bottomBG.layer.borderColor];
            
            self.bottomBG.layer.borderWidth = 0;
            self.bottomBG.layer.borderColor = [UIColor clearColor].CGColor;
            
            [self.bottomBG.layer renderInContext:context];
            
            // 恢复边框设置
            self.bottomBG.layer.borderWidth = originalBorderWidth;
            self.bottomBG.layer.borderColor = originalBorderColor.CGColor;
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *contentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 恢复圆角
    self.contentContainer.layer.cornerRadius = originalCornerRadius;
    self.contentContainer.layer.maskedCorners = originalMaskedCorners;
    
    return contentImage;
}

- (void)drawQRCodeAreaInContext:(CGContextRef)context frame:(CGRect)frame {
    // 二维码区域背景色与内容区域完全一致，无分割线
    // 注意：不重复绘制背景，避免产生视觉分割线
    
    // 布局参数
    CGFloat margin = 25; // 左右边距
    
    // 二维码整体大小：调整比例以适应新的区域高度
    CGFloat qrTotalSize = frame.size.height * 70.0 / 100.0; // 调整比例适应新的100/711区域
    CGFloat qrBorderWidth = 6.5; // 二维码白色边框宽度
    CGFloat qrSize = qrTotalSize - qrBorderWidth * 2; // 实际二维码大小
    
    CGFloat spacing = 12; // 图标和文字间距
    
    // === 左侧区域：图标 + 文案 ===
    CGFloat leftAreaX = frame.origin.x + margin;
    CGFloat leftAreaY = frame.origin.y;
    
    // 1. 绘制左侧图标（使用App图标或自定义图标）
    UIImage *appIcon = [UIImage imageNamed:@"home_top_center_image"];
    CGFloat iconX = leftAreaX;
    CGFloat iconY = leftAreaY + 0; // 进一步上移至3pt，最大化减少空白
    [appIcon drawInRect:CGRectMake(iconX, iconY, 20 * appIcon.size.width / appIcon.size.height , 20)];
    
    // 2. 绘制文案
    NSString *slogan = @"智绘容颜，Ai定义美学新维度";
    NSDictionary *textAttributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightMedium],
        NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#000000"]
    };
    
    CGFloat textX = iconX;
    CGFloat textY = iconY + 20 + spacing;
    
    [slogan drawAtPoint:CGPointMake(textX, textY) withAttributes:textAttributes];
    
    // === 右侧区域：二维码 + 白色边框 ===
    UIImage *qrCodeImage = [self generateQRCodeImageWithSize:qrSize];
    if (qrCodeImage) {
        // 计算二维码位置（右对齐，Y位置上移减少空白）
        CGFloat qrAreaX = frame.origin.x + frame.size.width - margin - qrTotalSize;
        CGFloat qrAreaY = frame.origin.y - 10; // 进一步上移至3pt，最大化减少空白
        
        // 绘制带圆角的白色边框
        UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(qrAreaX, qrAreaY, qrTotalSize, qrTotalSize) 
                                                              cornerRadius:6.5];
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddPath(context, borderPath.CGPath);
        CGContextFillPath(context);
        
        // 绘制二维码（也需要圆角裁剪）
        CGFloat qrX = qrAreaX + qrBorderWidth;
        CGFloat qrY = qrAreaY + qrBorderWidth;
        
        // 保存图形状态
        CGContextSaveGState(context);
        
        // 创建二维码的圆角裁剪路径
        UIBezierPath *qrClipPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(qrX, qrY, qrSize, qrSize) 
                                                              cornerRadius:6.5 - qrBorderWidth];
        CGContextAddPath(context, qrClipPath.CGPath);
        CGContextClip(context);
        
        // 绘制二维码
        [qrCodeImage drawInRect:CGRectMake(qrX, qrY, qrSize, qrSize)];
        
        // 恢复图形状态
        CGContextRestoreGState(context);
    }
}

- (UIImage *)getAppIconImage {
    // 尝试获取App图标
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSArray *iconFiles = infoPlist[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
    
    if (iconFiles.count > 0) {
        NSString *iconName = iconFiles.lastObject; // 获取最大的图标
        UIImage *appIcon = [UIImage imageNamed:iconName];
        if (appIcon) {
            return appIcon;
        }
    }
    
    // 如果获取不到App图标，使用默认图标或自定义图标
    UIImage *defaultIcon = [UIImage imageNamed:@"home_top_center_image"]; // 使用项目中的图标
    if (defaultIcon) {
        return defaultIcon;
    }
    
    // 如果都没有，创建一个简单的占位图标
    return [self createPlaceholderIcon];
}

- (UIImage *)createPlaceholderIcon {
    CGFloat size = 40;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 绘制圆形背景
    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"#AFAC8C"].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, size, size));
    
    // 绘制文字
    NSString *text = @"AI";
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
        NSForegroundColorAttributeName: [UIColor whiteColor]
    };
    
    CGSize textSize = [text sizeWithAttributes:attributes];
    CGFloat textX = (size - textSize.width) / 2;
    CGFloat textY = (size - textSize.height) / 2;
    
    [text drawAtPoint:CGPointMake(textX, textY) withAttributes:attributes];
    
    UIImage *placeholderIcon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return placeholderIcon;
}

- (UIImage *)generateQRCodeImageWithSize:(CGFloat)targetSize {
    // 生成二维码的内容（可以是App下载链接、网站链接等）
    // ⭐️
    NSString *qrContent = @"https://your-app-link.com"; // 替换为实际的链接
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:[qrContent dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    if (!qrImage) return nil;
    
    // 根据目标尺寸动态调整二维码大小
    CGFloat scaleX = targetSize / qrImage.extent.size.width;
    CGFloat scaleY = targetSize / qrImage.extent.size.height;
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    // 转换为UIImage
    CIContext *context = [CIContext context];
    CGImageRef cgImage = [context createCGImage:qrImage fromRect:qrImage.extent];
    UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return uiImage;
}

// 保留原方法以防其他地方调用
- (UIImage *)generateQRCodeImage {
    return [self generateQRCodeImageWithSize:60]; // 默认60px
}

- (void)savePosterImageToPhotoLibrary:(UIImage *)posterImage {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetCreationRequest creationRequestForAssetFromImage:posterImage];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [self showSuccessAlert:@"海报已保存到相册"];
            } else {
                NSString *errorMessage = error ? error.localizedDescription : @"保存失败，请重试";
                [self showErrorAlert:errorMessage];
            }
        });
    }];
}

#pragma mark - 提示框和加载指示器

- (void)showLoadingIndicator {
    // 简单的加载提示
    UIAlertController *loadingAlert = [UIAlertController alertControllerWithTitle:@"正在生成海报..." 
                                                                          message:nil 
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:loadingAlert animated:YES completion:nil];
}

- (void)hideLoadingIndicator {
    if (self.presentedViewController && [self.presentedViewController isKindOfClass:[UIAlertController class]]) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showSuccessAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"成功" 
                                                                   message:message 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" 
                                                       style:UIAlertActionStyleDefault 
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showErrorAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" 
                                                                   message:message 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" 
                                                       style:UIAlertActionStyleDefault 
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showPermissionDeniedAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"需要相册权限" 
                                                                   message:@"请在设置中开启相册访问权限以保存海报" 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"去设置" 
                                                             style:UIAlertActionStyleDefault 
                                                           handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] 
                                           options:@{} 
                                 completionHandler:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" 
                                                           style:UIAlertActionStyleCancel 
                                                         handler:nil];
    
    [alert addAction:settingsAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
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
        _fullReportButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
        [_fullReportButton addTarget:self action:@selector(jumpToFaceDetailVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullReportButton;
}

@end
