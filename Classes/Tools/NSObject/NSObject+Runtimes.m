//
//  NSObject+Runtimes.m
//  DIKit
//
//  Created by Back on 16/5/24.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "NSObject+Runtimes.h"
#import <objc/runtime.h>

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
	id res;
	
	Method method = class_getClassMethod(self.class, selector);
	char* returnType = method_copyReturnType(method);
	//strcmp not work
	if(returnType[0]=='v'&&returnType[1]=='\0')
	{
		void (*func)(id, SEL) = (void *)imp;
		func(self, selector);
	}
	else
	{
		id (*func)(id, SEL) = (void *)imp;
		res = func(self,selector);
	}
	free(returnType);
	
	return res;//如果返回值是void，直接返回会报错。
}

+(id)invokeSelector:(SEL)selector withParams:(id)param,...
{
	va_list params;
	IMP imp = [self methodForSelector:selector];
	id res;
	
	Method method = class_getClassMethod(self.class, selector);
	char* returnType = method_copyReturnType(method);
	//strcmp not work
	if(returnType[0]=='v'&&returnType[1]=='\0')
	{
		void (*func)(id, SEL,id,...) = (void *)imp;
		func(self, selector,param,params);
	}
	else
	{
		id (*func)(id, SEL,id,...) = (void *)imp;
		res = func(self, selector,param,params);
	}
	free(returnType);
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
	id res;
	
	Method method = class_getInstanceMethod(self.class, selector);
	char* returnType = method_copyReturnType(method);
	//strcmp not work
	if(returnType[0]=='v'&&returnType[1]=='\0')
	{
		void (*func)(id, SEL) = (void *)imp;
	 	func(self, selector);
	}
	else
	{
		id (*func)(id, SEL) = (void *)imp;
		res = func(self,selector);
	}
	free(returnType);
	
	return res;
}

-(id)invokeSelector:(SEL)selector withParams:(id)param,...
{
	va_list params;
	IMP imp = [self methodForSelector:selector];
	id res;
	
	Method method = class_getInstanceMethod(self.class, selector);
	char* returnType = method_copyReturnType(method);
	//strcmp not work
	if(returnType[0]=='v'&&returnType[1]=='\0')
	{
		void (*func)(id, SEL,id,...) = (void *)imp;
		func(self, selector,param,params);
	}
	else
	{
		id (*func)(id, SEL,id,...) = (void *)imp;
		res = func(self, selector,param,params);
	}
	free(returnType);
	
	return res;
}
@end
