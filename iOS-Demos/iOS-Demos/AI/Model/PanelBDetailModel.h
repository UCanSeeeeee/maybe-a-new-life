//
//  PanelBDetailModel.h
//  iOS-Demos
//
//  Created by Chieh on 2025/7/13.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN


@protocol KeyCorrectionModel <NSObject>

@end

@interface KeyCorrectionModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *disadvantage; // 面部不足
@property (nonatomic, strong) NSString<Optional> *suggestion;   // 修正建议

@end

@interface PanelBDetailModel : JSONModel

@property (nonatomic, assign) NSNumber<Optional> *conclusion;                     // 风格定位（0~8）
@property (nonatomic, strong) NSString<Optional> *recommended_makeup_styles;     // 推荐妆容风格（如：自然妆/裸妆）
@property (nonatomic, strong) NSArray<Optional> *key_corrections; // 关键修正项数组
@property (nonatomic, strong) NSNumber<Optional> *makeup_strategy;               // 妆容策略（如：眉妆+眼妆）

- (NSString *)conclusionStyleString;
- (NSString *)makeupStrategyKeyString;
- (NSArray<NSString *> *)makeupStrategyValueArray;

@end

NS_ASSUME_NONNULL_END
