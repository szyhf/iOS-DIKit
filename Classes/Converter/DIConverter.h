//
//  DIConverter.h
//  DIKit
//
//  Created by Back on 16/5/24.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIConverter : NSObject
+(UIImage*)toImage:(NSString*)string;
+(UIColor*)toColor:(NSString*)string;

+(CGSize)toSize:(NSString*)string;
+(NSValue*)toSizeValue:(NSString*)string;

+(UIEdgeInsets)toEdgeInsets:(NSString*)string;
+(NSValue*)toEdgeInsetsValue:(NSString*)string;
@end
