//
//  SettingPopupView.m
//  iOS-Demos
//
//  Created by Chieh on 2025/5/25.
//

#import "SettingPopupView.h"
#import "SettingItemModel.h"
#import "BaseFoundation.h"
#import <MessageUI/MessageUI.h>

// MARK: - Constants
static const CGFloat kAnimationDuration = 0.25;           // 动画时长
static const CGFloat kBackgroundAlpha = 0.4;              // 背景透明度
static const CGFloat kContainerCornerRadius = 20.0;       // 容器圆角
static const CGFloat kTitleTopMargin = 30.0;              // 标题顶部边距
static const CGFloat kTopSpacing = 61.0;                  // 顶部间距
static const CGFloat kBottomSpacing = 56.0;               // 底部间距
static const CGFloat kTableViewHeight = 420.0;            // 表格视图高度
static const CGFloat kCellHeight = 55.0;                  // 单元格高度

// MARK: - External URLs
static NSString * const kAppStoreURL = @"itms-apps://itunes.apple.com/app/id123456789";
static NSString * const kRedBookURL = @"xhsdiscover://user/63280d7800000000230254b8";
static NSString * const kFeedbackEmail = @"chieh504@qq.com";

@interface SettingPopupView () <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

// MARK: - UI Components
@property (nonatomic, strong) UIView *popupContainer;      // 弹窗容器
@property (nonatomic, strong) UIView *maskBackground;      // 蒙层背景
@property (nonatomic, strong) UITableView *settingsTable; // 设置表格
@property (nonatomic, strong) UILabel *titleLabel;        // 标题标签

// MARK: - Data
@property (nonatomic, strong) NSArray<NSArray<SettingItemModel *> *> *settingSections; // 设置项数据

@end

@implementation SettingPopupView

// MARK: - Class Methods
+ (void)showInParentView:(UIView *)parentView {
    SettingPopupView *popupView = [[SettingPopupView alloc] initWithFrame:parentView.bounds];
    [parentView addSubview:popupView];
    [popupView showWithAnimation];
}

// MARK: - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSettingItems];
        [self setupUserInterface];
        [self setupGestureRecognizers];
    }
    return self;
}

// MARK: - Public Methods
- (void)dismissWithAnimation {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.maskBackground.alpha = 0;
        self.popupContainer.transform = CGAffineTransformMakeTranslation(0, self.popupContainer.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// MARK: - Private Methods
- (void)showWithAnimation {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.maskBackground.alpha = 1.0;
        self.popupContainer.transform = CGAffineTransformIdentity;
    }];
}

- (void)setupGestureRecognizers {
    UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackgroundTap:)];
    [self.maskBackground addGestureRecognizer:backgroundTap];
}

- (void)setupUserInterface {
    [self setupMaskBackground];
    [self setupPopupContainer];
    [self setupTitleLabel];
    [self setupSettingsTable];
}

- (void)setupMaskBackground {
    self.maskBackground = [[UIView alloc] initWithFrame:self.bounds];
    self.maskBackground.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kBackgroundAlpha];
    self.maskBackground.alpha = 0;
    [self addSubview:self.maskBackground];
}

- (void)setupPopupContainer {
    CGFloat containerHeight = kTableViewHeight + kTopSpacing + kBottomSpacing;
    CGRect containerFrame = CGRectMake(0, 
                                     self.frame.size.height - containerHeight, 
                                     self.frame.size.width, 
                                     containerHeight);
    
    self.popupContainer = [[UIView alloc] initWithFrame:containerFrame];
    self.popupContainer.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
    self.popupContainer.layer.cornerRadius = kContainerCornerRadius;
    self.popupContainer.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.popupContainer.transform = CGAffineTransformMakeTranslation(0, containerHeight);
    [self addSubview:self.popupContainer];
}

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"设置";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:FontSize(17)];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.popupContainer.bounds.size.width / 2, kTitleTopMargin);
    [self.popupContainer addSubview:self.titleLabel];
}

- (void)setupSettingsTable {
    CGRect tableFrame = CGRectMake(0, kTopSpacing, self.popupContainer.frame.size.width, kTableViewHeight);
    self.settingsTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleInsetGrouped];
    self.settingsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.settingsTable.backgroundColor = UIColor.clearColor;
    self.settingsTable.delegate = self;
    self.settingsTable.dataSource = self;
    self.settingsTable.showsVerticalScrollIndicator = NO;
    [self.popupContainer addSubview:self.settingsTable];
}

// MARK: - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.settingSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingSections[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SettingTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:FontSize(16)];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    SettingItemModel *settingItem = self.settingSections[indexPath.section][indexPath.row];
    cell.textLabel.text = settingItem.title;
    cell.imageView.image = [UIImage imageNamed:settingItem.iconName];
    return cell;
}

// MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SettingItemModel *settingItem = self.settingSections[indexPath.section][indexPath.row];
    if (settingItem.actionBlock) {
        settingItem.actionBlock();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

// MARK: - Data Setup
- (void)setupSettingItems {
    __weak typeof(self) weakSelf = self;
    
    // 第一组：社交互动相关
    SettingItemModel *rateAppItem = [self createSettingItemWithTitle:@"给我们好评" 
                                                                 icon:@"setting_page_star" 
                                                               action:^{
        [weakSelf openAppStoreForRating];
    }];
    
    SettingItemModel *feedbackItem = [self createSettingItemWithTitle:@"意见反馈" 
                                                                  icon:@"setting_page_mail" 
                                                                action:^{
        [weakSelf showFeedbackOptions];
    }];
    
    SettingItemModel *followUsItem = [self createSettingItemWithTitle:@"关注我们" 
                                                                  icon:@"setting_page_redbook" 
                                                                action:^{
        [weakSelf openRedBookProfile];
    }];
    
    SettingItemModel *wechatGroupItem = [self createSettingItemWithTitle:@"加入微信群" 
                                                                     icon:@"setting_page_wechat" 
                                                                   action:^{
        [weakSelf showWeChatGroupInfo];
    }];
    
    // 第二组：法律条款相关
    SettingItemModel *privacyPolicyItem = [self createSettingItemWithTitle:@"隐私政策" 
                                                                       icon:@"setting_page_secret" 
                                                                     action:^{
        [weakSelf openPrivacyPolicy];
    }];
    
    SettingItemModel *termsOfServiceItem = [self createSettingItemWithTitle:@"使用协议" 
                                                                        icon:@"setting_page_license" 
                                                                      action:^{
        [weakSelf openTermsOfService];
    }];
    
    // 第三组：账户相关
    SettingItemModel *logoutItem = [self createSettingItemWithTitle:@"退出登录" 
                                                                icon:@"setting_page_sigh_out" 
                                                              action:^{
        [weakSelf handleLogout];
    }];
    
    self.settingSections = @[
        @[rateAppItem, feedbackItem, followUsItem, wechatGroupItem],
        @[privacyPolicyItem, termsOfServiceItem],
        @[logoutItem]
    ];
}

// MARK: - Helper Methods
- (SettingItemModel *)createSettingItemWithTitle:(NSString *)title icon:(NSString *)iconName action:(void(^)(void))actionBlock {
    SettingItemModel *settingItem = [[SettingItemModel alloc] init];
    settingItem.title = title;
    settingItem.iconName = iconName;
    settingItem.actionBlock = actionBlock;
    return settingItem;
}

- (void)handleBackgroundTap:(UITapGestureRecognizer *)gesture {
    CGPoint tapLocation = [gesture locationInView:self];
    if (!CGRectContainsPoint(self.popupContainer.frame, tapLocation)) {
        [self dismissWithAnimation];
    }
}

// MARK: - Action Handlers
- (void)openAppStoreForRating {
    NSURL *appStoreURL = [NSURL URLWithString:kAppStoreURL];
    [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:nil];
}

- (void)showFeedbackOptions {
    if ([MFMailComposeViewController canSendMail]) {
        [self presentMailComposer];
    } else {
        [self openMailApp];
    }
}

- (void)presentMailComposer {
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"应用反馈"];
    [mailComposer setToRecipients:@[kFeedbackEmail]];
    [mailComposer setMessageBody:@"请在此输入您的反馈内容..." isHTML:NO];
    
    UIViewController *rootViewController = [UIApplication sharedApplication].windows.firstObject.rootViewController;
    [rootViewController presentViewController:mailComposer animated:YES completion:nil];
}

- (void)openMailApp {
    NSString *mailURLString = [NSString stringWithFormat:@"mailto:%@", kFeedbackEmail];
    NSURL *mailURL = [NSURL URLWithString:mailURLString];
    if ([[UIApplication sharedApplication] canOpenURL:mailURL]) {
        [[UIApplication sharedApplication] openURL:mailURL options:@{} completionHandler:nil];
    }
}

- (void)openRedBookProfile {
    NSURL *redBookURL = [NSURL URLWithString:kRedBookURL];
    [[UIApplication sharedApplication] openURL:redBookURL options:@{} completionHandler:nil];
}

- (void)showWeChatGroupInfo {
    // TODO: 实现微信群信息展示
    NSLog(@"显示微信群信息");
}

- (void)openPrivacyPolicy {
    // TODO: 实现隐私政策页面跳转
    NSLog(@"打开隐私政策");
}

- (void)openTermsOfService {
    // TODO: 实现使用协议页面跳转
    NSLog(@"打开使用协议");
}

- (void)handleLogout {
    // TODO: 实现退出登录逻辑
    NSLog(@"处理退出登录");
}

// MARK: - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

// MARK: - Legacy Methods (for backward compatibility)
- (void)dismiss {
    [self dismissWithAnimation];
}

+ (void)showInView:(UIView *)parentView {
    [self showInParentView:parentView];
}

@end
