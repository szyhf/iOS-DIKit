//
//  DIRouterSettings.h
//  DIKit
//
//  Created by Back on 16/5/20.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  扁平化的路由存储（要求每个节点有唯一名称）
 */
@interface FlatRouterMap : NSObject
-(void)addChild:(NSString*)child
		 toNode:(NSString*)node;

-(void)removeChild:(NSString*)child
			ofNode:(NSString*)node;

-(void)removeNode:(NSString*)node;

-(NSArray<NSString*>*)childrenOfNode:(NSString*)node;

-(void)addAttributes:(NSDictionary<NSString *, NSString *> *)attributes
			  toNode:(NSString*)node;

-(void)removeAttributesOfNode:(NSString*)node;

-(NSDictionary<NSString *, NSString *> *)attributesOfNode:(NSString*)node;


@end
