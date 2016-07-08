//
//  DIViewModel.m
//  DIKit
//
//  Created by Back on 16/6/21.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIViewModel.h"
#import "DIContainer.h"
#import "DITools.h"
#import "NSObject+FBKVOController.h"

@implementation DIViewModel
-(void)setBindingInstance:(NSObject*)bindingInstance
{
	//重置观察，要不ViewModel在重用时可能无法正确更新被观察的对象
	[self.KVOControllerNonRetaining unobserveAll];
	[self watchModel:bindingInstance named:@"target"];
}

-(id)bindingInstance
{
	return self.watchMap[@"target"];
}

//-(void)startWatching
//{
	//for (NSString* key in [self.class bindingMap])
	//{
		//NSString* modelKey = [self.class bindingMap][key];
		
		////效率和写法不理想，有空再处理
		////key映射的model可能不存在（因为modelKey被拦截了）
		//NSInteger firstDotIndex = [key indexOf:@"."];
		//if(firstDotIndex>0)
		//{
			//NSString* modelName = [key substringToIndex:firstDotIndex];
			//if(![self.watchMap.allKeys containsObject:modelName])
			 //continue;
		//}
		
		////modelKey映射的Model必须存在
		//NSString* modelName = [self invokeMethod:@"modelNameFromKeyPath:" withParams:modelKey];
		//if(![self.watchMap.allKeys containsObject:modelName])
			//continue;
		
		////优先支持forKeyPath的selector，没有的话则尝试调用无forKeyPath的
		//SEL selectorToKeyPath = NSSelectorFromString([NSString stringWithFormat:@"set%@:toKeyPath:",[modelKey stringByReplacingOccurrencesOfString:@"." withString:@"_"]]);
		//SEL selectorNoKeyPath = NSSelectorFromString([NSString stringWithFormat:@"set%@:",[modelKey stringByReplacingOccurrencesOfString:@"." withString:@"_"]]);
		
		
		//FBKVONotificationBlock observerBlock;
		
		//if([self respondsToSelector:selectorToKeyPath])
		//{
			//observerBlock =
			//^(DIModel* observer, NSDictionary* watchMap, NSDictionary<
			  //NSString *,id> * change)
			//{
				//id newValue = [watchMap valueForKeyPath:modelKey];
				
				//[self onObserveNew:newValue forKeyPath:modelKey toKeyPath:key];
				//dispatch_queue_t queue = dispatch_get_main_queue();
				//if(![NSThread isMainThread])
				//{
					//dispatch_sync(queue, ^{
						//[observer invokeSelector:selectorToKeyPath withParams:newValue,key];
					//});
				//}
				//else
				//{
					//[observer invokeSelector:selectorToKeyPath withParams:newValue,key];
				//}
			//};
		//}
		//else if ([self respondsToSelector:selectorNoKeyPath])
		//{
			//observerBlock =
			//^(DIModel* observer, NSDictionary* watchMap, NSDictionary<
			  //NSString *,id> * change)
			//{
				//id newValue = [watchMap valueForKeyPath:modelKey];
				
				//[self onObserveNew:newValue forKeyPath:modelKey toKeyPath:key];
				//dispatch_queue_t queue = dispatch_get_main_queue();
				//if(![NSThread isMainThread])
				//{
					//dispatch_sync(queue, ^{
						//[observer invokeSelector:selectorNoKeyPath withParams:newValue];
					//});
				//}
				//else
				//{
					//[observer invokeSelector:selectorNoKeyPath withParams:newValue];
				//}
			//};
		//}
		//else
		//{
			//observerBlock =
			//^(DIModel* observer, NSDictionary* watchMap, NSDictionary<NSString *,id> * change)
			//{
				//id newValue = [watchMap valueForKeyPath:modelKey];
				////id oldValue = [watchMap valueForKeyPath:key];
				//[self onObserveNew:newValue forKeyPath:modelKey toKeyPath:key];
				////if ([newValue isEqual:oldValue])
				////{
				////return;
				////}
				//if(![NSThread isMainThread])
				//{
					//dispatch_queue_t queue = dispatch_get_main_queue();
					//dispatch_sync(queue,
								  //^{
									  //[watchMap setValue:newValue forKeyPath:key];
								  //});
				//}
				//else
				//{
					//[watchMap setValue:newValue forKeyPath:key];
				//}
			//};
		//}
		//[self.KVOControllerNonRetaining
		 //observe:self.watchMap
		 //keyPath:modelKey
		 //options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial
		 //block:observerBlock];
	//};
//}

//view.property => vm.property
//vm.property => model.property
@end
