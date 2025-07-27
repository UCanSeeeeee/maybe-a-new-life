//
//  ConclusionModel.m
//  iOS-Demos
//
//  Created by Chieh on 2025/7/12.
//

#import "ConclusionModel.h"

@implementation ConclusionModel

- (NSString *)fetchAnimateStyle {
    NSDictionary<NSString *, NSString *> *animateStyleMap = @{
        @"0": @"CH_rabbit_style",
        @"1": @"CH_dog_style",
        @"2": @"CH_deer_style",
        @"3": @"CH_cat_style",
        @"4": @"CH_pig_style",
        @"5": @"CH_snake_style",
        @"6": @"CH_fox_style",
        @"7": @"CH_bird_style"
    };
    NSString *tempStyle = @"CH_rabbit_style";
    if (self.animateStyle && self.animateStyle.integerValue <= 7) {
        tempStyle = [animateStyleMap valueForKey:self.animateStyle.stringValue];
    }
    return tempStyle;
}

- (NSString *)fetchAgeString {
    NSArray<NSNumber *> *numberArray = @[@18, @20, @24, @28, @30, @32, @35, @40];
    if (self.skinAge.integerValue <= 0) {
        return @"CH_conclusion_24";
    }
    NSNumber *closest = numberArray.firstObject;
    double minDifference = fabs(self.skinAge.doubleValue - closest.doubleValue);
    for (NSNumber *num in numberArray) {
        double diff = fabs(self.skinAge.doubleValue - num.doubleValue);
        if (diff < minDifference) {
            minDifference = diff;
            closest = num;
        }
    }
    return [NSString stringWithFormat:@"CH_conclusion_%ld", closest.integerValue];;
}

// 标准脸/长形脸/圆形脸/方形脸/梨形脸/瓜子脸/菱形脸
- (NSString *)fetchFaceStyleString {
    NSDictionary<NSString *, NSString *> *faceStyleMap = @{
        @"0": @"标准脸",
        @"1": @"长形脸",
        @"2": @"圆形脸",
        @"3": @"方形脸",
        @"4": @"梨形脸",
        @"5": @"瓜子脸",
        @"6": @"菱形脸"
    };
    NSString *tempStyle = @"标准脸";
    if (self.faceStyle && self.faceStyle.integerValue <= 6) {
        tempStyle = [faceStyleMap valueForKey:self.faceStyle.stringValue];
    }
    return tempStyle;
}
// 脸型特点总结
- (NSString *)fetchFaceStyleConclusionString {
    NSDictionary<NSString *, NSString *> *faceStyleMap = @{
        @"标准脸": @"堪称完美的脸型比例，额头饱满下巴圆润，线条流畅，什么发型都能hold住。",
        @"长形脸": @"下颌角存在感超强，线条分明，自带大气场，妥妥的高级脸代表。",
        @"圆形脸": @"可可爱爱的娃娃脸，脸颊肉肉的，下巴圆润，看起来比实际年龄小，但容易显脸大。",
        @"方形脸": @"脸型比较瘦长，中庭偏长容易显成熟，但自带优雅气质，适合走御姐风。",
        @"梨形脸": @"下半张脸比较有存在感，下颌角明显，容易显得稳重或有点憨厚感。",
        @"瓜子脸": @"上宽下窄的精致脸型，额头饱满，颧骨柔和，自带甜美又带点小妩媚的气质。",
        @"菱形脸": @"颧骨是整张脸最突出的部分，额头和下巴都比较窄，容易显得高冷或有点凶，但其实超级高级！"
    };
    NSString *tempStyle = [faceStyleMap valueForKey:self.fetchFaceStyleString];
    return tempStyle;
}
@end
