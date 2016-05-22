//
//  NSArray+Queue.m
//  DIKit
//
//  Created by Back on 16/5/22.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "NSArray+Queue.h"

@implementation NSArray (Queue)
-(id)head
{
	return [self firstObject];
}
-(id)firstObject
{
	if(self.count>0)
		return [self objectAtIndex:0];
	else
		return nil;
}
@end
