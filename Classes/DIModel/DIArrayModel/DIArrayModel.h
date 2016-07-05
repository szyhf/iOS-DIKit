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
+(Class)cellModelClass;
+(NSString*)collectionProperty;
@end
