//
//  DINode+Awake.m
//  Pods
//
//  Created by Back on 16/6/3.
//
//
#import "DINode.h"
#import "NSObject+DIAttribute.h"
#import "NUISettings.h"
#import "DIRouter+HandlerBlocks.h"
#import "DIRouter+Assemble.h"
#import "DIContainer.h"
#import "DITree.h"

@implementation DINode (Awake)
#pragma DINodeAwakeProtocol
-(void)awake
{
	if(self.implement && self.isGlobal)
	{
		return;
	}
	
	[self beforeImply];
	[self implying];
	[self afterImply];
	
	if(!self.parent)
	{
		[self finishAll];
	}
}

-(void)beforeImply
{
	for (DINode* child in self.children)
	{
		[child awake];
	}
}

-(void)implying
{
	DINode* detailRootNode = DITree.instance.nameToNode[self.name];
	if(detailRootNode && self!=detailRootNode )
	{
		//如果当前节点有细化的实现，则以细化实现为基础更新
		[detailRootNode awake];
		self.implement = detailRootNode.implement;
	}
	else
	{
		self.implement = [self makeInstance];
	}
		
}

-(void)afterImply
{
	for (DINode* child in self.children)
 	{
		[child assemblyTo:self];
	}
	
	[self patchAttribute];
}

-(void)finishAll
{
	[self delay];
}

-(void)delay
{
	for(DINode* child in self.children)
	{
		[child delay];
	}
	
	for (void (^ _Nonnull block)() in self.delayBlocks)
	{
		block();
	}
	
	[self.delayBlocks removeAllObjects];//释放。。
}
-(void)assemblyTo:(DINode*)parentNode
{
	//处理默认的组装
	RealizeHandlerBlock block = [DIRouter blockToAddElement:self.className toParent:parentNode.className];
	if(block)
	{
		block(parentNode.implement,self.implement);
	}
	else
		WarnLog(@"Add %@ to %@ failed.",self.name,parentNode.name);
}

-(void)patchAttribute
{
	[self autoSetNUIClass];
	[self.implement updateByNode:self];
}

-(void)autoSetNUIClass
{
	//如果已经手动设置了则跳过。
	if([[self.implement valueForKeyPath:@"style"] isKindOfClass:NSString.class])
		return;
	
	//如果节点中已经设置则跳过
	if(self.attributes[@"style"])
		return;
	
	//优先按照name匹配，匹配失败则尝试使用classname匹配。
	NUISettings*nuiInstance = [NUISettings invokeMethod:@"getInstance"];

	if(nuiInstance.styles[self.name])
	{
		self.attributes[@"style"] = self.name;
	}
	else if(nuiInstance.styles[self.className])
	{
		self.attributes[@"style"] = self.className;
	}
	else
	{
		//递归监测是否存在父类的定义
		Class currentClass = self.clazz;
		while(currentClass!=nil)
		{
			NSString* currentClassName = NSStringFromClass(currentClass);
			if(nuiInstance.styles[currentClassName])
			{
				self.attributes[@"style"] = currentClassName;
				break;
			}
			currentClass = [currentClass superclass];
		}
	}
	//如果还配不到就按NUI的默认处理。
	return;
}

-(id)makeInstance
{
	id nodeInstance;
	if([self isGlobal])
	{
		nodeInstance = [DIContainer makeInstance:self.clazz];
		[DIContainer setAlias:self.name forInstance:nodeInstance];
	}
	else
	{
		//局部成员
		nodeInstance = [DIContainer makeInstance:self.clazz];
	}
	return nodeInstance;
}
@end
