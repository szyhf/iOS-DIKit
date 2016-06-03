//
//  DINodeFactory.h
//  DIKit
//
//  Created by Back on 16/6/3.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DINode.h"

@interface DINodeFactory : NSObject
+(DINode*)newNodeWithElement:(NSString*)element
			 andNamespaceURI:(NSString *)namespaceURI
			   andAttributes:(NSDictionary<NSString*,NSString*>*)attributes;
@end