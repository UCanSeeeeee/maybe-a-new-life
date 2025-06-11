//
//  PanelAItems.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/7.
//

#import "PanelAItems.h"

@interface PanelAItems ()

@end

@implementation PanelAItems

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.size = CGSizeMake((kScreenWidth - 91) / 2, 107);
        self.layer.cornerRadius = 9.5;
        self.layer.masksToBounds = YES;
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds; // 根据实际视图调整 frame
        // 设置渐变颜色
        gradientLayer.colors = @[
            (__bridge id)[UIColor colorWithHexString:@"#FAFAFF"].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#F3F2FF"].CGColor
        ];
        // 设置渐变方向：由上至下（垂直）
        gradientLayer.startPoint = CGPointMake(0.5, 0.0);
        gradientLayer.endPoint = CGPointMake(0.5, 1.0);
        [self.layer insertSublayer:gradientLayer atIndex:0];
    }
    return self;
}

- (void)loadViewWithTitle:(NSString *)title andContent:(NSString *)content andImage:(UIImage *)image {
    UIImageView *icon = [[UIImageView alloc] initWithImage:image];
    [self addSubview:icon];
    icon.size = CGSizeMake(25, 25);
    icon.top = 16;
    icon.left = 9;
    
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:13];
    titleLabel.textColor = [UIColor colorWithHexString:@"#262626"];
    [titleLabel sizeToFit];
    titleLabel.left = icon.right + 6;
    titleLabel.centerY = icon.centerY;
    
    
    UILabel *subtitleLabel = [UILabel new];
    [self addSubview:subtitleLabel];
    subtitleLabel.numberOfLines = 2;
    subtitleLabel.font = [UIFont systemFontOfSize:12];
    subtitleLabel.textColor = [UIColor colorWithHexString:@"#262626"];
    subtitleLabel.width = self.width - 18;

    // 设置行间距和字距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7; // 行间距：根据需要调整

    NSDictionary *attributes = @{
        NSFontAttributeName: subtitleLabel.font,
        NSForegroundColorAttributeName: subtitleLabel.textColor,
        NSParagraphStyleAttributeName: paragraphStyle,
        NSKernAttributeName: @(0.5) // 字间距：根据需要调整
    };

    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    subtitleLabel.attributedText = attributedText;

    [subtitleLabel sizeToFit];
    subtitleLabel.left = icon.left;
    subtitleLabel.top = icon.bottom + 3;
}

@end
