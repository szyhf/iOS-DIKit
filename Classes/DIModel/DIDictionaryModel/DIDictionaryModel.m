//
//  DIDictionaryModel.m
//  DIKit
//
//  Created by Back on 16/6/30.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIDictionaryModel.h"
#import "NSObject+YYModel.h"
@interface DIDictionaryModel()
@property (nonatomic, strong) NSDictionary* diCollection;
@end

@implementation DIDictionaryModel
/**
 *  拦截一下，table的数据来源做点特殊处理。
 *
 *  @param json 以Dictionary为最外层封装的json字符串
 */
-(void)setJsonOnMainThread:(NSString*)json
{
	NSDictionary* cellsModels =	[NSDictionary yy_modelDictionaryWithClass:[self.class cellModelClass] json:json];
	[self performSelectorOnMainThread:@selector(di_setDICollection:) withObject:cellsModels waitUntilDone:YES];
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
