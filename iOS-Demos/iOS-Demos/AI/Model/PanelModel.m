//
//  PanelModel.m
//  iOS-Demos
//
//  Created by Chieh on 2025/6/6.
//

#import "PanelModel.h"

#pragma mark - FacialFeatures

@implementation FacialFeatures
@end

#pragma mark - FaceAnalysis

@implementation FaceAnalysis
@end

#pragma mark - StylePositioning

@implementation StylePositioning

+ (NSDictionary *)arrayPropertyToClassMap {
    return @{
        @"reference_celebrities": [NSString class],
        @"recommended_makeup_styles": [NSString class],
        @"makeup_focus_points": [NSString class]
    };
}

@end

#pragma mark - Techniques

@implementation Techniques
@end

#pragma mark - Contour

@implementation Contour
@end

#pragma mark - EyeMakeup

@implementation EyeMakeup
@end

#pragma mark - DailyDateMakeup

@implementation DailyDateMakeup
@end

#pragma mark - MakeupRecommendation

@implementation MakeupRecommendation
@end

#pragma mark - Summary

@implementation Summary
@end

#pragma mark - AIResult

@implementation AIResult
@end

#pragma mark - PanelModel

@implementation PanelModel
@end
