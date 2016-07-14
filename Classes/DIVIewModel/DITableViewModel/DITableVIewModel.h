//
//  DITableVIewModel.h
//  DIKit
//
//  Created by Back on 16/6/30.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIViewModel.h"
/**
 *  需要与合适的单元格VM配套使用
 */
@interface DITableViewModel : DIViewModel
/**
 *  单元格的VM的类型名
 *
 *  @return 单元格的类型名
 */
+(Class)cellViewModelClass;
/**
 *  该表格唯一性的DIArrayModel类型的集合
 *
 *  @return 
 */
+(Class)tableModelWatchClass;
@end
