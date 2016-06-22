//
//  DICollectionViewDataSource.m
//  DIKit
//
//  Created by Back on 16/6/13.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DICollectionViewDataSource.h"

@implementation DICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
	 numberOfItemsInSection:(NSInteger)section
{
	return 50;
}

- (UICollectionViewCell *)collectionView:(DICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return [collectionView dequeueDefaultCellForIndexPath:indexPath];
}
@end
