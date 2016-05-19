//
//  DIRouter+Xml.h
//  DIKit
//
//  Created by Back on 16/5/19.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRouter.h"

@interface DIRouter (Xml)
+(void)realizeXml:(NSString*)xmlString;
+(void)realizeXmlFile:(NSString*)xmlFilePath;

@end
