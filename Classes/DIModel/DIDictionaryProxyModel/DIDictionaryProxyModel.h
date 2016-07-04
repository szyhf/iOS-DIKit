//
//  DICollectionModel.h
//  Liangfeng
//
//  Created by Back on 16/6/29.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <DIKit/DIKit.h>
/**
 *  快速实现一个如下结构的集合对象的监视代理
 *  @interface XXModels
 *  @property (nonatomic, strong) NSDictionary<NSString*,XXModel*>* xxModels;
 *  @end
 *  字典的键值即该Model的唯一索引或者主键，可以唯一查找该Model。
 *  该结构主要用于解决关联式的模型组合
 */
@interface DIDictionaryProxyModel : DIModel
+(NSString*)primaryKey;
+(NSString*)collectionProperty;
+(Class)collectionClass;
@end
