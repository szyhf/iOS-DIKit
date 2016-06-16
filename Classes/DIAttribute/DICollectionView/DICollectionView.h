//
//  DICollectionView.h
//  DIKit
//
//  Created by Back on 16/6/13.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DITemplateNode.h"

@interface DICollectionView : UICollectionView
-(void)registerCellNode:(DITemplateNode*)templateNode;
-(UICollectionViewCell*)dequeueDefaultCellForIndexPath:(NSIndexPath*)indexPath;
@end
