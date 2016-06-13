//
//  UITableViewCell+DIAttribute.m
//  DIKit
//
//  Created by Back on 16/6/12.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "UITableViewCell+DIAttribute.h"
#import "UIView+DIAttribute.h"
#import "DIConverter.h"

@implementation UITableViewCell (DIAttribute)
+(UndefinedKeyHandlerBlock)di_AttributeBlock:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = @{
									@"backgroundColor":self.colorKey,
									} ;
				  });
	return _instance[key];
}

+(UndefinedKeyHandlerBlock)colorKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _colorKey_token;
	dispatch_once(&_colorKey_token,
				  ^{
					  _instance =  ^void(UITableViewCell* obj,NSString*key,id value)
					  {
						  UIColor* color = [DIConverter toColor:value];
						  [obj.contentView setBackgroundColor:color];
					  };
				  });
	return _instance;
}
@end
