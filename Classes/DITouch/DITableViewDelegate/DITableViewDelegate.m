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

@implementation DITableViewDelegate
//每行高度
-(CGFloat)tableView:(DITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DITableViewSection* diSection = [tableView objectInSectionsAtIndex:indexPath.section];
	NSString* reuseIdentifier = diSection.dataSource.cellTemplates.firstObject.name;
	return [tableView fd_heightForCellWithIdentifier:reuseIdentifier
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
	DITableViewSection* diSection = [tableView objectInSectionsAtIndex:section];
	if(diSection)
		return [diSection heightForHeaderViewByTableView:tableView];
	return 0.001;
}

//section.headerView
- (nullable UIView *)tableView:(DITableView *)tableView
		viewForHeaderInSection:(NSInteger)section
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
	if(diSection)
		return [diSection heightForFooterViewByTableView:tableView];
	return 0.001;//返回0的话会被设置为一个非零的高度
}

-(UIView*)tableView:(DITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	DITableViewSection* diSection = [tableView objectInSectionsAtIndex:section];
	if(diSection)
		return diSection.footerView;
	return nil;
}
@end
