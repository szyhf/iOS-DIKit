//
//  NSObject+Runtimes.m
//  DIKit
//
//  Created by Back on 16/5/24.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "NSObject+Runtimes.h"
#import <objc/runtime.h>
#import <objc/message.h>

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
	NSMethodSignature *sig= [self methodSignatureForSelector:selector];
	NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
	invo.target = self;
	invo.selector = selector;
	[invo setArgument:&param atIndex:2];
	
	va_start(params, param);
	for(int i = 3; i < sig.numberOfArguments;i++)
	{
		//返回可变参数，va_arg第二个参数为可变参数类型，如果有多个可变参数，依次调用可获取各个参数
		void* var_param = va_arg(params, void*);
		[invo setArgument:&var_param atIndex:i];
	}
	
	[invo retainArguments];
	va_end(params);
	[invo invoke];
	//获得返回值类型
	const char *returnType = sig.methodReturnType;
	
	id res = nil;
	if(!strcmp(returnType, @encode(void)))
	{
		//return nil;
	}
	else if(!strcmp(returnType, @encode(id)))
	{
		[invo getReturnValue:&res];
	}
	else
	{
		NSUInteger length = [sig methodReturnLength];
		//根据长度申请内存
		void *buffer = (void *)malloc(length);
		//为变量赋值
		[invo getReturnValue:buffer];
		
		if( !strcmp(returnType, @encode(BOOL)) )
		{
			res = [NSNumber numberWithBool:*((BOOL*)buffer)];
		}
		else if( !strcmp(returnType, @encode(char)))
		{
			res = [NSNumber numberWithChar:*((char*)buffer)];
		}
		else if(!strcmp(returnType, @encode(NSInteger)))
		{
			res = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
		}
		else if(!strcmp(returnType, @encode(int)))
		{
			res = [NSNumber numberWithInt:*((int*)buffer)];
		}
		else if(!strcmp(returnType, @encode(short)))
		{
			res = [NSNumber numberWithShort:*((short*)buffer)];
		}
		else if(!strcmp(returnType, @encode(long)))
		{
			res = [NSNumber numberWithLong:*((long*)buffer)];
		}
		else if(!strcmp(returnType, @encode(long long)))
		{
			res = [NSNumber numberWithLongLong:*((long long*)buffer)];
		}
		else if(!strcmp(returnType, @encode(unsigned char)))
		{
			res = [NSNumber numberWithUnsignedChar:*((unsigned char*)buffer)];
		}
		else if(!strcmp(returnType, @encode(unsigned int)))
		{
			res = [NSNumber numberWithUnsignedInt:*((unsigned int*)buffer)];
		}
		else if(!strcmp(returnType, @encode(unsigned int)))
		{
			res = [NSNumber numberWithUnsignedInteger:*((unsigned int*)buffer)];
		}
		else if(!strcmp(returnType, @encode(unsigned short)))
		{
			res = [NSNumber numberWithUnsignedShort:*((unsigned short*)buffer)];
		}
		else if(!strcmp(returnType, @encode(unsigned long)))
		{
			res = [NSNumber numberWithUnsignedLong:*((unsigned long*)buffer)];
		}
		else if(!strcmp(returnType, @encode(unsigned long long)))
		{
			res = [NSNumber numberWithUnsignedLongLong:*((unsigned long long*)buffer)];
		}
		else if(!strcmp(returnType, @encode(float)))
		{
			res = [NSNumber numberWithFloat:*((float*)buffer)];
		}
		else if(!strcmp(returnType, @encode(double)))
		{
			res = [NSNumber numberWithDouble:*((double*)buffer)];
		}
		else if(!strcmp(returnType, @encode(char *)))
		{
			res = [NSValue valueWithPointer:buffer];
		}
		else
		{
			res = [NSValue valueWithBytes:buffer objCType:returnType];
		}
	}
	
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
	NSString* cacheKey = [NSString stringWithFormat:@"%@*%@",NSStringFromClass(self.class),NSStringFromSelector(selector)];
	
	NSMethodSignature *sig= [self.class di_signatureCache][cacheKey];
	if(!sig)
		sig = [self methodSignatureForSelector:selector];
	NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
	invo.target = self;
	invo.selector = selector;
	[invo setArgument:&param atIndex:2];
	
	va_start(params, param);
	for(int i = 3; i < sig.numberOfArguments;i++)
	{
		//返回可变参数，va_arg第二个参数为可变参数类型，如果有多个可变参数，依次调用可获取各个参数
		void* var_param = va_arg(params, void*);
		[invo setArgument:&var_param atIndex:i];
	}
	
	[invo retainArguments];
	va_end(params);
	[invo invoke];
	//获得返回值类型
	const char *returnType = sig.methodReturnType;
	
	id res = nil;
	if(!strcmp(returnType, @encode(void)))
	{
		//return nil;
	}
	else if(!strcmp(returnType, @encode(id)))
	{
		[invo getReturnValue:&res];
	}
	else
	{
		NSUInteger length = [sig methodReturnLength];
		//根据长度申请内存
		void *buffer = (void *)malloc(length);
		//为变量赋值
		[invo getReturnValue:buffer];
		
		if( !strcmp(returnType, @encode(BOOL)) )
		{
			res = [NSNumber numberWithBool:*((BOOL*)buffer)];
		}
		else if( !strcmp(returnType, @encode(char)))
		{
			res = [NSNumber numberWithChar:*((char*)buffer)];
		}
		else if(!strcmp(returnType, @encode(NSInteger)))
		{
			res = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
		}
		else if(!strcmp(returnType, @encode(int)))
		{
			res = [NSNumber numberWithInt:*((int*)buffer)];
		}
		else if(!strcmp(returnType, @encode(short)))
		{
			res = [NSNumber numberWithShort:*((short*)buffer)];
		}
		else if(!strcmp(returnType, @encode(long)))
		{
			res = [NSNumber numberWithLong:*((long*)buffer)];
		}
		else if(!strcmp(returnType, @encode(long long)))
		{
			res = [NSNumber numberWithLongLong:*((long long*)buffer)];
		}
		else if(!strcmp(returnType, @encode(unsigned char)))
		{
			res = [NSNumber numberWithUnsignedChar:*((unsigned char*)buffer)];
		}
		else if(!strcmp(returnType, @encode(unsigned int)))
		{
			res = [NSNumber numberWithUnsignedInt:*((unsigned int*)buffer)];
		}
		else if(!strcmp(returnType, @encode(unsigned int)))
		{
			res = [NSNumber numberWithUnsignedInteger:*((unsigned int*)buffer)];
		}
		else if(!strcmp(returnType, @encode(unsigned short)))
		{
			res = [NSNumber numberWithUnsignedShort:*((unsigned short*)buffer)];
		}
		else if(!strcmp(returnType, @encode(unsigned long)))
		{
			res = [NSNumber numberWithUnsignedLong:*((unsigned long*)buffer)];
		}
		else if(!strcmp(returnType, @encode(unsigned long long)))
		{
			res = [NSNumber numberWithUnsignedLongLong:*((unsigned long long*)buffer)];
		}
		else if(!strcmp(returnType, @encode(float)))
		{
			res = [NSNumber numberWithFloat:*((float*)buffer)];
		}
		else if(!strcmp(returnType, @encode(double)))
		{
			res = [NSNumber numberWithDouble:*((double*)buffer)];
		}
		else if(!strcmp(returnType, @encode(char *)))
		{
			res = [NSValue valueWithPointer:buffer];
		}
		else
		{
			res = [NSValue valueWithBytes:buffer objCType:returnType];
		}
	}
	
	return res;
}

+(NSMutableDictionary<NSString*,NSMethodSignature*>*)di_signatureCache
{
	static NSMutableDictionary<NSString*,NSMethodSignature*>* cache;
	if(!cache)
	{
		cache = [NSMutableDictionary dictionary];
	}
	return cache;
}
@end
