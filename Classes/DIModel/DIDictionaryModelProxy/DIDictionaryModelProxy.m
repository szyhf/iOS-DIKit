//
//  DICollectionModel.m
//  Liangfeng
//
//  Created by Back on 16/6/29.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIDictionaryModelProxy.h"
#import "NSObject+FBKVOController.h"

@implementation DIDictionaryModelProxy

+(NSString*)primaryKey
{
	return @"ID";
}
+(NSString*)collectionProperty
{
	return @"collections";
}
+(Class)collectionsClass
{
	return NSObject.class;
}

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		[self watchModelClass:[self.class collectionsClass]];
		
		NSString *collectionWatchKeyPath = [NSString stringWithFormat:@"%@.%@",NSStringFromClass([self.class collectionsClass]),[self.class collectionProperty]];
		
		[self.KVOControllerNonRetaining
		 observe:self.watchMap
		 keyPath:collectionWatchKeyPath
		 options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
		block:^(DIDictionaryModelProxy*  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change)
		{
			for (NSString* property in [self.class selfProperties])
			{
				[self willChangeValueForKey:property];
			}
			
			//逆序调用didChange
			[[self.class selfProperties] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull property, NSUInteger idx, BOOL * _Nonnull stop) {
				[self didChangeValueForKey:property];
			}];
		}];
	}
	return self;
}

static NSMutableArray<NSString*>* _selfProperties;
+(NSMutableArray<NSString*>*)selfProperties
{
	if(!_selfProperties)
	{
		//动态获取当前Model的属性名，用于实现反向通知代理模拟更新
		unsigned int propertyCount = 0;
		objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
		_selfProperties = [NSMutableArray arrayWithCapacity:propertyCount];
		if(properties)
		{
			for(int i = 0; i < propertyCount; i ++)
			{
				objc_property_t property = properties[i];
				NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
				[_selfProperties addObject:propName];
			}
		}
		free(properties);
	}
	
	return _selfProperties;
}

-(void)collectionUpdated
{

}

-(void)setValue:(id)value
		 forKey:(NSString *)key
{
	NSString* pk = [self.class primaryKey];
	if([key isEqualToString:pk])
	{
		[super setValue:value forKey:key];
	}
	else
	{
		//将设置的行为映射为向集合的制定对象进行
		NSString* collectionProperty = [self.class collectionProperty];
		id pkValue = [self valueForKey:pk];
		
		DIModel* collectionModel = [DIContainer getInstance:[self.class collectionsClass]];
		NSString* keypath = [NSString stringWithFormat:@"%@.%@",collectionProperty,pkValue];
		DIDictionaryModelProxy* model = [collectionModel valueForKeyPath:keypath];
		[model super_setValue:value forKey:key];
	}
}

-(id)valueForKey:(NSString*)key
{
	NSString* pk = [self.class primaryKey];
	if([key isEqualToString:pk])
	{
		return 	[super valueForKey:key];
	}
	else
	{
		NSString* collectionProperty = [self.class collectionProperty];
		id pkValue = [self valueForKey:pk];
		
		DIModel* collectionModel = [DIContainer getInstance:[self.class collectionsClass]];
		NSString* keypath = [NSString stringWithFormat:@"%@.%@",collectionProperty,pkValue];
		DIDictionaryModelProxy* model = [collectionModel valueForKeyPath:keypath];
		return [model super_valueForKey:key];
	}
}

-(id)super_valueForKey:(NSString*)key
{
	return [super valueForKey:key];
}

-(void)super_setValue:(id)value forKey:(NSString *)key
{
	return [super setValue:value forKey:key];
}

@end
