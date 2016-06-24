//
//  DINode+Assume.m
//  DIKit
//
//  Created by Back on 16/6/4.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DINode.h"

@implementation DINode (Assume)

/**
 *  推断用的后缀
 */
+(NSDictionary<NSString*,Class>*)assumeMap
{
	static NSDictionary<NSString*,Class>* _assumeMap;
	if(_assumeMap==nil)
		_assumeMap=@{
					 //Controller结尾中，
					 @"NavigationController":UINavigationController.class,
					 @"TabBarController":UITabBarController.class,
					 @"ViewController":UIViewController.class,
					 
					 @"TabBarItem":UITabBarItem.class,
					 @"BarButtonItem":UIBarButtonItem.class,
					 @"BarButton":UIBarButtonItem.class,
					 @"TableViewSection":NSClassFromString(@"DITableViewSection"),
					 
					 @"CollectionViewCell":UICollectionViewCell.class,
					 @"TableViewCell":UITableViewCell.class,
					 @"Label":UILabel.class,
					 @"Button":UIButton.class,
					 @"TextField":UITextField.class,
					 @"TabBar":UITabBar.class,
					 
					 //view结尾中，最原始的View要最后结尾。
					 @"CollectionView":NSClassFromString(@"DICollectionView"),
					 @"TableView":NSClassFromString(@"DITableView"),
					 @"ImageView":UIImageView.class,
					 @"View":UIView.class,
					 };
	return _assumeMap;
}

-(Class)asumeByName:(NSString*)elementName
{
	for (NSString* suffix in [self.class assumeMap])
	{
		if([elementName hasSuffix:suffix])
		{
			return [self.class assumeMap][suffix];
		}
	}
	return nil;
}

@end
