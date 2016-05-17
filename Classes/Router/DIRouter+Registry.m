//
//  Router+Registry.m
//  Fakeshion
//
//  Created by Back on 16/5/3.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRouter+Registry.h"

@implementation DIRouter (Registry)
-(NSArray*)Registry
{
	return @[
			 @"RootDrawerViewController",
			 
			 @"MainTabBarController",
			 @"SiftViewController",
			 
			 @"ChosenNavigationController",
			 @"ChosenViewController",
			 @"ChosenSiftTableViewController",
			 
			 @"CircleNavigationController",
			 @"CircleViewController",
			 
			 @"MeNavigationController",
			 @"MeViewController",
			 
			 @"ItemNavigationController",
			 @"ItemViewController",
			 ];
}
@end
