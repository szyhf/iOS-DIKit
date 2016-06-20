//
//  DILayoutParserResult.h
//  DIKit
//
//  Created by Back on 16/5/31.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DILayoutParserResult : NSObject
+(instancetype)newParserResult;

@property (nonatomic, assign) BOOL isAbsolute;
@property (nonatomic, strong) NSString* oriAttribute;
@property (nonatomic, assign) NSLayoutRelation relation;
@property (nonatomic, strong) NSString* target;
@property (nonatomic, strong) NSString* targetAttribute;
@property (nonatomic, assign) CGFloat mutiply;
@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) CGFloat priority;
@end
