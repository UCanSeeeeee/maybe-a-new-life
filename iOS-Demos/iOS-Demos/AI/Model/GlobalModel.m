//
//  GlobalModel.m
//  iOS-Demos
//
//  Created by Chieh on 2025/7/13.
//

#import "GlobalModel.h"

@implementation GlobalModel

- (BOOL)canShowPanelInfo {
    if (self.panelAFaceModel && self.panelBDetailModel && self.panelCRecommandModel) {
        return YES;
    } else {
        return NO;
    }
}

//- (ConclusionModel *)conclusionModel {
//    // 获取本地JSON文件路径
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"conclusion" ofType:@"json"];
//    NSError *error = nil;
//    // 读取JSON文件内容
//    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
//    if (!jsonData) {
//        NSLog(@"无法读取JSON文件");
//        return nil;
//    }
//    
//    // 将JSON数据转换为字典
//    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                           options:NSJSONReadingAllowFragments
//                                                             error:&error];
//    if (error) {
//        NSLog(@"JSON解析错误: %@", error.localizedDescription);
//        return nil;
//    }
//    
//    // 使用JSONModel解析为PanelModel对象
//    ConclusionModel *panelModel = [[ConclusionModel alloc] initWithDictionary:jsonDict error:&error];    // 获取本地JSON文件路径
//    return panelModel;
//}
//
//- (PanelAFaceModel *)panelAFaceModel {
//    // 获取本地JSON文件路径
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"panelAFace" ofType:@"json"];
//    NSError *error = nil;
//    // 读取JSON文件内容
//    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
//    if (!jsonData) {
//        NSLog(@"无法读取JSON文件");
//        return nil;
//    }
//    
//    // 将JSON数据转换为字典
//    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                           options:NSJSONReadingAllowFragments
//                                                             error:&error];
//    if (error) {
//        NSLog(@"JSON解析错误: %@", error.localizedDescription);
//        return nil;
//    }
//    
//    // 使用JSONModel解析为PanelModel对象
//    PanelAFaceModel *panelModel = [[PanelAFaceModel alloc] initWithDictionary:jsonDict error:&error];    // 获取本地JSON文件路径
//    return panelModel;
//}
//
//- (PanelBDetailModel *)panelBDetailModel {
//    // 获取本地JSON文件路径
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"panelB" ofType:@"json"];
//    NSError *error = nil;
//    // 读取JSON文件内容
//    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
//    if (!jsonData) {
//        NSLog(@"无法读取JSON文件");
//        return nil;
//    }
//    
//    // 将JSON数据转换为字典
//    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                           options:NSJSONReadingAllowFragments
//                                                             error:&error];
//    if (error) {
//        NSLog(@"JSON解析错误: %@", error.localizedDescription);
//        return nil;
//    }
//    
//    // 使用JSONModel解析为PanelModel对象
//    PanelBDetailModel *panelModel = [[PanelBDetailModel alloc] initWithDictionary:jsonDict error:&error];    // 获取本地JSON文件路径
//    return panelModel;
//}
//
//- (PanelCRecommandModel *)panelCRecommandModel {
//    // 获取本地JSON文件路径
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"panelC" ofType:@"json"];
//    NSError *error = nil;
//    // 读取JSON文件内容
//    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
//    if (!jsonData) {
//        NSLog(@"无法读取JSON文件");
//        return nil;
//    }
//    
//    // 将JSON数据转换为字典
//    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                           options:NSJSONReadingAllowFragments
//                                                             error:&error];
//    if (error) {
//        NSLog(@"JSON解析错误: %@", error.localizedDescription);
//        return nil;
//    }
//    
//    // 使用JSONModel解析为PanelModel对象
//    PanelCRecommandModel *panelModel = [[PanelCRecommandModel alloc] initWithDictionary:jsonDict error:&error];    // 获取本地JSON文件路径
//    return panelModel;
//}

@end
