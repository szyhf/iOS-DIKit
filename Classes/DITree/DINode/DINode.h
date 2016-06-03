//
//  DINodes.h
//  DIKit
//
//  Created by Back on 16/5/26.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "DINodeLayoutConstraint.h"
#import "DINodeAwakeProtocol.h"
#import "DITools.h"
#import "NSObject+Runtimes.h"
#import "UndefinedKeyHandlerBlock.h"
#import "DILayoutParser.h"
#import "NUISettings.h"
#import "NSObject+DIAttribute.h"
@class DINodeLayoutConstraint;

@interface DINode : NSObject
-(instancetype)initWithElement:(NSString*)element
				  andNamespaceURI:(NSString *)namespaceURI
				 andAttributes:(NSDictionary<NSString*,NSString*>*)attributes;
-(void)addChild:(DINode*)child;
-(DINode*)childOfIndex:(NSInteger)index;

-(BOOL)isGlobal;

@property (nonatomic, weak) id implement;

@property (nonatomic, strong) Class clazz;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* className;
@property (nonatomic, strong) NSString* style;

@property (nonatomic, strong) DINode* parent;
@property (nonatomic, strong) NSArray<DINode*>* children;

@property (nonatomic, strong) NSMutableDictionary<NSString*,id>*attributes;
@property (nonatomic, strong) NSMutableArray<void(^)()>*delayBlocks;
@end

@interface DINode (Awake)<DINodeAwakeProtocol>
-(void)awake;
-(void)assemblyTo:(DINode*)parent;
@end
