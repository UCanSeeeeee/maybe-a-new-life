//
//  PanelAFaceModel.h
//  iOS-Demos
//
//  Created by Chieh on 2025/7/13.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface PanelAFaceModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *faceFeatures;// 面部特点总结，总结的格式是：有什么感 如幼态感、熟女感等不限）
@property (nonatomic, strong) NSString<Optional> *eyes;        // 眼睛特征描述
@property (nonatomic, strong) NSString<Optional> *nose;        // 鼻子特征描述
@property (nonatomic, strong) NSString<Optional> *lips;        // 唇部特征描述
@property (nonatomic, strong) NSString<Optional> *eyebrows;    // 眉毛特征描述

@end

NS_ASSUME_NONNULL_END
