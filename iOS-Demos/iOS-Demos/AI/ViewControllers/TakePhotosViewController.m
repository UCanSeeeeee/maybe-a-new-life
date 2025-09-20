//
//  TakePhotosViewController.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/15.
//

#import "TakePhotosViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "BaseFoundation.h"
#import "GlobalToolHandler.h"
#import <libextobjc/extobjc.h>
#import "ConclusionViewController.h"
#import "GlobalToolHandler+Promise.h"
#import <SDWebImage/SDAnimatedImageView.h>
#import <SDWebImage/SDAnimatedImage.h>

@interface TakePhotosViewController () <AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCapturePhotoOutput *photoOutput;
// 拍照后的照片
@property (nonatomic, strong) UIImageView *photoPreviewImageView;
@property (nonatomic, copy) void (^hiddenBlock)(void);
@property (nonatomic, strong) SDAnimatedImageView *centerImageView;

@end

@implementation TakePhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self setupCamera];
    
}

- (void)setupCamera {
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession
        discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera]
        mediaType:AVMediaTypeVideo
        position:AVCaptureDevicePositionFront];

    AVCaptureDevice *device = discoverySession.devices.firstObject;
    if (!device) {
        NSLog(@"前置摄像头不可用");
        return;
    }
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if ([session canAddInput:input]) {
        [session addInput:input];
    }

    AVCapturePhotoOutput *output = [[AVCapturePhotoOutput alloc] init];
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    self.photoOutput = output;
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.view.bounds;

    AVCaptureConnection *connection = previewLayer.connection;
    if (device.position == AVCaptureDevicePositionFront && connection.isVideoMirroringSupported) {
        connection.automaticallyAdjustsVideoMirroring = NO;
        connection.videoMirrored = YES;
    }
    [self.view.layer addSublayer:previewLayer];

    self.captureSession = session;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [session startRunning];
    });

    // 添加高斯模糊背景遮罩层
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;

    // 创建路径：全屏矩形 + 中间椭圆镂空
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.view.bounds];
    CGFloat ovalWidth = self.view.bounds.size.width - 80;
    CGFloat ovalHeight = self.view.bounds.size.height * 4.0 / 9.0;
    CGRect ovalRect = CGRectMake((self.view.bounds.size.width - ovalWidth) / 2.0,
                                 self.view.bounds.size.height * 0.2,
                                 ovalWidth,
                                 ovalHeight);
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
    [path appendPath:ovalPath];
    path.usesEvenOddFillRule = YES;

    // 创建 shapeLayer 作为遮罩
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    blurEffectView.layer.mask = maskLayer;
    blurEffectView.alpha = 0.6;
    [self.view addSubview:blurEffectView];
    
    // 顶部左侧返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"photo_back_icon"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(20, 50, 40, 40);
    [backButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];

    // 顶部右侧 image picker 按钮
    UIButton *pickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pickerButton setTitle:@"相册" forState:UIControlStateNormal];
    [pickerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pickerButton.frame = CGRectMake(self.view.bounds.size.width - 70, 50, 60, 40);
    [pickerButton addTarget:self action:@selector(openImagePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pickerButton];

    // 顶部中心 icon
    UIImageView *topCenterIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_center_top_icon"]];
    topCenterIcon.frame = CGRectMake((self.view.bounds.size.width - 40) / 2, 50, 90, 25);
    topCenterIcon.centerY = backButton.centerY;
    topCenterIcon.centerX = self.view.width / 2.0;
    [self.view addSubview:topCenterIcon];

    // 中间大 icon
    UIImageView *mainIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_main_big_icon"]];
    mainIcon.frame = CGRectMake(0, (SafeAreaTopHeight + 106) * kScreenRatio, 310 * kScreenRatio, 360 * kScreenRatio);
    mainIcon.centerX = self.view.width / 2.0;
    [self.view addSubview:mainIcon];
    
    // 添加提示文本
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"请保持光线充足、背景干净、正面镜头、无遮挡";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:FontSize(13)];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    tipLabel.layer.cornerRadius = 10;
    tipLabel.layer.masksToBounds = YES;

    // 计算文本宽度并设置frame
    CGSize textSize = [tipLabel.text sizeWithAttributes:@{NSFontAttributeName: tipLabel.font}];
    CGFloat labelWidth = textSize.width + 20; // 左右各留10pt内边距
    CGFloat labelHeight = 30.5;
    CGFloat labelX = (self.view.bounds.size.width - labelWidth) / 2;
    CGFloat labelY = mainIcon.bottom + 54;

    tipLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    [self.view addSubview:tipLabel];

    // 替换底部按钮为 icon 样式拍照按钮
    UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePhotoBtn setImage:[UIImage imageNamed:@"photo_capture_icon"] forState:UIControlStateNormal];
    takePhotoBtn.frame = CGRectMake((self.view.bounds.size.width - 80 * kScreenRatio) / 2, self.view.bounds.size.height - 80 * kScreenRatio - 80, 80 * kScreenRatio, 80 * kScreenRatio);
    [takePhotoBtn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePhotoBtn];
    
    self.hiddenBlock = ^{
//        mainIcon.hidden = YES;
//        takePhotoBtn.hidden = YES;
//        tipLabel.hidden = YES;
    };
    
    self.photoPreviewImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.photoPreviewImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoPreviewImageView.backgroundColor = [UIColor blackColor];
    self.photoPreviewImageView.hidden = YES;
    [self.view addSubview:self.photoPreviewImageView];
    
    // 中间图
    NSString *pathWebp = [[NSBundle mainBundle] pathForResource:@"scanning" ofType:@"webp"];
    NSData *dataWebp = [NSData dataWithContentsOfFile:pathWebp];
    // 构建带帧的 AnimatedImage
    SDAnimatedImage *animatedImage = [[SDAnimatedImage alloc] initWithData:dataWebp];
    self.centerImageView = [[SDAnimatedImageView alloc] initWithImage:animatedImage];
    self.centerImageView.size = CGSizeMake(kScreenWidth - 10, kScreenWidth - 10);
    self.centerImageView.center = mainIcon.center;
    self.centerImageView.hidden = YES;
    [self.view addSubview:self.centerImageView];
}

- (void)takePhoto {
    AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettings];
    [self.photoOutput capturePhotoWithSettings:settings delegate:self];
}

- (void)captureOutput:(AVCapturePhotoOutput *)output
didFinishProcessingPhoto:(AVCapturePhoto *)photo
                error:(NSError *)error {
    NSData *data = [photo fileDataRepresentation];
    UIImage *image = [UIImage imageWithData:data];
    
    // 对前置摄像头拍摄图片做镜像处理
    
    UIImage *finalImage = [UIImage imageWithCGImage:image.CGImage
                                              scale:image.scale
                                        orientation:UIImageOrientationLeftMirrored];
    [self handlerResultImage:finalImage];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    NSLog(@"选中照片: %@", selectedImage);
    [self handlerResultImage:selectedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)handlerResultImage:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.photoPreviewImageView.image = image;
        GlobalToolHandler.fetchGlobalModel.imageString = [GlobalToolHandler jsonStringFromImage:image];
        self.photoPreviewImageView.hidden = NO;
        self.centerImageView.hidden = NO;
        self.hiddenBlock();
    });
    __weak typeof(self) weakSelf = self;
    [CenterToastView showWithText:@"面部特征分析中"];
    // 请求面部分析
    NSDate *faceAnalysisStartTime = [NSDate date];
    NSLog(@"🔄 [API-1] 开始请求面部分析 - FacePlusPlus API");
    [GlobalToolHandler requestWithImage:image andCompletion:^(BOOL isSuccess) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (![GlobalToolHandler isSameVC:strongSelf]) {
            NSLog(@"⚠️ [API-1] 页面已切换，取消后续操作");
            return;
        }
        if (isSuccess) {
            NSLog(@"✅ [API-1] 面部分析请求成功 - 耗时: %.3f 秒", [[NSDate date] timeIntervalSinceDate:faceAnalysisStartTime]);
            
            NSString *formatFaceAnalysis = [GlobalToolHandler formatFaceAnalysisFromJSONString];
            if (formatFaceAnalysis.length > 0) {
                NSLog(@"📝 [API-1] 获取到格式化面部分析结果，长度: %lu 字符", (unsigned long)formatFaceAnalysis.length);
                // 在这里弹出toast动画
                [self showTypingAnimationWithText:formatFaceAnalysis];
            } else {
                NSLog(@"⚠️ [API-1] 格式化面部分析结果为空");
            }
            
            NSDate *conclusionStartTime = [NSDate date];
            [CenterToastView showWithText:@"deepseek总结中"];
            NSLog(@"🔄 [API-2] 开始请求DeepSeek初步总结");
            
            // 请求deepseek总结
            [GlobalToolHandler requestDeepSeekConclusion:^(BOOL isSuccess) {
                if (isSuccess) {
                    [CenterToastView showWithText:@"deepseek初步总结成功"];
                    NSLog(@"✅ [API-2] DeepSeek初步总结请求成功 - 耗时: %.3f 秒", [[NSDate date] timeIntervalSinceDate:conclusionStartTime]);
                    [GlobalToolHandler pushConclusionVC];
                } else {
                    NSLog(@"❌ [API-2] DeepSeek初步总结请求失败 - 耗时: %.3f 秒", [[NSDate date] timeIntervalSinceDate:conclusionStartTime]);
                    [CenterToastView showWithText:@"初步总结失败"];
                }
            }];
            
            // 请求deepseek细节
            NSLog(@"⏰ [API-3,4,5] 2秒后开始请求DeepSeek详细分析（3个并发请求）");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf requestWithRetry];
            });
        } else {
            NSLog(@"❌ [API-1] 面部分析请求失败 - 耗时: %.3f 秒", [[NSDate date] timeIntervalSinceDate:faceAnalysisStartTime]);
            [CenterToastView showWithText:@"分析失败"];
        }
    }];
}

- (void)requestWithRetry {
    NSDate *detailStartTime = [NSDate date];
    NSLog(@"🔄 [API-3,4,5] 开始并发请求DeepSeek详细分析 - 包含3个子请求");
    NSLog(@"    📋 [API-3] RequestA: 五官特点分析");
    NSLog(@"    📋 [API-4] RequestB: 妆容风格建议");  
    NSLog(@"    📋 [API-5] RequestC: 详细妆容方案");
    
    [GlobalToolHandler requestAllWithSuccess:^(id resultA, id resultB, id resultC) {
        [CenterToastView showWithText:@"详细报告已生成"];
        NSLog(@"✅ [API-3,4,5] DeepSeek详细分析全部请求成功 - 总耗时: %.3f 秒", [[NSDate date] timeIntervalSinceDate:detailStartTime]);
        NSLog(@"    ✅ [API-3] RequestA 成功: %@", [resultA isKindOfClass:[NSDictionary class]] ? @"数据正常" : @"数据异常");
        NSLog(@"    ✅ [API-4] RequestB 成功: %@", [resultB isKindOfClass:[NSDictionary class]] ? @"数据正常" : @"数据异常");
        NSLog(@"    ✅ [API-5] RequestC 成功: %@", [resultC isKindOfClass:[NSDictionary class]] ? @"数据正常" : @"数据异常");
        // 成功后你可以处理数据，或者回调
    } failure:^(NSError *error) {
        NSLog(@"❌ [API-3,4,5] DeepSeek详细分析请求失败 - 耗时: %.3f 秒", [[NSDate date] timeIntervalSinceDate:detailStartTime]);
        NSLog(@"    ❌ 失败原因: %@", error.localizedDescription);
        NSLog(@"    🔄 0.5秒后开始重试...");
        [CenterToastView showWithText:@"详细报告生成失败，正在重试"];
        // 失败后延迟0.5秒再重试，避免过快调用导致接口压力过大
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestWithRetry];
        });
    }];
}

#pragma mark - actions
// 新增：顶部左侧返回按钮事件
- (void)dismissViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

// 新增：顶部右侧相册按钮事件
- (void)openImagePicker {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)showTypingAnimationWithText:(NSString *)fullText {
    // 创建内容容器
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    containerView.layer.cornerRadius = 20;
    containerView.layer.masksToBounds = YES;
    
    // 标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"AI正在识别面部数据";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:FontSize(16) weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    // 将 UILabel 替换为 UITextView
    UITextView *contentTextView = [[UITextView alloc] init];
    contentTextView.text = @"";
    contentTextView.textColor = [UIColor whiteColor];
    contentTextView.font = [UIFont systemFontOfSize:FontSize(12) weight:UIFontWeightRegular];
    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.editable = NO;
    contentTextView.scrollEnabled = NO;
    contentTextView.textAlignment = NSTextAlignmentLeft;
    contentTextView.textContainerInset = UIEdgeInsetsZero;
    contentTextView.textContainer.lineFragmentPadding = 0;

    // 计算容器大小
    CGFloat containerWidth = self.view.bounds.size.width - 60; // 左右各30pt边距
    CGFloat maxContentWidth = containerWidth - 40; // 容器内左右各20pt边距
    
    // 计算内容高度
    CGSize contentSize = [fullText boundingRectWithSize:CGSizeMake(maxContentWidth, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName: contentTextView.font}
                                                context:nil].size;
    
    CGFloat containerHeight = 60 + contentSize.height + 40; // 标题60pt + 内容高度 + 底部边距40pt
    
    containerView.frame = CGRectMake((self.view.bounds.size.width - containerWidth) / 2,
                                     kScreenHeight - SafeAreaBottomHeight - 37.5 - containerHeight,
                                   containerWidth,
                                   containerHeight);
    
    titleLabel.frame = CGRectMake(20, 20, containerWidth - 40, 20);

    // 关键：设置固定的 frame，并确保文字从顶部开始
    // 设置固定frame
    contentTextView.frame = CGRectMake(20, 60, maxContentWidth, contentSize.height);

    // 额外设置：确保文字顶部对齐
    [contentTextView sizeToFit];
    CGRect fixedFrame = contentTextView.frame;
    fixedFrame.origin.x = 20;
    fixedFrame.origin.y = 60;
    fixedFrame.size.width = maxContentWidth;
    fixedFrame.size.height = contentSize.height;
    contentTextView.frame = fixedFrame;
    
    [containerView addSubview:titleLabel];
    [containerView addSubview:contentTextView];
    [self.view addSubview:containerView];
    
    // 开始打字动画
    [self startTypingAnimation:contentTextView withText:fullText];
}

- (void)startTypingAnimation:(UITextView *)textView withText:(NSString *)fullText {
    NSInteger totalCharacters = fullText.length;
    if (totalCharacters == 0) return;
    
    CGFloat intervalTime = 4.0 / totalCharacters; // 4秒内完成所有字符
    __block NSInteger currentIndex = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:intervalTime repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (currentIndex < totalCharacters) {
            NSString *currentText = [fullText substringToIndex:currentIndex + 1];
            textView.text = currentText;
            currentIndex++;
        } else {
            [timer invalidate];
        }
    }];
}

@end
