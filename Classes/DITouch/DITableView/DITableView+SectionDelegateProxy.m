//
//  DITableView+SectionDelegateProxy.m
//  DIKit
//
//  Created by Back on 16/6/28.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DITableView.h"
#import "UITableView+FDTemplateLayoutCell.h"
//使用DataSourceProxy的先决条件是存在Section。
@implementation DITableView (SectionDelegateProxy)
//每行高度
-(CGFloat)tableView:(DITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DITableViewSection* diSection = [tableView objectInSectionsAtIndex:indexPath.section];
	if([diSection.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
	{
		return [diSection.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
	}
	
	//没配置的话按默认生成。
	NSString* reuseIdentifier = diSection.dataSource.cellTemplates.firstObject.name;
	return [tableView fd_heightForCellWithIdentifier:reuseIdentifier cacheByIndexPath:indexPath
									   configuration:^(id cell) {
		
	}];
}

//选中某行
-		(void)tableView:(DITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	DITableViewSection* diSection = [tableView objectInSectionsAtIndex:indexPath.section];
	if([diSection.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
	{
		return [diSection.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
	
	//默认
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//section.headerView
- (nullable UIView *)tableView:(DITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	DITableViewSection* diSection = [tableView objectInSectionsAtIndex:section];
	if(diSection)
		return diSection.headerView;
	return nil;
}

//某个section.header的高度
- 	  (CGFloat)tableView:(DITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
	DITableViewSection* diSection = [tableView objectInSectionsAtIndex:section];
	if(diSection)
		return [diSection heightForHeaderViewByTableView:tableView];
	return 0;
}

-     (CGFloat)tableView:(DITableView *)tableView
heightForFooterInSection:(NSInteger)section
{
	DITableViewSection* diSection = [tableView objectInSectionsAtIndex:section];
	if(diSection)
		return [diSection heightForFooterViewByTableView:tableView];
	return 0.0001;
}

#pragma mark - cache
NSMutableDictionary<NSString*,NSNumber*> * _sectionHeaderHeightCache;
- (NSMutableDictionary<NSString*,NSNumber*> *)sectionHeaderHeightCache
{
	if(_sectionHeaderHeightCache == nil) {
		_sectionHeaderHeightCache = [[NSMutableDictionary<NSString*,NSNumber*> alloc] init];
	}
	return _sectionHeaderHeightCache;
}
NSMutableDictionary<NSString*,NSNumber*> * _sectionFooterHeightCache;
- (NSMutableDictionary<NSString*,NSNumber*> *)sectionFooterHeightCache {
	if(_sectionFooterHeightCache == nil) {
		_sectionFooterHeightCache = [[NSMutableDictionary<NSString*,NSNumber*> alloc] init];
	}
	return _sectionFooterHeightCache;
}

@end
