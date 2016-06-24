//
//  NSMutableArray+Queue.m
//  DIKit
//
//  Created by Back on 16/5/22.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "NSMutableArray+Queue.h"

@implementation NSMutableArray (Queue)
-(id)dequeue
{
	id firstObject = self[0];
	[self removeFirstObject];
	return firstObject;
}
-(void)removeFirstObject
{
	return [self removeObjectAtIndex:0];
}

-(void)enqueue:(id)object
{
	[self addObject:object];
}
@end
