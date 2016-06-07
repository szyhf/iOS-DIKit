//
//  Router.h
//  Fakeshion
//
//  Created by Back on 16/4/29.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DITools.h"
#import "DITree.h"
@interface DIRouter : NSObject
+(DIRouter*)Instance;
/**
 *  根据输入的path组装已有的viewController
 *
 *  @param path 组装路径
 */
+(void)realizePath:(NSString*)path;
@end

@interface DIRouter (Xml)
+(void)registryXmlDirectory:(NSString*)directory;
+(void)registryRealizeXml:(NSString*)xmlString;
+(void)remakeRealizeXml:(NSString*)xmlString;
@end
