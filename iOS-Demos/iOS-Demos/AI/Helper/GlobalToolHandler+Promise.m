//
//  GlobalToolHanlder+Promise.m
//  iOS-Demos
//
//  Created by Chieh on 2025/7/27.
//

#import "GlobalToolHandler.h"
#import "GlobalToolHandler+Promise.h"
#import <PromiseKit/PromiseKit.h>
#import <AFNetworking/AFNetworking.h>

@implementation GlobalToolHandler (Promise)

+ (void)requestAllWithSuccess:(void (^)(id resultA, id resultB, id resultC))successBlock
                      failure:(void (^)(NSError *error))failureBlock {
    NSDate *allStartTime = [NSDate date];
    NSLog(@"🔄 [API-3,4,5] GlobalToolHandler+Promise: 开始并发请求三个DeepSeek接口");
    
    PMKWhen(@[[self requestA], [self requestBWithRetry], [self requestC]]).then(^(NSArray *results) {
        NSLog(@"📥 [API-3,4,5] 所有并发请求完成 - 总耗时: %.3f 秒", [[NSDate date] timeIntervalSinceDate:allStartTime]);
        
        id resultA = results[0];
        id resultB = results[1];
        id resultC = results[2];
        
        NSLog(@"🔍 [API-3,4,5] 检查请求结果状态:");
        NSLog(@"    [API-3] RequestA: %@", [resultA isKindOfClass:[NSError class]] ? @"❌ 失败" : @"✅ 成功");
        NSLog(@"    [API-4] RequestB: %@", [resultB isKindOfClass:[NSError class]] ? @"❌ 失败" : @"✅ 成功");
        NSLog(@"    [API-5] RequestC: %@", [resultC isKindOfClass:[NSError class]] ? @"❌ 失败" : @"✅ 成功");
        
        // 任一错误都判定为失败
        if ([resultA isKindOfClass:[NSError class]]) {
            NSLog(@"❌ [API-3,4,5] 因RequestA失败而整体失败: %@", [(NSError*)resultA localizedDescription]);
            failureBlock(resultA);
        } else if ([resultB isKindOfClass:[NSError class]]) {
            NSLog(@"❌ [API-3,4,5] 因RequestB失败而整体失败: %@", [(NSError*)resultB localizedDescription]);
            failureBlock(resultB);
        } else if ([resultC isKindOfClass:[NSError class]]) {
            NSLog(@"❌ [API-3,4,5] 因RequestC失败而整体失败: %@", [(NSError*)resultC localizedDescription]);
            failureBlock(resultC);
        } else {
            NSLog(@"✅ [API-3,4,5] 所有请求均成功，返回结果");
            successBlock(resultA, resultB, resultC);
        }
        return nil;
    });
}

+ (AFHTTPSessionManager *)manager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"Bearer sk-29cf64d255434a8a8f142f4c1522898f" forHTTPHeaderField:@"Authorization"];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return manager;
}

+ (AnyPromise *)requestA {
    NSDate *startTime = [NSDate date];
    NSLog(@"🔄 [API-3] RequestA: 开始请求五官特点分析");
    
    NSString *systemPrompt = @"请与黄金比例脸对比，做出5个判断，并请按照以下json格式回复，其中faceFeatures为string类型，代表面部特点，内容是\"有什么感\"，参考\"细长冷感眼，有清冷娇憨感\"等十五字以内，不允许涉及脸型；其余均为string类型，代表着对应五官的特点，必须在十五到二十个字之间。\n{\n  \"faceFeatures\": string,\n  \"eyes\": string,\n  \"nose\": string,\n  \"lips\": string,\n  \"eyebrows\": string\n}";
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
    
    NSLog(@"📤 [API-3] RequestA: 请求参数构造完成 - 系统提示词长度: %lu", (unsigned long)systemPrompt.length);
    
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        NSString *urlString = @"https://api.deepseek.com/chat/completions";
        NSLog(@"🌐 [API-3] RequestA: 发起POST请求");
        
        [[self manager] POST:urlString parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"📥 [API-3] RequestA: 收到响应 - 耗时: %.3f 秒", [[NSDate date] timeIntervalSinceDate:startTime]);
            
            id reply = responseObject[@"choices"][0][@"message"][@"content"];
            NSLog(@"📋 [API-3] RequestA: 提取响应内容 - 长度: %lu 字符", (unsigned long)[reply length]);
            
            NSData *jsonData = [reply dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:nil];
            if (jsonDict) {
                GlobalToolHandler.fetchGlobalModel.panelAFaceModel = [[PanelAFaceModel alloc] initWithDictionary:jsonDict error:nil];
                NSLog(@"✅ [API-3] RequestA: JSON解析成功，PanelAFaceModel更新完成");
                NSLog(@"📄 [API-3] RequestA: 解析后的数据: %@", jsonDict);
                resolve(jsonDict);
            } else {
                NSLog(@"❌ [API-3] RequestA: JSON解析失败，原始内容: %@", reply);
                NSError *parseError = [NSError errorWithDomain:@"RequestA" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"JSON解析失败"}];
                resolve(parseError);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"❌ [API-3] RequestA: 请求失败 - 耗时: %.3f 秒", [[NSDate date] timeIntervalSinceDate:startTime]);
            NSLog(@"❌ [API-3] RequestA: 错误详情: %@", error.localizedDescription);
            resolve(error);
        }];
    }];
}

+ (AnyPromise *)requestBWithRetry {
    NSDate *startTime = [NSDate date];
    NSLog(@"🔄 [API-4] RequestB: 开始请求妆容风格建议");
    
    NSString *systemPrompt = @"请与黄金比例脸对比，做出6个判断，并请按照以下json格式回复，其中conclusion为int类型，代表风格定位（从五官量感和面部曲线是曲线型还是直线型，并将这两个维度结合得出结论 从以下9项中选其1：\"甜美型/活泼型/少年型/优雅型/自然型/前卫型/魅力型/古典型/帅气型\"，并返回对应的0～8；recommended_makeup_styles是字符串，代表参考妆容，回复格式是\"xxxx妆/xxxx分/...\"总共推荐三个妆容或风格；key_corrections是数组，每个对象包含两个属性，其中disadvantage是string类型，表示五官的一处缺点，内容必须是四个字，按照\"部位特点\"格式回复，例如\"中庭偏长\"，suggestion是string类型，表示这个缺点的妆容修缮方案，内容必须在十五到二十五字之间；makeup_strategy是int类型，代表着妆容思路，思路有四个选择分别是\"眉妆+眼/眼妆+唇妆/腮红+唇妆/眉妆+唇妆\"，返回对应的0~3。\n{\n\"conclusion\":int,\n    \"recommended_makeup_styles\":string,\n\"key_corrections\": [\n{\n\"disadvantage\": string\n\"suggestion\":string\n }\n],\n\"makeup_strategy\":int,\n}";

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
    
    NSLog(@"📤 [API-4] RequestB: 请求参数构造完成 - 系统提示词长度: %lu", (unsigned long)systemPrompt.length);
    
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        NSString *urlString = @"https://api.deepseek.com/chat/completions";
        NSLog(@"🌐 [API-4] RequestB: 发起POST请求");
        
        [[self manager] POST:urlString parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"📥 [API-4] RequestB: 收到响应 - 耗时: %.3f 秒", [[NSDate date] timeIntervalSinceDate:startTime]);
            
            id reply = responseObject[@"choices"][0][@"message"][@"content"];
            NSLog(@"📋 [API-4] RequestB: 提取响应内容 - 长度: %lu 字符", (unsigned long)[reply length]);
            
            NSData *jsonData = [reply dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:nil];
            if (jsonDict) {
                GlobalToolHandler.fetchGlobalModel.panelBDetailModel = [[PanelBDetailModel alloc] initWithDictionary:jsonDict error:nil];
                NSLog(@"✅ [API-4] RequestB: JSON解析成功，PanelBDetailModel更新完成");
                NSLog(@"📄 [API-4] RequestB: 解析后的数据: %@", jsonDict);
                resolve(jsonDict);
            } else {
                NSLog(@"❌ [API-4] RequestB: JSON解析失败，原始内容: %@", reply);
                NSError *parseError = [NSError errorWithDomain:@"RequestB" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"JSON解析失败"}];
                resolve(parseError);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"❌ [API-4] RequestB: 请求失败 - 耗时: %.3f 秒", [[NSDate date] timeIntervalSinceDate:startTime]);
            NSLog(@"❌ [API-4] RequestB: 错误详情: %@", error.localizedDescription);
            resolve(error);
        }];

    }];
}

+ (AnyPromise *)requestC {
    NSDate *startTime = [NSDate date];
    NSLog(@"🔄 [API-5] RequestC: 开始请求详细妆容方案");
    
    NSString *systemPrompt = @"请与黄金比例脸对比，做出5个判断，并请按照以下json格式回复，recommandStyle是string类型，代表一个推荐妆容，按照\"场景「妆容」\"来回复，例如\"通勤约会「清冷白开水妆」\"。\ncontourType为int类型，代表修容类型，从该7个选项\"长形脸修容圆形脸修容方形脸修容梨形脸修容瓜子脸修容菱形脸修容标准脸\"中选一个，返回对应的0～6；\neyeshadowColorType为int类型，代表眼影色类型，从该9个选项\"大地橘棕色、灰粉色、裸棕、灰调紫粉、烟粉色、奶茶色/裸粉、粉橘棕色、中性暖棕色、烟熏玫瑰色\"中选一个，返回对应的0～8；\neyeShapeType为int类型，代表眼妆-眼型，从该8个选项\"标准眼、下垂眼、吊梢眼、圆眼、长眼、小眼、眉眼间距过远、眉眼间距过近\"中选一个，返回对应的0～7；\neyebrowStyleType为int类型，代表眉妆类型，从该6个选项\"标准眉、欧式眉、平眉、弯月眉、柳叶眉、小挑眉\"中选一个，返回对应的0～5；\nlipType为int类型，代表唇妆类型，从该5个选项\"厚唇、薄唇、嘴角下垂、椭圆唇、宽唇、窄唇\"中选一个，返回对应的0～5；\nblushType为int类型，代表腮红类型，从该6个选项\"方形脸腮红、菱形脸腮红、圆形脸腮红、长形脸腮红、上镜氛围腮红、面中凹陷腮红\"中选一个，返回对应的0～5；\n{\n\"recommandStyle\":string,\n\"contourType\",int,\n\"eyeshadowColorType\":int,\n\"eyeShapeType\":int,\n\"eyebrowStyleType\":int,\n\"lipType\":int,\n\"blushType\":int\n}";
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
    
    NSLog(@"📤 [API-5] RequestC: 请求参数构造完成 - 系统提示词长度: %lu", (unsigned long)systemPrompt.length);
    
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        NSString *urlString = @"https://api.deepseek.com/chat/completions";
        NSLog(@"🌐 [API-5] RequestC: 发起POST请求");
        
        [[self manager] POST:urlString parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"📥 [API-5] RequestC: 收到响应 - 耗时: %.3f 秒", [[NSDate date] timeIntervalSinceDate:startTime]);
            
            id reply = responseObject[@"choices"][0][@"message"][@"content"];
            NSLog(@"📋 [API-5] RequestC: 提取响应内容 - 长度: %lu 字符", (unsigned long)[reply length]);
            
            NSData *jsonData = [reply dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:nil];
            if (jsonDict) {
                GlobalToolHandler.fetchGlobalModel.panelCRecommandModel = [[PanelCRecommandModel alloc] initWithDictionary:jsonDict error:nil];
                NSLog(@"✅ [API-5] RequestC: JSON解析成功，PanelCRecommandModel更新完成");
                NSLog(@"📄 [API-5] RequestC: 解析后的数据: %@", jsonDict);
                resolve(jsonDict);
            } else {
                NSLog(@"❌ [API-5] RequestC: JSON解析失败，原始内容: %@", reply);
                NSError *parseError = [NSError errorWithDomain:@"RequestC" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"JSON解析失败"}];
                resolve(parseError);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"❌ [API-5] RequestC: 请求失败 - 耗时: %.3f 秒", [[NSDate date] timeIntervalSinceDate:startTime]);
            NSLog(@"❌ [API-5] RequestC: 错误详情: %@", error.localizedDescription);
            resolve(error);
        }];
    }];
}

@end
