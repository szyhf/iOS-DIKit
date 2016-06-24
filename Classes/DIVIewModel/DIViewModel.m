//
//  DIViewModel.m
//  DIKit
//
//  Created by Back on 16/6/21.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIViewModel.h"
#import "DIContainer.h"
#import "NSObject+FBKVOController.h"
#import "NSObject+Runtimes.h"

@implementation DIViewModel
@synthesize modelsMap = _modelsMap;
@synthesize bindingInstance = _bindingInstance;
- (instancetype)init
{
	self = [super init];
	if (self) {
		_modelsMap = [NSMutableDictionary dictionary];
	}
	return self;
}

-(void)unbinding
{
	[_bindingInstance.KVOControllerNonRetaining unobserveAll];
}

-(void)setBindingInstance:(NSObject*)bindingInstance
{
	_bindingInstance = bindingInstance;
	[[self bindingMap]enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull modelKey, BOOL * _Nonnull stop)
	 {
		 SEL selector = NSSelectorFromString([NSString stringWithFormat:@"set%@:",[modelKey stringByReplacingOccurrencesOfString:@"." withString:@"_"]]);
		 void(^observerBlock)(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change);
		 
		 if([self respondsToSelector:selector])
		 {
			 observerBlock =
			 ^(id observer, NSMutableDictionary<NSString*,NSObject*>* modelsMap, NSDictionary<
			   NSString *,id> * change)
			 {
				 [((id)self) invokeSelector:selector withParams:[modelsMap valueForKeyPath:modelKey],observer];
			 };
		 }
		 else
		 {
			 observerBlock =
			 ^(id observer, NSMutableDictionary<NSString*,NSObject*>* modelsMap, NSDictionary<NSString *,id> * change)
			 {
				 id newValue = [modelsMap valueForKeyPath:modelKey];
				 [_bindingInstance setValue:newValue forKeyPath:key];
			 };
		 }
		 [_bindingInstance.KVOControllerNonRetaining observe:self.modelsMap keyPath:modelKey options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial block:observerBlock];
	 }];
}

-(void)registryModelClass:(Class)modelClass
{
	NSObject* currentModel = [DIContainer getInstance:modelClass];
	NSString* className = NSStringFromClass(modelClass);
	[self registryModel:currentModel named:className];
}

-(void)registryModel:(NSObject*)model
{
	NSString* className = NSStringFromClass(model.class);
	[self registryModel:model named:className];
}

-(void)registryModel:(NSObject*)model named:(NSString*)modelName
{
	self.modelsMap[modelName]=model;
}

-(NSMutableDictionary<NSString*,NSObject*>*)modelsMap
{
	return _modelsMap;
}

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
