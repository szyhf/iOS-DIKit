//
//  DITableViewDataSource+DIAttribute.m
//  DIKit
//
//  Created by Back on 16/6/23.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DITableViewDataSource+DIAttribute.h"
#import "NSObject+DIAttribute.h"

@implementation DITableViewDataSource (DIAttribute)
+(UndefinedKeyHandlerBlock)di_AttributeBlock:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = @{
									@"cell":self.cellKey,
									} ;
				  });
	return _instance[key];
}

+(UndefinedKeyHandlerBlock)cellKey
{
	return ^void(DITableViewDataSource* dataSource,NSString*key,id value)
	{
		NSMutableArray<DITemplateNode*>* values ;
		if([value isKindOfClass:DITemplateNode.class])
		{
			values = [NSMutableArray arrayWithObject:value];
		}
		else
		{
			values = value;
		}
		[[dataSource cellTemplates]addObjectsFromArray:values];
	};
}
@end
