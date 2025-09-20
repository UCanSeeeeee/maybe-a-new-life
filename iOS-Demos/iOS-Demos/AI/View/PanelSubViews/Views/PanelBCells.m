//
//  PanelBCells.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/9.
//

#import "PanelBCells.h"
#import "BaseFoundation.h"

@interface PanelBCells ()
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *rightLabel;
@end

@implementation PanelBCells

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.leftLabel = [UILabel new];
        self.leftLabel.font = [UIFont systemFontOfSize:FontSize(13) weight:UIFontWeightMedium];
        self.leftLabel.textColor = [UIColor colorWithHexString:@"#262626"];
        self.leftLabel.textAlignment = NSTextAlignmentCenter;
        self.leftLabel.layer.cornerRadius = 8;
        self.leftLabel.clipsToBounds = YES;
        self.rightLabel = [UILabel new];
        self.rightLabel.font = [UIFont systemFontOfSize:FontSize(13) weight:UIFontWeightRegular];
        self.rightLabel.textColor = [UIColor colorWithHexString:@"#262626"];
        self.iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"style_arrow_icon"]];
        self.iconView.size = CGSizeMake(12, 12);
        [self addSubview:self.leftLabel];
        [self addSubview:self.iconView];
        [self addSubview:self.rightLabel];
    }
    return self;
}

- (void)loadViewWithTitle:(NSString *)title andContent:(NSString *)content {
    if (content && content.length > 0) {
        self.leftLabel.text = title;
        [self.leftLabel sizeToFit];
        self.leftLabel.size = CGSizeMake(self.leftLabel.width + 18, self.leftLabel.height + 8);
        self.leftLabel.backgroundColor = [UIColor colorWithHexString:@"#F8F6F5"];
        self.iconView.centerY = self.leftLabel.centerY;
        self.iconView.left = self.leftLabel.right + 4;
        self.rightLabel.numberOfLines = 2;
        self.rightLabel.width = self.width - self.iconView.right - 4 - 17;
        self.rightLabel.left = self.iconView.right + 4;
        self.rightLabel.top = self.leftLabel.top;
        
        // 设置文本和行间距
        if (content && content.length > 0) {
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:content];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = LineSpacing(2);
            paragraphStyle.alignment = NSTextAlignmentLeft;
            [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
            [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FontSize(13) weight:UIFontWeightRegular] range:NSMakeRange(0, content.length)];
            [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#262626"] range:NSMakeRange(0, content.length)];
            self.rightLabel.attributedText = attributedText;
        } else {
            self.rightLabel.text = content;
        }
        
        [self.rightLabel sizeToFit];
        self.height = MAX(self.leftLabel.bottom, self.rightLabel.bottom);
    } else {
        self.hidden = YES;
    }
}

@end
