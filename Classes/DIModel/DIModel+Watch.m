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
-(void)unwatchMdoelClass:(Class)modelClass
{
	NSString* modelName = NSStringFromClass(modelClass);
	return [self unwatchMdoelNamed:modelName];
}

-(void)unwatchMdoelNamed:(NSString*)modelName
{
	//嵌套过多、每次都要重新计算，可以优化
	for (NSString* srcKey in [self.class bindingMap])
	{
		//左端目标存在？
		NSString* leftTargetName = [self modelNameFromKeyPath:srcKey];
		
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
			
			if([leftTargetName isEqualToString:modelName]||[rightTargetName isEqualToString:modelName])
			{
				[self.KVOControllerNonRetaining unobserve:self.watchMap keyPath:srcKey];
				break;
			}
		}
	}
}

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
						 if([self onObserveNew:newValue fromKeyPath:srcKey toKeyPath:distKey])
							 [self invokeSelector:selectorToKeyPath withParams:newValue,distKey];
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
						 if([self onObserveNew:newValue fromKeyPath:srcKey toKeyPath:distKey])
						[self invokeSelector:selectorNoKeyPath withParams:newValue];
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
					[self performBlockOnMainThread:^{
						NoticeLog(@"Will set value %@ forKeyPath %@",newValue,distKey);
						if([self onObserveNew:newValue fromKeyPath:srcKey toKeyPath:distKey])
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
