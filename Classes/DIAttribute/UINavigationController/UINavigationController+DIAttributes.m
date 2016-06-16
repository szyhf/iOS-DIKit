//
//  UINavigationController+DIAttributes.m
//  DIKit
//
//  Created by Back on 16/6/7.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "UINavigationController+DIAttributes.h"
#import "DITree.h"
#import "DIRouter.h"
#import "DITemplateNode.h"

@implementation UINavigationController (DIAttributes)
+(UndefinedKeyHandlerBlock)di_AttributeBlock:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = @{
									@"push":self.pushKey,
									@"navigationBarHidden":self.NavigationBarHiddenKey
									} ;
				  });
	return _instance[key];
}
+(UndefinedKeyHandlerBlock)NavigationBarHiddenKey
{
	return ^void(UINavigationController* _self,NSString*key,NSString* value)
	{
		[_self setValue:[NSNumber numberWithBool:[value boolValue]] forKey:key];
	};
}
+(UndefinedKeyHandlerBlock)pushKey
{
	return ^void(UINavigationController* _self,NSString*key,id value)
	{
		NSMutableArray* pushs = [_self valueForKey:@"di_push"];
		NSArray* newAry;
		if([value isKindOfClass:NSArray.class])
		{
			newAry = value;
		}
		else
		{
			newAry=@[value];
		}
		
		if(pushs)
		{
			[pushs addObjectsFromArray:newAry];
		}
		else
		{
			pushs = [NSMutableArray arrayWithArray:newAry];
		}
		[_self setValue:pushs forKey:@"di_push"];
		
		if([[_self childViewControllers]count]==0)
			[_self pushNext];
	};
}
-(void)pushNext
{
	NSArray* pushs = [self valueForKey:@"di_push"];
	NSInteger currentIndex = [[self childViewControllers]count];
	if(pushs.count>currentIndex)
	{
		DITemplateNode* targetNode = pushs[currentIndex];
		UIViewController* ctrl =targetNode.newImplement;
		[self pushViewController:ctrl animated:YES];
	}
}
-(void)pop
{
	[self popViewControllerAnimated:YES];
}
@end
