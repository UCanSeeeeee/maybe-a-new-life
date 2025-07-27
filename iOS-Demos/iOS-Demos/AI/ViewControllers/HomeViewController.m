//
//  HomeViewController.m
//  iOS-Demos
//
//  Created by Chieh on 2025/5/25.
//

#import "HomeViewController.h"
#import "BaseFoundation.h"
#import "HomeViewController+Action.h"
#import "TakePhotosViewController.h"
#import "ConclusionViewController.h"
#import "GlobalModel.h"
#import <SDWebImage/SDAnimatedImageView.h>
#import <SDWebImage/SDAnimatedImage.h>

@interface HomeViewController ()
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) SDAnimatedImageView *centerImageView;
@property (nonatomic, strong) UIButton *mainButton;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGradientBackground];
    [self setupUI];
}

- (void)setupGradientBackground {
    NSLog(@"SafeAreaTopHeight:%f", SafeAreaTopHeight);
    NSLog(@"SafeAreaBottomHeight:%f", SafeAreaBottomHeight);
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = @[(__bridge id)[UIColor colorWithRed:1 green:0.8 blue:0.9 alpha:1].CGColor,
                        (__bridge id)[UIColor whiteColor].CGColor];
    gradient.startPoint = CGPointMake(0.5, 0.0);
    gradient.endPoint = CGPointMake(0.5, 1.0);
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    // 如果还有阴影图片：
    UIImageView *shadowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_bg_cover"]];
    shadowImg.width = self.view.width;
    shadowImg.height = 330;
    shadowImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:shadowImg];
}

- (void)setupUI {
    // 顶部 Logo
    self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_top_center_image"]];
    self.logoView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoView.frame = CGRectMake(0, SafeAreaTopHeight, 90, 25);
    self.logoView.center = CGPointMake(self.view.center.x, self.logoView.center.y);
    [self.view addSubview:self.logoView];

    // 设置按钮
    self.settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.settingButton setImage:[UIImage imageNamed:@"home_top_right_image"] forState:UIControlStateNormal];
    self.settingButton.frame = CGRectMake(self.view.frame.size.width - 50, 0, 30, 30);
    self.settingButton.centerY = self.logoView.centerY;
    [self.settingButton addTarget:self action:@selector(showSettingPopup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.settingButton];

    // 中间图
    NSString *path = [[NSBundle mainBundle] pathForResource:@"home_center" ofType:@"webp"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    // 构建带帧的 AnimatedImage
    SDAnimatedImage *animatedImage = [[SDAnimatedImage alloc] initWithData:data];
    self.centerImageView = [[SDAnimatedImageView alloc] initWithImage:animatedImage];
    self.centerImageView.size = CGSizeMake(170, 170);
    self.centerImageView.centerX = self.view.width / 2.0;
    self.centerImageView.top = 222 * kScreenRatio;
    self.centerImageView.center = CGPointMake(self.view.center.x, self.centerImageView.center.y);
    [self.view addSubview:self.centerImageView];

    // 底部横排 item（用 stack 简单模拟）
    NSArray *icons = @[@"homt_bottom_1", @"homt_bottom_2", @"homt_bottom_3"];
    NSArray *strings = @[@"智能面部分析", @"精准妆容定制", @"明星脸型匹配"];
    CGFloat iconSize = 40;
    CGFloat spacing = (self.view.frame.size.width - 3 * iconSize) / 4;
    for (int i = 0; i < icons.count; i++) {
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icons[i]]];
        img.frame = CGRectMake(spacing + i * (iconSize + spacing), self.view.frame.size.height - (205 + iconSize), iconSize, iconSize);
        [self.view addSubview:img];
        UILabel *label = [UILabel new];
        label.text = strings[i];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        [label sizeToFit];
        label.centerX = img.centerX;
        label.top = img.bottom + 6;
        [self.view addSubview:label];
    }

    // 测一测按钮
    self.mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mainButton.frame = CGRectMake(40, self.view.frame.size.height - (105 + 58), self.view.frame.size.width - 80, 50);
    [self.mainButton setTitle:@"测一测" forState:UIControlStateNormal];
    self.mainButton.backgroundColor = [UIColor blackColor];
    self.mainButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.mainButton.layer.cornerRadius = 25;
    [self.mainButton addTarget:self action:@selector(takePhotosVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mainButton];
}

- (void)takePhotosVC {
    TakePhotosViewController *vc = [TakePhotosViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
