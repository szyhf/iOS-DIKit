//
//  DIArrayModel.h
//  Pods
//
//  Created by Back on 16/6/30.
//
//

#import <DIKit/DIKit.h>
/**
 *  快速处理数组型表格数据
 */
@interface DIArrayModel: DIModel
/**
 *  定义数组的元素类型
 *
 *  @return 数组元素类型
 */
+(Class)cellModelClass;

/**
 *  定义数组内嵌的集合属性的属性名（默认为diCollection）
 *
 *  @return 属性名
 */
+(NSString*)collectionProperty;

-(NSArray*)array;
@end
