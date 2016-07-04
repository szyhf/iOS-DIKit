//
//  DITableView.m
//  DIKit
//
//  Created by Back on 16/6/12.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DITableView.h"
#import "DIContainer.h"
#import "DITableViewDelegate.h"
#import "DITableViewDataSource.h"
#import "DIObject.h"
@interface DITableView()
{
	NSMutableArray<DITableViewSection*>* _sections ;
}
@property (nonatomic, strong) NSMutableDictionary<NSString*,DITemplateNode*>* identifierNodeMap;
@property (nonatomic, strong) NSMutableSet<UITableViewCell*>* packedCells;
@property (nonatomic, strong) DITableViewDelegate* tableDelegate;
@property (nonatomic, strong) DITableViewDataSource* tableDataSource;
@end

@implementation DITableView
+(void)load
{
	[self exchangeInstanceSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:) toSelector:@selector(di_dequeueReusableCellWithIdentifier:forIndexPath:)];
}
- (instancetype)init
{
	self = [super init];
	//self = [super initWithFrame:CGRectZero style:UITableViewStyleGrouped];

	if (self)
	{
		[self setEstimatedRowHeight:128];//设一个默认高度
		_sections = [[NSMutableArray<DITableViewSection*> alloc] init];
		//self.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.00001)];//grouped的风格下，会有一个脑残留白。
		//self.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.00001)];
	}
	return self;
}

-(void)didMoveToSuperview
{
	[super didMoveToSuperview];
	//没有的话默认提供一个基础的
	//还支持DI系列功能嘿嘿
	//delegate必须有strong的持有，所以lazy加载一个
	if(!self.sections.count)
	{
		if(!self.delegate)
			self.delegate = self.tableDelegate;
		if(!self.dataSource)
			self.dataSource = self.tableDataSource;
		
	}else
	{
		if(!self.delegate)
			self.delegate = self;
		if(!self.dataSource)
			self.dataSource = self;
	}
}

-(void)registerCellNode:(DITemplateNode*)templateNode
{
	if(!self.identifierNodeMap[templateNode.name])
	{
		self.identifierNodeMap[templateNode.name]=templateNode;
		[self registerClass:templateNode.clazz forCellReuseIdentifier:templateNode.name];
	}
}

-(UITableViewCell*)dequeueDefaultCellForIndexPath:(nonnull NSIndexPath *)indexPath
{
	return [self dequeueReusableCellWithIdentifier:self.identifierNodeMap.allKeys.lastObject forIndexPath:indexPath];
}

-(UITableViewCell*)di_dequeueReusableCellWithIdentifier:(NSString*)identifier
										forIndexPath:(nonnull NSIndexPath *)indexPath
{
	UITableViewCell* cell = [self di_dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
	if(![self.packedCells containsObject:cell])
	{
		__weak id weak_cell = cell;
		[self.packedCells addObject:weak_cell];
		[self.identifierNodeMap[identifier] packInstance:cell];
	}
	return cell;
}

-(UITableViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier
										   forIndexPath:(nonnull NSIndexPath *)indexPath
{
	UITableViewCell* cell = [super dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
	return cell;
}

-(UITableViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier
{
	UITableViewCell* cell = [super dequeueReusableCellWithIdentifier:identifier];
	if(![self.packedCells containsObject:cell])
	{
		__weak id weak_cell = cell;
		[self.packedCells addObject:weak_cell];
		[self.identifierNodeMap[identifier] packInstance:cell];
	}
	return cell;
}

#pragma mark - property
//预处理高度
-(void)setTableHeaderView:(UIView *)tableHeaderView
{
	CGSize size = [self contentViewFittingSize:tableHeaderView];
	[tableHeaderView setFrame:CGRectMake(0, 0, size.width, size.height)];
	[super setTableHeaderView:tableHeaderView];
}

-(void)setTableFooterView:(UIView *)tableFooterView
{
	CGSize size = [self contentViewFittingSize:tableFooterView];
	[tableFooterView setFrame:CGRectMake(0, 0, size.width, size.height)];
	[super setTableFooterView:tableFooterView];

}

-(DITableViewSection*)objectInSectionsAtIndex:(NSUInteger)index
{
	if(self.sections)
		if(index<self.sections.count)
			return self.sections[index];
	return nil;
}

- (NSMutableDictionary *)identifierNodeMap {
	if(_identifierNodeMap == nil) {
		_identifierNodeMap = [[NSMutableDictionary alloc] init];
	}
	return _identifierNodeMap;
}

- (DITableViewDelegate *)tableDelegate {
	if(_tableDelegate == nil) {
		_tableDelegate = [[DITableViewDelegate alloc] init];
	}
	return _tableDelegate;
}

-(void)setDataSource:(id<UITableViewDataSource>)dataSource
{
	[super setDataSource:dataSource];
	if([dataSource isKindOfClass:DITableViewDataSource.class])
	{
		DITableViewDataSource* source = dataSource;
		if(source.cellTemplates)
		{
			for (DITemplateNode* templateNode in source.cellTemplates)
			{
				[self registerCellNode:templateNode];
			}
		}
	}
}

- (DITableViewDataSource *)tableDataSource {
	if(_tableDataSource == nil) {
		_tableDataSource = [[DITableViewDataSource alloc] init];
	}
	return _tableDataSource;
}

- (NSMutableSet<UITableViewCell*> *)packedCells {
	if(_packedCells == nil) {
		_packedCells = [[NSMutableSet<UITableViewCell*> alloc] init];
	}
	return _packedCells;
}

@synthesize sections = _sections;
-(void)addSectionsObject:(DITableViewSection *)section
{
	if(section.dataSource)
	{
		if(section.dataSource.cellTemplates)
		{
			for (DITemplateNode* templateNode in section.dataSource.cellTemplates)
			{
				[self registerCellNode:templateNode];
			}
		}
	}
	[_sections addObject:section];
}

-(void)addSections:(NSSet<DITableViewSection*> *)objects
{
	for (DITableViewSection* section in objects)
	{
		[self addSectionsObject:section];
	}
}
@end
