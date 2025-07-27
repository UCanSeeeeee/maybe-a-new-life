//
//  GlobalToolHanlder.m
//  iOS-Demos
//
//  Created by Chieh on 2025/7/12.
//

#import "GlobalToolHandler.h"
#import <AFNetworking/AFNetworking.h>
#import <PromiseKit/PromiseKit.h>

@interface GlobalToolHandler ()
@property (nonatomic, strong) GlobalModel *globalModel;
@end

@implementation GlobalToolHandler

+ (instancetype)sharedInstance {
    static GlobalToolHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GlobalToolHandler alloc] init];
        sharedInstance.globalModel = [GlobalModel new];
    });
    return sharedInstance;
}

+ (GlobalModel *)fetchGlobalModel {
    return [GlobalToolHandler sharedInstance].globalModel;
}

+ (void)updateModelWithDic:(NSDictionary *)rawDic andHandler:(nonnull void (^)(void))completionHandler{
    GlobalToolHandler *handler = [GlobalToolHandler sharedInstance];
    // 更新model
//    handler.model.xxx =
    // 更新panel
    if (completionHandler) {
        completionHandler();
    } else if (handler.updateHandler) {
        handler.updateHandler();
    }
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

+ (void)requestDeepSeekPanelA:(void (^)(BOOL))completion {
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

+ (void)requestDeepSeekPanelB:(void (^)(BOOL))completion {
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

+ (void)requestDeepSeekPanelC:(void (^)(BOOL))completion {
    // 1. 创建 Session 管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    // 2. 设置请求/响应类型为 JSON
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    // 3. 设置请求头
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"Bearer sk-29cf64d255434a8a8f142f4c1522898f" forHTTPHeaderField:@"Authorization"];

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

@end
