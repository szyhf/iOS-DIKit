//
//  DIModel.h
//  DIKit
//
//  Created by Back on 16/6/21.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DIModel : NSObject
@end

@interface DIModel(Watch)
/**
 *  当前模型监控的所有模型的列表
 */
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString*,NSObject*>*watchMap;

-(void)startWatching;
-(void)watchModel:(NSObject*)model named:(NSString*)modelName;
-(void)watchModel:(NSObject*)model;
-(void)watchModelClass:(Class)modelClass;

/**
 *  当前模型的默认绑定列表
 *
 *  @return
 */
+(NSDictionary<NSString*,NSString*>*)bindingMap;

/**
 *  要监控的非全局唯一Model注册表
 *
 *  @return 非全局唯一Model数组
 */
+(NSArray*)commonModelWatchClass;
/**
 *  要监控的非全局唯一Model注册表
 *
 *  @return 非全局唯一Model数组
 */
+(NSArray*)uniqueModelWatchClass;
@end