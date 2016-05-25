//
//  NSObject+Runtimes.m
//  DIKit
//
//  Created by Back on 16/5/24.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "NSObject+Runtimes.h"

@implementation NSObject (Runtimes)
+(id)invokeStaticMethod:(NSString*)methodName
{
	return [self.class invokeMethod:methodName];
}

+(id)invokeStaticMethod:(NSString*)methodName withParams:(id)param,...
{
	va_list params;
	//静态方法可以看做对类型的对象的操作（Mata Class）
	return [self.class invokeMethod:methodName withParams:param,params];
}

-(id)invokeMethod:(NSString*)methodName
{
	SEL selector = NSSelectorFromString(methodName);
	if(![self respondsToSelector:selector])return nil;
	IMP imp = [self methodForSelector:selector];
	if(imp==nil)return nil;
	id (*func)(id, SEL) = (void *)imp;
	return func(self, selector);
}

-(id)invokeMethod:(NSString *)methodName withParams:(id)param,...
{
	va_list params;
	SEL selector = NSSelectorFromString(methodName);
	if(![self respondsToSelector:selector])return nil;
	IMP imp = [self methodForSelector:selector];
	if(imp==nil)return nil;
	id (*func)(id, SEL,id,...) = (void *)imp;
	return func(self, selector,param,params);
}
@end
