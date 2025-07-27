//
//  PanelDSummary.h
//  iOS-Demos
//
//  Created by Chieh on 2025/6/7.
//

#import <UIKit/UIKit.h>
#import "BaseFoundation.h"
#import "ConclusionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PanelDSummary : UIView

@property (nonatomic, strong) ConclusionModel *dataModel;

- (void)loadView;

@end

NS_ASSUME_NONNULL_END
