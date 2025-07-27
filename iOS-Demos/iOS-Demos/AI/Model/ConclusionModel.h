//
//  ConclusionModel.h
//  iOS-Demos
//
//  Created by Chieh on 2025/7/12.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConclusionModel : JSONModel
// 皮肤年龄
@property (nonatomic, strong) NSNumber<Optional> *skinAge;
// 相似明星
@property (nonatomic, strong) NSString<Optional> *similarStar;
// 推荐妆容
@property (nonatomic, strong) NSString<Optional> *recommendMakeup;
// 面部润色
@property (nonatomic, strong) NSString<Optional> *suggestion;
// 动物系
@property (nonatomic, strong) NSNumber<Optional> *animateStyle;
// 动物系解释
@property (nonatomic, strong) NSString<Optional> *animateDetail;
// 脸型 标准脸/长形脸/圆形脸/方形脸/梨形脸/瓜子脸/菱形脸
@property (nonatomic, strong) NSNumber<Optional> *faceStyle;

- (NSString *)fetchAnimateStyle;
- (NSString *)fetchAgeString;

- (NSString *)fetchFaceStyleString;
- (NSString *)fetchFaceStyleConclusionString;
@end

NS_ASSUME_NONNULL_END
