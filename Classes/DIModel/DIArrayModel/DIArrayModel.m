//
//  DIArrayModel.m
//  Pods
//
//  Created by Back on 16/6/30.
//
//

#import "DIArrayModel.h"
#import "NSObject+YYModel.h"
@interface DIArrayModel()
//默认存放点
@property (nonatomic, strong) NSArray* diCollection;
@end

@implementation DIArrayModel
/**
 *  拦截一下，table的数据来源做点特殊处理。
 *
 *  @param json 以Array为最外层封装的json字符串
 */
-(void)setByJson:(NSString*)json
{
	NSArray* cellsModels = [NSArray yy_modelArrayWithClass:[self.class cellModelClass] json:json];
	[self performSelectorOnMainThread:@selector(di_setDICollection:) withObject:cellsModels waitUntilDone:YES];
	//[self di_setDICollection:cellsModels];
}

-(void)di_setDICollection:models
{
	[self setValue:models forKey:[self.class collectionProperty]];
}

+(Class)cellModelClass
{
	return DIModel.class;
}

+(NSString*)collectionProperty
{
	return @"diCollection";
}
@end
