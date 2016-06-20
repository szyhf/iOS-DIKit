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
}

-(void)packInstance:(id)instance
{
	if([instance isKindOfClass:self.clazz])
	{
		self.implement = instance;
		
		[self beforeImply];
		[self packing];
		[self afterImply];
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
		//以细化节点的类型取代当前的类型。
		self.clazz = detailRootNode.clazz;
	}
	else
	{
		self.implement = [self makeInstance];
	}
}

-(void)packing
{
	DINode* detailRootNode = DITree.instance.nameToNode[self.name];
	if(detailRootNode && self!=detailRootNode )
	{
		//如果当前节点有细化的实现，则以细化实现为基础更新
		[detailRootNode packInstance:self.implement];
	}
}

-(void)afterImply
{
	for (DINode* child in self.children)
 	{
		[child assemblyTo:self];
	}
	
	[self patchAttribute];
	
	if(!self.parent)
	{
		[self delay];
	}
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
	//block不能随意释放。。否则想重用同一个node的时候会出错。
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
	//优先级：代理节点配置<实例配置<默认
	
	//代理节点配置即当前节点的Attribute.style属性或者nui属性
	//实例节点配置即implement的nui属性
	
	//如果已经手动设置了则跳过。
	
	//因为支持直接对viewcontroller配置，所以要区分处理
	//检查是否存在实例配置（Style在实际执行时被转成了nuiClass）
	if([self.clazz isKindOfClass:UIViewController.class])
	{
		UIViewController* ctrl = self.implement;
		if([[ctrl.view valueForKeyPath:@"nuiClass"] isKindOfClass:NSString.class])
			return;
	}
	else
	{
		if([[self.implement valueForKeyPath:@"nuiClass"] isKindOfClass:NSString.class])
			return;
	}
	
	
	//如果节点中已经设置则跳过
	if(self.attributes[@"style"])
		return;
	
	//当且仅当上述配置不存在时，尝试执行默认配置。
	//优先按照name匹配，匹配失败则尝试使用classname匹配。
	NUISettings*nuiInstance = [NUISettings invokeMethod:@"getInstance"];

	if(nuiInstance.styles[self.name])
	{
		self.attributes[@"style"] = self.name;
	}
	//else if(nuiInstance.styles[self.className])
	//{
		//self.attributes[@"style"] = self.className;
	//}
	//else
	//{
		////递归监测是否存在父类的定义（这样做会严重影响第三方控件的自定义样式 废弃）
		//Class currentClass = self.clazz;
		//while(currentClass!=nil)
		//{
			//NSString* currentClassName = NSStringFromClass(currentClass);
			//if(nuiInstance.styles[currentClassName])
			//{
				//self.attributes[@"style"] = currentClassName;
				//break;
			//}
			//currentClass = [currentClass superclass];
		//}
	//}
	//如果还配不到就按NUI的默认处理。
	return;
}

-(id)makeInstance
{
	id nodeInstance;
	if([self isGlobal])
	{
		if([DIContainer isBind:self.name])
		{
			nodeInstance = [DIContainer getInstanceByName:self.name];
		}
		else
		{
			nodeInstance = [DIContainer makeInstance:self.clazz];
			[DIContainer setAlias:self.name forInstance:nodeInstance];
		}
	}
	else
	{
		//局部成员
		nodeInstance = [DIContainer makeInstance:self.clazz];
	}
	return nodeInstance;
}
@end
