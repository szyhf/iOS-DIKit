//
//  DITableViewSection.m
//  DIKit
//
//  Created by Back on 16/6/22.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DITableViewSection.h"
@interface DITableViewSection()
@property (nonatomic, strong) NSMutableDictionary<NSString*,NSNumber*>* headerHeightCache;
@property (nonatomic, strong) NSMutableDictionary<NSString*,NSNumber*>* footerHeightCache;
@end

@implementation DITableViewSection
@synthesize headerView = _headerView;
-(void)setHeaderView:(UIView *)headerView
{
	_headerView = headerView;
}

-(CGFloat)heightForHeaderViewByTableView:(DITableView*)tableView
{
	//check cache
	NSNumber* heightNumber = self.headerHeightCache[[NSString stringWithFormat:@"%ld",tableView.hash]];
	if(heightNumber)
	{
		return heightNumber.floatValue;
	}
	
	CGFloat height = 0;
	if(self.headerView)
	{
		CGSize fittingSize = [tableView contentViewFittingSize:self.headerView];
		height = fittingSize.height;
	}
	
	//set cache
	self.headerHeightCache[[NSString stringWithFormat:@"%ld",tableView.hash]] = [NSNumber numberWithFloat:height];
	return height;
}

-(CGFloat)heightForFooterViewByTableView:(DITableView*)tableView
{
	//check cache
	NSNumber* heightNumber = self.footerHeightCache[[NSString stringWithFormat:@"%ld",tableView.hash]];
	if(heightNumber)
	{
		return heightNumber.floatValue;
	}
	
	CGFloat height = 0.0001;//返回0不能正确的不显示footer
	if(self.footerView)
	{
		CGSize fittingSize = [tableView contentViewFittingSize:self.footerView];
		return fittingSize.height;
	}
	
	//set cache
	self.footerHeightCache[[NSString stringWithFormat:@"%ld",tableView.hash]] = [NSNumber numberWithFloat:height];
	return height;
}
- (NSMutableDictionary<NSString*,NSNumber*> *)headerHeightCache {
	if(_headerHeightCache == nil) {
		_headerHeightCache = [[NSMutableDictionary<NSString*,NSNumber*> alloc] init];
	}
	return _headerHeightCache;
}

- (NSMutableDictionary<NSString*,NSNumber*> *)footerHeightCache {
	if(_footerHeightCache == nil) {
		_footerHeightCache = [[NSMutableDictionary<NSString*,NSNumber*> alloc] init];
	}
	return _footerHeightCache;
}

@end
