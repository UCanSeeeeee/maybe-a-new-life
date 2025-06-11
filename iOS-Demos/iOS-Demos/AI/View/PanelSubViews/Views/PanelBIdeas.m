//
//  PanelBIdeas.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/10.
//

#import "PanelBIdeas.h"

@interface PanelBIdeas ()

@end

@implementation PanelBIdeas

- (void)loadViewWithModel:(StylePositioning *)model {
    
    UIView *containerView = [UIView new];
    [self addSubview:containerView];
    containerView.width = self.width - 38;
    containerView.height = 29.5;
    containerView.left = 19;
    containerView.backgroundColor = [UIColor colorWithHexString:@"#F8F6F5"];
    containerView.layer.cornerRadius = 9.5;
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    titleLabel.text = model.makeup_strategy;
    titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    titleLabel.textColor = [UIColor colorWithHexString:@"#262626"];
    [titleLabel sizeToFit];
    titleLabel.centerY = containerView.centerY;
    titleLabel.left = containerView.left + 9;
    CGFloat padding = 24.5;
    CGFloat labelSpacing = 8.0;
    CGFloat currentY = titleLabel.bottom + 12;
    
    UIFont *textFont = [UIFont systemFontOfSize:13];
    UIColor *textColor = [UIColor colorWithHexString:@"#333333"];
    
    for (NSInteger i = 0; i < model.makeup_focus_points.count; i++) {
        NSString *text = [NSString stringWithFormat:@"%ld·   %@", (long)i + 1, model.makeup_focus_points[i]];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = text;
        label.font = textFont;
        label.textColor = textColor;
        label.numberOfLines = 0;
        
        CGFloat maxWidth = self.bounds.size.width - 2 * padding;
        CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
        CGRect textRect = [label.text boundingRectWithSize:maxSize
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName: textFont}
                                                    context:nil];
        label.frame = CGRectMake(padding, currentY, maxWidth, ceil(textRect.size.height));
        [self addSubview:label];
        
        currentY += ceil(textRect.size.height) + labelSpacing;
    }
    
    // 更新自身高度（可选）
    CGRect frame = self.frame;
    frame.size.height = currentY;
    self.frame = frame;
}

@end
