//
//  RouterXmlParser.h
//  DIKit
//
//  Created by Back on 16/5/19.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlatRouterMap.h"

@interface RouterXmlParserDelegate : NSObject<NSXMLParserDelegate>
-(void)fillToSettings:(FlatRouterMap*)flatSettings;
@end
