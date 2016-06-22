//
//  DICollectionView.m
//  DIKit
//
//  Created by Back on 16/6/13.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DICollectionView.h"
#import "DIContainer.h"
#import "DICollectionViewDelegate.h"
#import "DICollectionViewDataSource.h"
@interface DICollectionView()
@property (nonatomic, strong) NSMutableDictionary<NSString*,DITemplateNode*>* identifierNodeMap;
@property (nonatomic, strong) NSMutableSet<UICollectionViewCell*>* packedCells;
@end

@implementation DICollectionView
+(void)load
{
	[DIContainer bindClass:self withBlock:^id(DICollectionView* alloced)
	{
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
		return [alloced initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
	}];
}
	 
-(void)registerCellNode:(DITemplateNode *)templateNode
{
	self.identifierNodeMap[templateNode.name] = templateNode;
	[self registerClass:templateNode.clazz forCellWithReuseIdentifier:templateNode.name];
}

-(UICollectionViewCell*)dequeueDefaultCellForIndexPath:(NSIndexPath*)indexPath
{
	return [self dequeueReusableCellWithReuseIdentifier:self.identifierNodeMap.allKeys.firstObject forIndexPath:indexPath];
}

-(UICollectionViewCell*)dequeueReusableCellWithReuseIdentifier:(NSString*)identifier
												  forIndexPath:(NSIndexPath*)indexPath
{
	UICollectionViewCell* cell = [super dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
	if(![self.packedCells containsObject:cell])
	{
		__weak id weak_cell = cell;
		[self.packedCells addObject:weak_cell];
		[self.identifierNodeMap[identifier] packInstance:cell];
	}
	return cell;

}

- (NSMutableSet<UICollectionViewCell*> *)packedCells {
	if(_packedCells == nil) {
		_packedCells = [[NSMutableSet<UICollectionViewCell*> alloc] init];
	}
	return _packedCells;
}

- (NSMutableDictionary<NSString*,DITemplateNode*> *)identifierNodeMap {
	if(_identifierNodeMap == nil) {
		_identifierNodeMap = [[NSMutableDictionary<NSString*,DITemplateNode*> alloc] init];
	}
	return _identifierNodeMap;
}

@end
