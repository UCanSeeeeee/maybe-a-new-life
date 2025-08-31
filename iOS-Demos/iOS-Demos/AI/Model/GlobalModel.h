//
//  GlobalModel.h
//  iOS-Demos
//
//  Created by Chieh on 2025/7/13.
//

#define kCWLastTimeModelKey @"kCWLastTimeModelKey"

#import <JSONModel/JSONModel.h>
#import "ConclusionModel.h"
#import "PanelAFaceModel.h"
#import "PanelBDetailModel.h"
#import "PanelCRecommandModel.h"
NS_ASSUME_NONNULL_BEGIN

@class UIImage;

@interface GlobalModel : JSONModel

@property (nonatomic, strong) ConclusionModel *conclusionModel;
@property (nonatomic, strong) PanelAFaceModel *panelAFaceModel;
@property (nonatomic, strong) PanelBDetailModel *panelBDetailModel;
@property (nonatomic, strong) PanelCRecommandModel *panelCRecommandModel;
@property (nonatomic, strong) NSString *imageString;

- (BOOL)canShowPanelInfo;
- (UIImage *)userPhotoImage;
+ (instancetype)fetchLastGlobalModel;

@end

NS_ASSUME_NONNULL_END
