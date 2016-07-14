//
//  DIArrayProxyModel.h
//  Liangfeng
//
//  Created by Back on 16/7/12.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <DIKit/DIKit.h>
#import "DIModel.h"
//proxy model是一个伪数据原型，其本质是一组定义好筛选条件的筛选器
//使用时先绑定指定的数据源
//配置与筛选条件相关的属性
//当与筛选条件相关的属性发生更新时，则提示所有数据都发生了更新（因为映射的数据元素发生了改变）
//但与筛选条件无关的属性发生写入时，则将写入的结果更新到数据集合，数据集合通知其他的代理可能发生了更新。
@interface DIArrayProxyModel : DIModel
/**
 *  定义主键或者唯一索引的键的集合（支持符合主键\唯一索引）
 *
 *  @return 定义的主键或者唯一索引的集合（默认为ID）
 */
+(NSArray<NSString*>*)primaryKeys;
/**
 *  当前代理实际映射的集合类型
 *
 *  @return 集合类型
 */
+(Class)collectionClass;
@end
