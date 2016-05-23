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
		NSArray<NSLayoutConstraint*>* constarints = [DILayoutParser constraints:value toAttribute:key forView:self.view];
		[self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.view.superview addConstraints:constarints];
	}
}
@end
