//
//  Router.h
//  Fakeshion
//
//  Created by Back on 16/4/29.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIRouter : NSObject
//+(void)AutoRouter:(UIViewController*)controller;
+(void)init;
+(void)autoPathRegister:(UIViewController*)child;
/**
 *  根据输入的path组装已有的viewController
 *
 *  @param path 组装路径
 */
+(void)realizePath:(NSString*)path;
/**
 *  预先记录注册路径，用于实现延迟加载
 *
 *  @param path 希望注册的路径
 */
+(void)registerPath:(NSString*)path;
/**
 *  根据注册结果加载当前控制器的成员控制器（用于延迟加载）
 *
 *  @param controller
 */
+(void)lazyLoad:(UIViewController*)controller;
+(void)printRouterMap;
@end
