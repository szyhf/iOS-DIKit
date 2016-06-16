//
//  UIWebView+DIAttribute.m
//  Pods
//
//  Created by Back on 16/6/14.
//
//

#import "UIWebView+DIAttribute.h"
#import "NSObject+DIAttribute.h"

@implementation UIWebView (DIAttribute)
+(UndefinedKeyHandlerBlock)di_AttributeBlock:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = @{
									@"url":self.urlKey
									} ;
				  });
	return _instance[key];
}
+(UndefinedKeyHandlerBlock)urlKey
{
	return ^void(UIWebView* webView,NSString* key, NSString* value)
	{
		NSURL* url = [NSURL URLWithString:value];
		NSURLRequest* request = [NSURLRequest requestWithURL:url];
		[webView loadRequest:request];
	};
}
@end
