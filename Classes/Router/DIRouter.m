//
//  Router.m
//  Fakeshion
//
//  Created by Back on 16/4/29.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRouter.h"
#import "DIRouter+Registry.h"
#import "DIRouterParentViewObserver.h"
#import "DIRouter+HandlerBlocks.h"
#import "DILog.h"
#import "NSString+Judge.h"
#import "DIContainer.h"

@interface DIRouter()
/**
 *  记录一个实例所处的路径
 */
@property(atomic)NSDictionary* routerMap;
/**
 *  记录一个实例希望持有的子实例集合，每个元素都是NSArray
 */
@property(atomic)NSDictionary* expertChildrenMap;

@property(atomic)NSMutableSet* Loaded;
@end

@implementation DIRouter
/**
 *  获取全局容器实例
 *
 *  @return 当前容器
 */
+(DIRouter*)Instance{
	static DIRouter* _instance = nil;
	static dispatch_once_t routerToken ;
	dispatch_once(&routerToken, ^{
		_instance = [[self alloc] init] ;
	}) ;
	
	return _instance ;
}

+(void)init
{
	[DIRouter Instance];
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
 *  根据注册结果加载当前控制器的成员控制器（用于延迟加载）
 *
 *  @param controller
 */
+(void)lazyLoad:(UIViewController*)controller
{
	DIRouter* currentRouter = [DIRouter Instance];
	NSString* currentName = NSStringFromClass([controller class]);
	if(![currentRouter.Loaded containsObject:currentName])
	{
		NSArray* children = [[currentRouter expertChildrenMap]objectForKey:currentName];
		if (children)
		{
			for (NSString* child in children)
			{
				//调用realize方法实现加载
				[DIRouter realizePath:[NSString stringWithFormat:@"%@/%@",currentName,child]];
			}
		}
		[currentRouter.Loaded addObject:currentName];
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
		bool isSlove = false;
		if(![NSString isNilOrEmpty:lastElement])
		{
			Class lastClazz = NSClassFromString(lastElement);
			Class currentClazz = NSClassFromString(element);
			
			NSDictionary<NSString*,RealizeHandlerBlock>* blockMap;
			Class superLastClazz = lastClazz;
			
			//回溯当前类，直到找到最接近的被注册过的类型。
			while (superLastClazz!=nil
				   && blockMap == nil
				   && !isSlove )
			{
				NSString* superLastName = NSStringFromClass(superLastClazz);
				blockMap = [[self realizeMap]objectForKey:superLastName];
				
				//如果找到了blockMap，则尝试在blockMap中继续找可能符合条件的处理器
				//完全有可能存在blockMap，但不存在处理器的情况，此时应继续向上遍历当前父类是否还存在别的可能符合条件的处理器
				if(blockMap!=nil)
				{
					Class superCurrentClazz = currentClazz;
					RealizeHandlerBlock handlerBlock;
					
					//回溯当前类，直到找到最近被注册的处理器
					while (superCurrentClazz!=nil
						   && handlerBlock==nil)
					{
						NSString* superCurrentName = NSStringFromClass(superCurrentClazz);
						handlerBlock = [blockMap objectForKey:superCurrentName];
						if(handlerBlock!=nil)
						{
							handlerBlock(lastElement,element);
							isSlove = true;
							break;
						}
						superCurrentClazz = [superCurrentClazz superclass];
					}
				}
				
				superLastClazz = [superLastClazz superclass];
			}
#ifdef WARN
			if (!isSlove)
			{
				WarnLog(@"RelizePath Failed: %@\nError: %@",path,element);
			}
#endif
		}
		lastElement = element;

	}
}

+(void)printRouterMap
{
	NSMutableString* res = [NSMutableString stringWithCapacity:64];
	DIRouter* current = [DIRouter Instance];
	for (NSString* key in [current routerMap])
	{
		[res appendFormat:@"\r%@ => \r%@",key,(NSString*)[[current routerMap]objectForKey:key]];
	}
	NoticeLog(@"%@",res);
}

-(NSObject*)init
{
	self = [super init];
	if(self)
	{
		[self registerViewController:[self Registry]];
		self.routerMap = [NSMutableDictionary dictionaryWithCapacity:10];
		self.expertChildrenMap = [NSMutableDictionary dictionaryWithCapacity:10];
	}
	
	return self;
}

-(void)registerViewController:(NSArray*)views
{
	DIRouterParentViewObserver* observer = [[DIRouterParentViewObserver alloc]init];
	AfterInitBlock pathRegisterBlock = ^(id ins)
	{
		//给view注册启动回调
		//每当Controller的ParentController发生变化时，重置路径（包括子controler）
		if([ins isKindOfClass:[UIViewController class]])
		{
			UIViewController* viewCtrl = (UIViewController*)ins;
			[viewCtrl addObserver:observer
					   forKeyPath:NSStringFromSelector(@selector(parentViewController))
						  options:NSKeyValueObservingOptionNew
						  context:nil];
		}
	};
	
	for (NSString* viewCtrlName in views)
	{
		[DIContainer bindClassName:viewCtrlName];
		
		[DIContainer hookAfterInit:pathRegisterBlock
					  forClassName:viewCtrlName];
	}
}




@end
