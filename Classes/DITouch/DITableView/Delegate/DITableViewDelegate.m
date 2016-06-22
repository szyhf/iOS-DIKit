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

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
	
//}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
	//// custom view for header. will be adjusted to default or specified header height
	//return [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 50)];
//}
@end
