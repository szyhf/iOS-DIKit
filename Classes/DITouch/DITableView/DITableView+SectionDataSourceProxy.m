//
//  DITableView+SectionDataSourceProxy.m
//  DIKit
//
//  Created by Back on 16/6/28.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DITableView.h"
//使用DataSourceProxy的先决条件是存在Section。
@implementation DITableView (SectionDataSourceProxy)
-(NSInteger)numberOfSectionsInTableView:(DITableView *)tableView
{
	NSArray* sections = tableView.sections;
	if(sections)
		return sections.count;
	return 1;
}

-(NSInteger)tableView:(DITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
	//检查section是否存在代理数据源
	DITableViewSection* diSection = [tableView objectInSectionsAtIndex:section];
	
	if([diSection.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)])
		return [diSection.dataSource tableView:tableView numberOfRowsInSection:section];
	
	return 0;
}

- (UITableViewCell *)tableView:(DITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//检查section是否存在代理数据源
	DITableViewSection* diSection = [tableView objectInSectionsAtIndex:indexPath.section];
	
	if([diSection.dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)])
	{
		return [diSection.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
	}
		
	//返回默认值
	return [tableView dequeueDefaultCellForIndexPath:indexPath];
}
@end
