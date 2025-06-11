//
//  PanelBItemsContainer.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/9.
//

#import "PanelBItemsContainer.h"
#import "PanelBItems.h"

@interface PanelBItemsContainer ()

@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *titles;
@property (nonatomic, strong) NSMutableArray<PanelBItems *> *itemViews;

@end

@implementation PanelBItemsContainer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titles = @[
            @[@"甜美型", @"活泼型", @"少年型"],
            @[@"优雅型", @"自然型", @"前卫型"],
            @[@"魅力型", @"古典型", @"帅气型"]
        ];
        self.itemViews = [NSMutableArray array];
        
        CGFloat spacing = 8;
        CGFloat itemWidth = (frame.size.width - spacing * 2) / 3;
        CGFloat itemHeight = (frame.size.height - spacing * 2) / 3;
        
        for (NSInteger row = 0; row < 3; row++) {
            for (NSInteger col = 0; col < 3; col++) {
                CGRect itemFrame = CGRectMake(col * (itemWidth + spacing),
                                              row * (itemHeight + spacing),
                                              itemWidth,
                                              itemHeight);
                PanelBItems *itemView = [[PanelBItems alloc] initWithFrame:itemFrame];
                [self addSubview:itemView];
                [self.itemViews addObject:itemView];
            }
        }
    }
    return self;
}

- (void)setHighlightedStyle:(NSString *)styleName highlightColor:(UIColor *)highlightColor {
    NSInteger index = 0;
    for (NSArray *row in self.titles) {
        for (NSString *title in row) {
            PanelBItems *itemView = self.itemViews[index];
            [itemView configureWithTitle:title highlighted:[title isEqualToString:styleName] highlightColor:highlightColor];
            index++;
        }
    }
    UILabel *labelV1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 40, 200)];
    labelV1.numberOfLines = 0;
    labelV1.textAlignment = NSTextAlignmentCenter;
    labelV1.font = [UIFont systemFontOfSize:14];
    labelV1.textColor = [UIColor grayColor];
    labelV1.text = @"五\n官\n量\n感\n大";
    [self addSubview:labelV1];
    
    UILabel *labelV2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 100, 40, 200)];
    labelV2.numberOfLines = 0;
    labelV2.textAlignment = NSTextAlignmentCenter;
    labelV2.font = [UIFont systemFontOfSize:14];
    labelV2.textColor = [UIColor grayColor];
    labelV2.text = @"五\n官\n量\n感\n小";
    [self addSubview:labelV2];
    
    CGFloat gridBottomY = self.frame.size.height + 8;

    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, gridBottomY, 60, 20)];
    leftLabel.text = @"曲线型";
    leftLabel.font = [UIFont systemFontOfSize:12];
    leftLabel.textColor = [UIColor grayColor];
    [self addSubview:leftLabel];

    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, gridBottomY, 60, 20)];
    rightLabel.text = @"直线型";
    rightLabel.font = [UIFont systemFontOfSize:12];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.textColor = [UIColor grayColor];
    [self addSubview:rightLabel];

    // 添加底部线
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(leftLabel.frame.origin.x + leftLabel.frame.size.width,
                                                                  gridBottomY + 10,
                                                                  rightLabel.frame.origin.x - leftLabel.frame.origin.x - leftLabel.frame.size.width,
                                                                  1)];
    bottomLine.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [self addSubview:bottomLine];
}

@end
