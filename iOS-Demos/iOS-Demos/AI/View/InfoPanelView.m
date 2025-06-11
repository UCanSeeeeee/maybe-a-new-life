//
//  InfoPanelView.m
//  iOS-Demos
//
//  Created by Chieh on 2025/5/29.
//

#import "InfoPanelView.h"
#import "PanelDSummary.h"
#import "PanelAFace.h"
#import "PanelBStyle.h"
#import "PanelCMakeup.h"

@interface InfoPanelView ()

@property (nonatomic, strong) PanelDSummary *topView;
@property (nonatomic, strong) PanelAFace *faceView;
@property (nonatomic, strong) PanelBStyle *styleView;
@property (nonatomic, strong) PanelCMakeup *makeupView;


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
    self.topView = [PanelDSummary new];
    [self addSubview:self.topView];
    self.faceView = [PanelAFace new];
    [self addSubview:self.faceView];
    self.styleView = [PanelBStyle new];
    [self addSubview:self.styleView];
    self.makeupView = [PanelCMakeup new];
    [self addSubview:self.makeupView];
}

- (void)loadViewWithModel:(AIResult *)model {
    [self.topView loadViewWithModel:model.summary];
    self.topView.top = 20;
    [self.faceView loadViewWithModel:model.face_analysis];
    self.faceView.top = self.topView.bottom + 10;
    [self.styleView loadViewWithModel:model.style_positioning];
    self.styleView.top = self.faceView.bottom + 10;
    [self.makeupView loadViewWithModel:model.makeup_recommendation];
    self.makeupView.top = self.styleView.bottom + 10;
    self.height = self.makeupView.bottom + SafeAreaBottomHeight;
    
}


@end
