//
//  DITree.h
//  DIKit
//
//  Created by Back on 16/5/26.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DINode.h"

@interface DITree : NSObject
@property (nonatomic, readonly) DINode* root;
+(instancetype)instance;
-(void)clear;
-(void)newWithXML:(NSString*)xmlString;
-(void)updateWithXML:(NSString*)xmlString;
-(void)remakeWithXML:(NSString*)xmlString;
@property (nonatomic, strong) NSMutableDictionary<NSString*,DINode*>* pathToNode;
@property (nonatomic, strong) NSMutableDictionary<NSString*,DINode*>* nameToNode;
@property (nonatomic, strong) NSMutableDictionary<DINode*,NSString*>* nodeOfPath;
@end
