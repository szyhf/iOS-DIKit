//
//  DIRouter+Assemble.m
//  DIKit
//
//  Created by Back on 16/5/17.
//  Copyright © 2016年 Back. All rights reserved.
//


#import "DIRouter+Assemble.h"
#import "DIRouter+HandlerBlocks.h"
#import "DITools.h"
#import "DIContainer.h"

@implementation DIRouter (Assemble)

+(void)sloveSuper:(Class)clazz
{
	NSDictionary<NSString*,RealizeHandlerBlock>* blockMap;
	while (clazz!=nil)
	{
		NSString* clazzName = NSStringFromClass(clazz);
		
		blockMap = [[self realizeMap]objectForKey:clazzName];
		
 	}
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
	
	NSDictionary<NSString*,RealizeHandlerBlock>* blockMap;
	Class superLastClazz = lastClazz;//纯改名，lastClazz已经没用了。
	
	//回溯父控件的类，直到找到最接近的被注册过的类型。
	while (superLastClazz!=nil
		   && blockMap == nil
		   && !isSlove )
	{
		blockMap = [[self realizeMap]objectForKey:superLastName];
		
		//如果找到了blockMap，则尝试在blockMap中继续找可能符合条件的处理器
		//完全有可能存在blockMap，但不存在处理器的情况，此时应继续向上遍历当前父类是否还存在别的可能符合条件的处理器
		if(blockMap!=nil)
		{
			Class superCurrentClazz = currentClazz;
			RealizeHandlerBlock handlerBlock;
			
			NSString* superCurrentName = elementRealizeName;
			//回溯当前类，直到找到最近被注册的处理器
			while (superCurrentClazz!=nil
				   && handlerBlock==nil)
			{
				handlerBlock = [blockMap objectForKey:superCurrentName];
				if(handlerBlock!=nil)
				{
					handlerBlock(lastElement,element);
					isSlove = true;
					break;
				}
				//因为superCurrent有初始值（匿名的情况），所以最后才更新。
				superCurrentName = NSStringFromClass(superCurrentClazz);
				
				superCurrentClazz = [superCurrentClazz superclass];
			}
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
+(NSString*)realizeOfAnonymous:(NSString*)anonymous
{
	NSString* realizeName = [self anonymousMap][anonymous];
	if([NSString isNilOrEmpty:realizeName])
	{
		//尝试根据名称进行推测
		for (NSString* suffix in [DIRouter assumeMap])
		{
			if([anonymous endsWith:suffix])
			{
				realizeName = [DIRouter assumeMap][suffix];
				break;
			}
		}
	}	
	
	if(![DIContainer isBind:anonymous])
	{
		//尚未注册过
		Class realizeClazz = NSClassFromString(realizeName);
		if(realizeClazz!=nil)
		{
			id ins = [[realizeClazz alloc]init];
			//用实例注册一个匿名的类型
			[DIContainer bindClassName:anonymous withInstance:ins];
		}
		WarnLogWhile(realizeClazz==nil, @"Using anonymousMap as %@ => %@, but origin class is not exit.",anonymous,realizeName);
	}
	
	DebugLogWhile(anonymous!=realizeName, @"Assume %@ as %@",anonymous,realizeName);
	return realizeName;
}

static NSDictionary<NSString*,NSString*>* _assumeMap;
+(NSDictionary<NSString*,NSString*>*)assumeMap
{
	if(_assumeMap==nil)
		_assumeMap=@{
					 //Controller结尾中，
					 @"NavigationController":@"UINavigationController",
					 @"TabBarController":@"UITabBarController",
					 @"ViewController":@"UIViewController",
					 
					 @"Label":@"UILable",
					 
					 //view结尾中，最原始的View要最后结尾。
					 @"ImageView":@"UIImageView",
					 @"View":@"UIView",
					 };
	return _assumeMap;
}

static NSDictionary<NSString*,NSString*>* _anonymousMap;
+(NSDictionary<NSString*,NSString*>*)anonymousMap
{
	if (_anonymousMap ==nil)
		_anonymousMap
		= @{
			@"MainTabBarController":@"UITabBarController"
		  };
	return _anonymousMap;
}
@end
