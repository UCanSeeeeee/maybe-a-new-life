//
//  GlobalToolHanlder.h
//  iOS-Demos
//
//  Created by Chieh on 2025/7/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GlobalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GlobalToolHandler : NSObject

@property (nonatomic, copy) void (^updateHandler)(void);
@property (nonatomic, copy) NSString *rawFaceString;

+ (instancetype)sharedInstance;
+ (GlobalModel *)fetchGlobalModel;

+ (void)updateModelWithDic:(NSDictionary *)rawDic andHandler:(void (^)(void))completionHandler;

+ (void)requestWithImage:(UIImage *)image andCompletion:(void (^)(BOOL isSuccess))completion;

+ (void)requestDeepSeekConclusion:(void (^)(BOOL isSuccess))completion;
+ (void)requestDeepSeekPanelA:(void (^)(BOOL isSuccess))completion;
+ (void)requestDeepSeekPanelB:(void (^)(BOOL isSuccess))completion;
+ (void)requestDeepSeekPanelC:(void (^)(BOOL isSuccess))completion;

@end

NS_ASSUME_NONNULL_END
