//
//  PanelAFace.h
//  iOS-Demos
//
//  Created by Chieh on 2025/6/7.
//

#import <UIKit/UIKit.h>
#import "PanelAFaceModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 面部分析面板 - 显示脸型分析和五官特点
@interface PanelAFace : UIView

// MARK: - Data
@property (nonatomic, strong, nullable) PanelAFaceModel *faceAnalysisData;

// MARK: - Public Methods
/// 加载并显示面部分析内容
- (void)loadAndDisplayContent;

@end

NS_ASSUME_NONNULL_END
