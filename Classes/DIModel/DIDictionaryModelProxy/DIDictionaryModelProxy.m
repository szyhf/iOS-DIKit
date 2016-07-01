//
//  DICollectionModel.m
//  Liangfeng
//
//  Created by Back on 16/6/29.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIDictionaryModelProxy.h"
#import "NSObject+FBKVOController.h"
@interface DIDictionaryModelProxy()
@property (nonatomic, strong,readonly) NSString* collectionKeyPath;
/**
 *  当前模型除了主键外的其他属性
 */
@property (nonatomic, strong,readonly) NSArray<NSString*>* commonProperties;
/**
 *  +(NSString*)primaryKey的代理属性。
 */
@property (nonatomic, strong,readonly) NSString* primaryKey;
/**
 *  +(NSString*)collectionProperty的代理属性
 */
@property (nonatomic, strong,readonly) NSString* collectionProperty;
/**
 *  +(Class)collectionClass的代理属性
 */
@property (nonatomic, assign) Class collectionClass;
@end

@implementation DIDictionaryModelProxy

+(NSString*)primaryKey
{
	return @"ID";
}
+(NSString*)collectionProperty
{
	return [[self collectionClass]invokeMethod:@"collectionProperty"];
}
+(Class)collectionClass
{
	return DIDictionaryModel.class;
}

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		NSAssert([[self.class collectionClass]isSubclassOfClass:DIDictionaryModel.class], @"[DIDictionaryModelProxy collectionClass] should be subclass of DIDictionaryModel.");
		[self watchModelClass:self.collectionClass];
		
		[self watchCollection];
		[self watchPrimaryKey];
		//TODO（待定，目前难以测试）：
		//观察当前映射对象的非主键属性
		//并根据新的主键更新监控的对象路径
		//其他属性更新时仅调用该成员已更新的通知。
	
	}
	return self;
}

-(NSArray*)commonProperties
{
	static NSArray* _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					 unsigned int propertyCount = 0;
					  objc_property_t *properties = class_copyPropertyList(self.class, &propertyCount);
					 NSMutableArray* _properties = [NSMutableArray arrayWithCapacity:propertyCount];
					  if(properties)
					  {
						  for(int i = 0; i < propertyCount; i ++)
						  {
							  objc_property_t property = properties[i];
							  NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
							  [_properties addObject:propName];
						  }
					  }
					  free(properties);
					  [_properties removeObject:self.primaryKey];
					  
					  _instance = [NSArray arrayWithArray:_properties];
				  });
	return _instance;
}

/**
 *  发出除主键以外其他属性已更新的通知
 */
-(void)notifyModelUpdated
{
	for (NSString* property in self.commonProperties)
	{
		[self willChangeValueForKey:property];
	}
	
	//逆序调用didChange
	[self.commonProperties enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull property, NSUInteger idx, BOOL * _Nonnull stop) {
		[self didChangeValueForKey:property];
	}];
}

/**
 *  监视当前代理的主键，如果主键更新，模拟通知其他属性已更新
 */
-(void)watchPrimaryKey
{
	[self.KVOControllerNonRetaining
	 observe:self
	 keyPath:self.primaryKey
	 options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
	 block:
	 ^(DIDictionaryModelProxy*  _Nullable observer, DIDictionaryModelProxy*  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change)
	 {
		 [self notifyModelUpdated];
	 }
	 ];
}

/**
 *  监视代理的目标集合，如果集合更新，则模拟通知所有代理的非主键属性已更新
 */
-(void)watchCollection
{
	[self.KVOControllerNonRetaining
	 observe:self.watchMap
	 keyPath:self.collectionKeyPath
	 options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
		block:^(DIDictionaryModelProxy*  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change)
		{
			[self notifyModelUpdated];
		}];
}

-(void)setValue:(id)value
		 forKey:(NSString *)key
{
	NSString* pk = self.primaryKey;
	if([key isEqualToString:pk])
	{
		[super setValue:value forKey:key];
	}
	else
	{
		//将设置的行为映射为向集合的制定对象进行
		NSString* collectionProperty = self.collectionProperty;
		id pkValue = [self valueForKey:pk];
		
		DIModel* collectionModel = [DIContainer getInstance:self.collectionClass];
		NSString* keypath = [NSString stringWithFormat:@"%@.%@",collectionProperty,pkValue];
		DIDictionaryModelProxy* model = [collectionModel valueForKeyPath:keypath];
		[model super_setValue:value forKey:key];
	}
}

-(id)valueForKey:(NSString*)key
{
	NSString* pk = self.primaryKey;
	if([key isEqualToString:pk])
	{
		return 	[super valueForKey:key];
	}
	else
	{
		NSString* collectionProperty = self.collectionProperty;
		id pkValue = [self valueForKey:pk];
		
		DIModel* collectionModel = [DIContainer getInstance:self.collectionClass];
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

#pragma mark - property
-(NSString*)collectionKeyPath
{
	return [NSString stringWithFormat:@"%@.%@",NSStringFromClass(self.collectionClass),self.collectionProperty];
}
-(NSString*)primaryKey
{
	return [self.class primaryKey];
}
-(NSString*)collectionProperty
{
	return [self.class collectionProperty];
}
-(Class)collectionClass
{
	return [self.class collectionClass];
}
@end
