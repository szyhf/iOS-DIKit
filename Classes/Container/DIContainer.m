//
//  Container.m
//  Fakeshion
//
//  Created by Back on 16/4/29.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIContainer.h"
#import "DILog.h"
@interface DIContainer()
/**
 *  实例注册表
 */
@property(atomic,strong)NSMutableDictionary* instanceMap;
/**
 *  工厂函数注册表
 */
@property(atomic,strong)NSMutableDictionary* factoryMap;
/**
 *  别名注册表
 */
@property(atomic,strong)NSMutableDictionary* aliasMap;
/**
 *  Hook回调记录表
 */
@property(atomic,strong)NSMutableDictionary* afterInitHookMap;
/**
 *  依赖记录表（记录当前的调用依赖，防止循环调用）
 */
@property(atomic,strong)NSMutableArray* dependenceArray;

@end

@implementation DIContainer
@synthesize instanceMap;
@synthesize factoryMap;
@synthesize aliasMap;
@synthesize afterInitHookMap;

/********* Public Static Method ************/

/**
 *  获取全局容器实例
 *
 *  @return 当前容器
 */
+(DIContainer*)Instance
{
	static DIContainer* _instance = nil;
	static dispatch_once_t containerToken ;
	dispatch_once(&containerToken, ^
	{
		_instance = [[self alloc] init] ;
	}) ;

	return _instance ;
}

/**
 *  一个类型是否已经被注册
 *
 *  @param Clazz 类型全名
 */
+(bool)isBind:(NSString*)Clazz
{
	DIContainer* shared = [DIContainer Instance];
	if([[shared instanceMap]objectForKey:Clazz]!=nil)
	{
		return true;
	}
	if([[shared factoryMap]objectForKey:Clazz]!=nil)
	{
		return true;
	}
	if([[shared aliasMap]objectForKey:Clazz]!=nil)
	{
		return true;
	}
	return false;
}

+(id)makeInstance:(Class)clazz
{
	NSString* className = NSStringFromClass(clazz);
	return [self makeInstanceByName:className];	
}

+(id)makeInstanceByName:(NSString*)name
{
	DIContainer* shared       = [DIContainer Instance];
	
	id ins                  = nil;
	//检查是否存在别名
	NSString* className     = (NSString*)[[shared aliasMap]objectForKey:name];
	className               = className ? className : name;
	
	//创建一个新的
	ins = [NSClassFromString(className) alloc];
	if(ins==nil)
	{
		WarnLog(@"Try make instance of %@ but failed.",name);
		return nil;
	}
	
	ins = [shared initlizeInstance:ins];
	
	return ins;
}

/**
 *  根据类型名称注册一个类型
 *
 *  @param className 类型的名称
 */
+(void)bindClassName:(NSString*)className
{
	Class clazz = NSClassFromString(className);
	[DIContainer bindClass:clazz];
}

/**
 *  通过类型名称，绑定一个实例到指定类型
 *
 *  @param clazz 指定类型
 *  @param ins   指定实例
 */
+(void )bindClassName:(NSString*)className withInstance:(id)ins
{
	DIContainer* shared = [DIContainer Instance];
	[[shared instanceMap]setValue:ins
						   forKey:className];
}

/**
 *  通过类型名称，绑定一个实例工厂到指定类型
 *
 *  @param clazz   类型
 *  @param factory 实例工厂方法
 */
+(void)bindClassName:(NSString*)className withBlock:(FactoryBlock)factory
{
	DIContainer* shared = [DIContainer Instance];
	[[shared factoryMap]setValue:factory
						  forKey:className];
}

/**
 *  一个类型的构造函数被调用之后回调
 *
 *  @param onInit 回调要做的事情
 *  @param clazz  类型的全名
 */
+(void)hookAfterInit:(AfterInitBlock)onInit forClassName:(NSString*)className
{
	DIContainer* shared = [DIContainer Instance];
	[[shared afterInitHookMap]setValue:onInit forKey:className];
}

/**
 *  一个类型的构造函数被调用之后回调
 *
 *  @param onInit 回调要做的事情
 *  @param clazz  类型
 */
+(void)hookAfterInit:(AfterInitBlock)onInit forClass:(Class)clazz
{
	NSString* className = NSStringFromClass(clazz);
	[DIContainer hookAfterInit:onInit forClassName:className];
}

/**
 *  设置别名
 *
 *  @param alias 别名
 *  @param clazz 指定类型
 */
+(void)setAlias:(NSString*)alias forClass:(Class)clazz;
{
	DIContainer* shared = [DIContainer Instance];
	NSString* className = NSStringFromClass(clazz);
	[[shared aliasMap]setValue:className forKey:alias];
}

/**
 *  设置别名
 *
 *  @param alias 别名
 *  @param ins 指定类型
 */
+(void)setAlias:(NSString*)alias forInstance:(id)ins
{
	DIContainer* shared = [DIContainer Instance];
	shared.instanceMap[alias]=ins;
}


+(void)bindInstance:(id)ins
{
	NSString* className = NSStringFromClass([ins class]);
	[DIContainer bindClassName:className withInstance:ins];
}

/**
 *  注册一个类型（延迟加载，使用默认init方法初始化）
 *
 *  @param clazz 被注册的类型
 */
+(void)bindClass:(Class)clazz
{
	[DIContainer bindClass:clazz
			   withBlock:nil
	 ];
}

/**
 *  绑定一个实例到指定类型
 *
 *  @param clazz 指定类型
 *  @param ins   指定实例
 */
+(void )bindClass:(Class)clazz withInstance:(id)ins
{
	NSString*className = NSStringFromClass(clazz);
	[DIContainer bindClassName:className withInstance:ins];
}

/**
 *  绑定一个实例工厂到指定类型
 *
 *  @param clazz   类型
 *  @param factory 实例工厂方法
 */
+(void)bindClass:(Class)clazz withBlock:(FactoryBlock)factory
{
	NSString* className = NSStringFromClass(clazz);
	[DIContainer bindClassName:className withBlock:factory];
}

+(id)getInstanceByName:(NSString*)name
{
	DIContainer* shared       = [DIContainer Instance];
	
	id ins                  = nil;
	//检查是否存在别名
	NSString* className     = (NSString*)[[shared aliasMap]objectForKey:name];
	className               = className ? className : name;
	
	//原来已经有注册好的了
	ins                     = [[shared instanceMap]objectForKey:className];
	if(ins)
	{
		return ins;
	}
	
	//创建一个新的
	ins = [NSClassFromString(className) alloc];
	if(ins==nil)
	{
		WarnLog(@"Try make instance of %@ but failed.",className);
		return nil;
	}
	[DIContainer bindClassName:className withInstance:ins];
	NoticeLog(@"Make a instance of %@",className);
	
	ins = [shared initlizeInstance:ins];
	
	AfterInitBlock afterBlock = (AfterInitBlock)[[shared afterInitHookMap]objectForKey:className];
	if(afterBlock)
	{
		afterBlock(ins);
	}
	return ins;
}



/**
 *  根据指定类型获取对应单例
 *
 *  @param clazz 类型
 *
 *  @return 对应的单例，如果不存在则返回nil
 */
+(id)getInstance:(Class)clazz
{
	NSString* className = NSStringFromClass(clazz);
	return [DIContainer getInstanceByName:className];
}

+(id)initlizeInstance:(id)ins
{
	DIContainer* container = [DIContainer Instance];
	return [container initlizeInstance:ins];
}
+(void)clear
{
	return [[DIContainer Instance]clear];
}

-(void)clear
{
	[self.instanceMap removeAllObjects];
	[self.aliasMap removeAllObjects];
	[self.factoryMap removeAllObjects];
	[self.afterInitHookMap removeAllObjects];
	[self.dependenceArray removeAllObjects];
}
/********* End Public Static Method ************/

/**
 *  初始化函数
 *
 *  @return 当前对象实例
 */
-(id)init
{
	self = [super init];
	if(self)
	{
		self.instanceMap = [NSMutableDictionary dictionaryWithCapacity:10];
		self.aliasMap = [NSMutableDictionary dictionaryWithCapacity:10];
		self.factoryMap = [NSMutableDictionary dictionaryWithCapacity:10];
		self.afterInitHookMap = [NSMutableDictionary dictionaryWithCapacity:10];
		self.dependenceArray = [NSMutableArray arrayWithCapacity:1];
	}
	return self;
}

-(id)initlizeInstance:(id)ins
{
	NSString*className = NSStringFromClass([ins class]);
	//延迟加载方案，用工厂初始化（包括已注册使用默认init方法的）
	FactoryBlock insFactory = (FactoryBlock)[[self factoryMap]objectForKey:className];
	
	//检查是否存在依赖循环
	if([[self dependenceArray]containsObject:className])
	{
		NSException*ex = [NSException exceptionWithName:@"DependencCircle" reason:@"Try to make instance failed" userInfo:@{@"dependence":[self dependenceArray]}];
		@throw ex;
	}
	
	//记录一次依赖
	[[self dependenceArray]addObject:className];
	
	//没有注册方法的话，用默认方法实现
	if(insFactory)
		ins = insFactory(ins);
	else
		ins = [ins init];
	[[self dependenceArray]removeLastObject];
	
	return ins;
}
@end