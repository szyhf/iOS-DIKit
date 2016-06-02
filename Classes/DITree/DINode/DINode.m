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
#import "DILayoutParser.h"
#import "DINodeLayoutConstraint.h"

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
-(NSObject*)Implement {
	return _Implement;
}

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
+(NSDictionary<NSString*,UndefinedKeyHandlerBlock>*)nodeBlocks
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _uiView_token;
	dispatch_once(&_uiView_token,
				  ^{
					  _instance = @{
									//支持相对值、绝对值
									@"height":self.layoutKey,
									@"h":self.layoutKey,
									@"width":self.layoutKey,
									@"w":self.layoutKey,
									
									//支持相对值、相对绝对值（转化为相对值）
									@"centerX":self.layoutRelativeKey,
									@"cX":self.layoutRelativeKey,
									@"centerY":self.layoutRelativeKey,
									@"cY":self.layoutRelativeKey,
									
									//仅支持相对值
									@"top":self.layoutRelativeKey,
									@"t":self.layoutRelativeKey,
									@"bottom":self.layoutRelativeKey,
									@"b":self.layoutRelativeKey,
									@"left":self.layoutRelativeKey,
									@"l":self.layoutRelativeKey,
									@"right":self.layoutRelativeKey,
									@"r":self.layoutRelativeKey,
									
									@"leading":self.layoutRelativeKey,
									@"ld":self.layoutRelativeKey,
									@"trailing":self.layoutRelativeKey,
									@"tl":self.layoutRelativeKey,
									
									//扩展属性
									@"edges":self.layoutEdgesKey,
									//@"size":@"",
									//@"center":@"",
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
					  _instance = ^void(DINode* node,NSString*key,id value)
					  {
						  NSArray<DILayoutParserResult*>* res = [DILayoutParser parserResults:value attributeKey:key];
						  NSMutableArray<DINodeLayoutConstraint*>* constraints =
						  [NSMutableArray arrayWithCapacity:res.count];
						  
						  [res enumerateObjectsUsingBlock:
						   ^(DILayoutParserResult * _Nonnull result, NSUInteger idx, BOOL * _Nonnull stop)
						  {
							  [constraints addObject:[[DINodeLayoutConstraint alloc]initWithOriNode:node parserResult:result]];
						  }];
						  
						  node.attributes[key]=constraints;
					  } ;
				  });
	return _instance;
}

+(UndefinedKeyHandlerBlock)layoutRelativeKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _layoutKey;
	dispatch_once(&_layoutKey,
				  ^{
					  _instance = ^void(DINode* node,NSString*key,NSString* value)
					  {
						  //如果是绝对值或者为空，自动补:号
						  if([value isMatchRegular:@"^\\d*;?$"])
						  {
							  value = [@":" stringByAppendingString:value];
						  }
						  self.layoutKey(node,key,value);
					  } ;
				  });
	return _instance;
}

+(UndefinedKeyHandlerBlock)layoutEdgesKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _layoutKey;
	dispatch_once(&_layoutKey,
				  ^{
					  _instance = ^void(DINode* node,NSString*key,NSString* value)
					  {
						  NSArray<NSString*>* edges = [value componentsSeparatedByString:@","];
						  //支持省略写法，省略值默认为0
						  NSString* top=@"0";
						  NSString* left = @"0";
						  NSString* bottom=@"0";
						  NSString* right=@"0";
						  NSCharacterSet* trimSet = [NSCharacterSet characterSetWithCharactersInString:@",;()"];
						  switch (edges.count)
						  {
							  case 4:
							  {
								  right = [edges[3] stringByTrimmingCharactersInSet:trimSet];
								  right=![right isEmpty]?[@"-" stringByAppendingString:right]:@"0";
							  }
							  case 3:
							  {
								  bottom = [edges[2] stringByTrimmingCharactersInSet:trimSet];
								  bottom=![bottom isEmpty]?[@"-"stringByAppendingString:bottom]:@"0";
							  }
							  case 2:
							  {
								  left = [edges[1] stringByTrimmingCharactersInSet:trimSet];
								  left=![left isEmpty]?left:@"0";
							  }
							  case 1:
							  {
								  top = [edges[0] stringByTrimmingCharactersInSet:trimSet];
								  top=![top isEmpty]?top:@"0";
								  break;
							  }
						  }
						  self.layoutRelativeKey(node,@"top",top);
						  self.layoutRelativeKey(node,@"left",left);
						  self.layoutRelativeKey(node,@"bottom",bottom);
						  self.layoutRelativeKey(node,@"right",right);
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