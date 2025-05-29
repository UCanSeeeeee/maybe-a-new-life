//
//  ScanViewController+deepseek.m
//  iOS-Demos
//
//  Created by Chieh on 2025/5/29.
//

#import "ScanViewController+deepseek.h"
#import "BaseFoundation.h"

@implementation ScanViewController (deepseek)

- (void)requestDeepseek {
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

@end
