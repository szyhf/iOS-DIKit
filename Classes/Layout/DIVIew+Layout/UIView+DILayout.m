//
//  NSUIView+layout.m
//  DIKit
//
//  Created by Back on 16/5/22.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "UIView+DILayout.h"
#import "DILayoutParser.h"
#import "DILayoutKey.h"
#import "DITools.h"

@implementation UIView (layout)
-(void)setValue:(id)value
forUndefinedKey:(NSString *)key
{
	if([DILayoutKey isLayoutAttribute:key]
	   && [value isKindOfClass:NSString.class])
	{
		NSArray<NSLayoutConstraint*>* constarints = [DILayoutParser constraints:value toAttribute:key forView:self];
		[self setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.superview addConstraints:constarints];
	}
}
@end
