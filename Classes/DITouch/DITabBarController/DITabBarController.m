//
//  DITabBarController.m
//  Liangfeng
//
//  Created by Back on 16/6/18.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DITabBarController.h"
#import "UIImage+Resize.h"
@interface DITabBarController()
@end

@implementation DITabBarController
-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	CGFloat screenHeight=[UIScreen mainScreen].bounds.size.height;
	NSString* heightRateString = [self.tabBar valueForKey:@"heightRate"];
	CGFloat heightRate = [heightRateString doubleValue];
	if(heightRate>0)
	{
		CGFloat tabBarHeight = screenHeight * heightRate;
		
		CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
		tabFrame.size.height = tabBarHeight;
		tabFrame.origin.y = self.view.frame.size.height - tabBarHeight;
		self.tabBar.frame = tabFrame;
	}

	CGFloat fixedHeight = 30;//*[UIScreen mainScreen].scale;
		
	for (UITabBarItem* item in self.tabBar.items)
	{
		UIImage* barImage = item.image;
		UIImage* barSelectedImage = item.selectedImage;
		if(barImage!=nil)
		{
			item.image = [barImage resizedImageToFitInHeight:fixedHeight];
		}
		if(barSelectedImage!=nil)
		{
			item.selectedImage = [barSelectedImage resizedImageToFitInHeight:fixedHeight];
		}
	}
}

@end
