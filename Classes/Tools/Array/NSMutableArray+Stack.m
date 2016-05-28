//
//  NSArray+Stack.m
//  DIKit
//
//  Created by Back on 16/5/22.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "NSMutableArray+Stack.h"
#import "NSArray+Stack.h"

@implementation NSMutableArray (Stack)
-(id)pop
{
	id top = [self top];
	[self removeLastObject];
	return top;
}
-(void)push:(id)obj
{
	[self addObject:obj];
}

@end
