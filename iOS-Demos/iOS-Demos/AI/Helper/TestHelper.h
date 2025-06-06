//
//  TestHelper.h
//  iOS-Demos
//
//  Created by Chieh on 2025/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AIResult;

@interface TestHelper : NSObject

+ (void)requestDeepseek;
+ (AIResult *)showResultPanel;

@end

NS_ASSUME_NONNULL_END
