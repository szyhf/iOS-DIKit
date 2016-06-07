//
//  DINodes.m
//  DIKit
//
//  Created by Back on 16/5/26.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DINode.h"


@interface DINode()
{
	BOOL _isGlobal;
	NSException* _exception;
	NSMutableDictionary<NSString *,id> *_attributes;
}
@property (nonatomic, strong) NSMutableArray<DINode*>* childrenStorage;
@end

@interface DINode (Assume)
+(NSDictionary<NSString*,Class>*)assumeMap;
-(Class)asumeByName:(NSString*)elementName;
@end

@implementation DINode

-(instancetype)initWithElement:(NSString*)element
				  andNamespaceURI:(NSString *)namespaceURI
				 andAttributes:(NSDictionary<NSString*,NSString*>*)attributes;
{
	self = [super init];
	if(self)
	{
		/**
		 *  类型推导优先级（失败自动尝试）：
		 *  1、attribute[@"class"]
		 *  2、element name
		 *  3、suffix by assume map。
		 */
		self.clazz = NSClassFromString(attributes[@"class"]);
		if(!self.clazz)
		{
			self.clazz = NSClassFromString(element);
		}
		if(!self.clazz)
		{
			self.clazz = [self asumeByName:element];
		}
		WarnLogWhile(self.clazz==nil, @"node named %@ where class = %@ can't not implememnted",element,attributes[@"class"]);
		
		//处理id和访问性
		self.name = attributes[@"id"];
		if([NSString isNilOrEmpty:self.name])
		{
			//如果没定义，则以element的名称为准
			self.name = element;
			//所有的Controller也强制设置为全局访问
			if([self.clazz isSubclassOfClass:UIViewController.class])
			{
				//未定义id的情况下，仅将Controller处理为Global。
				self->_isGlobal = true;
			}
		}
		else
		{
			//定义了ID则表明强制要求全局访问。
			_isGlobal = true;
		}
		
		//处理style
		/**
		 * 1、attribute[@"style"]
		 * 2、name
		 */
		self.style = attributes[@"style"];
		if([NSString isNilOrEmpty:self.style])
		{
			self.style = self.name;
		}
		//处理Attributes
		self.attributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
	}
	return self;
}

-(BOOL)isError
{
	return self->_exception!=nil;
}

-(NSException*)exception
{
	return _exception;
}

-(NSMutableDictionary<NSString*,id>*)attributes
{
	return self->_attributes;
}

-(BOOL)isGlobal
{
	return self->_isGlobal;
}

-(DINode*)childOfIndex:(NSInteger)index
{
	return self.children[index];
}

-(void)addChild:(DINode*)child
{
	[self.childrenStorage addObject:child];
	
	child.parent = self;
}

-(void)removeChild:(DINode*)child
{
	[self.childrenStorage removeObject:child];
	child.parent = nil;
}

-(void)addChildren:(NSArray<DINode*>*)children
{
	[self.childrenStorage addObjectsFromArray:children];
	
	for (DINode* child in children)
	{
		child.parent = self;
	}
}
-(NSString*)description
{
	NSString* desString =
	[NSString stringWithFormat:@"\t<%@ class=\"%@\" %p>\n",self.name,self.className,self];
	for (DINode* child in self.children)
	{		
		desString = [desString stringByAppendingString:child.description];
	}
	desString = [desString replace:@"\n\t" withString:@"\n\t\t"];
	
	return desString;
}

#pragma mark -- property
@synthesize name;
@synthesize style;
@synthesize parent;

- (NSMutableArray<void(^)()> *)delayBlocks {
	if(_delayBlocks == nil) {
		_delayBlocks = [[NSMutableArray<void(^)()> alloc] init];
	}
	return _delayBlocks;
}

- (Class)clazz {
	if(!_clazz) {
		_clazz = 0;
	}
	return _clazz;
}

- (NSString *)className
{
	return NSStringFromClass(self.clazz);
}

- (NSArray<DINode*> *)children
{
	return self.childrenStorage;
}

-(void)setValue:(id)value
forUndefinedKey:(NSString *)key
{
	return objc_setAssociatedObject(self, NSSelectorFromString(key), value, OBJC_ASSOCIATION_RETAIN);
}

-(id)valueForUndefinedKey:(NSString *)key
{
	return objc_getAssociatedObject(self, NSSelectorFromString(key));
}

- (NSMutableArray<DINode*> *)childrenStorage {
	if(_childrenStorage == nil)
	{
		_childrenStorage = [[NSMutableArray<DINode*> alloc] init];
	}
	return _childrenStorage;
}

- (id)implement
{
	return _implement;
}
@end
