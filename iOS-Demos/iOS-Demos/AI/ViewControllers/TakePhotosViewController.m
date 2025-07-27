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

@interface TakePhotosViewController () <AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCapturePhotoOutput *photoOutput;
// 拍照后的照片
@property (nonatomic, strong) UIImageView *photoPreviewImageView;
@property (nonatomic, copy) void (^hiddenBlock)(void);
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

    // 添加背景遮罩层
    UIView *maskBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:maskBackgroundView];

    self.photoPreviewImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.photoPreviewImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.photoPreviewImageView.backgroundColor = [UIColor blackColor];
    self.photoPreviewImageView.hidden = YES;
    [self.view addSubview:self.photoPreviewImageView];
    
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
    
    // 替换底部按钮为 icon 样式拍照按钮
    UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePhotoBtn setImage:[UIImage imageNamed:@"photo_capture_icon"] forState:UIControlStateNormal];
    takePhotoBtn.frame = CGRectMake((self.view.bounds.size.width - 80) / 2, self.view.bounds.size.height - 120, 80, 80);
    [takePhotoBtn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePhotoBtn];
    
    self.hiddenBlock = ^{
        mainIcon.hidden = YES;
        takePhotoBtn.hidden = YES;
    };
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
    UIImage *finalImage = image;
    AVCaptureDevicePosition position = AVCaptureDevicePositionFront; // 这里我们默认前置摄像头
    if (position == AVCaptureDevicePositionFront) {
        finalImage = [UIImage imageWithCGImage:image.CGImage
                                         scale:image.scale
                                   orientation:UIImageOrientationLeftMirrored];
    }
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
        self.photoPreviewImageView.hidden = NO;
        self.hiddenBlock();
    });
    __weak typeof(self) weakSelf = self;
    [CenterToastView showWithText:@"面部特征分析中"];
    [GlobalToolHandler requestWithImage:image andCompletion:^(BOOL isSuccess) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (isSuccess) {
            NSDate *startTime = [NSDate date];
            [CenterToastView showWithText:@"deepseek总结中"];
            [GlobalToolHandler requestDeepSeekConclusion:^(BOOL isSuccess) {
                [CenterToastView showWithText:@"deepseek初步总结成功"];
                NSLog(@"Chieh request DeepSeek1 请求成功 耗时: %.3f 秒", [[NSDate date] timeIntervalSinceDate:startTime]);
                ConclusionViewController *vc = [ConclusionViewController new];
                vc.dataModel = GlobalToolHandler.fetchGlobalModel.conclusionModel;
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf requestWithRetry];
            });
        } else {
            [CenterToastView showWithText:@"分析失败"];
        }
    }];
}

- (void)requestWithRetry {
    NSDate *startTime = [NSDate date];
    [GlobalToolHandler requestAllWithSuccess:^(id resultA, id resultB, id resultC) {
        [CenterToastView showWithText:@"详细报告已生成"];
        NSLog(@"Chieh request DeepSeek3 请求成功 耗时: %.3f 秒", [[NSDate date] timeIntervalSinceDate:startTime]);
        // 成功后你可以处理数据，或者回调
    } failure:^(NSError *error) {
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

@end
