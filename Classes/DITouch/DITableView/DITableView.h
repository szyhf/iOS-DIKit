//
//  DITableView.h
//  DIKit
//
//  Created by Back on 16/6/12.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DITemplateNode.h"

@interface DITableView : UITableView
-(void)registerCellNode:(DITemplateNode*)templateNode;
-(UITableViewCell*)dequeueDefaultCell;


//配置section命令
@property (nonatomic, strong) id di_section;
@end
