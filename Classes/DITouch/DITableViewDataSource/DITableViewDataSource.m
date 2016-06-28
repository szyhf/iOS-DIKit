//
//  DIDataSource.m
//  Pods
//
//  Created by Back on 16/6/12.
//
//

#import "DITableViewDataSource.h"
#import "DITableView.h"
#import "DITableViewSection.h"
#import "DITools.h"

@implementation DITableViewDataSource
-(NSInteger)tableView:(DITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
	//快速设置一些可能本身并不需要真实数据源或者可变数据源的情况
	if(self.maxRowCount)
		return self.maxRowCount.integerValue;
	
	return 2;//默认返回两行看效果=。=
}

- (UITableViewCell *)tableView:(DITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//临时处理为section的第一类cell
	DITableViewSection* diSection = [tableView objectInSectionsAtIndex:indexPath.section];
	return [tableView dequeueReusableCellWithIdentifier:diSection.dataSource.cellTemplates.firstObject.name forIndexPath:indexPath];
}

#pragma mark - property
- (NSMutableArray<DITemplateNode*> *)cellTemplates {
	if(_cellTemplates == nil) {
		_cellTemplates = [[NSMutableArray<DITemplateNode*> alloc] init];
	}
	return _cellTemplates;
}
@end
