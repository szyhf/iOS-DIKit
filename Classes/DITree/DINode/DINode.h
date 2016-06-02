//
//  DINodes.h
//  DIKit
//
//  Created by Back on 16/5/26.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DINodeLayoutConstraint.h"
@class DINodeLayoutConstraint;

@interface DINode : NSObject
-(instancetype)initWithElement:(NSString*)element
				  andNamespaceURI:(NSString *)namespaceURI
				 andAttributes:(NSDictionary<NSString*,NSString*>*)attributes;
-(void)addChild:(DINode*)child;
-(DINode*)childOfIndex:(NSInteger)index;
-(BOOL)isGlobal;
-(BOOL)isProperty;

@property (nonatomic, weak) NSObject* implement;

@property (nonatomic, strong) Class clazz;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* className;
@property (nonatomic, strong) NSString* style;
@property (nonatomic, strong) NSString* property;

@property (nonatomic, strong) DINode* parent;
@property (nonatomic, strong) NSArray<DINode*>* children;

@property (nonatomic, strong) NSMutableDictionary<NSString*,id>*attributes;
@property (nonatomic, strong) NSMutableDictionary<NSArray<DINodeLayoutConstraint*>*,NSString*>* constraints;

@end
