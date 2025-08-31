//
//  ResultDetailController.m
//  iOS-Demos
//
//  Created by Chieh on 2025/5/29.
//

#import "ResultDetailController.h"
#import "BaseFoundation.h"
#import "PanelDSummary.h"

@interface ResultDetailController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *panelContainer;        // 外部容器
@property (nonatomic, strong) PanelDSummary *topView;
@property (nonatomic, strong) InfoPanelView *panelContentView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture; // 滑动手势
@property (nonatomic, assign) CGFloat panelTopLimit;    // 顶部限制
@property (nonatomic, assign) CGFloat contentScrollY;   // 内容滚动位置
@property (nonatomic, assign) CGFloat maxContentScroll; // 内容最大滚动距离
@property (nonatomic, assign) BOOL isPanelAtTop;        // 面板是否在顶部
@property (nonatomic, strong) UIView *buttonContainer;        // 按钮容器
@property (nonatomic, strong) NSArray<UIButton *> *sectionButtons;  // 分段按钮数组
@property (nonatomic, assign) NSInteger currentSectionIndex;  // 当前选中的段落索引

// 拍照后的照片
@property (nonatomic, strong) UIImageView *photoPreviewImageView;
@end

@implementation ResultDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化参数
    self.panelTopLimit = 100;
    self.contentScrollY = 0;
    self.isPanelAtTop = NO;
    
    self.photoPreviewImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.photoPreviewImageView.image = [GlobalToolHandler fetchGlobalModel].userPhotoImage;
    self.photoPreviewImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoPreviewImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.photoPreviewImageView];
    
    // 顶部左侧返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"photo_back_icon"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(20, 50, 40, 40);
    [backButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // 设置面板视图
    [self setupPanelView];
    
    // 设置内容视图
    [self setupContentView];
    
    // 添加滑动手势
    [self setupPanGesture];
}

- (void)setupPanelView {
    // 创建面板视图
    
    self.panelContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height * 0.9, self.view.bounds.size.width, self.view.height - self.panelTopLimit)];
    self.panelContainer.backgroundColor = [UIColor whiteColor];
    self.panelContainer.layer.cornerRadius = 16;
    self.panelContainer.clipsToBounds = YES;
    
    // 添加三色渐变背景
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.panelContainer.bounds;
    gradient.colors = @[(__bridge id)[UIColor colorWithRed:0.9 green:0.4 blue:0.4 alpha:0.2].CGColor,
                        (__bridge id)[UIColor colorWithRed:0.4 green:0.9 blue:0.4 alpha:0.2].CGColor,
                        (__bridge id)[UIColor colorWithRed:0.4 green:0.4 blue:0.9 alpha:0.2].CGColor];
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(1.0, 1.0);
    [self.panelContainer.layer insertSublayer:gradient atIndex:0];
    
    [self.view addSubview:self.panelContainer];
}

- (void)setupContentView {
    self.topView = [PanelDSummary new];
    [self.panelContainer addSubview:self.topView];
    [self.topView loadView];
    self.topView.top = 20;
    
    // 设置按钮组
    [self setupSectionButtons];
    
    UIView *clipContainer = [[UIView alloc] init];
    [self.panelContainer addSubview:clipContainer];
    self.panelContentView = [InfoPanelView new];
    [clipContainer addSubview:self.panelContentView];
    [self.panelContentView loadView];
    clipContainer.size = self.panelContentView.size;
    clipContainer.top = self.buttonContainer.bottom + 10;
    clipContainer.clipsToBounds = YES;
    
    self.maxContentScroll = self.panelContentView.bottom - self.panelContainer.bounds.size.height + clipContainer.top;
    if (self.maxContentScroll < 0) {
        self.maxContentScroll = 0;
    }
}

- (void)setupPanGesture {
    // 添加滑动手势到内容视图
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.panGesture.delegate = self;
//    UIView *tempGes = [UIView new];
    [self.panelContainer addGestureRecognizer:self.panGesture];
}

#pragma mark - 手势处理

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.view];
    CGPoint velocity = [gesture velocityInView:self.view];
    static CGFloat initialPanelY;
    static CGFloat initialContentY;
    
    CGFloat positionBottom = self.view.bounds.size.height * 0.9;
    CGFloat positionTop = self.panelTopLimit;
    
    // 手势开始时记录初始位置
    if (gesture.state == UIGestureRecognizerStateBegan) {
        initialPanelY = self.panelContainer.frame.origin.y;
        initialContentY = self.contentScrollY;
        [gesture setTranslation:CGPointZero inView:self.view];
        return;
    }
    
    // 处理滑动中的状态
    if (gesture.state == UIGestureRecognizerStateChanged) {
        // 向下滑动为正，向上滑动为负
        if (translation.y > 0) { // 向下滑动
            if (self.contentScrollY > 0) {
                // 如果内容已经滚动，先滚回顶部
                self.contentScrollY = MAX(0, initialContentY - translation.y);
                [self updateContentPosition];
            } else if (initialPanelY <= positionTop) {
                // 内容已经在顶部，且面板在顶部或以上位置，移动面板
                CGFloat newY = MIN(positionBottom, initialPanelY + translation.y);
                [self updatePanelPosition:newY];
            }
        } else { // 向上滑动
            if (initialPanelY > positionTop) {
                // 如果面板不在顶部，先将面板移到顶部
                CGFloat newY = MAX(positionTop, initialPanelY + translation.y);
                [self updatePanelPosition:newY];
            } else if (self.contentScrollY < self.maxContentScroll) {
                // 面板已经在顶部，滚动内容
                self.contentScrollY = MIN(self.maxContentScroll, initialContentY - translation.y);
                [self updateContentPosition];
            }
        }
    }
    
    // 处理手势结束状态
    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateCancelled) {
        
        // 计算面板最终位置
        if (self.panelContainer.frame.origin.y > positionTop) {
            CGFloat finalY;
            
            // 根据速度和位置决定最终位置
            if (fabs(velocity.y) > 500) {
                finalY = velocity.y > 0 ? positionBottom : positionTop;
            } else {
                CGFloat midPoint = (positionTop + positionBottom) / 2;
                finalY = self.panelContainer.frame.origin.y < midPoint ? positionTop : positionBottom;
            }
            
            // 更新面板状态
            self.isPanelAtTop = (finalY == positionTop);
            
            // 动画到最终位置
            [UIView animateWithDuration:0.3 animations:^{
                [self updatePanelPosition:finalY];
            }];
        }
        // 处理内容的惯性滚动
        else if (self.contentScrollY >= 0 && self.contentScrollY <= self.maxContentScroll) {
            // 计算内容的惯性滚动
            CGFloat finalContentY = self.contentScrollY;
            
            // 根据速度计算惯性滚动
            if (fabs(velocity.y) > 100) {
                // 速度转换为滚动距离 (大致模拟)
                CGFloat momentum = velocity.y * -0.3; // 反向，因为向上滑动时velocity为负
                finalContentY = self.contentScrollY + momentum;
                
                // 限制范围
                finalContentY = MAX(0, MIN(self.maxContentScroll, finalContentY));
            }
            
            // 动画到最终位置
            [UIView animateWithDuration:0.3 animations:^{
                self.contentScrollY = finalContentY;
                [self updateContentPosition];
            }];
        }
    }
}

#pragma mark - 位置更新
- (void)updatePanelPosition:(CGFloat)yPosition {
    CGRect frame = self.panelContainer.frame;
    frame.origin.y = yPosition;
    self.panelContainer.frame = frame;
    
    // 更新面板位置状态
    self.isPanelAtTop = (yPosition == self.panelTopLimit);
}

- (void)updateContentPosition {
    // 更新内容子视图的位置
    if (self.panelContainer.subviews.count > 0) {
        UIView *contentContainer = self.panelContentView;
        CGRect frame = contentContainer.frame;
        frame.origin.y = -self.contentScrollY;
        contentContainer.frame = frame;
        // 更新按钮状态
       [self updateSectionButtonsForOffset:self.contentScrollY];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 允许同时识别
    return YES;
}

#pragma mark - 控制板块
- (void)updateSectionButtonsForOffset:(CGFloat)offset {
    // 根据偏移量判断当前显示的是哪个部分
    NSInteger targetSection = 0;
    
    if (offset >= self.panelContentView.makeupView.top) {
        targetSection = 2;
    } else if (offset >= self.panelContentView.styleView.top) {
        targetSection = 1;
    }
    
    if (targetSection != self.currentSectionIndex) {
        [self updateSelectedButton:targetSection];
    }
}

- (void)setupSectionButtons {
    // 创建按钮容器
    self.buttonContainer = [[UIView alloc] init];
    [self.panelContainer addSubview:self.buttonContainer];
    self.buttonContainer.frame = CGRectMake(0, self.topView.bottom + 10, self.view.width, 40);
    
    // 创建三个按钮
    NSArray *titles = @[@"面部分析", @"风格定位", @"妆容推荐"];
    NSMutableArray *buttons = [NSMutableArray array];
    CGFloat buttonWidth = self.view.width / 3;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, 40);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [button setTitleColor:[UIColor colorWithHexString:@"#777777"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#262626"] forState:UIControlStateSelected];
        button.tag = i;
        [button addTarget:self action:@selector(sectionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonContainer addSubview:button];
        [buttons addObject:button];
    }
    
    self.sectionButtons = buttons;
    // 默认选中第一个按钮
    [self updateSelectedButton:0];
}

- (void)sectionButtonTapped:(UIButton *)sender {
    [self scrollToSection:sender.tag animated:YES];
}

- (void)scrollToSection:(NSInteger)sectionIndex animated:(BOOL)animated {
    // 更新按钮状态
    [self updateSelectedButton:sectionIndex];
    
    // 计算目标偏移量
    CGFloat targetOffset = 0;
    switch (sectionIndex) {
        case 0: // 面部分析
            targetOffset = 0;
            break;
        case 1: // 风格定位
            targetOffset = self.panelContentView.styleView.top;
            break;
        case 2: // 妆容推荐
            targetOffset = self.panelContentView.makeupView.top;
            break;
    }
    
    // 确保不超过最大滚动距离
    targetOffset = MIN(targetOffset, self.maxContentScroll);
    targetOffset = MAX(0, targetOffset);
    
    // 执行滚动动画
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentScrollY = targetOffset;
            [self updateContentPosition];
        }];
    } else {
        self.contentScrollY = targetOffset;
        [self updateContentPosition];
    }
}

- (void)updateSelectedButton:(NSInteger)selectedIndex {
    self.currentSectionIndex = selectedIndex;
    [self.sectionButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        button.selected = (idx == selectedIndex);
        // 可以添加更多选中状态的样式
        button.backgroundColor = (idx == selectedIndex) ? [UIColor colorWithWhite:0.9 alpha:1.0] : [UIColor clearColor];
    }];
}

#pragma mark - 外部接口

- (void)switchValueChanged:(UISwitch *)sender {
    CGFloat targetPosition = sender.isOn ? self.panelTopLimit : self.view.bounds.size.height * 0.9;
    
    // 更新面板位置状态
    self.isPanelAtTop = sender.isOn;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self updatePanelPosition:targetPosition];
    }];
}

- (void)dismissViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
