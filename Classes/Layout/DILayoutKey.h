//
//  DILayoutKey.h
//  Pods
//
//  Created by Back on 16/5/23.
//
//

#import <UIKit/UIKit.h>

@interface DILayoutKey : NSObject
+(NSLayoutAttribute)layoutAttributeOf:(NSString*)attributeName;
+(BOOL)isLayoutAttribute:(NSString*)attributeName;
@end
