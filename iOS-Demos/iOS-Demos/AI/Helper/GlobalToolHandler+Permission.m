//
//  GlobalToolHandler+Permission.m
//  iOS-Demos
//
//  Created by Chieh on 2025/8/16.
//

#import "GlobalToolHandler+Permission.h"
#import <CoreTelephony/CTCellularData.h>
#import <Network/Network.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "CWViewsFoundation.h"

@interface GlobalToolHandler ()

@property (nonatomic, assign, readwrite) BOOL networkAvailable;
@property (nonatomic, copy, readwrite) NSString *networkStatus;

@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;
@property (nonatomic, strong) CTCellularData *cellularData;

@end

@implementation GlobalToolHandler (Permission)

+ (BOOL)requestWiFiPermission {
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    if (state > 0) {
        return YES;
    } else {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }
    return NO;
}

+ (BOOL)checkNetworkStatus {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝网络");
                break;
            case AFNetworkReachabilityStatusUnknown:
            default:
                NSLog(@"未知");
                break;
        }
    }];
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (status > 0) {
        return YES;
    }
    
    return NO;
}

@end
