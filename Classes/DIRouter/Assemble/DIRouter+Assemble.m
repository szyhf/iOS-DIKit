//
//  DIRouter+Assemble.m
//  DIKit
//
//  Created by Back on 16/5/17.
//  Copyright © 2016年 Back. All rights reserved.
//


#import "DIRouter+Assemble.h"
#import "DITools.h"
#import "DIContainer.h"
#import "NSObject+Runtimes.h"

@implementation DIRouter (Assemble)

+(RealizeHandlerBlock)blockToAddElement:(NSString*)element
		 toParent:( NSString*)lastElement
{
	bool isSlove = false;
	
	Class lastClazz = NSClassFromString(lastElement);
	NSString* superLastName = lastElement;
	if(lastClazz==nil)
	{
		//尝试匿名解决
		superLastName =[self realizeOfAnonymous:lastElement];
		lastClazz = NSClassFromString(superLastName);
	}
	
	Class currentClazz = NSClassFromString(element);
	
	NSString* elementRealizeName = element;
	if(currentClazz == nil)
	{
		//尝试匿名解决
		elementRealizeName = [self realizeOfAnonymous:element];
		currentClazz = NSClassFromString(elementRealizeName);
	}
	
	Class superLastClazz = lastClazz;//纯改名，lastClazz已经没用了。
	
	//回溯父控件的类，直到找到最接近的被注册过的类型。
	while (superLastClazz!=nil
		   && !isSlove )
	{
		Class superCurrentClazz = currentClazz;
		NSString* superCurrentName = elementRealizeName;
		//回溯当前类，直到找到最近被注册的处理器
		while (superCurrentClazz!=nil)
		{
			NSString* realizeName = [NSString stringWithFormat:@"realize%@To%@",superLastName,superCurrentName];
			SEL select = NSSelectorFromString(realizeName);
			if([(id)self.class respondsToSelector:select])
			{
				RealizeHandlerBlock testBlock = [self invokeMethod:realizeName];
				return testBlock;
			}
			//因为superCurrent有初始值（匿名的情况），所以最后才更新。
			superCurrentName = NSStringFromClass(superCurrentClazz);
			
			superCurrentClazz = [superCurrentClazz superclass];
		}
		//因为superLastName有初始值，所以最后才更新
		superLastName = NSStringFromClass(superLastClazz);
		
		superLastClazz = [superLastClazz superclass];
	}
	return nil;
}

+(void)addElement:(NSString* _Nonnull)element
		 toParent:( NSString* _Nonnull )lastElement
{
	bool isSlove = false;
	
	Class lastClazz = NSClassFromString(lastElement);
	NSString* superLastName = lastElement;
	if(lastClazz==nil)
	{
		//尝试匿名解决
		superLastName =[self realizeOfAnonymous:lastElement];
		lastClazz = NSClassFromString(superLastName);
	}
	
	Class currentClazz = NSClassFromString(element);
	
	NSString* elementRealizeName = element;
	if(currentClazz == nil)
	{
		//尝试匿名解决
		elementRealizeName = [self realizeOfAnonymous:element];
		currentClazz = NSClassFromString(elementRealizeName);
	}
	
	Class superLastClazz = lastClazz;//纯改名，lastClazz已经没用了。
	
	//回溯父控件的类，直到找到最接近的被注册过的类型。
	while (superLastClazz!=nil
		   && !isSlove )
	{
		Class superCurrentClazz = currentClazz;
		NSString* superCurrentName = elementRealizeName;
		//回溯当前类，直到找到最近被注册的处理器
		while (superCurrentClazz!=nil)
		{
			NSString* realizeName = [NSString stringWithFormat:@"realize%@To%@",superLastName,superCurrentName];
			SEL select = NSSelectorFromString(realizeName);
			if([(id)self.class respondsToSelector:select])
			{
				RealizeHandlerBlock testBlock = [self invokeMethod:realizeName];
				testBlock(lastElement,element);
				isSlove = true;
				break;
				
			}
			//因为superCurrent有初始值（匿名的情况），所以最后才更新。
			superCurrentName = NSStringFromClass(superCurrentClazz);
			
			superCurrentClazz = [superCurrentClazz superclass];
		}
		//因为superLastName有初始值，所以最后才更新
		superLastName = NSStringFromClass(superLastClazz);
		
		superLastClazz = [superLastClazz superclass];
	}
	
	WarnLogWhile(!isSlove, @"Add %@ to %@ Failed.",element,lastElement);
}

/**
 *  尝试推断可能符合条件的element
 *
 *  @param element 元素名
 *
 *  @return 推断出来的可行元素名
 */
+(NSString*)realizeOfAnonymous:(NSString*)aliasName
{
	NSString* realizeName = [self aliasMap][aliasName];
	if([NSString isNilOrEmpty:realizeName])
	{
		//尝试根据名称进行推测
		for (NSString* suffix in [DIRouter assumeMap])
		{
			if([aliasName hasSuffix:suffix])
			{
				realizeName = [DIRouter assumeMap][suffix];
				break;
			}
		}
		
		//记录下来。
		[self aliasMap][aliasName]=realizeName;
	}
	
	if(![DIContainer isBind:aliasName])
	{
		//尚未注册过
		Class realizeClazz = NSClassFromString(realizeName);
		if(realizeClazz!=nil)
		{
			id ins = [[realizeClazz alloc]init];
			//用实例注册一个匿名的类型
			[DIContainer bindClassName:aliasName withInstance:ins];
		}
		WarnLogWhile(realizeClazz==nil, @"Using anonymousMap as %@ => %@, but origin class is not exit.",aliasName,realizeName);
		
		NoticeLogWhile(aliasName!=realizeName, @"Assume 😇%@😇 as ☺️%@☺️",aliasName,realizeName);
	}
	
	return realizeName;
}

/**
 *  推断用的后缀
 */
+(NSDictionary<NSString*,NSString*>*)assumeMap
{
	static NSDictionary<NSString*,NSString*>* _assumeMap;
	if(_assumeMap==nil)
		_assumeMap=@{
					 //Controller结尾中，
					 @"NavigationController":@"UINavigationController",
					 @"TabBarController":@"UITabBarController",
					 @"ViewController":@"UIViewController",
					 
					 @"TabBarItem":@"UITabBarItem",
					 @"BarButtonItem":@"UIBarButtonItem",
					 @"BarButton":@"UIBarButtonItem",
					 
					 @"Label":@"UILabel",
					 @"Button":@"UIButton",
					 
					 //view结尾中，最原始的View要最后结尾。
					 @"ImageView":@"UIImageView",
					 @"View":@"UIView",
					 };
	return _assumeMap;
}

/**
 *  自定义的别名
 */
+(NSMutableDictionary<NSString*,NSString*>*)aliasMap
{
	static NSMutableDictionary<NSString*,NSString*>* _aliasMap;
	if (_aliasMap ==nil)
		_aliasMap
		= [NSMutableDictionary
		   dictionaryWithDictionary:@{
			  @"MainTabBarController":@"UITabBarController"
		}];
	return _aliasMap;
}

+(NSMutableDictionary<NSString*,RealizeHandlerBlock>*)realizeBlockCache
{
	static NSMutableDictionary<NSString*,RealizeHandlerBlock>*_realizeBlockCached;
	if(_realizeBlockCached==nil)
		_realizeBlockCached = [NSMutableDictionary dictionaryWithCapacity:10];
	return _realizeBlockCached;
}
@end
