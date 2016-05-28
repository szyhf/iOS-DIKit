//
//  DINodes.m
//  DIKit
//
//  Created by Back on 16/5/26.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DINode.h"
#import <objc/runtime.h>
#import "DITools.h"
#import "NSObject+Runtimes.h"
#import "UndefinedKeyHandlerBlock.h"

@interface DINode()
{
	BOOL _isGlobal;
	BOOL _isProp;
	//NSMutableDictionary<NSString*,NSString*>* _attributes;
}
@property (nonatomic, strong) NSMutableArray<DINode*>* childrenStorage;
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
		
		//处理属性项目
		/**
		 * 1、attributes[@"prop"];
		 * 2、name
		 */
		self.property = attributes[@"prop"];
		
		//处理Attributes
		self.attributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
	}
	return self;
}

-(BOOL)isGlobal
{
	return self->_isGlobal;
}

-(BOOL)isProperty
{
	return ![NSString isNilOrEmpty:self.property];
}

-(void)addChild:(DINode*)child
{
	[self.childrenStorage addObject:child];
	
	child.parent = self;
}

-(void)addChildren:(NSArray<DINode*>*)children
{
	[self.childrenStorage addObjectsFromArray:children];
	
	for (DINode* child in children)
	{
		child.parent = self;
	}
}
-(Class)asumeByName:(NSString*)elementName
{
	for (NSString* suffix in [self.class assumeMap])
	{
		if([elementName hasSuffix:suffix])
		{
			return [self.class assumeMap][suffix];
		}
	}
	return nil;
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
- (NSString *)name
{
	return _name;
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

- (NSString *)style
{
	return _style;
}

- (NSArray<DINode*> *)children
{
	return [NSArray arrayWithArray:self.childrenStorage];
}

- (DINode *)parent
{
	return _parent;
}

-(void)setAttributes:(NSMutableDictionary<NSString *,NSString *> *)attributes
{
	
	self->_attributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
	[self->_attributes removeObjectsForKeys:[self.class nodeKeyWord]];
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

#pragma mark -- static
+(NSDictionary<NSString*,UndefinedKeyHandlerBlock>*)nodeBlocks
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _uiView_token;
	dispatch_once(&_uiView_token,
				  ^{
					  _instance = @{
									@"height":DINode.layoutKey,
									@"width":DINode.layoutKey,
									
									@"top":DINode.layoutKey,
									@"bottom":DINode.layoutKey,
									@"left":DINode.layoutKey,
									@"right":DINode.layoutKey,
									
									@"centerX":DINode.layoutKey,
									@"centerY":DINode.layoutKey,
									
									@"leading":DINode.layoutKey,
									@"trailing":DINode.layoutKey,
									} ;
				  });
	return _instance;
}

+(UndefinedKeyHandlerBlock)layoutKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _layoutKey;
	dispatch_once(&_layoutKey,
				  ^{
					  _instance = ^void(UIView* obj,NSString*key,id value)
					  {
						  
					  } ;
				  });
	return _instance;
}

+(NSArray<NSString*>*)nodeKeyWord
{
	static NSArray* _instance;
	static dispatch_once_t _nodeAttribute_token;
	dispatch_once(&_nodeAttribute_token,
				  ^{
					  //保留字
					  _instance = @[
									@"prop",
									@"id",];
				  });
	return _instance;
}

/**
 *  推断用的后缀
 */
+(NSDictionary<NSString*,Class>*)assumeMap
{
	static NSDictionary<NSString*,Class>* _assumeMap;
	if(_assumeMap==nil)
		_assumeMap=@{
					 //Controller结尾中，
					 @"NavigationController":UINavigationController.class,
					 @"TabBarController":UITabBarController.class,
					 @"ViewController":UIViewController.class,
					 
					 @"TabBarItem":UITabBarItem.class,
					 @"BarButtonItem":UIBarButtonItem.class,
					 @"BarButton":UIBarButtonItem.class,
					 
					 @"Label":UILabel.class,
					 @"Button":UIButton.class,
					 
					 //view结尾中，最原始的View要最后结尾。
					 @"ImageView":UIImageView.class,
					 @"View":UIView.class,
					 };
	return _assumeMap;
}


@end
