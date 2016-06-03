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
}
@property (nonatomic, strong) NSMutableArray<DINode*>* childrenStorage;
@end

@interface DINode (DIAttribute)
+(NSDictionary<NSString*,UndefinedKeyHandlerBlock>*)nodeBlocks;
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
@synthesize implement;
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

-(void)setAttributes:(NSMutableDictionary<NSString *,NSString *> *)attributes
{
	
	self->_attributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
	[self->_attributes removeObjectsForKeys:[self.class nodeKeyWord]];
	[self->_attributes enumerateKeysAndObjectsUsingBlock:
	 ^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop)
	{
		UndefinedKeyHandlerBlock block = [self.class nodeBlocks][key];
		if(block)
			block(self,key,obj);
	}];
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
