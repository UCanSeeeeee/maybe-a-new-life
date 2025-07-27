//
//  GlobalToolHanlder+Promise.h
//  iOS-Demos
//
//  Created by Chieh on 2025/7/27.
//

#import "GlobalToolHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface GlobalToolHandler (Promise)

+ (void)requestAllWithSuccess:(void (^)(id resultA, id resultB, id resultC))successBlock
                      failure:(void (^)(NSError *error))failureBlock;

@end

NS_ASSUME_NONNULL_END
