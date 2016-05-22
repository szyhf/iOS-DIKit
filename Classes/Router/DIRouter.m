//
//  Router.m
//  Fakeshion
//
//  Created by Back on 16/4/29.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRouter.h"
#import "DIRouter+HandlerBlocks.h"
#import "DIRouter+Assemble.h"

@interface DIRouter()
/**
 *  记录一个实例所处的路径
 */
@property(atomic)NSDictionary* routerMap;
/**
 *  记录一个实例希望持有的子实例集合，每个元素都是NSArray
 */
@property(atomic)NSDictionary* expertChildrenMap;

@end

@implementation DIRouter
/**
 *  获取全局容器实例
 *
 *  @return 当前容器
 */
+(DIRouter*)Instance{
	static DIRouter* _instance ;
	static dispatch_once_t routerToken ;
	dispatch_once(&routerToken, ^{
		_instance = [[self alloc] init] ;
	}) ;
	
	return _instance ;
}

+(void)autoPathRegister:(UIViewController*)viewController
{
	if(viewController!=nil)
	{
		DIRouter* current = [DIRouter Instance];
		NSMutableArray* stack = [NSMutableArray arrayWithCapacity:3];
		NSString* ctrlName = NSStringFromClass([viewController class]);
		
		//如果子成员已经注册过了，说明是变更，要继续变更子ctrl的路径
		for (UIViewController*childCtrl in viewController.childViewControllers)
		{
			if([[current routerMap]objectForKey:
				NSStringFromClass([childCtrl class])]!=nil)
			{
				[DIRouter autoPathRegister:childCtrl];
			}
		}
		
		//遍历父类，获得路径
		for (UIViewController* tempViewController = viewController;
			 tempViewController != nil;
			 tempViewController =[tempViewController parentViewController])
		{
			NSString* className = NSStringFromClass([tempViewController class]);
			[stack addObject:className];
		}
		
		//拼接出路径
		NSMutableString* path = [NSMutableString string];
		while ([stack count]>0)
		{
			NSString* className = (NSString*)[stack lastObject];
			[path appendFormat:@"/%@",className];
			[stack removeLastObject];
		}
		[[current routerMap] setValue:path
							   forKey:ctrlName];
		NoticeLog(@"AutoRegisterPath: %@",path);
	}
}

/**
 *  预先记录注册路径，用于实现延迟加载
 *
 *  @param path 希望注册的路径
 */
+(void)registerPath:(NSString*)path
{
	DIRouter* currentRouter = [DIRouter Instance];
	path = [path stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
	NSArray* elements = [path componentsSeparatedByString:@"/"];
	
	//叶子元素可以直接忽略
	for(NSInteger i = 0; i < [elements count] - 1; i ++)
	{
		//只记录路径，不验证合法性，合法性在延迟加载的时候才验证。
		
		NSMutableArray* children =
		[[currentRouter expertChildrenMap]
		 objectForKey:[elements objectAtIndex:i]];
		if (!children)
		{
			//第一次注册，则初始化记录
			children = [NSMutableArray arrayWithCapacity:1];
			[[currentRouter expertChildrenMap]
			 	setValue:children
			 	forKey:[elements objectAtIndex:i]
			 ];
		}
		//添加进注册表
		[children addObject:[elements objectAtIndex:i+1]];
	}
}

/**
 *  根据输入的path组装已有的viewController
 *
 *  @param path 组装路径
 */
+(void)realizePath:(NSString*)path
{
	path = [path stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
	NSArray* elements = [path componentsSeparatedByString:@"/"];
	
	NSString* lastElement;
	for (NSString* element in elements)
	{
		[self addElement:element toParent:lastElement];
		
		lastElement = element;

	}
}

+(void)clearRouterMap
{
	[DIRouter Instance].flatRouterMap = [[FlatRouterMap alloc]init];
}

-(NSObject*)init
{
	self = [super init];
	if(self)
	{
		self.routerMap = [NSMutableDictionary dictionaryWithCapacity:10];
		self.expertChildrenMap = [NSMutableDictionary dictionaryWithCapacity:10];
	}
	
	return self;
}

-(FlatRouterMap *)flatRouterMap {
	if(_flatRouterMap == nil) {
		_flatRouterMap = [[FlatRouterMap alloc] init];
	}
	return _flatRouterMap;
}
@end
