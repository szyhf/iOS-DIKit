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
		parentNode.attributes[self.template]=self;
	}
	else if([current isKindOfClass:NSMutableArray.class])
	{
		[((NSMutableArray*)current) addObject:self];
	}
	else
	{
		NSMutableArray* ary = [NSMutableArray arrayWithObjects:current,self,nil];
		parentNode.attributes[self.template]=ary;
	}
}
@end
