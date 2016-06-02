//
//  DIRouter+Xml.h
//  DIKit
//
//  Created by Back on 16/5/19.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRouter.h"

@interface DIRouter (Xml)
+(void)registryXmlDirectory:(NSString*)directory;
+(void)registryRealizeXml:(NSString*)xmlString;
+(void)remakeRealizeXml:(NSString*)xmlString;
+(id)realizeNode:(DINode*)parent;
@end