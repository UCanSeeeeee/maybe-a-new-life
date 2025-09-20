//
//  CenterToastView.m
//  iOS-Demos
//
//  Created by Chieh on 2025/7/27.
//

#import "CenterToastView.h"
#import "BaseFoundation.h"

@interface CenterToastView ()

@property (nonatomic, strong) UILabel *label;
@end

@implementation CenterToastView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        [self addSubview:self.label];
    }
    return self;
}

- (void)setText:(NSString *)text {
    self.label.text = text;
    self.label.centerX = self.width / 2.0;
    self.label.centerY = self.height / 2.0;
}

/// 隐藏toast，带淡出动画
- (void)dismiss {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        // 清理静态变量
        static CenterToastView *_currentToast = nil;
        if (_currentToast == self) {
            _currentToast = nil;
        }
    }];
}

/// 显示toast
+ (instancetype)showWithText:(NSString *)text {
    static CenterToastView *_currentToast = nil;
    UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
    if (!keyWindow) return nil;
    
    // 如果已有toast，先隐藏
    if (_currentToast) {
        [_currentToast dismiss];
        _currentToast = nil;
    }
    
    CenterToastView *toast = [[CenterToastView alloc] initWithFrame:CGRectMake(0, 0, 150, 70)];
    toast.center = keyWindow.center;
    [toast setText:text];
    [keyWindow addSubview:toast];
    
    _currentToast = toast;

    // 1.5秒后自动隐藏
    [toast performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];

    return toast;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:FontSize(16)];
        _label.numberOfLines = 1;
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _label;
}
@end
