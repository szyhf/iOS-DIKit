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
@property (nonatomic, strong) NSArray* cellModels;
@end

@implementation DIArrayModel
/**
 *  拦截一下，table的数据来源做点特殊处理。
 *
 *  @param json 以Array为最外层封装的json字符串
 */
-(void)setJsonOnMainThread:(NSString*)json
{
	NSArray* cellsModels = [NSMutableArray yy_modelArrayWithClass:[self.class cellModelClass] json:json];
	[self performSelectorOnMainThread:@selector(di_setCellModels:) withObject:cellsModels waitUntilDone:YES];
}

-(void)di_setCellModels:models
{
	[self setValue:models forKey:[self.class collectionProperty]];
}

+(Class)cellModelClass
{
	return DIModel.class;
}

+(NSString*)collectionProperty
{
	return @"cellModels";
}
@end
