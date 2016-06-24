//
//  DINodes.h
//  DIKit
//
//  Created by Back on 16/5/26.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DINodeLayoutConstraint.h"
#import "DINodeAwakeProtocol.h"
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
-(void)removeChild:(DINode*)child;
-(DINode*)childOfIndex:(NSInteger)index;

-(BOOL)isGlobal;
-(BOOL)isError;
-(NSException*)exception;

#if TARGET_OS_SIMULATOR
//严格来说应该是strong然后要递归清理，但真机调试的时候暂时不涉及重置，所以就无所谓了。
//先这样处理着
@property (nonatomic, weak) id implement;
#else
@property (nonatomic, strong) id implement;
#endif

@property (nonatomic, strong) Class clazz;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* className;
@property (nonatomic, strong) NSString* style;

@property (nonatomic, strong) DINode* parent;
@property (nonatomic, strong) NSArray<DINode*>* children;

@property (nonatomic, strong) NSMutableArray<void(^)()>*delayBlocks;
-(NSMutableDictionary<NSString*,id>*)attributes;
@end

@interface DINode (Awake)<DINodeAwakeProtocol>
-(void)awake;
-(void)packInstance:(id)instance;
-(void)assemblyTo:(DINode*)parentNode;
@end

@interface DINode (DIAttribute)
+(NSDictionary<NSString*,UndefinedKeyHandlerBlock>*)nodeBlocks;
-(void)setAttributes:(NSMutableDictionary<NSString *,NSString *> *)attributes;
@end