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
							//支持相对值、绝对值
							@"height":[NSNumber numberWithInteger:NSLayoutAttributeHeight],
							@"h":[NSNumber numberWithInteger:NSLayoutAttributeHeight],
							@"width":[NSNumber numberWithInteger:NSLayoutAttributeWidth],
							@"w":[NSNumber numberWithInteger:NSLayoutAttributeWidth],
							
							//支持相对值、相对绝对值
							@"centerX":[NSNumber numberWithInteger:NSLayoutAttributeCenterX],
							@"x":[NSNumber numberWithInteger:NSLayoutAttributeCenterX],
							@"centerY":[NSNumber numberWithInteger:NSLayoutAttributeCenterY],
							@"y":[NSNumber numberWithInteger:NSLayoutAttributeCenterY],
							@"top":[NSNumber numberWithInteger:NSLayoutAttributeTop],
							@"t":[NSNumber numberWithInteger:NSLayoutAttributeTop],
							@"bottom":[NSNumber numberWithInteger:NSLayoutAttributeBottom],
							@"b":[NSNumber numberWithInteger:NSLayoutAttributeBottom],
							@"left":[NSNumber numberWithInteger:NSLayoutAttributeLeft],
							@"l":[NSNumber numberWithInteger:NSLayoutAttributeLeft],
							@"leftMargin":[NSNumber numberWithInteger:NSLayoutAttributeLeftMargin],
							@"right":[NSNumber numberWithInteger:NSLayoutAttributeRight],
							@"r":[NSNumber numberWithInteger:NSLayoutAttributeRight],
							
							@"leading":[NSNumber numberWithInteger:NSLayoutAttributeLeading],
							@"ld":[NSNumber numberWithInteger:NSLayoutAttributeLeading],
							@"trailing":[NSNumber numberWithInteger:NSLayoutAttributeTrailing],
							@"tl":[NSNumber numberWithInteger:NSLayoutAttributeTrailing],
							
							@"not":[NSNumber numberWithInteger:NSLayoutAttributeNotAnAttribute],
							};
	});
	return _layoutAttribute;
}
+(NSLayoutAttribute)layoutAttributeOf:(NSString*)attrName
{
	return (NSLayoutAttribute)[self layoutAttribute][attrName].integerValue;
}
+(BOOL)isLayoutAttribute:(NSString*)attributeName
{
	return [self layoutAttribute][attributeName]!=nil;
}
@end
