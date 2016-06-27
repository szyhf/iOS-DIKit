//
//  DITableView+DIAttribute.m
//  DIKit
//
//  Created by Back on 16/6/12.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DITableView+DIAttribute.h"
#import "DITableViewSection.h"

@implementation DITableView (DIAttribute)
+(UndefinedKeyHandlerBlock)di_AttributeBlock:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = @{
									@"cell":self.cellKey,
									//@"section":self.sectionKey,
									} ;
				  });
	return _instance[key];
}

//+(UndefinedKeyHandlerBlock)sectionKey
//{
	//return ^void(DITableView* view,NSString*key,id value)
	//{
		//NSMutableArray<DITableViewSection*>* values ;
		//if([value isKindOfClass:DITableViewSection.class])
		//{
			//values = [NSMutableArray arrayWithObject:value];
		//}
		//else
		//{
			//values = value;
		//}
		//if(view.sections)
			//[view.sections addObjectsFromArray:values];
		//else
			//[view setSections:values];
	//};
//}

+(UndefinedKeyHandlerBlock)cellKey
{
	return ^void(DITableView* view,NSString*key,id value)
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
		
		for (DITemplateNode* templateNode in values)
		{
			[view registerCellNode:templateNode];
		}
	};
}
@end
