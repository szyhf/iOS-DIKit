//
//  NSObject+DIAttribute.m
//  DIKit
//
//  Created by Back on 16/5/24.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "NSObject+DIAttribute.h"
#import "DIConverter.h"
#import "NSObject+Runtimes.h"
#import <objc/runtime.h>

@implementation NSObject (DIAttribute)
+(void)load
{
	Method oldSetValue = class_getInstanceMethod(self, @selector(setValue:forKey:));
	Method newSetValue = class_getInstanceMethod(self, @selector(di_setValue:forKey:));
	method_exchangeImplementations(oldSetValue, newSetValue);
}
-(void)di_setValue:(id)value forKey:(NSString*)key
{
	static NSMutableArray* _dependencyArray;
	if(!_dependencyArray)
	{
		_dependencyArray = [NSMutableArray array];
	}
	
	Class superClass = self.class;
	//[_dependencyArray push:self.class];
	while (superClass)
	{
		if([((id)superClass)respondsToSelector:@selector(di_AttributeBlock:)])
		{
			UndefinedKeyHandlerBlock block  = [superClass di_AttributeBlock:key];
			if(block!=nil)
			{
				if ([[_dependencyArray top]isEqual:superClass])
				{
					[_dependencyArray pop];
					return [self di_setValue:value forKey:key];
				}
				[_dependencyArray push:superClass];
				if(_dependencyArray.count>100)
				{
					DebugLog(@"");
				}
				block(self,key,value);
				[_dependencyArray pop];
				return;
			}
		}
		superClass = [superClass superclass];
	}
	
	[_dependencyArray push:self.class];
	//@try
	//{
		//[self di_setValue:value forKey:key];
	//}
	//@catch (NSException *exception)
	//{
		value = [self.class di_assumeValue:value byKey:key];
		[self di_setValue:value forKey:key];
	//}
	//@finally
	//{
		[_dependencyArray pop];
	//}

}

-(void)updateByNode:(DINode*)node
{
	[node.attributes enumerateKeysAndObjectsUsingBlock:
	 ^(NSString * _Nonnull key,
	   NSString * _Nonnull value,
	   BOOL * _Nonnull stop)
	{
		@try
		{
			//[self.class di_UpdateObject:self byKey:key value:value];
			[self setValue:value forKeyPath:key];
		}
		@catch (NSException *exception)
		{
			WarnLog(@"set <%@ %p> attribute[%@ => %@] failed\nException:%@",node.name,self,key,value,exception);
		}
	}];
}

+(id)di_assumeValue:(id)value byKey:(NSString*)key
{
	if(![value isKindOfClass:NSString.class])
		return value;
	NSString* lowerValue = [value lowercaseString];
	if([lowerValue isEqualToString:@"true"] || [lowerValue isEqualToString:@"yes"])
		return [NSNumber numberWithBool:YES];
	if([lowerValue isEqualToString:@"false"] || [lowerValue isEqualToString:@"no"])
		return [NSNumber numberWithBool:NO];
	
	NSString* lowerKey = [key lowercaseString];
	
	if([lowerKey hasSuffix:@"color"])
	{
		return [DIConverter toColor:value];
	}
	if([lowerKey hasSuffix:@"image"])
	{
		return [DIConverter toImage:value];
	}
	if([lowerKey hasSuffix:@"size"])
	{
		return [DIConverter toSizeValue:value];
	}
	if([lowerKey hasSuffix:@"insets"])
	{
		return [DIConverter toEdgeInsetsValue:value];
	}
	if([lowerKey hasSuffix:@"inset"])
	{
		return [DIConverter toEdgeInsetsValue:value];
	}
	return value;
}

+(void)di_UpdateObject:(id)obj byKey:(NSString*)key value:(NSString*)value
{
	UndefinedKeyHandlerBlock block  = [self di_AttributeBlock:key];
	if(block!=nil)
		block(obj,key,value);
	else
	{
		Class superClass = [self superclass];
		while (superClass)
		{
			if([((id)superClass)respondsToSelector:@selector(di_UpdateObject:byKey:value:)])
			{
				return (void)[superClass di_UpdateObject:obj byKey:key value:value];
			}
			superClass = [superClass superclass];
		}
#ifndef DI_DEBUG
		@try
		{
			[obj setValue:value forKeyPath:key];
		}
		@catch (NSException *exception)
		{
#endif
			value = [self di_assumeValue:value byKey:key];
			[obj setValue:value forKeyPath:key];
#ifndef DI_DEBUG
		}
#endif
	}
}

-(void)setValue:(id)value
forUndefinedKey:(NSString *)key
{
	objc_setAssociatedObject(self, NSSelectorFromString(key), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)valueForUndefinedKey:(NSString *)key
{
	return objc_getAssociatedObject(self,NSSelectorFromString(key));
}

+(UndefinedKeyHandlerBlock)styleKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _leftBarKey_token;
	dispatch_once(&_leftBarKey_token,
				  ^{
					  _instance =  ^void(UIViewController* obj,NSString*key,id value)
					  {
						  [obj setValue:value forKey:@"nuiClass"];
					  } ;
				  });
	return _instance;
}

+(UndefinedKeyHandlerBlock)di_AttributeBlock:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = @{
									@"style":self.styleKey,
									} ;
				  });
	return _instance[key];
}
@end
