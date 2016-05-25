//
//  NSObject+Runtimes.h
//  DIKit
//
//  Created by Back on 16/5/24.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtimes)
#pragma mark - static
/**
 *  用方法名显式调用一个类型的静态方法（安全起见调用前应先检查方法是否存在）
 *
 *  @param methodName 方法名
 *
 *  @return 方法的返回值
 */
+(id)invokeStaticMethod:(NSString*)methodName;
/**
 *  用方法名显式调用一个类型的静态方法（安全起见调用前应先检查方法是否存在）
 *
 *  @param methodName 方法名
 *  @param param      参数列表
 *
 *  @return 方法返回值
 */
+(id)invokeStaticMethod:(NSString*)methodName withParams:(id)param,...;

#pragma mark
/**
 *  用方法名显式调用一个对象的方法
 *
 *  @param methodName 方法名
 *
 *  @return 方法的返回值
 */
-(id)invokeMethod:(NSString*)methodName;
/**
 *  用方法名显式调用一个对象的带参数方法
 *
 *  @param methodName 方法名
 *  @param param      参数列表
 *
 *  @return 方法返回值
 */
-(id)invokeMethod:(NSString *)methodName withParams:(id)param,...;
@end
