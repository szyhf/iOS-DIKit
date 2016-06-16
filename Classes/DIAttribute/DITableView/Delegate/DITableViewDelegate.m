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

@implementation DITableViewDelegate
-(CGFloat)tableView:(DITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView dequeueDefaultCell];
	return [tableView fd_heightForCellWithIdentifier:cell.reuseIdentifier
									cacheByIndexPath:indexPath
									   configuration:nil
		 ];
}

-		(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
