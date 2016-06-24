//
//  DIConfig.h
//  Fakeshion
//
//  Created by Back on 16/5/5.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIConfig : UIViewController
-(bool)parseBool:(id)obj;
-(void)set:(id)value forKey:(NSString*)key;
+(NSString*(^)(NSString*))getNSString;
+(BOOL(^)(NSString*))getBool;
@end
