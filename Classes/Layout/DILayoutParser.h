//
//  DILayoutParser.h
//  DIKit
//
//  Created by Back on 16/5/22.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DILayoutParser : NSObject
+(instancetype)instance;
-(void)parserFormula:(NSString*)layoutFormula;
-(NSLayoutConstraint*)constraint:(NSString*)layoutFormula
					 toAttribute:(NSString*)attribute
						 forView:(UIView*)view;
@end
