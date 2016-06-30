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

@implementation DIModel
- (instancetype)init
{
	self = [super init];
	if (self)
	{
		//模拟数据源
#if TARGET_OS_SIMULATOR
		NSString* dataPath = [NSString stringWithFormat:@"%@%@.json",DIConfig.getNSString(@"LocalDataDirectory"),self.class];
		[DIWatcher watch:dataPath withCallback:
		 ^{
			 NSString* json = [NSString stringWithContentsOfFile:dataPath
										   usedEncoding:nil
														   error:nil];
			 [self setJsonOnMainThread:json];
		 }];
#else
		NSString* dataPath = [[NSBundle mainBundle]pathForResource:NSStringFromClass(self.class) ofType:@".json"];
#endif
		NSString* json = [NSString stringWithContentsOfFile:dataPath
											   usedEncoding:nil
													  error:nil];
		[self setJsonOnMainThread:json];
		
		//正式
		[self watchModel:self named:@"self"];
		[self watchUniqueModelClass];
		[self watchCommonModelClass];
	}
	return self;
}

-(void)setJsonOnMainThread:(NSString*)json
{
	[self performSelectorOnMainThread:@selector(yy_modelSetWithJSON:) withObject:json waitUntilDone:YES];
}

-(void)watchCommonModelClass
{
	//CommonModel是非单例，一般是ProxyModel
	for (id clazz in [self.class commonModelWatchClass])
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
+(NSArray*)commonModelWatchClass
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

-(void)dealloc
{
	DebugLog(@"Model: %@ dealloced.",self);
}
@end
