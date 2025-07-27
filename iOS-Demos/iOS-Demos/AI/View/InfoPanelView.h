//
//  InfoPanelView.h
//  iOS-Demos
//
//  Created by Chieh on 2025/5/29.
//

#import <UIKit/UIKit.h>
#import "PanelAFace.h"
#import "PanelBStyle.h"
#import "PanelCMakeup.h"

NS_ASSUME_NONNULL_BEGIN
@class AIResult;

@interface InfoPanelView : UIView

@property (nonatomic, strong) PanelAFace *faceView;
@property (nonatomic, strong) PanelBStyle *styleView;
@property (nonatomic, strong) PanelCMakeup *makeupView;

- (void)loadView;

@end

NS_ASSUME_NONNULL_END
