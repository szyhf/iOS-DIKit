//
//  NSString+Json.m
//  Pods
//
//  Created by Back on 16/5/17.
//
//

#import "NSString+Json.h"

@implementation NSString (Json)
-(NSDictionary*)jsonDictionary
{
	NSData* jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
	return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
}
@end
