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

@interface SettingPopupView () <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSArray<SettingItemModel *> *> *dataSource;
@end

@implementation SettingPopupView

+ (void)showInView:(UIView *)parentView {
    SettingPopupView *popupView = [[SettingPopupView alloc] initWithFrame:parentView.bounds];
    [parentView addSubview:popupView];
    [UIView animateWithDuration:0.25 animations:^{
        popupView.backgroundView.alpha = 1.0;
        popupView.containerView.transform = CGAffineTransformIdentity;
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
        [self setupUI];
        // 点击背景关闭
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackgroundTap:)];
        [self.backgroundView addGestureRecognizer:tap];
    }
    return self;
}

- (void)setupUI {
    // 背景蒙层
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.backgroundView.alpha = 0;
    [self addSubview:self.backgroundView];
    
    // 底部弹窗容器
    CGFloat topSpacing = 61;
    CGFloat bottomSpacing = 56;
    CGFloat containerHeight = 385 + 35 + topSpacing + bottomSpacing;
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - containerHeight, self.frame.size.width, containerHeight)];
    self.containerView.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
    self.containerView.layer.cornerRadius = 20;
    self.containerView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.containerView.transform = CGAffineTransformMakeTranslation(0, containerHeight);
    [self addSubview:self.containerView];
    
    // 标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"设置";
    title.font = [UIFont boldSystemFontOfSize:17];
    [title sizeToFit];
    title.center = CGPointMake(self.containerView.bounds.size.width / 2, 30);
    [self.containerView addSubview:title];
    
    // 设置表格
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topSpacing, self.containerView.frame.size.width, 385 + 35) style:UITableViewStyleInsetGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.dataSource = self;
    [self.containerView addSubview:self.tableView];
}

- (void)dismiss {
//    [self removeFromSuperview];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0;
        self.containerView.transform = CGAffineTransformMakeTranslation(0, self.containerView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - TableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    SettingItemModel *item = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.text = item.title;
    cell.imageView.image = [UIImage imageNamed:item.iconName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"fuck u");
    SettingItemModel *item = self.dataSource[indexPath.section][indexPath.row];
    if (item.actionBlock) {
        item.actionBlock();
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor clearColor];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - Data Setup

- (void)setupData {
    __weak typeof(self) weakSelf = self;
    
    SettingItemModel *item1 = [self itemWithTitle:@"给我们好评" icon:@"setting_page_star" action:^{
        NSLog(@"fuck u 1");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id123456789"] options:@{} completionHandler:nil];
    }];
    
    SettingItemModel *item2 = [self itemWithTitle:@"意见反馈" icon:@"setting_page_mail" action:^{
        NSLog(@"fuck u 2");
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
            mailVC.mailComposeDelegate = self;

            [mailVC setSubject:@"chieh"];
            [mailVC setToRecipients:@[@"chieh504@qq.com"]]; // 收件人
            [mailVC setMessageBody:@"hello" isHTML:NO];
            [[UIApplication sharedApplication].windows.firstObject.rootViewController presentViewController:mailVC animated:YES completion:nil];
        } else {
            NSURL *url = [NSURL URLWithString:@"mailto:chieh504@qq.com"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        }
        // 跳转反馈页面
//        [weakSelf.navigationController pushViewController:[FeedbackViewController new] animated:YES];
    }];
    
    SettingItemModel *item3 = [self itemWithTitle:@"关注我们" icon:@"setting_page_redbook" action:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"xhsdiscover://user/63280d7800000000230254b8"] options:@{} completionHandler:nil];
        // 展示二维码页面
//        [weakSelf showQRCode];
    }];
    
    SettingItemModel *item4 = [self itemWithTitle:@"加入微信群" icon:@"setting_page_wechat" action:^{
        // 展示微信群弹窗
//        [weakSelf showWeChatGroupAlert];
    }];
    
    SettingItemModel *item5 = [self itemWithTitle:@"隐私政策" icon:@"setting_page_secret" action:^{
//        [weakSelf openWebViewWithURL:@"https://xxx.com/privacy"];
    }];
    
    SettingItemModel *item6 = [self itemWithTitle:@"使用协议" icon:@"setting_page_license" action:^{
//        [weakSelf openWebViewWithURL:@"https://xxx.com/agreement"];
    }];
    
    SettingItemModel *item7 = [self itemWithTitle:@"退出登录" icon:@"setting_page_sigh_out" action:^{
//        [weakSelf handleLogout];
    }];
    
    self.dataSource = @[
        @[item1, item2, item3, item4],
        @[item5, item6],
        @[item7]
    ];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (SettingItemModel *)itemWithTitle:(NSString *)title icon:(NSString *)icon action:(void(^)(void))action {
    SettingItemModel *item = [[SettingItemModel alloc] init];
    item.title = title;
    item.iconName = icon;
    item.actionBlock = action;
    return item;
}


// 然后添加这个方法:
- (void)handleBackgroundTap:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self];
    if (!CGRectContainsPoint(self.containerView.frame, location)) {
        [self dismiss];
    }
}

@end
