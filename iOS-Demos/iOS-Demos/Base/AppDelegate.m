//
//  AppDelegate.m
//  iOS-Demos
//
//  Created by Chieh on 2025/5/23.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "HomeViewController.h"
#import <SDWebImageWebPCoder/SDImageWebPCoder.h>
#import <MMKV/MMKV.h>
#import "GlobalToolHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    SDImageWebPCoder *webPCoder = [SDImageWebPCoder sharedCoder];
    [[SDImageCodersManager sharedManager] addCoder:webPCoder];
    self.window = [UIWindow new];
    HomeViewController *rootVC = [HomeViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    nav.navigationBar.hidden = YES;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    [MMKV initializeMMKV:nil];
    [[GlobalToolHandler sharedInstance] startMonitoring];
    return YES;
}

@end
