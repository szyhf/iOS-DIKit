//
//  DIModel.m
//  DIKit
//
//  Created by Back on 16/6/21.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIModel.h"
#import "DIWatcher.h"
#import "DIConfig.h"
#import "DITools.h"
#import "DIContainer.h"
#import "NSObject+YYModel.h"
#import "DIObject.h"

#import <objc/runtime.h>

@implementation DIModel
- (instancetype)init
{
	self = [super init];
	if (self)
	{
		//模拟数据源
#if TARGET_OS_SIMULATOR
		//NSString* dataPath = [NSString stringWithFormat:@"%@%@.json",DIConfig.getNSString(@"LocalDataDirectory"),self.class];
		NSString* dirPath = DIConfig.getNSString(@"LocalDataDirectory");
		NSString* fileName = [NSString stringWithFormat:@"%@.json",self.class];
		NSString* dataPath = [DIIO recurFullPathToFile:fileName inDirectory:dirPath];
		//DebugLogWhile(![NSString isNilOrEmpty:dataPath], dataPath);
		[DIWatcher watch:dataPath withCallback:
		 ^{
			 NSString* json = [NSString stringWithContentsOfFile:dataPath
										   usedEncoding:nil
														   error:nil];
			 [self setByJson:json];
		 }];
#else
		NSString* dataPath = [[NSBundle mainBundle]pathForResource:NSStringFromClass(self.class) ofType:@".json"];
#endif
		NSString* json = [NSString stringWithContentsOfFile:dataPath
											   usedEncoding:nil
													  error:nil];
		[self setByJson:json];
		
		//正式
		[self loadAffectingMap];
		[self watchModel:self named:@"self"];
		[self watchUniqueModelClass];
		[self watchCommonModelClass];
	}
	return self;
}

-(void)setByJson:(NSString*)json
{
	//TODO:将UI更新的主线程控制延后到setValueForKey等行为。。
	//[self performSelectorOnMainThread:@selector(yy_modelSetWithJSON:) withObject:json waitUntilDone:YES];
	[self yy_modelSetWithJSON:json];
}

-(void)watchCommonModelClass
{
	//CommonModel是非单例，一般是ProxyModel
	for (id clazz in [self.class commonModelWatchClasses])
	{
		DIModel* model;
		if([clazz isKindOfClass:NSString.class])
		{
			model = [DIContainer makeInstanceByName:clazz];
		}
		else
		{
			model = [DIContainer makeInstance:clazz];
		}
		[self watchModel:model];
	}
}

/**
 *  要监控的非全局唯一Model注册表
 *
 *  @return 非全局唯一Model数组
 */
+(NSArray*)commonModelWatchClasses
{
	return @[];
}

//自动初始化监控默认的UniqueModelClass
-(void)watchUniqueModelClass
{
	//uniqueModel是全局单例，直接从容器获取即可
	for (id clazz in [self.class uniqueModelWatchClass])
	{
		if([clazz isKindOfClass:NSString.class])
		{
			[self watchModelClass:NSClassFromString(clazz)];
		}
		else
		{
			[self watchModelClass:clazz];
		}
	}
}

/**
 *  要监控的非全局唯一Model注册表
 *
 *  @return 非全局唯一Model数组
 */
+(NSArray*)uniqueModelWatchClass
{
	return @[];
}

-(void)loadAffectingMap
{
	for (NSString* key in [self.class affectingMap])
	{
		NSString* affectSelectorName = [NSString stringWithFormat:@"keyPathsForValuesAffecting%@",key];
		
		NSSet*(^block)() = ^NSSet*()
		{
			return [NSSet setWithArray:[self.class affectingMap][key]];
		};
		
		IMP imp = imp_implementationWithBlock(block);
		class_addMethod(object_getClass(self.class), NSSelectorFromString(affectSelectorName), imp, "@@:");
	}
}

-(void)dealloc
{
	DebugLog(@"Model: %@ dealloced.",self);
}
@end
