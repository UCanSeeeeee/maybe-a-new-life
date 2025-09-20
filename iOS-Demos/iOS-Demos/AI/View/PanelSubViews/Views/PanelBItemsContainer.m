//
//  PanelBItemsContainer.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/9.
//

#import "PanelBItemsContainer.h"
#import "PanelBItems.h"
#import "BaseFoundation.h"

@interface PanelBItemsContainer ()

@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *titles;
@property (nonatomic, strong) NSMutableArray<PanelBItems *> *itemViews;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *itemsContainer;

@end

@implementation PanelBItemsContainer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.bgImageView = [UIImageView new];
        self.bgImageView.size = CGSizeMake(264.75 * kScreenRatio, 172 * kScreenRatio);
        self.bgImageView.image = [UIImage imageNamed:@"colors_frame"];
        [self addSubview:self.bgImageView];
        self.itemsContainer = [UIView new];
        [self addSubview:self.itemsContainer];
        self.titles = @[
            @[@"甜美型", @"活泼型", @"少年型"],
            @[@"优雅型", @"自然型", @"前卫型"],
            @[@"魅力型", @"古典型", @"帅气型"]
        ];
        self.itemViews = [NSMutableArray array];
        CGFloat spacing = 8;
        CGFloat itemWidth = (260 - spacing * 2) / 3;
        CGFloat itemHeight = (172 - spacing * 2) / 3;
        self.itemsContainer.size = CGSizeMake(itemWidth * 3 + 16, itemHeight * 3 + 12);
        for (NSInteger row = 0; row < 3; row++) {
            for (NSInteger col = 0; col < 3; col++) {
                CGRect itemFrame = CGRectMake(col * (itemWidth + spacing),
                                              row * (itemHeight + 6),
                                              itemWidth,
                                              itemHeight);
                PanelBItems *itemView = [[PanelBItems alloc] initWithFrame:itemFrame];
                [self.itemsContainer addSubview:itemView];
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
    UILabel *labelV1 = [[UILabel alloc] init];
    [self addSubview:labelV1];
    labelV1.numberOfLines = 0;
    labelV1.textAlignment = NSTextAlignmentCenter;
    labelV1.font = [UIFont systemFontOfSize:FontSize(9)];
    labelV1.textColor = [UIColor grayColor];
    labelV1.text = @"五\n官\n量\n感\n大";
    [labelV1 sizeToFit];
    
    self.bgImageView.left = labelV1.right + 2;
    self.bgImageView.top = labelV1.top;
    self.itemsContainer.centerY = self.bgImageView.centerY - 1;
    self.itemsContainer.centerX = self.bgImageView.centerX;
    
    UILabel *labelV2 = [[UILabel alloc] init];
    [self addSubview:labelV2];
    labelV2.numberOfLines = 0;
    labelV2.textAlignment = NSTextAlignmentCenter;
    labelV2.font = [UIFont systemFontOfSize:FontSize(9)];
    labelV2.textColor = [UIColor grayColor];
    labelV2.text = @"五\n官\n量\n感\n小";
    [labelV2 sizeToFit];
    labelV2.centerX = labelV1.centerX;
    labelV2.bottom = self.bgImageView.bottom - 10;

    UILabel *leftLabel = [[UILabel alloc] init];
    [self addSubview:leftLabel];
    leftLabel.text = @"曲线型";
    leftLabel.font = [UIFont systemFontOfSize:FontSize(9)];
    leftLabel.textColor = [UIColor grayColor];
    [leftLabel sizeToFit];
    leftLabel.left = self.bgImageView.left + 8;
    leftLabel.top = self.bgImageView.bottom + 4;

    UILabel *rightLabel = [[UILabel alloc] init];
    [self addSubview:rightLabel];
    rightLabel.text = @"直线型";
    rightLabel.font = [UIFont systemFontOfSize:FontSize(9)];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.textColor = [UIColor grayColor];
    [rightLabel sizeToFit];
    rightLabel.right = self.bgImageView.right;
    rightLabel.top = self.bgImageView.bottom + 4;
    
    self.size = CGSizeMake(self.bgImageView.right, rightLabel.bottom);

}

@end
