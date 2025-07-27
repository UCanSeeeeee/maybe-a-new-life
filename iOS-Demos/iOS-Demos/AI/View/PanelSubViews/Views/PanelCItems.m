//
//  PanelCItems.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/11.
//

#import "PanelCItems.h"


@interface PanelCItems ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation PanelCItems

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [UIImageView new];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)loadViewWithTitle:(NSString *)title imageStr:(NSString *)imageStr values:(NSArray *)values {
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.titleLabel.text = title;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#262626"];

    [self.titleLabel sizeToFit];
    self.titleLabel.left = 12;
    self.titleLabel.top = 0;
    
    UIImage *tempImage = [UIImage imageNamed:imageStr];
    self.imageView.size = CGSizeMake(285, 285 * tempImage.size.height / tempImage.size.width * 1.0);
    self.imageView.image = tempImage;
    self.imageView.centerX = self.width / 2.0;
    self.imageView.top = self.titleLabel.bottom + 8;
    self.imageView.layer.cornerRadius = 16;
    self.imageView.clipsToBounds = YES;
    
    CGFloat labelY = CGRectGetMaxY(self.imageView.frame) + 12;
    for (NSString *text in values) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        label.text = text;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:13];
        label.numberOfLines = 0;
        label.width = 285;
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
        label.left = self.imageView.left - 1;
        label.top = labelY;
        labelY += (label.height + 8);
    }
    self.height = labelY + 8;
}

@end
