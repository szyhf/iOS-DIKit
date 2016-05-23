//
//  NSString+RegularExpression.m
//  DIKit
//
//  Created by Back on 16/5/22.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "NSString+RegularExpression.h"

@implementation NSString (RegularExpression)
-(BOOL)isMatchRegular:(NSString*)regularExpression
{
	NSPredicate* predicate ;
	if (predicate==nil)
	{
		predicate =
		[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regularExpression];
	}
	return [predicate evaluateWithObject:self];
}
@end
