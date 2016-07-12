//
//  DIArrayProxyModel.m
//  Liangfeng
//
//  Created by Back on 16/7/12.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIArrayProxyModel.h"
#import "DIModel.h"
#import "NSObject+FBKVOController.h"
@interface DIArrayProxyModel()
@property (nonatomic, strong,readonly) NSString* collectionKeyPath;
/**
 *  当前模型除了主键外的其他属性
 */
@property (nonatomic, strong) NSArray<NSString*>* commonProperties;
/**
 *  +(NSString*)primaryKey的代理属性。
 */
@property (nonatomic, strong,readonly) NSArray* primaryKeys;
/**
 *  +(NSString*)collectionProperty的代理属性
 */
@property (nonatomic, strong,readonly) NSString* collectionProperty;
/**
 *  +(Class)collectionClass的代理属性
 */
@property (nonatomic, assign) Class collectionClass;

@property (nonatomic, weak) DIArrayProxyModel* srcModel;

@end

@implementation DIArrayProxyModel
+(NSArray<NSString*>*)primaryKeys
{
	return @[@"ID"];
}
+(NSString*)collectionProperty
{
	return @"diCollection";
}
+(Class)collectionClass
{
	return DIArrayModel.class;
}

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		NSAssert([[self.class collectionClass]isSubclassOfClass:DIArrayModel.class], @"[%@ collectionClass] should be subclass of DIArrayModel.",self);
		[self watchModelClass:self.collectionClass];
		[self watchCollection];
		[self watchPrimaryKey];
		//观察当前映射对象的非主键属性
		//并根据新的主键更新监控的对象路径
		//其他属性更新时仅调用该成员已更新的通知。
	}
	return self;
}

-(void)setValue:(id)value
		 forKey:(NSString *)key
{
	if([self.primaryKeys containsObject:key])
	{
		[super setValue:value forKey:key];
	}
	else
	{
		if(self.srcModel)
			return [self.srcModel super_setValue:value forKey:key];
	}
}

-(id)valueForKey:(NSString*)key
{
	if([self.primaryKeys containsObject:key])
	{
		return [super valueForKey:key];
	}
	else
	{
		DIArrayProxyModel* srcModel = (DIArrayProxyModel*)self.srcModel;
		if(srcModel)
			return [srcModel super_valueForKey:key];
		return nil;
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
	[self.KVOControllerNonRetaining observe:self keyPaths:self.primaryKeys options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change)
	 {
		 [self notifyModelUpdated];
		 if(self!=self.srcModel)
		 for (NSString* property in [self commonProperties])
		 {
			 [self.KVOControllerNonRetaining
			  observe:self.srcModel
			  keyPath:property
			  options:NSKeyValueObservingOptionNew
			  block:
			  ^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change)
			  {
				  ////如果当前代理本身也充当了数据结构的话，取消监控以防止死循环。
				  //NSArray* sourceModels = [collectionModel valueForKeyPath:self.collectionProperty];
				  //if([sourceModels containsObject:self])
				  //{
				  ////DebugLog(@"Remove observe:%@",self);
				  //[self.KVOControllerNonRetaining unobserve:collectionModel keyPath:watchKeyPath];
				  //return;
				  //}
				  [self willChangeValueForKey:property];
				  [self didChangeValueForKey:property];
			  }];
		 }
	 }];
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
	 block:^(DIDictionaryProxyModel*  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change)
	 {
		 [self notifyModelUpdated];
	 }];
}

#pragma mark - property
+(NSArray*)commonProperties
{
	//存在性能问题，每次都要重新生成，待处理。
	NSArray* _instance;
	//dispatch_once_t onceToken;
	//dispatch_once(&onceToken,
	//^{
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
	[_properties removeObjectsInArray:[self primaryKeys]];
	
	_instance = [NSArray arrayWithArray:_properties];
	
	//});
	return _instance;
}
-(NSArray*)primaryKeys
{
	return [self.class primaryKeys];
}
-(NSString*)collectionProperty
{
	return [self.class collectionProperty];
}
-(Class)collectionClass
{
	return [self.class collectionClass];
}

-(NSString*)collectionKeyPath
{
	return [NSString stringWithFormat:@"%@.%@",NSStringFromClass(self.collectionClass),self.collectionProperty];
}

- (NSArray<NSString*> *)commonProperties {
	if(_commonProperties == nil)
	{
		NSMutableArray*__commonProperties = [NSMutableArray array];
		Class clazz = self.superclass;
		while(clazz!=DIArrayProxyModel.class)
		{
			[__commonProperties addObjectsFromArray:[clazz commonProperties]];
			clazz = clazz.superclass;
		}
		[__commonProperties addObjectsFromArray:[self.class commonProperties]];
		_commonProperties = [NSArray arrayWithArray:__commonProperties];
	}
	return _commonProperties;
}

-(DIArrayProxyModel*)srcModel
{
	//TODO:缓存
	NSMutableArray* predicates = [NSMutableArray array];
	for (NSString* pk in self.primaryKeys)
	{
		id value = [self valueForKey:pk];
		if([value isKindOfClass:NSNumber.class])
		{
			[predicates addObject:[NSPredicate predicateWithFormat:@"%K==%@",pk,value]];
		}
		else
		{
			[predicates addObject:[NSPredicate predicateWithFormat:@"%K=='%@'",pk,value]];
		}
	}
	NSCompoundPredicate* cPre = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
	
	DIModel* collectionModel = [DIContainer getInstance:self.collectionClass];
	NSArray* models = [collectionModel valueForKey:self.collectionProperty];
	NSArray* results = [models filteredArrayUsingPredicate:cPre];
	if(results)
	{
		if(results.count>0)
		{
			WarnLogWhile(results.count>1, @"DIArrayProxyModel got more than one results.");
			//根据当前的主键设置找出的元数据元素
			return results.firstObject;
		}
	}
	
	//WarnLog(@"%@ can't find a result.\n%@",self,cPre);
	return nil;
}

@end
