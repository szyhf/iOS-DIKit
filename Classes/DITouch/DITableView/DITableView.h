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

@class DITableViewSection;

@interface DITableView : UITableView

@property (nonatomic, strong,readonly) NSArray<DITableViewSection*>*_Nullable sections;

-(void)registerCellNode:(nonnull DITemplateNode*)templateNode;
-(nonnull UITableViewCell*)dequeueDefaultCellForIndexPath:(nonnull NSIndexPath*)indexPath;

-(nullable DITableViewSection*)objectInSectionsAtIndex:(NSUInteger)index;
-(void)addSectionsObject:(nonnull DITableViewSection *)section;
-(void)addSections:(nonnull NSSet *)objects;
@end

#pragma mark - category

@interface DITableView(Layout)
-(CGSize)contentViewFittingSize:(UIView*_Nullable)contentView;
@end

@interface DITableView (SectionDataSourceProxy)<UITableViewDataSource>
@end

@interface DITableView (SectionDelegateProxy)<UITableViewDelegate>
@end