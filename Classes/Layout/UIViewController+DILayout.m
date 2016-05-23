//
//  UIViewController+DILayout.m
//  DIKit
//
//  Created by Back on 16/5/22.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "UIViewController+DILayout.h"
#import "DILayoutParser.h"
#import "DILayoutKey.h"

@implementation UIViewController (DILayout)
-(void)setValue:(id)value
forUndefinedKey:(NSString *)key
{
	if([DILayoutKey isLayoutAttribute:key]
	   && [value isKindOfClass:NSString.class])
	{
		NSLayoutConstraint* constraint =
		[[DILayoutParser instance]constraint:value
								 toAttribute:key
									 forView:self.view];
		[self.view.superview addConstraint:constraint];
	}
}
@end
