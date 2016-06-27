//
//  DITableViewDelegate.m
//  Pods
//
//  Created by Back on 16/6/12.
//
//

#import "DITableViewDelegate.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "DITableView.h"
#import "DITableViewSection.h"
@interface DITableViewDelegate()
@property (nonatomic, strong) NSMutableDictionary<NSString*,NSNumber*> *sectionHeaderHeightCache;
@property (nonatomic, strong) NSMutableDictionary<NSString*,NSNumber*> *sectionFooterHeightCache;
@end

@implementation DITableViewDelegate
- (instancetype)init
{
	self = [super init];
	if (self)
	{
	}
	return self;
}
//每行高度
-(CGFloat)tableView:(DITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView dequeueDefaultCell];
	return [tableView fd_heightForCellWithIdentifier:cell.reuseIdentifier
									cacheByIndexPath:indexPath
									   configuration:nil
		 ];
}

//选中某行
-		(void)tableView:(DITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//某个section.header的高度
- 	  (CGFloat)tableView:(DITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
	//check cache
	NSNumber* heightNumber = self.sectionHeaderHeightCache[[NSString stringWithFormat:@"%ld",section]];
	if(heightNumber)
	{
		return heightNumber.floatValue;
	}
		
	DITableViewSection* diSection = [tableView objectInSectionsAtIndex:section];
	if(diSection.headerView)
	{
		CGSize fittingSize = [tableView contentViewFittingSize:diSection.headerView];
		self.sectionHeaderHeightCache[[NSString stringWithFormat:@"%ld",section]] = [NSNumber numberWithFloat:fittingSize.height];
		return fittingSize.height;
	}
	return 0;
}

//section.headerView
- (nullable UIView *)tableView:(DITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	DITableViewSection* diSection = [tableView objectInSectionsAtIndex:section];
	if(diSection)
		return diSection.headerView;
	return nil;
}

//某个section的footer的高度
-(CGFloat)tableView:(DITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	DITableViewSection* diSection = [tableView objectInSectionsAtIndex:section];
	if(diSection.footerView)
	{
		CGSize fittingSize = [tableView contentViewFittingSize:diSection.footerView];
		self.sectionFooterHeightCache[[NSString stringWithFormat:@"%ld",section]] = [NSNumber numberWithFloat:fittingSize.height];
		if(fittingSize.height<0.01 && fittingSize.height >= 0)
			return 0.001;//返回0的话会被设置为一个非零的高度			
		return fittingSize.height;
	}
	return 0.001;//返回0的话会被设置为一个非零的高度
}

- (NSMutableDictionary<NSString*,NSNumber*> *)sectionHeaderHeightCache
{
	if(_sectionHeaderHeightCache == nil) {
		_sectionHeaderHeightCache = [[NSMutableDictionary<NSString*,NSNumber*> alloc] init];
	}
	return _sectionHeaderHeightCache;
}
- (NSMutableDictionary<NSString*,NSNumber*> *)sectionFooterHeightCache {
	if(_sectionFooterHeightCache == nil) {
		_sectionFooterHeightCache = [[NSMutableDictionary<NSString*,NSNumber*> alloc] init];
	}
	return _sectionFooterHeightCache;
}

@end
