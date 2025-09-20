//
//  ResultDetailController.m
//  iOS-Demos
//
//  Created by Chieh on 2025/5/29.
//

#import "ResultDetailController.h"
#import "BaseFoundation.h"
#import "PanelDSummary.h"
#import <YYCategories/YYCategories.h>

// MARK: - Constants
static const CGFloat kBackButtonSize = 40.0;       // 返回按钮尺寸
static const CGFloat kBackButtonMargin = 20.0;     // 返回按钮边距
static const CGFloat kSectionButtonHeight = 40.0;  // 分段按钮高度
static const CGFloat kContentTopMargin = 20.0;     // 内容顶部边距
static const CGFloat kContentBottomMargin = 20.0;  // 内容底部边距
static const CGFloat kSectionSpacing = 10.0;       // 区块间距
static const CGFloat kPopupImageViewHeight = 314.5; // 弹窗图片高度
static const CGFloat kPopupAnimationDuration = 0.3; // 弹窗动画时长

// MARK: - User Defaults Keys
static NSString * const kMakeupPopupShownKey = @"MakeupPopupHasBeenShown";

// MARK: - Section Types
typedef NS_ENUM(NSInteger, ResultSection) {
    ResultSectionFaceAnalysis = 0,  // 面部分析
    ResultSectionStyleGuide,        // 风格定位
    ResultSectionMakeupRecommend    // 妆容推荐
};

@interface ResultDetailController () <UIScrollViewDelegate>

// MARK: - UI Components
@property (nonatomic, strong) UIView *containerView;           // 主容器
@property (nonatomic, strong) UIScrollView *mainScrollView;    // 主滚动视图
@property (nonatomic, strong) UIView *scrollContentView;      // 滚动内容容器
@property (nonatomic, strong) PanelDSummary *summaryView;     // 顶部摘要视图
@property (nonatomic, strong) UIView *segmentedControlView;   // 分段控制器容器
@property (nonatomic, strong) InfoPanelView *detailPanelView; // 详情面板视图

// MARK: - Controls
@property (nonatomic, strong) NSArray<UIButton *> *segmentButtons;  // 分段按钮数组
@property (nonatomic, assign) ResultSection currentSection;         // 当前选中的段落
@property (nonatomic, assign) CGFloat segmentedControlOriginalY;    // segmentedControlView的原始Y坐标

// MARK: - Popup Components
@property (nonatomic, strong) UIImageView *makeupPopupImageView;    // 妆容推荐弹窗图片
@property (nonatomic, assign) BOOL isPopupShown;                    // 弹窗是否已显示
@property (nonatomic, assign) BOOL hasReachedMakeupSection;         // 是否已到达妆容推荐区域

@end

@implementation ResultDetailController

// MARK: - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupContainerView];
    [self setupScrollView];
    [self setupContentViews];
}

// MARK: - Setup Methods
- (void)setupNavigationBar {
    // 返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backIcon = [UIImage imageNamed:@"photo_back_icon"];
    // 将白色图片转换为黑色
    UIImage *blackBackIcon = [backIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backButton setImage:blackBackIcon forState:UIControlStateNormal];
    backButton.tintColor = [UIColor blackColor];
    backButton.frame = CGRectMake(kBackButtonMargin, 0, kBackButtonSize, kBackButtonSize);
    backButton.bottom = SafeAreaTopHeight + 40;
    
    [backButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // 标题文案
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"面部美学报告";
    titleLabel.textColor = [UIColor colorWithHexString:@"#262626"];
    titleLabel.font = [UIFont systemFontOfSize:FontSize(14)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(self.view.width / 2, backButton.centerY);
    [self.view addSubview:titleLabel];
    
    // 分享按钮
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *shareIcon = [UIImage imageNamed:@"CH_share_icon"];
    // 调整图片大小为 15x15
    UIImage *resizedShareIcon = [self resizeImage:shareIcon toSize:CGSizeMake(20, 20)];
    [shareButton setImage:resizedShareIcon forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(self.view.width - kBackButtonMargin - kBackButtonSize, 0, kBackButtonSize, kBackButtonSize);
    shareButton.centerY = backButton.centerY;
    [shareButton addTarget:self action:@selector(shareButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
}

- (void)setupContainerView {
    CGFloat containerHeight = self.view.height - (SafeAreaTopHeight + 45);
    CGFloat containerY = SafeAreaTopHeight + 45;
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, containerY, self.view.width, containerHeight)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.clipsToBounds = YES;
    
    [self.view addSubview:self.containerView];
}

- (void)setupScrollView {
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.containerView.bounds];
    self.mainScrollView.delegate = self;
    self.mainScrollView.showsVerticalScrollIndicator = YES;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.containerView addSubview:self.mainScrollView];
    
    // 创建滚动内容容器
    self.scrollContentView = [[UIView alloc] init];
    [self.mainScrollView addSubview:self.scrollContentView];
}

- (void)setupContentViews {
    [self setupSummaryView];
    [self setupSegmentedControl];
    [self setupDetailPanelView];
    [self setupMakeupPopupImageView];
    [self updateScrollViewContentSize];
}

- (void)setupSummaryView {
    self.summaryView = [PanelDSummary new];
    [self.scrollContentView addSubview:self.summaryView];
    [self.summaryView loadView];
    self.summaryView.top = kContentTopMargin;
}

- (void)setupSegmentedControl {
    self.segmentedControlView = [[UIView alloc] init];
    [self.scrollContentView addSubview:self.segmentedControlView];
    
    // 计算并保存原始Y坐标
    self.segmentedControlOriginalY = self.summaryView.bottom + kSectionSpacing;
    self.segmentedControlView.frame = CGRectMake(0, 
                                                self.segmentedControlOriginalY, 
                                                self.containerView.width, 
                                                kSectionButtonHeight);
    
    // 设置背景色以便在吸顶时有清晰的视觉效果
    self.segmentedControlView.backgroundColor = [UIColor whiteColor];
    
    NSArray<NSString *> *sectionTitles = @[@"面部分析", @"风格定位", @"妆容推荐"];
    [self createSegmentButtonsWithTitles:sectionTitles];
    // 确保在所有装饰视图添加完成后再设置初始选中状态
    dispatch_async(dispatch_get_main_queue(), ^{
        [self selectSegmentAtIndex:ResultSectionFaceAnalysis];
    });
}

- (void)setupDetailPanelView {
    self.detailPanelView = [InfoPanelView new];
    [self.scrollContentView addSubview:self.detailPanelView];
    [self.scrollContentView bringSubviewToFront:self.segmentedControlView];
    [self.detailPanelView loadAndLayoutPanels];
    self.detailPanelView.top = self.segmentedControlView.bottom + kSectionSpacing;
}

- (void)setupMakeupPopupImageView {
    // 检查用户是否已经看过弹窗
//    if ([self hasMakeupPopupBeenShown]) {
//        return;
//    }
    
    CGFloat popupHeight = kPopupImageViewHeight * kScreenRatio;
    self.makeupPopupImageView = [[UIImageView alloc] init];
    self.makeupPopupImageView.frame = CGRectMake(0, self.view.height, kScreenWidth, popupHeight);
    self.makeupPopupImageView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    self.makeupPopupImageView.userInteractionEnabled = YES;
    self.makeupPopupImageView.hidden = YES;
    
    // 设置圆角（仅顶部）
    self.makeupPopupImageView.layer.cornerRadius = 20.0;
    self.makeupPopupImageView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    
    // 添加阴影效果
    self.makeupPopupImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.makeupPopupImageView.layer.shadowOffset = CGSizeMake(0, -2);
    self.makeupPopupImageView.layer.shadowOpacity = 0.1;
    self.makeupPopupImageView.layer.shadowRadius = 8.0;
    
    // 添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopupImageView)];
    [self.makeupPopupImageView addGestureRecognizer:tapGesture];
    
    // 添加到主视图（而不是滚动视图）
    [self.view addSubview:self.makeupPopupImageView];
    
    // 初始化状态
    self.isPopupShown = NO;
    self.hasReachedMakeupSection = NO;
}

- (void)updateScrollViewContentSize {
    CGFloat contentHeight = self.detailPanelView.bottom + kContentBottomMargin;
    self.scrollContentView.frame = CGRectMake(0, 0, self.containerView.width, contentHeight);
    self.mainScrollView.contentSize = CGSizeMake(self.containerView.width, contentHeight);
}

// MARK: - UI Helpers
- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (void)addDecorationViewsToButton:(UIButton *)button isLastButton:(BOOL)isLastButton {
    // 背景图 - 70*27pt，每个按钮都有，但只在选中时显示
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = [UIImage imageNamed:@"detail_button_bg"];
    backgroundImageView.frame = CGRectMake(0, 0, 70, 27);
    backgroundImageView.centerX = button.bounds.size.width / 2;
    backgroundImageView.bottom = button.bounds.size.height;
    backgroundImageView.tag = 1001; // 设置tag用于查找
    backgroundImageView.hidden = YES; // 初始隐藏，后续通过selectSegmentAtIndex控制显示
    [button insertSubview:backgroundImageView atIndex:0]; // 插入到最底层
    
    // 右侧图标 - 28*14pt，只有最后一个按钮才有，一直显示
    if (isLastButton) {
        UIImageView *hotIconImageView = [[UIImageView alloc] init];
        hotIconImageView.image = [UIImage imageNamed:@"detail_button_hot"];
        hotIconImageView.frame = CGRectMake(0, 0, 28, 14);
        hotIconImageView.tag = 1002; // 设置tag用于查找
        
        // 计算按钮文字的尺寸和位置，让图标紧贴文字右侧
        CGSize textSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
        CGFloat textCenterX = button.bounds.size.width / 2;
        CGFloat textRightEdge = textCenterX + textSize.width / 2;
        
        // 图标紧贴文字右侧，添加2pt间距
        hotIconImageView.left = textRightEdge + 2;
        hotIconImageView.centerY = button.bounds.size.height / 2;
        // 右侧图标一直显示，不受选中状态影响
        [button addSubview:hotIconImageView];
    }
}

- (void)createSegmentButtonsWithTitles:(NSArray<NSString *> *)titles {
    NSMutableArray *buttons = [NSMutableArray array];
    CGFloat buttonWidth = self.containerView.width / titles.count;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [self createSegmentButtonWithTitle:titles[i] 
                                                        frame:CGRectMake(buttonWidth * i, 0, buttonWidth, kSectionButtonHeight)
                                                          tag:i];
        [self.segmentedControlView addSubview:button];
        [buttons addObject:button];
        
        // 为每个按钮添加装饰视图
        [self addDecorationViewsToButton:button isLastButton:(i == titles.count - 1)];
    }
    
    self.segmentButtons = [buttons copy];
}

- (UIButton *)createSegmentButtonWithTitle:(NSString *)title frame:(CGRect)frame tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightMedium];
    [button setTitleColor:[UIColor colorWithHexString:@"#777777"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#262626"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(segmentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

// MARK: - Segment Control
- (void)segmentButtonTapped:(UIButton *)sender {
    ResultSection targetSection = (ResultSection)sender.tag;
    
    // 如果点击的是妆容推荐按钮，检查是否需要显示弹窗
    if (targetSection == ResultSectionMakeupRecommend) {
        [self showPopupImageViewIfNeeded];
    }
    
    // 然后执行滚动动画
    [self scrollToSection:targetSection animated:YES];
    // 立即更新按钮选中状态和视觉效果
    [self selectSegmentAtIndex:targetSection];
}

- (void)scrollToSection:(ResultSection)section animated:(BOOL)animated {
    // 如果当前section已经是目标section，不需要重复选中
    if (self.currentSection != section) {
        [self selectSegmentAtIndex:section];
    }
    
    CGFloat targetOffset = [self offsetForSection:section];
    CGFloat maxOffset = MAX(0, self.mainScrollView.contentSize.height - self.mainScrollView.frame.size.height);
    targetOffset = MIN(targetOffset, maxOffset);
    targetOffset = MAX(0, targetOffset);
    
    [self.mainScrollView setContentOffset:CGPointMake(0, targetOffset + 1) animated:animated];
}

- (CGFloat)offsetForSection:(ResultSection)section {
    switch (section) {
        case ResultSectionFaceAnalysis:
            return 0;
        case ResultSectionStyleGuide:
            return self.detailPanelView.styleGuidePanel.top;
        case ResultSectionMakeupRecommend:
            return self.detailPanelView.makeupRecommendPanel.top;
    }
}

- (void)selectSegmentAtIndex:(ResultSection)section {
    self.currentSection = section;
    [self.segmentButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        BOOL isSelected = (idx == section);
        button.selected = isSelected;
        
        // 更新背景图显示状态
        UIImageView *backgroundImageView = [button viewWithTag:1001];
        if (backgroundImageView) {
            backgroundImageView.hidden = !isSelected;
        }
    }];
}

- (void)updateSegmentSelectionForScrollOffset:(CGFloat)offset {
    ResultSection targetSection = ResultSectionFaceAnalysis;
    
    if (offset >= self.detailPanelView.makeupRecommendPanel.top) {
        targetSection = ResultSectionMakeupRecommend;
    } else if (offset >= self.detailPanelView.styleGuidePanel.top) {
        targetSection = ResultSectionStyleGuide;
    }
    
    if (targetSection != self.currentSection) {
        [self selectSegmentAtIndex:targetSection];
    }
}

// MARK: - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateSegmentSelectionForScrollOffset:scrollView.contentOffset.y];
    [self updateSegmentedControlStickyPosition:scrollView.contentOffset.y];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 滑动结束后检查是否在妆容推荐区域
    [self checkAndShowPopupAfterScrollEnd:scrollView.contentOffset.y];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 如果没有减速，立即检查
    if (!decelerate) {
        [self checkAndShowPopupAfterScrollEnd:scrollView.contentOffset.y];
    }
}

- (void)updateSegmentedControlStickyPosition:(CGFloat)scrollOffsetY {
    // 计算segmentedControlView相对于scrollView顶部的位置
    CGFloat segmentedControlRelativeY = self.segmentedControlOriginalY - scrollOffsetY;
    
    // 如果segmentedControlView即将滚出顶部，则让它吸附在顶部
    if (segmentedControlRelativeY <= 0) {
        // 吸顶状态：固定在scrollView的顶部
        CGRect stickyFrame = self.segmentedControlView.frame;
        stickyFrame.origin.y = scrollOffsetY;
        self.segmentedControlView.frame = stickyFrame;
    } else {
        // 正常状态：保持原始位置
        CGRect normalFrame = self.segmentedControlView.frame;
        normalFrame.origin.y = self.segmentedControlOriginalY;
        self.segmentedControlView.frame = normalFrame;
    }
}

// MARK: - Popup Management
- (void)checkAndShowPopupAfterScrollEnd:(CGFloat)offset {
    // 滑动结束后，如果在妆容推荐区域，延迟显示弹窗
    if (offset >= self.detailPanelView.makeupRecommendPanel.top) {
        // 添加短暂延迟，确保滑动完全停止
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showPopupImageViewIfNeeded];
        });
    }
}

- (void)showPopupImageViewIfNeeded {
    // 检查是否应该显示弹窗
    if (self.makeupPopupImageView && !self.isPopupShown && !self.hasReachedMakeupSection) {
        self.hasReachedMakeupSection = YES;
        [self showPopupImageView];
    }
}

- (void)showPopupImageView {
    if (self.isPopupShown || !self.makeupPopupImageView) {
        return;
    }
    
    self.isPopupShown = YES;
    self.makeupPopupImageView.hidden = NO;
    
    // 禁用滚动视图滚动
    self.mainScrollView.scrollEnabled = NO;
    
    // 从底部弹出动画
    [UIView animateWithDuration:kPopupAnimationDuration 
                          delay:0 
                        options:UIViewAnimationOptionCurveEaseOut 
                     animations:^{
        CGFloat popupHeight = kPopupImageViewHeight * kScreenRatio;
        self.makeupPopupImageView.frame = CGRectMake(0, self.view.height - popupHeight, kScreenWidth, popupHeight);
    } completion:nil];
}

- (void)hidePopupImageView {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"xhsdiscover://user/63280d7800000000230254b8"] options:@{} completionHandler:nil];
    if (!self.isPopupShown || !self.makeupPopupImageView) {
        return;
    }
    // 记录用户已经看过弹窗
    [self setMakeupPopupHasBeenShown:YES];
    
    // 隐藏动画
    [UIView animateWithDuration:kPopupAnimationDuration 
                          delay:0 
                        options:UIViewAnimationOptionCurveEaseIn 
                     animations:^{
        self.makeupPopupImageView.frame = CGRectMake(0, self.view.height, kScreenWidth, kPopupImageViewHeight * kScreenRatio);
    } completion:^(BOOL finished) {
        self.makeupPopupImageView.hidden = YES;
        self.isPopupShown = NO;
        
        // 恢复滚动视图滚动
        self.mainScrollView.scrollEnabled = YES;
        
        // 移除弹窗视图（因为用户已经看过了）
        [self.makeupPopupImageView removeFromSuperview];
        self.makeupPopupImageView = nil;
    }];
}

// MARK: - User Defaults Management
- (BOOL)hasMakeupPopupBeenShown {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kMakeupPopupShownKey];
}

- (void)setMakeupPopupHasBeenShown:(BOOL)shown {
    [[NSUserDefaults standardUserDefaults] setBool:shown forKey:kMakeupPopupShownKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// MARK: - Actions
- (void)dismissViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonTapped {
    // TODO: 实现分享功能
    NSLog(@"分享按钮被点击");
}

@end
