//
//  DIArraySelectionModel.m
//  DIKit
//
//  Created by Back on 16/7/14.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIArraySelectionModel.h"
@interface DIArraySelectionModel ()
@property (nonatomic, strong) NSMutableArray* andPredicates;
@property (nonatomic, strong) NSMutableArray* orPredicates;
@property (nonatomic, strong) NSMutableArray* notPredicates;
@end

@implementation DIArraySelectionModel
+(Class)cellModelClass
{
	return [self.collectionClass cellModelClass];
}

+(Class)collectionClass
{
	return DIArrayModel.class;
}

+(NSSet*)keyPathsForValuesAffectingSorts
{
	return [NSSet setWithObject:@"orders"];
}

-(NSArray*)diCollection
{
	DIArrayModel* arrayModel = [DIContainer getInstance:[self.class collectionClass]];
	NSArray* srcArray = arrayModel.array;
	if(self.predicate)
	{
		NSArray* res = [srcArray filteredArrayUsingPredicate:self.predicate];
		if(res.count>0&&self.sorts)
			res = [res sortedArrayUsingDescriptors:self.sorts];
		return res;
	}
	return @[];
}

/**
 *  一个表示当前默认排序的声明@[@{firstResponseKey:order},@{secondeResponseKey:order}]
 *
 *  @return
 */
-(NSArray<NSDictionary<NSString*,NSNumber*>*>*)orders
{
	return @[
			 ];
}

//-(NSArray<NSSortDescriptor*>*)sorts
//{
	//if([self orders].count==0)
		//return @[];
	
	//NSMutableArray* sorts = [NSMutableArray arrayWithCapacity:[self orders].count];
	//for (NSDictionary<NSString*,NSNumber*>* orders in [self orders])
	//{
		//for (NSString* key in orders)
		//{
			//NSNumber* isASC = orders[key];
			//NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:key ascending:isASC.boolValue];
			//[sorts addObject:sort];
		//}
	//}
	
	//return sorts;
//}

-(void)reversOrderByKey:(NSString*)key
{
	bool asc = NO;
	NSMutableArray* newSorts = [NSMutableArray arrayWithCapacity:self.sorts.count];
	for (NSSortDescriptor* sorter in self.sorts)
	{
		if([sorter.key isEqualToString:key])
		{
			asc = !sorter.ascending;
		}
		//else
		//{
			//[newSorts addObject:sorter];
		//}
	}
	
	[newSorts addObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:asc]];;
	self.sorts = newSorts;
	
	//bool asc = NO;
	//for (NSDictionary* order in self.orders)
	//{
		//if(order[key])
		//{
			//asc = !((NSNumber*)order[key]).boolValue;
		//}
	//}
	//self.orders = @[@{key:[NSNumber numberWithBool:asc]}];
}
@end
