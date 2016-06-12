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
	
	Class currentClazz = NSClassFromString(element);
	
	NSString* elementRealizeName = element;
	
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

+(NSMutableDictionary<NSString*,RealizeHandlerBlock>*)realizeBlockCache
{
	static NSMutableDictionary<NSString*,RealizeHandlerBlock>*_realizeBlockCached;
	if(_realizeBlockCached==nil)
		_realizeBlockCached = [NSMutableDictionary dictionaryWithCapacity:10];
	return _realizeBlockCached;
}
@end
