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

+(void)addElement:(NSString*)element
		 toParent:(NSString*)lastElement
{
	bool isSlove = false;
	if(![NSString isNilOrEmpty:lastElement])
	{
		Class lastClazz = NSClassFromString(lastElement);
		Class currentClazz = NSClassFromString(element);
		
		NSDictionary<NSString*,RealizeHandlerBlock>* blockMap;
		Class superLastClazz = lastClazz;
		
		//回溯父控件的类，直到找到最接近的被注册过的类型。
		while (superLastClazz!=nil
			   && blockMap == nil
			   && !isSlove )
		{
			NSString* superLastName = NSStringFromClass(superLastClazz);
			blockMap = [[self realizeMap]objectForKey:superLastName];
			
			//如果找到了blockMap，则尝试在blockMap中继续找可能符合条件的处理器
			//完全有可能存在blockMap，但不存在处理器的情况，此时应继续向上遍历当前父类是否还存在别的可能符合条件的处理器
			if(blockMap!=nil)
			{
				Class superCurrentClazz = currentClazz;
				RealizeHandlerBlock handlerBlock;
				
				//回溯当前类，直到找到最近被注册的处理器
				while (superCurrentClazz!=nil
					   && handlerBlock==nil)
				{
					NSString* superCurrentName = NSStringFromClass(superCurrentClazz);
					handlerBlock = [blockMap objectForKey:superCurrentName];
					if(handlerBlock!=nil)
					{
						handlerBlock(lastElement,element);
						isSlove = true;
						break;
					}
					superCurrentClazz = [superCurrentClazz superclass];
				}
			}
			
			superLastClazz = [superLastClazz superclass];
		}
#ifdef WARN
		if (!isSlove)
		{
			WarnLog(@"RelizePath Failed: %@\nError: %@",path,element);
		}
#endif
	}
}
@end
