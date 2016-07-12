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
#import "DIString.h"
#import "DIObject.h"
#import <objc/runtime.h>
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
	__weak NSObject* weakModel = model;
	self.watchMap[modelName]=weakModel;
	[self startWatching];
}

-(void)startWatching
{
	for (NSString* key in [self.class bindingMap])
	{
		NSString* modelKey = [self.class bindingMap][key];
		
		//效率和写法不理想，有空再处理
		//key映射的model可能不存在（因为modelKey被拦截了）
		NSInteger firstDotIndex = [key indexOf:@"."];
		NSString* modelName;
		if(firstDotIndex>0)
		{
			modelName = [key substringToIndex:firstDotIndex];
			if(![self.watchMap.allKeys containsObject:modelName])
			 continue;
		}
		
		//modelKey映射的Model必须存在
		modelName = [self modelNameFromKeyPath:modelKey];
		if(![self.watchMap.allKeys containsObject:modelName])
			continue;
		
		//优先支持forKeyPath的selector，没有的话则尝试调用无forKeyPath的
		SEL selectorToKeyPath = NSSelectorFromString([NSString stringWithFormat:@"set%@:toKeyPath:",[modelKey stringByReplacingOccurrencesOfString:@"." withString:@"_"]]);
		SEL selectorNoKeyPath = NSSelectorFromString([NSString stringWithFormat:@"set%@:",[modelKey stringByReplacingOccurrencesOfString:@"." withString:@"_"]]);
		
		
		FBKVONotificationBlock observerBlock;
		
		if([self respondsToSelector:selectorToKeyPath])
		{
			observerBlock =
			^(DIModel* observer, NSDictionary* watchMap, NSDictionary<
			  NSString *,id> * change)
			{
				id newValue = [watchMap valueForKeyPath:modelKey];
				[self onObserveNew:newValue fromKeyPath:modelKey toKeyPath:key];
#if TARGET_OS_SIMULATOR
				dispatch_queue_t queue = dispatch_get_main_queue();
				if(![NSThread isMainThread])
				{
					dispatch_sync(queue, ^{
#endif
								  [observer invokeSelector:selectorToKeyPath withParams:newValue,key];
#if TARGET_OS_SIMULATOR
							  });
				}else
				{
					 [observer invokeSelector:selectorToKeyPath withParams:newValue,key];
				}
#endif
			};
		}
		else if ([self respondsToSelector:selectorNoKeyPath])
		{
			observerBlock =
			^(DIModel* observer, NSDictionary* watchMap, NSDictionary<
			  NSString *,id> * change)
			{
				id newValue = [watchMap valueForKeyPath:modelKey];
				[self onObserveNew:newValue fromKeyPath:modelKey toKeyPath:key];
#if TARGET_OS_SIMULATOR
				dispatch_queue_t queue = dispatch_get_main_queue();
				if(![NSThread isMainThread])
				{
					dispatch_sync(queue, ^{
#endif
								  [observer invokeSelector:selectorNoKeyPath withParams:newValue];
#if TARGET_OS_SIMULATOR
							  });
				}else
				{
					  [observer invokeSelector:selectorNoKeyPath withParams:newValue];
				}
#endif
			};
		}
		else
		{
			observerBlock =
			^(DIModel* observer, NSDictionary* watchMap, NSDictionary<NSString *,id> * change)
			{
				id newValue = [watchMap valueForKeyPath:modelKey];
				if(newValue==nil)
					return ;
				[self onObserveNew:newValue fromKeyPath:modelKey toKeyPath:key];
#if TARGET_OS_SIMULATOR
				dispatch_queue_t queue = dispatch_get_main_queue();
				if(![NSThread isMainThread])
				{
					dispatch_sync(queue, ^{
#endif
								  [watchMap setValue:newValue forKeyPath:key];
#if TARGET_OS_SIMULATOR
							  });
				}else
				{
					[watchMap setValue:newValue forKeyPath:key];
				}
#endif
			};
		}
		
		[self willObserveKeyPath:modelKey toKeyPath:key];
		
		[self.KVOControllerNonRetaining
		 observe:self.watchMap
		 keyPath:modelKey
		 options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial
		 block:observerBlock];
	};
}

-(void)stopWatching
{
	[[self.class bindingMap]enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull modelKey, BOOL * _Nonnull stop)
	 {
		 [self.KVOControllerNonRetaining unobserve:self keyPath:[NSString stringWithFormat:@"watchMap.%@",modelKey]];
	 }];
}

-(void)prepareBindingMap
{
	//NSMutableDictionary* newBindingMap = [NSMutableDictionary dictionary];
	//for (NSString* key in self.bindingMap)
	//{
		//NSString* modelKey;
		
		
	//}
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

#pragma mark - event
-(void)willObserveKeyPath:(NSString*)keyPath
		  toKeyPath:(NSString*)targetKeyPath
{
	//便于子类调试。
}

-(bool)onObserveNew:(id)newValue
		 fromKeyPath:(NSString*)keyPath
		  toKeyPath:(NSString*)targetKeyPath
{
	//便于子类调试。
	return YES;
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

+(NSDictionary<NSString*,NSString*>*)bindingMap
{
	return @{};
}

+(NSDictionary*)affectingMap
{
	return @{
			 
			 };
}
@end
