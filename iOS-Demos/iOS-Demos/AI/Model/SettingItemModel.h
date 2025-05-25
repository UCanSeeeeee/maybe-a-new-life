//
//  SettingItemModel.h
//  iOS-Demos
//
//  Created by Chieh on 2025/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingItemModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) void (^actionBlock)(void);

@end

NS_ASSUME_NONNULL_END
