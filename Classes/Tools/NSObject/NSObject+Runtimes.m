//
//  NSObject+Runtimes.m
//  DIKit
//
//  Created by Back on 16/5/24.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "NSObject+Runtimes.h"

@implementation NSObject (Runtimes)
#pragma mark -- static
+(id)invokeMethod:(NSString*)methodName
{
	SEL selector = NSSelectorFromString(methodName);
	return [self invokeSelector:selector];
}

+(id)invokeMethod:(NSString*)methodName withParams:(id)param,...
{
	va_list params;
	SEL selector = NSSelectorFromString(methodName);
	return [self invokeSelector:selector withParams:param,params];
}

+(id)invokeSelector:(SEL)selector
{
	IMP imp = [self methodForSelector:selector];
	id (*func)(id, SEL) = (void *)imp;
	id res = func(self, selector);
	return res;//如果返回值是void，直接返回会报错。
}

+(id)invokeSelector:(SEL)selector withParams:(id)param,...
{
	va_list params;
	IMP imp = [self methodForSelector:selector];
	id (*func)(id, SEL,id,...) = (void *)imp;
	id res =  func(self, selector,param,params);
	return res;
}

-(id)invokeMethod:(NSString*)methodName
{
	SEL selector = NSSelectorFromString(methodName);
	return [self invokeSelector:selector];
}

-(id)invokeMethod:(NSString *)methodName withParams:(id)param,...
{
	va_list params;
	SEL selector = NSSelectorFromString(methodName);
	return [self invokeSelector:selector withParams:param,params];
}

-(id)invokeSelector:(SEL)selector
{
	IMP imp = [self methodForSelector:selector];
	id (*func)(id, SEL) = (void *)imp;
	id res = func(self, selector);
	return res;
}

-(id)invokeSelector:(SEL)selector withParams:(id)param,...
{
	va_list params;
	IMP imp = [self methodForSelector:selector];
	id (*func)(id, SEL,id,...) = (void *)imp;
	id res = func(self, selector,param,params);
	return res;
}
@end
