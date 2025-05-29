//
//  Header.h
//  iOS-Demos
//
//  Created by Chieh on 2025/5/25.
//

#ifndef Header_h
#define Header_h

#import "YYCategories.h"
#import <libextobjc/extobjc.h>
#import <AFNetworking/AFNetworking.h>

// 顶部安全区域高度（包含刘海或灵动岛）
#define SafeAreaTopHeight ({\
    CGFloat topInset = 0;\
    if (@available(iOS 11.0, *)) {\
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];\
        topInset = window.safeAreaInsets.top;\
    } else {\
        topInset = 20.0;\
    }\
    topInset;\
})

// 底部安全区域高度（底部虚拟Home条高度）
#define SafeAreaBottomHeight ({\
    CGFloat bottomInset = 0;\
    if (@available(iOS 11.0, *)) {\
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];\
        bottomInset = window.safeAreaInsets.bottom;\
    } else {\
        bottomInset = 0;\
    }\
    bottomInset;\
})

#endif /* Header_h */
