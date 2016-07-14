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
@interface DITableViewDataSource()
@property (nonatomic, strong) NSMutableSet<UITableView*>* tableViews;
@property (nonatomic, strong) NSMutableDictionary<NSString*,DIViewModel*>* vmForReuse;
@end

@implementation DITableViewDataSource
-(NSInteger)tableView:(DITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
	self.tableView = tableView;
	//快速设置一些可能本身并不需要真实数据源或者可变数据源的情况
	if(self.maxRowCount)
		return self.maxRowCount.integerValue;
	else
		return _cellsViewModel.count;
}

- (UITableViewCell *)tableView:(DITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.tableView = tableView;
	//默认处理为section的第一类cell（有需要，请重载）
	DITableViewSection* diSection = [tableView objectInSectionsAtIndex:indexPath.section];
	UITableViewCell* cell;
	if(diSection)
		cell = [tableView dequeueReusableCellWithIdentifier:diSection.dataSource.cellTemplates.firstObject.name forIndexPath:indexPath];
	else
		cell = [tableView dequeueDefaultCellForIndexPath:indexPath];
	[cell prepareForReuse];
	//配置数据
	if(indexPath.row<_cellsViewModel.count)
	{
		DIViewModel* cellViewModel = self.cellsViewModel[indexPath.row];
		
		//因为cell会被重用，所以可能会出现同一个cell被多个cellVM重复关注的情况
		//所以要把cellVM的关注情况也处理起来。		
		__weak DIViewModel* weakCellVM = cellViewModel;
		DIViewModel* oldVM = self.vmForReuse[[cell description]];
		if(oldVM)
			[oldVM unwatchMdoelNamed:@"target"];
		self.vmForReuse[[cell description]] = weakCellVM;
		
		[cellViewModel setBindingInstance:cell];
	}
	
	[cell setNeedsLayout];
	[cell layoutIfNeeded];
	
	return cell;
}

#pragma mark - property
- (NSMutableArray<DITemplateNode*> *)cellTemplates {
	if(_cellTemplates == nil) {
		_cellTemplates = [[NSMutableArray<DITemplateNode*> alloc] init];
	}
	return _cellTemplates;
}

@synthesize cellsViewModel = _cellsViewModel;
-(void)setCellsViewModel:(NSArray*)viewModels
{
	_cellsViewModel = viewModels;
	for (UITableView* tableView in self.tableViews)
	{
		[tableView reloadData];
	}
}

/**
 *  其实是添加一个tableView。
 *
 *  @param tableView 可能调用的tableView引用
 */
-(void)setTableView:(UITableView *)tableView
{
	__weak UITableView * weakTable = tableView;
	[self.tableViews addObject:weakTable];
}

- (NSMutableSet<UITableView*> *)tableViews {
	if(_tableViews == nil) {
		_tableViews = [[NSMutableSet<UITableView*> alloc] init];
	}
	return _tableViews;
}
- (NSMutableDictionary<NSString*,DIViewModel*> *)vmForReuse {
	if(_vmForReuse == nil) {
		_vmForReuse = [[NSMutableDictionary<NSString*,DIViewModel*> alloc] init];
	}
	return _vmForReuse;
}

@end
