//
//  DICollectionView+DIAttribute.m
//  Pods
//
//  Created by Back on 16/6/13.
//
//

#import "DICollectionView+DIAttribute.h"

@implementation DICollectionView (DIAttribute)
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
	return ^void(DICollectionView* view,NSString*key,id value)
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
