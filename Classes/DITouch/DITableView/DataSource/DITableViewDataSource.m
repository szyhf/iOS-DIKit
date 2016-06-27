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

-(NSInteger)numberOfSectionsInTableView:(DITableView *)tableView
{
	NSArray* sections = tableView.sections;
	if(sections)
		return sections.count;
	return 1;
}

-(NSInteger)tableView:(DITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//快速设置一些可能本身并不需要真实数据源或者可变数据源的情况
	if(self.maxRowCount)
		return self.maxRowCount.integerValue;
	
	//检查section是否存在代理数据源
	DITableViewSection* diSection = [tableView objectInSectionsAtIndex:section];

	//防止递归调用，仅对子类有效
	//if(![diSection.dataSource isMemberOfClass:self.class])
	{
		return [diSection.dataSource tableView:tableView numberOfRowsInSection:section];
	}
	
	return 2;//默认返回两行看效果=。=
}

- (UITableViewCell *)tableView:(DITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//检查section是否存在代理数据源
	DITableViewSection* section = [tableView objectInSectionsAtIndex:indexPath.section];
	if(section.dataSource.cellTemplates.count>0)
	{
		//防止递归调用，仅对子类有效
		if(![section.dataSource isMemberOfClass:self.class])
		{
			return [section.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
		}
		//临时处理为section的第一类cell
		return [tableView dequeueReusableCellWithIdentifier:section.dataSource.cellTemplates.firstObject.name forIndexPath:indexPath];
	}
	//返回默认值
	return [tableView dequeueDefaultCell];
}

#pragma mark - property
- (NSMutableArray<DITemplateNode*> *)cellTemplates {
	if(_cellTemplates == nil) {
		_cellTemplates = [[NSMutableArray<DITemplateNode*> alloc] init];
	}
	return _cellTemplates;
}
@end
