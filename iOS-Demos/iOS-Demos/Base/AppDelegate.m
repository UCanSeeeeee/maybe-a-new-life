//
//  AppDelegate.m
//  iOS-Demos
//
//  Created by Chieh on 2025/5/23.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [UIWindow new];
    self.window.rootViewController = [HomeViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
