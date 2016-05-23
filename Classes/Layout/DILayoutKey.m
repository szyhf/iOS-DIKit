//
//  DILayoutKey.m
//  Pods
//
//  Created by Back on 16/5/23.
//
//

#import "DILayoutKey.h"
@interface DILayoutKey()

@end

@implementation DILayoutKey
+(NSDictionary<NSString*,NSNumber*>*)layoutAttribute
{
	static dispatch_once_t layoutAttribute_token;
	static NSDictionary<NSString*,NSNumber*>* _layoutAttribute;
	dispatch_once(&layoutAttribute_token, ^{
		_layoutAttribute =@{
							@"height":[NSNumber numberWithInteger:NSLayoutAttributeHeight],
							@"width":[NSNumber numberWithInteger:NSLayoutAttributeWidth],
							
							@"top":[NSNumber numberWithInteger:NSLayoutAttributeTop],
							@"bottom":[NSNumber numberWithInteger:NSLayoutAttributeBottom],
							@"left":[NSNumber numberWithInteger:NSLayoutAttributeLeft],
							@"right":[NSNumber numberWithInteger:NSLayoutAttributeRight],
							
							@"centerx":[NSNumber numberWithInteger:NSLayoutAttributeCenterX],
							@"centery":[NSNumber numberWithInteger:NSLayoutAttributeCenterY],
							
							@"leading":[NSNumber numberWithInteger:NSLayoutAttributeLeading],
							@"trailing":[NSNumber numberWithInteger:NSLayoutAttributeTrailing],
							
							@"not":[NSNumber numberWithInteger:NSLayoutAttributeNotAnAttribute],
							};
	});
	return _layoutAttribute;
}
+(NSLayoutAttribute)layoutAttributeOf:(NSString*)attrName
{
	attrName = [attrName lowercaseString];
	return (NSLayoutAttribute)[self layoutAttribute][attrName].integerValue;
}
+(BOOL)isLayoutAttribute:(NSString*)attributeName
{
	return [self layoutAttribute][attributeName]!=nil;
}
@end
