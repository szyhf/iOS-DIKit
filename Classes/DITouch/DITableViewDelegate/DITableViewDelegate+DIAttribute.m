//
//  DITableViewDelegate+DIAttribute.m
//  Pods
//
//  Created by Back on 16/6/14.
//
//

#import "DITableViewDelegate+DIAttribute.h"
#import "NSObject+DIAttribute.h"
#import "DIContainer.h"

@implementation DITableViewDelegate (DIAttribute)
+(void)load
{
	Method oriSelectCallBack = class_getInstanceMethod(self, @selector(tableView:didSelectRowAtIndexPath:));
	Method diSelectCallBack = class_getInstanceMethod(self, @selector(di_tableView:didSelectRowAtIndexPath:));
	method_exchangeImplementations(oriSelectCallBack, diSelectCallBack);
}
+(UndefinedKeyHandlerBlock)di_AttributeBlock:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = @{
									@"select":self.selectKey,
									} ;
				  });
	return _instance[key];
}

-		(void)di_tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	id tap_value = [self valueForKey:@"di_select"];
	void(^tapBlock)() ;
	if([tap_value isKindOfClass:NSString.class])
	{
		NSArray* commands = [(NSString*)tap_value componentsSeparatedByString:@";"];
		NSMutableArray* actions = [NSMutableArray arrayWithCapacity:commands.count];
		for (NSString* command in commands)
		{
			NSScanner* scanner = [NSScanner scannerWithString:command];
			NSString* targetName;
			NSString* methodName;
			[scanner scanUpToString:@"." intoString:&targetName];
			[scanner scanString:@"." intoString:nil];
			[scanner scanUpToString:@"" intoString:&methodName];
			id target = [DIContainer getInstanceByName:targetName];
			
			SEL action = NSSelectorFromString(methodName);
			if([target respondsToSelector:action])
				[actions addObject:@[target,methodName]];
		}
		
		tap_value =^void(UITableView *_tableView,NSIndexPath *_indexPath)
		{
			for (NSArray* action in actions)
			{
				NSString* methodName = action.lastObject;
				if([methodName hasSuffix:@":"])
				{
					[action.firstObject invokeSelector:NSSelectorFromString(methodName) withParams:_tableView,_indexPath];
				}
				else
				{
					[action.firstObject  invokeMethod:methodName];
				}
			}
			
		};
		tapBlock = tap_value;
		[self setValue:tap_value forKey:@"di_select"];
	}
	else
	{
		tapBlock = tap_value;
	}
	if(tapBlock)
		tapBlock(tableView,indexPath);
	
	[self di_tableView:tableView didSelectRowAtIndexPath:indexPath];
}

+(UndefinedKeyHandlerBlock)selectKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = ^void(DITableViewDelegate* delegate,NSString* key,id value)
					  {
						  //[button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
						  [delegate setValue:value forKey:@"di_select"];
					  };
				  });
	return _instance;
}
@end
