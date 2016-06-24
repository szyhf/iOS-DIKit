//
//  DITableViewSection.h
//  DIKit
//
//  Created by Back on 16/6/22.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DITableViewDataSource.h"
#import "DITableViewDelegate.h"

@interface DITableViewSection : NSObject
@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) UIView* footerView;
@property (nonatomic, weak) DITableViewDelegate* delegate;
@property (nonatomic, weak) DITableViewDataSource* dataSource;
@end
