//
//  DINavigationControllerDelegate.m
//  DIKit
//
//  Created by Back on 16/6/14.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DINavigationControllerDelegate.h"

@implementation DINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
	   didShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated
{
	NSNumber* hiddenValue = [[navigationController visibleViewController]valueForKey:@"navigationBarHidden"];
	if(hiddenValue.boolValue)
	{
		[navigationController setNavigationBarHidden:hiddenValue.boolValue animated:YES];
	}
}
@end
