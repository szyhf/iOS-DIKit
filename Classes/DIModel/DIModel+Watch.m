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
#import "DITools.h"
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

-(void)startWatching_old
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
				[self performBlockOnMainThread:
				 ^{
					[observer invokeSelector:selectorToKeyPath withParams:newValue,key];
				} waitUntilDone:YES];
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
				[self performBlockOnMainThread:
				 ^{
					[observer invokeSelector:selectorNoKeyPath withParams:newValue];
				} waitUntilDone:YES];
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
				[self performBlockOnMainThread:^{
					[watchMap setValue:newValue forKeyPath:key];
				} waitUntilDone:YES];
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

-(void)startWatching
{
	//嵌套过多、每次都要重新计算，可以优化
	for (NSString* srcKey in [self.class bindingMap])
	{
		//左端目标存在？
		NSString* leftTargetName = [self modelNameFromKeyPath:srcKey];
		if(![self.watchMap.allKeys containsObject:leftTargetName])
			continue;
		
		//右端目标可能是数组
		NSArray* distKeys;
		id rightTarget = [self.class bindingMap][srcKey];
		if([rightTarget isKindOfClass:NSString.class])
		{
			distKeys = @[rightTarget];
		}
		else if([rightTarget isKindOfClass:NSArray.class])
		{
			distKeys = rightTarget;
		}
		else
		{
			//暂时不支持NSString和NSArray<NSString*>以外的情况
			WarnLog(@"Unregionzed rightTarget %@",rightTarget);
			continue;
		}
		
		for (NSString* distKey in distKeys)
		{
			//右端存在时继续
			NSString* rightTargetName = [self modelNameFromKeyPath:distKey];
			if(![self.watchMap.allKeys containsObject:rightTargetName])
				continue;
			
			//优先支持forKeyPath的selector，没有的话则尝试调用无forKeyPath的
			SEL selectorToKeyPath = NSSelectorFromString([NSString stringWithFormat:@"set%@:toKeyPath:",[srcKey stringByReplacingOccurrencesOfString:@"." withString:@"_"]]);
			SEL selectorNoKeyPath = NSSelectorFromString([NSString stringWithFormat:@"set%@:",[srcKey stringByReplacingOccurrencesOfString:@"." withString:@"_"]]);
			
			FBKVONotificationBlock observerBlock;
			
			if([self respondsToSelector:selectorToKeyPath])
			{
				observerBlock =
				^(DIModel* observer, NSDictionary* watchMap, NSDictionary<
				  NSString *,id> * change)
				{
					id newValue = [watchMap valueForKeyPath:srcKey];
					[self onObserveNew:newValue fromKeyPath:srcKey toKeyPath:distKey];
					[self performBlockOnMainThread:
					 ^{
						 [observer invokeSelector:selectorToKeyPath withParams:newValue,distKey];
					 } waitUntilDone:YES];
				};
			}
			else if ([self respondsToSelector:selectorNoKeyPath])
			{
				observerBlock =
				^(DIModel* observer, NSDictionary* watchMap, NSDictionary<
				  NSString *,id> * change)
				{
					id newValue = [watchMap valueForKeyPath:srcKey];
					[self onObserveNew:newValue fromKeyPath:srcKey toKeyPath:distKey];
					[self performBlockOnMainThread:
					 ^{
						 [observer invokeSelector:selectorNoKeyPath withParams:newValue];
					 } waitUntilDone:YES];
				};
			}
			else
			{
				
				observerBlock =^(DIModel* observer, NSDictionary* watchMap, NSDictionary<NSString *,id> * change)
				{
					id newValue = [watchMap valueForKeyPath:srcKey];
					if(newValue==nil)
						return ;
					[self onObserveNew:newValue fromKeyPath:srcKey toKeyPath:distKey];
					[self performBlockOnMainThread:^{
						DebugLog(@"Will set value %@ forKeyPath %@",newValue,distKey);
						[watchMap setValue:newValue forKeyPath:distKey];
					} waitUntilDone:YES];
				};
			}
			
			[self willObserveKeyPath:srcKey toKeyPath:distKey];
			
			[self.KVOControllerNonRetaining
			 observe:self.watchMap
			 keyPath:srcKey
			 options:NSKeyValueObservingOptionNew
			 block:observerBlock];
			
			observerBlock(self,self.watchMap,@{});
		}
		
	}
}

-(void)stopWatching
{
	[[self.class bindingMap]enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull srcKey, NSString*  _Nonnull distKey, BOOL * _Nonnull stop)
	 {
		 [self.KVOControllerNonRetaining unobserve:self keyPath:[NSString stringWithFormat:@"watchMap.%@",srcKey]];
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
