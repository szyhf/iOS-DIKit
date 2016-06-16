//
//  DITemplateNode.m
//  DIKit
//
//  Created by Back on 16/6/4.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DITemplateNode.h"
#import "DITree.h"
#import "NSObject+Runtimes.h"
@interface DITemplateNode()
{
	BOOL _isGlobal;
}
@property (nonatomic, strong) NSString* template;
@end

@implementation DITemplateNode
@synthesize template;
-(instancetype)initWithElement:(NSString *)element andNamespaceURI:(NSString *)namespaceURI andAttributes:(NSDictionary<NSString *,NSString *> *)attributes
{
	self = [super initWithElement:element andNamespaceURI:namespaceURI andAttributes:attributes];
	if(self)
	{
		//处理属性项目
		/**
		 * 1、attributes[@"prop"];
		 * 2、name
		 */
		self.template = attributes[@"template"];
		self->_isGlobal = false;
	}
	return self;
}

-(void)awake
{
	//todo:附加声明的时候不能正确处理为template。
}

-(id)newImplement
{
	[super awake];
	return self.implement;
}

-(void)assemblyTo:(DINode *)parentNode
{
	id current = parentNode.attributes[self.template];
	if(!current)
	{
		//原来没有，则设置为指定属性
		parentNode.attributes[self.template]=self;
	}
	else if([current isKindOfClass:NSMutableArray.class])
	{
		//原来已有，且为数组，则添加为新的成员。
		[((NSMutableArray*)current) addObject:self];
	}
	else
	{
		//原来已有，但非数组，则创建数组且处理为对应属性
		NSMutableArray* ary = [NSMutableArray arrayWithObjects:current,self,nil];
		parentNode.attributes[self.template]=ary;
	}
}

-(void)afterImply
{
	[super afterImply];
	//一⃓般⃓调⃓用⃓的⃓时⃓候⃓不⃓要⃓执⃓行⃓delay
	//实⃓例⃓化⃓的⃓时⃓候⃓才⃓执⃓行⃓。。Orz
	if(self.parent)
	{
		[self override_delay];
	}
}

-(void)override_delay
{
	//会⃓被⃓父⃓节⃓点⃓调⃓用⃓Orz
	
	for(DINode* child in self.children)
	{
		[child invokeMethod:@"delay"];
	}
	for (void (^ _Nonnull block)() in self.delayBlocks)
	{
		block();
	}
	//block不能随意释放。。否则想重用同一个node的时候会出错。
}

-(void)delay
{
	
}
@end
