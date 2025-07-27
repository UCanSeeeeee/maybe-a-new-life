//
//  PanelBDetailModel.m
//  iOS-Demos
//
//  Created by Chieh on 2025/7/13.
//

#import "PanelBDetailModel.h"

@implementation KeyCorrectionModel

@end

@implementation PanelBDetailModel

// 甜美型/活泼型/少年型/优雅型/自然型/前卫型/魅力型/古典型/
- (NSString *)conclusionStyleString {
    NSDictionary<NSString *, NSString *> *faceStyleMap = @{
        @"0": @"甜美型",
        @"1": @"活泼型",
        @"2": @"少年型",
        @"3": @"优雅型",
        @"4": @"自然型",
        @"5": @"前卫型",
        @"6": @"魅力型",
        @"7": @"古典型",
        @"8": @"帅气型",
    };
    NSString *tempStyle = @"自然型";
    if (self.conclusion && self.conclusion.integerValue <= 8) {
        tempStyle = [faceStyleMap valueForKey:self.conclusion.stringValue];
    }
    return tempStyle;
}

- (NSString *)makeupStrategyKeyString {
    NSDictionary<NSString *, NSString *> *faceStyleMap = @{
        @"0": @"眉妆+眼妆（强调眉眼的立体感）",
        @"1": @"眼妆+唇妆（适合眼睛漂亮的瓜子脸、鹅蛋脸）",
        @"2": @"腮红+唇妆（拉低视觉重心，注重妆面色彩和谐度） ",
        @"3": @"眉妆+唇妆（眉毛和嘴唇形成强烈的颜色对比感）",
    };
    NSString *tempStyle = @"眉妆+眼妆（强调眉眼的立体感）";
    if (self.makeup_strategy && self.makeup_strategy.integerValue <= 3) {
        tempStyle = [faceStyleMap valueForKey:self.makeup_strategy.stringValue];
    }
    return tempStyle;
}

- (NSArray<NSString *> *)makeupStrategyValueArray {
    NSDictionary *faceStyleMap = @{
        @"0": @[@"眉毛颜色稍深，和精致的眼妆平衡，同时提升眉毛毛流感", @"眼影要有深浅层次感，提升立体度", @"勾画卧蚕，增加眼睛体量", @"夹翘睫毛，睫毛短少的可以贴上单簇假睫毛", @"裸色口红，避免全脸重点"],
        @"1": @[@"眼影和唇妆同色系",@"眼妆强调卧蚕和睫毛，让眼妆更灵动",@"眼妆可以适当增加亮片，增加华丽感",@"眉毛不要太有攻击性，自然弯眉即可"],
        @"2": @[@"腮红大面积晕染苹果肌减少面部留白，但不要超过鼻翼",@"口红和腮红用同色系，打造氛围感，上唇口红稍微晕出，缩短人中",@"哑光高光提亮面中和鼻梁，鼻侧影加深山根，塑造立体感",@"眉毛颜色不用太深，用眉粉打造毛茸茸的感觉",@"眼妆重点可以放在睫毛上"],
        @"3": @[
            @"眉毛颜色稍深，眉形菱角利落，提升毛流感",
            @"口红颜色选饱和度高的，比如正红色",
            @"眉毛和口红形成红黑对比",
            @"眼妆用浅棕色、杏色带过，达到消肿和增加深邃感即可"
        ]
    };
    NSArray *tempStyle = @[@"眉毛颜色稍深，和精致的眼妆平衡，同时提升眉毛毛流感", @"眼影要有深浅层次感，提升立体度", @"勾画卧蚕，增加眼睛体量", @"夹翘睫毛，睫毛短少的可以贴上单簇假睫毛", @"裸色口红，避免全脸重点"];
    if (self.makeup_strategy && self.makeup_strategy.integerValue <= 3) {
        tempStyle = [faceStyleMap valueForKey:self.makeup_strategy.stringValue];
    }
    return tempStyle;
}

@end
