//
//  DIDataSource.h
//  Pods
//
//  Created by Back on 16/6/12.
//
//

#import <UIKit/UIKit.h>
#import "DITemplateNode.h"

@interface DITableViewDataSource : NSObject<UITableViewDataSource>
/**
 *  在数据源有足够数据的情况下最多显示多少行
 */
@property (nonatomic, strong) NSNumber* maxRowCount;
@property (nonatomic, strong) NSMutableArray<DITemplateNode*>* cellTemplates;
@property (nonatomic, strong) NSArray<DIViewModel*>* cellsViewModel;
@end
