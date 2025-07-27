//
//  InfoPanelView.m
//  iOS-Demos
//
//  Created by Chieh on 2025/5/29.
//

#import "InfoPanelView.h"
#import "BaseFoundation.h"

@interface InfoPanelView ()


@end

@implementation InfoPanelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.width = kScreenWidth;
        self.height = 1000;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.faceView = [PanelAFace new];
    [self addSubview:self.faceView];
    self.styleView = [PanelBStyle new];
    [self addSubview:self.styleView];
    self.makeupView = [PanelCMakeup new];
    [self addSubview:self.makeupView];
}

- (void)loadView {
    [self.faceView loadView];
    self.faceView.centerX = self.width / 2.0;
    [self.styleView loadView];
    self.styleView.top = self.faceView.bottom + 10;
    self.styleView.centerX = self.width / 2.0;
    [self.makeupView loadView];
    self.makeupView.top = self.styleView.bottom + 10;
    self.makeupView.centerX = self.width / 2.0;
    self.height = self.makeupView.bottom + SafeAreaBottomHeight;
    
}

@end
