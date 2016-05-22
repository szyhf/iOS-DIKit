//
//  Container.h
//  Fakeshion
//
//  Created by Back on 16/4/29.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^FactoryBlock)(id alloced);
typedef void(^AfterInitBlock)(id newIns);

/**
 *  一个简单的容器（非常简单）
 */
@interface DIContainer : NSObject

/**
 *  一个类型是否已经被注册
 *
 *  @param Clazz 类型全名
 */
+(bool)isBind:(NSString*)Clazz;

/**
 *  自动绑定一个对象到容器，设置为这个类型的单例
 *
 *  @param ins 对象
 */
+(void)bindInstance:(id)ins;

/**
 *  绑定一个实例到指定类型
 *
 *  @param clazz 指定类型
 *  @param ins   指定实例
 */
+(void )bindClass:(Class)clazz withInstance:(id)ins;

/**
 *  绑定一个实例工厂到指定类型
 *
 *  @param clazz   类型
 *  @param factory 实例工厂方法
 */
+(void)bindClass:(Class)clazz withBlock:(FactoryBlock)factory;

/**
 *  注册一个类型，并使用默认init初始化（延迟加载）
 *
 *  @param clazz 类型
 */
+(void)bindClass:(Class)clazz;

/**
 *  通过类型名称，绑定一个实例到指定类型
 *
 *  @param clazz 指定类型
 *  @param ins   指定实例
 */
+(void )bindClassName:(NSString*)className withInstance:(id)ins;

/**
 *  通过类型名称，绑定一个实例工厂到指定类型
 *
 *  @param clazz   类型
 *  @param factory 实例工厂方法
 */
+(void)bindClassName:(NSString*)className withBlock:(FactoryBlock)factory;

/**
 *  根据类型名称注册一个类型
 *
 *  @param className 类型的名称
 */
+(void)bindClassName:(NSString*)className;

/**
 *  一个类型的构造函数被调用之后回调
 *
 *  @param onInit 回调要做的事情
 *  @param clazz  类型的全名
 */
+(void)hookAfterInit:(AfterInitBlock)onInit forClassName:(NSString*)className;

/**
 *  一个类型的构造函数被调用之后回调
 *
 *  @param onInit 回调要做的事情
 *  @param clazz  类型
 */
+(void)hookAfterInit:(AfterInitBlock)onInit forClass:(Class)clazz;

/**
 *  给一个类型设置别名
 *
 *  @param alias 别名
 *  @param clazz 类型
 */
+(void)setAlias:(NSString*)alias forClass:(Class)clazz;

/**
 *  根据给出的实例自动给一个类型设置别名
 *
 *  @param alias 别名
 *  @param ins   实例
 */
+(void)setAlias:(NSString*)alias forInstance:(id)ins;

/**
 *  根据名称获取实例
 *
 *  @param name 名称或别名
 *
 *  @return 实例，如果不存在则返回nil
 */
+(id)getInstanceByName:(NSString*)name;

/**
 *  根据指定类型获取对应单例
 *
 *  @param clazz 类型
 *
 *  @return 对应的单例，如果不存在则返回nil
 */
+(id)getInstance:(Class)clazz;

+(void)clear;
@end