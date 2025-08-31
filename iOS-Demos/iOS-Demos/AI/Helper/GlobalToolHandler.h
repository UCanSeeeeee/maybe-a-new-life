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

+ (UIViewController *)topViewController;
+ (BOOL)isSameVC:(id)currentVC;
+ (instancetype)sharedInstance;
+ (void)clearGlobalModel;
+ (void)updateGlobalModel:(GlobalModel *)model;
+ (GlobalModel *)fetchGlobalModel;

+ (void)updateModelWithDic:(NSDictionary *)rawDic andHandler:(void (^)(void))completionHandler;

+ (void)requestWithImage:(UIImage *)image andCompletion:(void (^)(BOOL isSuccess))completion;

+ (void)requestDeepSeekConclusion:(void (^)(BOOL isSuccess))completion;

/// Promise
+ (void)requestAllWithSuccess:(void (^)(id resultA, id resultB, id resultC))successBlock
                      failure:(void (^)(NSError *error))failureBlock;

/// Jump
+ (void)pushConclusionVC;
+ (void)pushResultDetailVC;

/// Permission
+ (BOOL)requestWiFiPermission;
+ (BOOL)checkNetworkStatus;

@property (nonatomic, assign, readonly) BOOL networkAvailable;   // 当前是否可用
@property (nonatomic, copy, readonly) NSString *networkStatus;   // 状态描述（WiFi/蜂窝/无网络/受限）

/// 启动监听（App 启动时调用一次即可）
- (void)startMonitoring;

+ (NSString *)jsonStringFromImage:(UIImage *)image;
+ (UIImage *)imageFromJsonString:(NSString *)jsonString;
@end

NS_ASSUME_NONNULL_END
