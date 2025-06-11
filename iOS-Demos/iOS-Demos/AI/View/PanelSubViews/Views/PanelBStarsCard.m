//
//  PanelBStarsCard.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/9.
//

#import "PanelBStarsCard.h"

@interface PanelBStarsCard ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *celebrityLabel;
@end

@implementation PanelBStarsCard

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupGradientBackground];
        [self setupSubviews];
    }
    return self;
}

- (void)setupGradientBackground {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = @[
        (__bridge id)[UIColor colorWithRed:0xF4/255.0 green:0xF3/255.0 blue:0xFE/255.0 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0xF8/255.0 green:0xF4/255.0 blue:0xF0/255.0 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0xF8/255.0 green:0xF4/255.0 blue:0xF0/255.0 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:0xF6/255.0 green:0xE4/255.0 blue:0xF1/255.0 alpha:1].CGColor
    ];
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(1, 0.5);
    gradient.cornerRadius = 12;
    [self.layer insertSublayer:gradient atIndex:0];
}

- (void)setupSubviews {
    self.layer.cornerRadius = 12;
    self.clipsToBounds = YES;
    
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"参考明星";
    self.titleLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightRegular];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel sizeToFit];
    
    self.celebrityLabel = [[UILabel alloc] init];
    [self addSubview:self.celebrityLabel];
    self.celebrityLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    self.celebrityLabel.textColor = [UIColor colorWithHexString:@"#262626"];
    self.celebrityLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)loadViewWithModel:(StylePositioning *)model {
    self.titleLabel.top = 16;
    self.titleLabel.centerX = self.width / 2.0;
    self.celebrityLabel.text = [model.reference_celebrities componentsJoinedByString:@"、"];
    [self.celebrityLabel sizeToFit];
    self.celebrityLabel.centerX = self.width / 2.0;
    self.celebrityLabel.top = self.titleLabel.bottom + 7;

    // 创建底部推荐标签
    NSInteger maxCount = MIN(model.recommended_makeup_styles.count, 3);
    NSArray *makeupStyles = [model.recommended_makeup_styles subarrayWithRange:NSMakeRange(0, maxCount)];

    if (makeupStyles.count > 0) {
        CGFloat containerWidth = self.width - 18;
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, containerWidth, 0)];
        container.backgroundColor = UIColor.clearColor;

        NSInteger count = makeupStyles.count;
        CGFloat spacing = 12;
        CGFloat labelWidth = (containerWidth - spacing * (count - 1)) / count;

        CGFloat maxLabelHeight = 0;

        for (int i = 0; i < makeupStyles.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.text = makeupStyles[i];
            label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
            label.textColor = [UIColor colorWithHexString:@"#262626"];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = UIColor.clearColor;
            [label sizeToFit];

            CGRect labelFrame = label.frame;
            maxLabelHeight = MAX(maxLabelHeight, labelFrame.size.height);
        }

        CGFloat labelHeight = maxLabelHeight + 8;

        CGFloat x = 0;
        for (int i = 0; i < makeupStyles.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, labelWidth, labelHeight)];
            label.text = makeupStyles[i];
            label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
            label.textColor = [UIColor colorWithHexString:@"#262626"];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = UIColor.clearColor;

            [container addSubview:label];
            x += labelWidth;

            if (i < makeupStyles.count - 1) {
                UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(x, 6, 0.5, labelHeight - 12)];
                separator.backgroundColor = [UIColor colorWithHexString:@"#E3E1E1"];
                [container addSubview:separator];
                x += spacing;
            }
        }

        container.frame = CGRectMake(0, 0, containerWidth, labelHeight);
        container.bottom = self.height - 9;
        container.centerX = self.width / 2.0;
        [self addSubview:container];
        container.backgroundColor = UIColor.whiteColor;
        container.layer.cornerRadius = 8;
    }
}

@end
