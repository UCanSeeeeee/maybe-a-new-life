//
//  PanelCItems.h
//  iOS-Demos
//
//  Created by Chieh on 2025/6/11.
//

#import <UIKit/UIKit.h>
#import "BaseFoundation.h"

NS_ASSUME_NONNULL_BEGIN

@interface PanelCItems : UIView

- (void)loadViewWithModel:(Contour *)model andImagePrefix:(NSString *)Prefix andTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
