//
//  PanelBItems.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/9.
//

#import "PanelBItems.h"
#import "BaseFoundation.h"

@implementation PanelBItems

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 8;
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
//        self.backgroundColor = UIColor.whiteColor;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor grayColor];
        [self addSubview:_titleLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}

- (void)configureWithTitle:(NSString *)title highlighted:(BOOL)isHighlighted highlightColor:(UIColor *)highlightColor {
    self.titleLabel.text = title;
    if (isHighlighted) {
        self.backgroundColor = highlightColor;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    } else {
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F6F5"];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }

}

@end
