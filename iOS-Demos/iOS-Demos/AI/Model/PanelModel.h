//
//  PanelModel.h
//  iOS-Demos
//
//  Created by Chieh on 2025/6/6.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FacialFeatures @end
@protocol KeyCorrections @end

/**
 * 五官特征模型
 */
@interface FacialFeatures : JSONModel
@property (nonatomic, strong) NSString *eyes;        // 眼睛特征描述
@property (nonatomic, strong) NSString *nose;        // 鼻子特征描述
@property (nonatomic, strong) NSString *lips;        // 唇部特征描述
@property (nonatomic, strong) NSString *eyebrows;    // 眉毛特征描述
@end

/**
 * 面部分析模型
 */
@interface FaceAnalysis : JSONModel
@property (nonatomic, strong) NSString *face_shape_and_contour;    // 脸型与轮廓描述
@property (nonatomic, strong) FacialFeatures *facial_features;     // 五官特征详情
@property (nonatomic, strong) NSString *keywords_summary;          // 关键词总结
@property (nonatomic, strong) NSString *keywords_summary_2;          // 关键词总结
@end

/**
 * 风格定位模型
 */
@interface StylePositioning : JSONModel
@property (nonatomic, strong) NSString *conclusion;                                    // 分析结论
@property (nonatomic, strong) NSArray<NSString*> *reference_celebrities;              // 参考明星列表 b2
@property (nonatomic, strong) NSArray<NSString*> *recommended_makeup_styles;          // 推荐妆容风格列表
@property (nonatomic, strong) NSDictionary<NSString*, NSString*> *key_corrections;    // 重点修饰建议
@property (nonatomic, strong) NSString *makeup_strategy;                              // 妆容思路
@property (nonatomic, strong) NSArray<NSString*> *makeup_focus_points;               // 思路方向要点
@end

/**
 * 修容技巧模型
 */
@interface Techniques : JSONModel
@property (nonatomic, strong) NSString *cheekbones;      // 颧弓修容方法
@property (nonatomic, strong) NSString *chin;            // 下巴修容方法
@property (nonatomic, strong) NSString *nose_contour;    // 鼻影修容方法
@end

/**
 * 修容模型
 */
@interface Contour : JSONModel
@property (nonatomic, strong) NSString *shape;
@property (nonatomic, strong) NSNumber<Optional> *eyeshadow_color;
@property (nonatomic, strong) NSArray<NSString *> *techniques;
@end

/**
 * 眼妆模型
 */
@interface EyeMakeup : JSONModel
@property (nonatomic, strong) NSString *eyeshadow_color;     // 眼影色系
@property (nonatomic, strong) NSString *eye_shape;           // 眼形描述
@property (nonatomic, strong) NSDictionary *techniques;      // 眼妆技巧
@end

/**
 * 日常约会妆容模型
 */
@interface DailyDateMakeup : JSONModel
@property (nonatomic, strong) Contour *contour;         // 修容方案
@property (nonatomic, strong) Contour *eye_makeup;    // 眼妆方案
@property (nonatomic, strong) Contour *eyebrow_makeup;    // 眉毛方案
@property (nonatomic, strong) Contour *lip_makeup;    // 唇部方案
@property (nonatomic, strong) Contour *blush;    // 腮红方案
// ... 其他makeup相关属性
@end

/**
 * 妆容推荐模型
 */
@interface MakeupRecommendation : JSONModel
@property (nonatomic, strong) DailyDateMakeup *daily_date_makeup;    // 通勤约会妆方案
@end

/**
 * 总结模型 d
 */
@interface Summary : JSONModel
@property (nonatomic, strong) NSString *recommended_style;        // 推荐风格 d-1
@property (nonatomic, strong) NSString *facial_feature_summary;   // 面部特点总结 d-2
@property (nonatomic, strong) NSString *makeup_age;              // 肌龄妆感 24 d-3
@property (nonatomic, strong) NSString *facial_polishing;        // 面部润色建议 d-4
@property (nonatomic, strong) NSString *animal_type_look;        // 动物系长相 d-5
@end

/**
 * AI分析结果模型
 */
@interface AIResult : JSONModel
@property (nonatomic, strong) FaceAnalysis *face_analysis;                // 面部分析a
@property (nonatomic, strong) StylePositioning *style_positioning;        // 风格定位b
@property (nonatomic, strong) MakeupRecommendation *makeup_recommendation;// 妆容推荐c
@property (nonatomic, strong) Summary *summary;                           // 总结d
@end

/**
 * 面板数据主模型
 */
@interface PanelModel : JSONModel
@property (nonatomic, strong) AIResult *ai_result;    // AI分析结果
@end

NS_ASSUME_NONNULL_END
