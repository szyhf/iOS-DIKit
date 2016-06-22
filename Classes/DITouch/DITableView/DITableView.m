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
@interface DITableView()
@property (nonatomic, strong) NSMutableDictionary<NSString*,DITemplateNode*>* identifierNodeMap;
@property (nonatomic, strong) NSMutableSet<UITableViewCell*>* packedCells;
@property (nonatomic, strong) DITableViewDelegate* tableDelegate;
@property (nonatomic, strong) DITableViewDataSource* tableDataSource;
@end

@implementation DITableView
- (instancetype)init
{
	self = [super init];
	if (self)
	{
		[self setEstimatedRowHeight:128];//设一个默认高度
	}
	return self;
}

-(void)registerCellNode:(DITemplateNode*)templateNode
{
	self.identifierNodeMap[templateNode.name]=templateNode;
	[self registerClass:templateNode.clazz forCellReuseIdentifier:templateNode.name];
}

-(UITableViewCell*)dequeueDefaultCell
{
	return [self dequeueReusableCellWithIdentifier:self.identifierNodeMap.allKeys.firstObject];
}

-(UITableViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier
										forIndexPath:(nonnull NSIndexPath *)indexPath
{
	return [self dequeueReusableCellWithIdentifier:identifier];
}

-(UITableViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier
{
	UITableViewCell* cell = [super dequeueReusableCellWithIdentifier:identifier];
	if(![self.packedCells containsObject:cell])
	{
		__weak id weak_cell = cell;
		[self.packedCells addObject:weak_cell];
		[self.identifierNodeMap.allValues.firstObject packInstance:cell];
	}
	return cell;
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

@end
