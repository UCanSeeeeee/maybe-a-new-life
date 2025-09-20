//
//  GlobalToolHanlder.m
//  iOS-Demos
//
//  Created by Chieh on 2025/7/12.
//

#import "GlobalToolHandler.h"
#import <AFNetworking/AFNetworking.h>
#import <PromiseKit/PromiseKit.h>
#import <libextobjc/extobjc.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <CoreTelephony/CTCellularData.h>

@interface GlobalToolHandler ()
@property (nonatomic, strong) GlobalModel *globalModel;

@property (nonatomic, assign, readwrite) BOOL networkAvailable;
@property (nonatomic, copy, readwrite) NSString *networkStatus;

@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;
@property (nonatomic, strong) CTCellularData *cellularData;
@end

@implementation GlobalToolHandler

- (GlobalModel *)globalModel {
    if (!_globalModel) {
        _globalModel = [GlobalModel new];
    }
    return _globalModel;
}

+ (instancetype)sharedInstance {
    static GlobalToolHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GlobalToolHandler alloc] init];
        sharedInstance.globalModel = [GlobalModel new];
    });
    return sharedInstance;
}

+ (UIViewController *)topViewController {
    UIViewController *rootVC = UIApplication.sharedApplication.windows.firstObject.rootViewController;
    return [self topViewControllerFrom:rootVC];
}

+ (UIViewController *)topViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        // 取栈顶
        return [self topViewControllerFrom:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // 取当前选中的 tab
        return [self topViewControllerFrom:[(UITabBarController *)vc selectedViewController]];
    } else if (vc.presentedViewController) {
        // 有 modal 出来的
        return [self topViewControllerFrom:vc.presentedViewController];
    } else {
        // 到底了
        return vc;
    }
}

+ (BOOL)isSameVC:(id)currentVC {
    if ([currentVC isEqual:[self topViewController]]) {
        return YES;
    }
    return NO;
}

- (instancetype)init {
    if (self = [super init]) {
        _reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        _networkAvailable = NO;
        _networkStatus = @"未知";
    }
    return self;
}

+ (void)clearGlobalModel {
    [GlobalToolHandler sharedInstance].globalModel = nil;
}

+ (void)updateGlobalModel:(GlobalModel *)model {
    [GlobalToolHandler sharedInstance].globalModel = model;
}

+ (GlobalModel *)fetchGlobalModel {
    return [GlobalToolHandler sharedInstance].globalModel;
}

+ (NSString *)formatFaceAnalysisFromJSONString {
    NSString *jsonString = [GlobalToolHandler sharedInstance].rawFaceString;
    if (!jsonString || jsonString.length == 0) return @"";
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error || !jsonDict) {
        return @"JSON 解析失败";
    }
    
    NSMutableString *result = [NSMutableString string];
    
    // ===== 中下庭比例 =====
    NSDictionary *threeParts = jsonDict[@"three_parts"];
    if (threeParts) {
        NSDictionary *twoPart = threeParts[@"two_part"];
        NSDictionary *threePart = threeParts[@"three_part"];
        [result appendFormat:@"中下庭比例-中庭长度：%.2fcm、下庭长度：%.2fcm；\n",
         [twoPart[@"facemid_length"] floatValue] / 10.0,
         [threePart[@"facedown_length"] floatValue] / 10.0];
    }
    
    // ===== 五眼比例 =====
    NSDictionary *fiveEyes = jsonDict[@"five_eyes"];
    if (fiveEyes) {
        [result appendFormat:@"五眼比例-外眼角颧弓留白：%.2fcm、眼睛宽度：%.2fcm、内眼角间距：%.2fcm；\n",
         [fiveEyes[@"one_eye"][@"righteye_empty_length"] floatValue] / 10.0,
         [fiveEyes[@"righteye"] floatValue] / 10.0,
         [fiveEyes[@"three_eye"][@"eyein_length"] floatValue] / 10.0];
    }
    
    // ===== 脸型 =====
    NSDictionary *face = jsonDict[@"face"];
    if (face) {
        CGFloat zygomaWidth = [face[@"zygoma_length"] floatValue] / 10.0;
        CGFloat mandibleWidth = [face[@"mandible_length"] floatValue] / 10.0;
        [result appendFormat:@"脸型-颧弓下颌角比：%.2f/1、颧弓宽度：%.2fcm、下颌角宽度：%.2fcm；\n",
         zygomaWidth / mandibleWidth, zygomaWidth, mandibleWidth];
    }
    
    // ===== 眼睛 =====
    NSDictionary *eyes = jsonDict[@"eyes"];
    if (eyes) {
        [result appendFormat:@"眼睛宽度：%.2fcm、眼睛高度：%.2fcm；\n",
         [eyes[@"eye_width"] floatValue] / 10.0,
         [eyes[@"eye_height"] floatValue] / 10.0];
    }
    
    // ===== 下巴 =====
    NSDictionary *jaw = jsonDict[@"jaw"];
    if (jaw) {
        [result appendFormat:@"下巴长度：%.2fcm、下颌角宽度：%.2fcm......",
         [jaw[@"jaw_length"] floatValue] / 10.0,
         [jaw[@"jaw_width"] floatValue] / 10.0];
    }
    
    return result;
}

+ (void)requestWithImage:(UIImage *)image andCompletion:(void (^)(BOOL))completion {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8); // 或 PNG
    NSString *base64String = [imageData base64EncodedStringWithOptions:0];
    // 2. 参数
    NSDictionary *params = @{
        @"image_base64": base64String,
        @"api_key": @"FpYEOibTcWAdppV-yLxLh6ageRGrazIs",
        @"api_secret": @"R5iPupcw6YSE-GPvaKE0EbHkouaPGpv1"
    };
    NSLog(@"Chieh request params %@", params);
    // 3. 请求管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 4. 设置 Content-Type 为 multipart/form-data（但 base64 本质是字符串）
    NSString *urlString = @"https://api-cn.faceplusplus.com/facepp/v1/facialfeatures";
    [manager POST:urlString parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Chieh request success %@", responseObject);
        NSDictionary *resultDic = [responseObject valueForKey:@"result"];
        if (resultDic.count > 0) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject[@"result"]
                                                                   options:NSJSONWritingPrettyPrinted
                                                                     error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [GlobalToolHandler sharedInstance].rawFaceString = jsonString;
            NSLog(@"Chieh response JSON:\n%@", jsonString);
            completion(YES);
            // 进行四次deepseek数据请求
        } else {
            // 失败重试
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Chieh request failture %@", error.description);
    }];
}

+ (void)requestDeepSeekConclusion:(void (^)(BOOL))completion {
    // 1. 创建 Session 管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    // 2. 设置请求/响应类型为 JSON
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    // 3. 设置请求头
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"Bearer sk-29cf64d255434a8a8f142f4c1522898f" forHTTPHeaderField:@"Authorization"]; // 替换成你的 DeepSeek API Key
    // 4. 构造请求参数
    NSString *systemPrompt = @"请与黄金比例脸对比，做出6个判断，并请按照以下json格式回复，其中skinAge为int类型，代表肌肤年龄，值在“18、20、24、28、30、32、35、40”中取一个，similarStar为string类型，表示面容相似的明星，两人；recommendMakeup为string类型，表示妆容风格，参考\"XXX感，适合XX风格的妆容\"给出十字内描述；faceStyle是int类型，从“标准脸/长形脸/圆形脸/方形脸/梨形脸/瓜子脸/菱形脸”里选一个，分别对应0～6；suggestion为string类型，是面部润色建议，以\"你的脸型\"为开头，结合faceStyle的内容，回复60个字以内；animateStyle为int类型，表示动物系长相，用0～7对应“兔系、犬系、鹿系、猫系、猪系、蛇系、狐系、鸟系”;animateDetail是所对应动物系长相的30字以内的说明：\n{\n  \"skinAge\": int,\n  \"similarStar\": string,\n  \"recommendMakeup\": string,\n  \"suggestion\": string,\n  \"faceStyle\": int,\n  \"animateStyle\": int,\n  \"animateDetail\": string\n}";
    
    NSDictionary *params = @{
        @"model": @"deepseek-chat",
        @"messages": @[
            @{@"role": @"system", @"content": systemPrompt},
            @{@"role": @"user", @"content": [NSString stringWithFormat:@"这是一份面部分析数据，请你根据这份数据和我的要求来对面部特点做总结：%@", [GlobalToolHandler sharedInstance].rawFaceString]}
        ],
        @"response_format": @{
            @"type": @"json_object"
        }
    };

    // 5. 发起 POST 请求
    NSDate *startTime = [NSDate date];
    NSString *urlString = @"https://api.deepseek.com/chat/completions";
    [manager POST:urlString
       parameters:params
          headers:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 2. NSData 转 NSDictionary
        id reply = responseObject[@"choices"][0][@"message"][@"content"];
        NSData *jsonData = [reply dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
        [self sharedInstance].globalModel.conclusionModel = [[ConclusionModel alloc] initWithDictionary:jsonDict error:nil];
        completion(YES);
        NSLog(@"Chieh request DeepSeek 响应: %@ 耗时: %.3f 秒", [self sharedInstance].globalModel, [[NSDate date] timeIntervalSinceDate:startTime]);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(NO);
        NSLog(@"Chieh request DeepSeek 请求失败: %@，耗时: %.3f 秒", error, [[NSDate date] timeIntervalSinceDate:startTime]);
          }];
}

#pragma mark - network
- (void)startMonitoring {
    // 1. 监听网络连通性
    @weakify(self);
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @strongify(self);
        [self updateNetworkStatusWithReachability:status];
    }];
    [self.reachabilityManager startMonitoring];

    // 2. 监听蜂窝数据权限
    self.cellularData = [[CTCellularData alloc] init];
    __weak typeof(self) weakSelf = self;
    self.cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        [weakSelf updateCellularRestriction:state];
    };
}

#pragma mark - Private

- (void)updateNetworkStatusWithReachability:(AFNetworkReachabilityStatus)status {
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:
            self.networkAvailable = NO;
            self.networkStatus = @"无网络";
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            self.networkAvailable = YES;
            self.networkStatus = @"WiFi";
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            // 这里要结合蜂窝权限判断
            if ([self isCellularRestricted]) {
                self.networkAvailable = NO;
                self.networkStatus = @"蜂窝数据受限";
            } else {
                self.networkAvailable = YES;
                self.networkStatus = @"蜂窝网络";
            }
            break;
        case AFNetworkReachabilityStatusUnknown:
        default:
            self.networkAvailable = NO;
            self.networkStatus = @"未知";
            break;
    }
}

- (void)updateCellularRestriction:(CTCellularDataRestrictedState)state {
    if (state == kCTCellularDataRestricted) {
        if (self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
            self.networkAvailable = NO;
            self.networkStatus = @"蜂窝数据受限";
        }
    }
}

- (BOOL)isCellularRestricted {
    CTCellularDataRestrictedState state = self.cellularData.restrictedState;
    return (state == kCTCellularDataRestricted);
}

// UIImage 转 JSON String
+ (NSString *)jsonStringFromImage:(UIImage *)image {
    if (!image) return nil;
    
    // 转 NSData (PNG 或 JPEG)
    NSData *data = UIImagePNGRepresentation(image);
    // NSData → Base64
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    
    // 拼 JSON
    NSDictionary *jsonDict = @{@"image": base64String};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
    
    if (error) {
        NSLog(@"json encode error: %@", error);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

// JSON String 转 UIImage
+ (UIImage *)imageFromJsonString:(NSString *)jsonString {
    if (!jsonString) return nil;
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error || ![dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"json decode error: %@", error);
        return nil;
    }
    
    NSString *base64String = dict[@"image"];
    if (!base64String) return nil;
    
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    return [UIImage imageWithData:imageData];
}

+ (NSString *)formatAnimateDetailText:(NSString *)originalText {
    if (!originalText || originalText.length == 0) {
        return originalText;
    }
    
    // 简单替换：逗号和句号替换为换行符
    NSString *formattedText = [originalText stringByReplacingOccurrencesOfString:@"，" withString:@"\n"];
    formattedText = [formattedText stringByReplacingOccurrencesOfString:@"。" withString:@"\n"];
    
    // 去除首尾空白和换行符
    return [formattedText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
