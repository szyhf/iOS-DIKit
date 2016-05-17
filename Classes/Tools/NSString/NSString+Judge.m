//
//  NSString+Judge.m
//  Fakeshion
//
//  Created by Back on 16/5/4.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "NSString+Judge.h"

@implementation NSString (Judge)
+(bool)isNilOrEmpty:(NSString*)string
{
	if (string == nil)
	{
		return YES;
	}
	
	return [string isEmpty];
}

-(bool)isEmpty
{
	return [self isEqualToString:@""];
}
@end
