//
//  UIViewControllerObserver.m
//  Fakeshion
//
//  Created by Back on 16/5/3.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRouterParentViewObserver.h"
#import "DIRouter.h"
@implementation DIRouterParentViewObserver
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	[DIRouter autoPathRegister:object];
}
@end
