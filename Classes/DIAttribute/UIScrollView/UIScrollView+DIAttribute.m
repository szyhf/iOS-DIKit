//
//  UIScrollView+DIAttribute.m
//  DIKit
//
//  Created by Back on 16/6/3.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "UIScrollView+DIAttribute.h"
#import "UIView+DIAttribute.h"

@implementation UIScrollView (DIAttribute)
+(UndefinedKeyHandlerBlock)di_AttributeBlock:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = @{
									@"contentOffsetX":self.contentOffsetXKey,
									@"contentOffsetY":self.contentOffsetYKey,
									} ;
				  });
	return _instance[key];
}
+(UndefinedKeyHandlerBlock)contentOffsetXKey
{
	return ^void(UIScrollView* view,NSString*key,NSString* value)
	{
		CGPoint offset = view.contentOffset;
		offset.x=[value doubleValue];
		view.contentOffset = offset;
	};
}
+(UndefinedKeyHandlerBlock)contentOffsetYKey
{
	return ^void(UIScrollView* view,NSString*key,NSString* value)
	{
		CGPoint offset = view.contentOffset;
		offset.y=[value doubleValue];
		view.contentOffset = offset;
	};
}
@end
