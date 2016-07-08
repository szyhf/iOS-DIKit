//
//  DIModel.h
//  DIKit
//
//  Created by Back on 16/6/21.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DIModel : NSObject
/**
 *  要监控的非全局唯一Model注册表
 *
 *  @return 非全局唯一Model数组
 */
+(NSArray*)commonModelWatchClasses;

/**
 *  要监控的全局唯一Model注册表
 *
 *  @return 全局唯一Model数组
 */
+(NSArray*)uniqueModelWatchClass;
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
 *  依赖键映射表
 *
 *  @return [@"key1WillAffected"=>@[@"keyAffecting1",@"keyAffecting2",...],@"key2WillAffected"=>...]
 */
+(NSDictionary*)affectingMap;

-(void)willObserveKeyPath:(NSString*)keyPath
			toKeyPath:(NSString*)targetKeyPath;

-(void)onObserveNew:(id)newValue
		 forKeyPath:(NSString*)keyPath
		  toKeyPath:(NSString*)targetKeyPath;

@end