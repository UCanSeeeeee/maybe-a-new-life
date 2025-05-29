//
//  ScanViewController.m
//  iOS-Demos
//
//  Created by Chieh on 2025/5/29.
//

#import "ScanViewController.h"
#import "BaseFoundation.h"
@interface ScanViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *panelView;        // 外部容器
@property (nonatomic, strong) UIView *contentView;      // 内容视图
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture; // 滑动手势
@property (nonatomic, assign) CGFloat panelTopLimit;    // 顶部限制
@property (nonatomic, assign) CGFloat contentScrollY;   // 内容滚动位置
@property (nonatomic, assign) CGFloat maxContentScroll; // 内容最大滚动距离
@property (nonatomic, assign) BOOL isPanelAtTop;        // 面板是否在顶部

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化参数
    self.panelTopLimit = 100;
    self.contentScrollY = 0;
    self.isPanelAtTop = NO;
    
    // 设置面板视图
    [self setupPanelView];
    
    // 设置内容视图
    [self setupContentView];
    
    // 添加滑动手势
    [self setupPanGesture];
}

- (void)setupPanelView {
    // 创建面板视图
    CGFloat panelHeight = self.view.height * 1.3;
    self.panelView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height * 0.9, self.view.bounds.size.width, panelHeight)];
    self.panelView.backgroundColor = [UIColor whiteColor];
    self.panelView.layer.cornerRadius = 16;
    self.panelView.clipsToBounds = YES;
    
    // 添加三色渐变背景
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.panelView.bounds;
    gradient.colors = @[(__bridge id)[UIColor colorWithRed:0.9 green:0.4 blue:0.4 alpha:1.0].CGColor,
                        (__bridge id)[UIColor colorWithRed:0.4 green:0.9 blue:0.4 alpha:1.0].CGColor,
                        (__bridge id)[UIColor colorWithRed:0.4 green:0.4 blue:0.9 alpha:1.0].CGColor];
    gradient.startPoint = CGPointMake(0.0, 0.0);
    gradient.endPoint = CGPointMake(1.0, 1.0);
    [self.panelView.layer insertSublayer:gradient atIndex:0];
    
    [self.view addSubview:self.panelView];
}

- (void)setupContentView {
    // 创建内容视图容器
    self.contentView = [[UIView alloc] initWithFrame:self.panelView.bounds];
    self.contentView.height = self.view.height - 100;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.panelView addSubview:self.contentView];
    
    // 添加测试内容
    CGFloat labelHeight = 40;
    UIView *contentContainer = [[UIView alloc] initWithFrame:self.contentView.bounds];
    
    for (int i = 0; i < 30; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, i * labelHeight, self.contentView.bounds.size.width - 40, labelHeight)];
        label.text = [NSString stringWithFormat:@"第 %d 行内容", i + 1];
        label.textColor = [UIColor blackColor];
        [contentContainer addSubview:label];
    }
    
    [self.contentView addSubview:contentContainer];
    
    // 计算内容最大滚动距离
    self.maxContentScroll = 30 * labelHeight - self.contentView.bounds.size.height;
    if (self.maxContentScroll < 0) {
        self.maxContentScroll = 0;
    }
}

- (void)setupPanGesture {
    // 添加滑动手势到内容视图
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.panGesture.delegate = self;
    [self.contentView addGestureRecognizer:self.panGesture];
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
        initialPanelY = self.panelView.frame.origin.y;
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
        if (self.panelView.frame.origin.y > positionTop) {
            CGFloat finalY;
            
            // 根据速度和位置决定最终位置
            if (fabs(velocity.y) > 500) {
                finalY = velocity.y > 0 ? positionBottom : positionTop;
            } else {
                CGFloat midPoint = (positionTop + positionBottom) / 2;
                finalY = self.panelView.frame.origin.y < midPoint ? positionTop : positionBottom;
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
    CGRect frame = self.panelView.frame;
    frame.origin.y = yPosition;
    self.panelView.frame = frame;
    
    // 更新面板位置状态
    self.isPanelAtTop = (yPosition == self.panelTopLimit);
}

- (void)updateContentPosition {
    // 更新内容子视图的位置
    if (self.contentView.subviews.count > 0) {
        UIView *contentContainer = self.contentView.subviews[0];
        CGRect frame = contentContainer.frame;
        frame.origin.y = -self.contentScrollY;
        contentContainer.frame = frame;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 允许同时识别
    return YES;
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

@end
