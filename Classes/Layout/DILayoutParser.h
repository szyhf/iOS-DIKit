//
//  DILayoutParser.h
//  DIKit
//
//  Created by Back on 16/5/22.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DINode.h"
#import "DILayoutParserResult.h"

#import "DILayoutKey.h"

@interface DILayoutParser : NSObject
+(NSArray<DILayoutParserResult*>*)parserResults:(NSString*)layoutFormula
			  attributeKey:(NSString*)attribute;
@end
