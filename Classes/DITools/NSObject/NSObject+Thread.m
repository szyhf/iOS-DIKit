//
//  NSObject+Thread.m
//  DIKit
//
//  Created by Back on 16/7/8.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "NSObject+Thread.h"

@implementation NSObject (Thread)
-(void)performBlockOnMainThread:(void(^)())aBlock
				  waitUntilDone:(BOOL)wait
{
	dispatch_queue_t mainQueue = dispatch_get_main_queue();
	if(wait)
	{
		//如果当前就是主线程会导致阻塞
		if([NSThread isMainThread])
			aBlock();
		else
			dispatch_sync(mainQueue, aBlock);
	}
	else
	{
		dispatch_async(mainQueue, aBlock);
	}
}
@end
