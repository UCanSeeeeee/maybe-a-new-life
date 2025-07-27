//
//  UIViewController+DeallocLogging.m
//  iOS-Demos
//
//  Created by Chieh on 2025/7/27.
//

#import "UIViewController+DeallocLogging.h"
#import <objc/runtime.h>
@implementation UIViewController (DeallocLogging)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = NSSelectorFromString(@"dealloc");
        SEL swizzledSelector = @selector(xxx_dealloc);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)xxx_dealloc {
    NSLog(@"chieh dealloc %@", NSStringFromClass(self.class));
    // 调用原始dealloc方法（实际上是交换后的方法）
    [self xxx_dealloc];
}

@end
