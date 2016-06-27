//
//  DIModel+Watch.m
//  Pods
//
//  Created by Back on 16/6/27.
//
//

#import "DIModel.h"
#import "DIContainer.h"
#import "NSObject+FBKVOController.h"
#import "NSObject+Runtimes.h"
#import <objc/runtime.h>
#import "DIString.h"
@implementation DIModel (Watch)
-(void)watchModelClass:(Class)modelClass
{
	NSObject* currentModel = [DIContainer getInstance:modelClass];
	NSString* className = NSStringFromClass(modelClass);
	[self watchModel:currentModel named:className];
}

-(void)watchModel:(NSObject*)model
{
	NSString* className = NSStringFromClass(model.class);
	[self watchModel:model named:className];
}

-(void)watchModel:(NSObject*)model named:(NSString*)modelName
{
	self.watchMap[modelName]=model;
	[self startWatching];
}

-(void)startWatching
{
	for (NSString* key in self.bindingMap)
	{
		//效率和写法不理想，有空再处理
		NSString* modelKey = self.bindingMap[key];
		NSInteger firstDotIndex = [key indexOf:@"."];
		if(firstDotIndex>0)
		{
			NSString* modelName = [key substringToIndex:firstDotIndex];
			if(![self.watchMap.allKeys containsObject:modelName])
			 continue;
		}
		firstDotIndex = [modelKey indexOf:@"."];
		NSString* modelName = [modelKey substringToIndex:firstDotIndex];
		if(![self.watchMap.allKeys containsObject:modelName])
			continue;
		
		SEL selector = NSSelectorFromString([NSString stringWithFormat:@"set%@:",[modelKey stringByReplacingOccurrencesOfString:@"." withString:@"_"]]);
		FBKVONotificationBlock observerBlock;
		
		if([self respondsToSelector:selector])
		{
			observerBlock =
			^(DIModel* observer, NSDictionary* watchMap, NSDictionary<
			  NSString *,id> * change)
			{
				id newValue = [watchMap valueForKeyPath:modelKey];
				[observer invokeSelector:selector withParams:newValue];
			};
		}
		else
		{
			observerBlock =
			^(DIModel* observer, NSDictionary* watchMap, NSDictionary<NSString *,id> * change)
			{
				id newValue = [watchMap valueForKeyPath:modelKey];
				[watchMap setValue:newValue forKeyPath:key];
			};
		}
		[self.KVOControllerNonRetaining
		 observe:self.watchMap
		 keyPath:modelKey
		 options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial
		 block:observerBlock];
	};
}

-(void)stopWatching
{
	[[self bindingMap]enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull modelKey, BOOL * _Nonnull stop)
	 {
		 [self.KVOControllerNonRetaining unobserve:self keyPath:[NSString stringWithFormat:@"watchMap.%@",modelKey]];
	 }];
}

-(void)prepareBindingMap
{
	NSMutableDictionary* newBindingMap = [NSMutableDictionary dictionary];
	for (NSString* key in self.bindingMap)
	{
		NSString* modelKey;
		
		
	}
}

-(NSString*)modelNameFromKeyPath:(NSString*)modelKeyPath
{
	NSInteger firstDotIndex = [modelKeyPath indexOf:@"."];
	switch (firstDotIndex)
	{
		case -1:
		{
			return modelKeyPath;
			break;
		}
		default:
		{
			NSString* modelName = [modelKeyPath substringToIndex:firstDotIndex];
			return modelName;
			break;
		}
	}
}

#pragma mark - property
@dynamic watchMap;
-(NSMutableDictionary<NSString*,NSObject*>*)watchMap
{
	id watchMap = objc_getAssociatedObject(self, NSSelectorFromString(@"watchMap"));
	if(!watchMap)
	{
		watchMap = [NSMutableDictionary dictionary];
		objc_setAssociatedObject(self, NSSelectorFromString(@"watchMap"), watchMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return watchMap;
}

@dynamic bindingMap;
-(NSDictionary<NSString*,NSString*>*)bindingMap
{
	static NSDictionary* _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = @{
									//@"controllerKeyPath":@"(modelName).modelKeyPath"
									};
				  });
	return _instance;
}
@end
