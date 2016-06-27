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
@property (nonatomic, strong) NSNumber* maxRowCount;
@property (nonatomic, strong) NSMutableArray<DITemplateNode*>* cellTemplates;


@end
