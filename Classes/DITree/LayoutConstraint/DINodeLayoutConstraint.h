//
//  DINodeLayoutConstant.h
//  DIKit
//
//  Created by Back on 16/6/1.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DINode.h"
#import "DILayoutParserResult.h"
@class DINode;

@interface DINodeLayoutConstraint : NSObject
-(instancetype)initWithOriNode:(DINode*)node
				  parserResult:(DILayoutParserResult*)result;
-(void)realizeConstant;
@end
