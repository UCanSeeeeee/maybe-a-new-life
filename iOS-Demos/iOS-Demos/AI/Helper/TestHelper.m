//
//  TestHelper.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/6.
//

#import "TestHelper.h"
#import "BaseFoundation.h"
#import "PanelModel.h"

@implementation TestHelper

+ (void)requestDeepseek {
    NSString *baseURLString = @"https://api.deepseek.com";
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *apiPath = @"/chat/completions";
    NSDictionary *bodyParams = @{
        @"model": @"deepseek-chat",
        @"messages": @[
            @{@"role": @"system", @"content": @"你的回复是json格式"},
            @{@"role": @"user", @"content": @"hello"}
        ],
        @"stream": @NO,
        @"response_format": @{@"type": @"json_object"}
    };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    // 设置请求序列化和响应序列化为JSON
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 设置Authorization头，注意部分API需要前面加Bearer空格，或者直接用Key，这里你确认下接口文档
    [manager.requestSerializer setValue:@"Bearer sk-29cf64d255434a8a8f142f4c1522898f" forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"chieh 开始请求deepseek");
    [manager POST:apiPath
       parameters:bodyParams
          headers:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        NSArray *choices = jsonDict[@"choices"];
        NSLog(@"chieh %@", choices);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"chieh 请求失败: %@", error);
    }];
}

+ (AIResult *)showResultPanel {
    // 获取本地JSON文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"testmodel" ofType:@"json"];
    NSError *error = nil;
    // 读取JSON文件内容
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    if (!jsonData) {
        NSLog(@"无法读取JSON文件");
        return nil;
    }
    
    // 将JSON数据转换为字典
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
    if (error) {
        NSLog(@"JSON解析错误: %@", error.localizedDescription);
        return nil;
    }
    
    // 使用JSONModel解析为PanelModel对象
    PanelModel *panelModel = [[PanelModel alloc] initWithDictionary:jsonDict error:&error];
    if (error) {
        NSLog(@"模型解析错误: %@", error.localizedDescription);
        return nil;
    }
    
    // 获取AIResult对象
    AIResult *aiResult = panelModel.ai_result;
    
    // 在这里可以使用解析后的aiResult对象
    // 例如：展示面部分析结果
    NSLog(@"面部分析 - 脸型描述: %@", aiResult.face_analysis.face_shape_and_contour);
    NSLog(@"风格定位 - 结论: %@", aiResult.style_positioning.conclusion);
    NSLog(@"推荐妆容 - 动物系长相: %@", aiResult.summary.animal_type_look);
    
    return aiResult;
}

@end
