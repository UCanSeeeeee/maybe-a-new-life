//
//  PanelCRecommandModel.h
//  iOS-Demos
//
//  Created by Chieh on 2025/7/13.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface PanelCRecommandModel : JSONModel

@property (nonatomic, strong) NSString *recommandStyle;   // 妆容推荐风格（如“温柔奶茶妆”）

@property (nonatomic, assign) NSNumber<Optional> *contourType; // 修容类型
@property (nonatomic, assign) NSNumber<Optional> *eyeshadowColorType;   // 眼影色类型（枚举值0~8）
@property (nonatomic, assign) NSNumber<Optional> *eyeShapeType;         // 眼型类型（枚举值0~7）
@property (nonatomic, assign) NSNumber<Optional> *eyebrowStyleType;     // 眉型类型（枚举值0~5）
@property (nonatomic, assign) NSNumber<Optional> *lipType;              // 唇型类型（枚举值0~5）
@property (nonatomic, assign) NSNumber<Optional> *blushType;            // 腮红类型（枚举值0~5）

- (NSArray *)contourValues;
- (NSArray *)eyeshadowValues;
- (NSArray *)eyeshapeValues;
- (NSArray *)eyebrowValues;
- (NSArray *)lipValues;
- (NSArray *)blushValues;


@end

NS_ASSUME_NONNULL_END
