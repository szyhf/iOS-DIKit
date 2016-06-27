//
//  DITableView.h
//  DIKit
//
//  Created by Back on 16/6/12.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DITemplateNode.h"
#import "DITableViewSection.h"

@interface DITableView : UITableView
-(void)registerCellNode:(DITemplateNode*)templateNode;
-(UITableViewCell*)dequeueDefaultCell;

@property (nonatomic, strong,readonly) NSArray<DITableViewSection*>* sections;
-(DITableViewSection*)objectInSectionsAtIndex:(NSUInteger)index;
-(void)addSectionsObject:(DITableViewSection *)section;
-(void)addSections:(NSSet *)objects;
@end

@interface DITableView(Layout)
-(CGSize)contentViewFittingSize:(UIView*)contentView;

@end
