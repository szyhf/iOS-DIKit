//
//  DICommand.h
//  DIKit
//
//  Created by Back on 16/7/14.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 以字符串的形式描述对指定的对象（容器中唯一）的指定方法发出一次调用请求的封装
 */
@interface DICommand : NSObject
-(instancetype)initWithString:(NSString*)commandString;
-(id)call;
@end
