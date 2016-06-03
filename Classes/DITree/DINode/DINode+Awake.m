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

@implementation DINode (Awake)
#pragma DINodeAwakeProtocol
-(void)awake
{
	[self beforeImply];
	[self implying];
	[self afterImply];
	
	if(!self.parent)
	{
		[self finishAll];
	}
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
-(void)beforeImply
{
	for (DINode* child in self.children)
	{
		[child awake];
	}
}

-(void)implying
{
	self.implement = [self makeInstance];
}

-(void)afterImply
{
	for (DINode* child in self.children)
 	{
		[child assemblyTo:self];
	}
	
	[self patchAttribute];
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
	[self autoSetNUIClass:self.name withInstance:self.implement];
	[self.implement updateByNode:self];
}

-(void)autoSetNUIClass:(NSString*)element withInstance:(id)instance
{
	NUISettings*nuiInstance = [NUISettings invokeMethod:@"getInstance"];
	if(nuiInstance.styles[element]!=nil)
	{
		if([NSString isNilOrEmpty:[instance valueForKey:@"nuiClass"]])
		{
			[instance setValue:element forKey:@"nuiClass"];
		}
	}
}

-(id)makeInstance
{
	id nodeInstance;
	if([self isGlobal])
	{
		nodeInstance = [DIContainer getInstance:self.clazz];
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
