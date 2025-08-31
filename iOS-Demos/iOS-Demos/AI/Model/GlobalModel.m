//
//  GlobalModel.m
//  iOS-Demos
//
//  Created by Chieh on 2025/7/13.
//

#import "GlobalModel.h"
#import <MMKV/MMKV.h>
#import "GlobalToolHandler.h"

@implementation GlobalModel

- (BOOL)canShowPanelInfo {
    if (self.panelAFaceModel && self.panelBDetailModel && self.panelCRecommandModel) {
        NSLog(@"chieh jsonstring + %@", [self toJSONString]);
        [[MMKV defaultMMKV] setString:[self toJSONString] forKey:kCWLastTimeModelKey];
        return YES;
    } else {
        return NO;
    }
}

+ (instancetype)fetchLastGlobalModel {
    NSString *rawString = [[MMKV defaultMMKV] getStringForKey:kCWLastTimeModelKey];
    GlobalModel *lastModel = [[GlobalModel alloc] initWithString:rawString error:nil];
    return lastModel;
}

- (UIImage *)userPhotoImage {
    return [GlobalToolHandler imageFromJsonString:self.imageString];
}

@end
