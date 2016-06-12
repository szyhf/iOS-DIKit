//
//  DINode_DIAttribute.h
//  DIKit
//
//  Created by Back on 16/6/3.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DINode.h"
@interface DINode()
{
	NSException* __weak _exception;
	NSMutableDictionary<NSString *,NSString *> *_attributes;
}
@end

@implementation DINode (DIAttribute)
+(NSDictionary<NSString*,UndefinedKeyHandlerBlock>*)nodeBlocks
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _uiView_token;
	dispatch_once(&_uiView_token,
				  ^{
					  _instance = @{
									//支持相对值、绝对值
									@"height":self.layoutKey,
									@"h":self.layoutKey,
									@"width":self.layoutKey,
									@"w":self.layoutKey,
									
									//支持相对值、相对绝对值（转化为相对值）
									@"centerX":self.layoutRelativeKey,
									@"x":self.layoutRelativeKey,
									@"centerY":self.layoutRelativeKey,
									@"y":self.layoutRelativeKey,
									@"top":self.layoutRelativeKey,
									@"t":self.layoutRelativeKey,
									@"bottom":self.layoutRelativeKey,
									@"b":self.layoutRelativeKey,
									@"left":self.layoutRelativeKey,
									@"leftMargin":self.layoutRelativeKey,
									@"l":self.layoutRelativeKey,
									@"right":self.layoutRelativeKey,
									@"r":self.layoutRelativeKey,
									
									@"leading":self.layoutRelativeKey,
									@"ld":self.layoutRelativeKey,
									@"trailing":self.layoutRelativeKey,
									@"tl":self.layoutRelativeKey,
									
									//扩展属性
									@"edges":self.layoutEdgesKey,
									@"size":self.sizeKey,
									//@"center":@"",
									} ;
				  });
	return _instance;
}

+(NSArray<NSString*>*)nodeKeyWord
{
	static NSArray* _instance;
	static dispatch_once_t _nodeAttribute_token;
	dispatch_once(&_nodeAttribute_token,
				  ^{
					  //保留字
					  _instance = @[
									@"prop",
									@"id",
									@"ref",
									@"template",
									];
				  });
	return _instance;
}

+(UndefinedKeyHandlerBlock)layoutKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _layoutKey;
	dispatch_once(&_layoutKey,
				  ^{
					  _instance = ^void(DINode* node,NSString*key,id value)
					  {
						  NSArray<DILayoutParserResult*>* res = [DILayoutParser parserResults:value attributeKey:key];
						  for (DILayoutParserResult* result in res)
						  {
							  DINodeLayoutConstraint* nodeConstraint = [[DINodeLayoutConstraint alloc]initWithOriNode:node parserResult:result];
							  void(^delayBlock)()=^void()
							  {
								  [nodeConstraint realizeConstant];
							  };
							  [node.delayBlocks addObject:delayBlock];
						  }
						  [node.attributes removeObjectForKey:key];
					  } ;
				  });
	return _instance;
}

+(UndefinedKeyHandlerBlock)layoutRelativeKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _layoutKey;
	dispatch_once(&_layoutKey,
				  ^{
					  _instance = ^void(DINode* node,NSString*key,NSString* value)
					  {
						  //如果是绝对值或者为空，自动补:号
						  if([value isMatchRegular:@"^[>=<]?[\\+-]?\\d*\\.?\\d*;?$"])
						  {
							  value = [@":" stringByAppendingString:value];
						  }
						  self.layoutKey(node,key,value);
					  } ;
				  });
	return _instance;
}

+(UndefinedKeyHandlerBlock)layoutEdgesKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _layoutKey;
	dispatch_once(&_layoutKey,
				  ^{
					  _instance = ^void(DINode* node,NSString*key,NSString* value)
					  {
						  NSArray<NSString*>* edges = [value componentsSeparatedByString:@","];
						  //支持省略写法，省略值默认为0
						  NSString* top=@"0";
						  NSString* left = @"0";
						  NSString* bottom=@"0";
						  NSString* right=@"0";
						  NSCharacterSet* trimSet = [NSCharacterSet characterSetWithCharactersInString:@",;()"];
						  switch (edges.count)
						  {
							  case 4:
							  {
								  right = [edges[3] stringByTrimmingCharactersInSet:trimSet];
								  if(![right isEmpty])
								  {
									  if([right isMatchRegular:@"^[\\+-]?\\d*;?$"])
									  {
										  right = [NSString stringWithFormat:@"%f",[right doubleValue]*-1];
									  }
									  self.layoutRelativeKey(node,@"right",right);
								  }
							  }
							  case 3:
							  {
								  bottom = [edges[2] stringByTrimmingCharactersInSet:trimSet];
								  if(![bottom isEmpty])
								  {
									  if([bottom isMatchRegular:@"^[\\+-]?\\d*;?$"])
									  {
										  bottom = [NSString stringWithFormat:@"%f",[bottom doubleValue]*-1];
									  }
									  self.layoutRelativeKey(node,@"bottom",bottom);
								  }
							  }
							  case 2:
							  {
								  left = [edges[1] stringByTrimmingCharactersInSet:trimSet];
								  if(![left isEmpty])
								  {
									  if([left isMatchRegular:@"^[\\+-]?\\d*;?$"])
									  {
										  left = [NSString stringWithFormat:@"%f",[left doubleValue]];
									  }
									  self.layoutRelativeKey(node,@"left",left);
								  }
							  }
							  case 1:
							  {
								  top = [edges[0] stringByTrimmingCharactersInSet:trimSet];
								  if(![top isEmpty])
								  {
									  if([top isMatchRegular:@"^[\\+-]?\\d*;?$"])
									  {
										  top = [NSString stringWithFormat:@"%f",[top doubleValue]];
									  }
									  self.layoutRelativeKey(node,@"top",top);
								  }
								  break;
							  }
						  }
						  [node.attributes removeObjectForKey:key];
					  } ;
				  });
	return _instance;
}


+(UndefinedKeyHandlerBlock)sizeKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _layoutKey;
	dispatch_once(&_layoutKey,
				  ^{
					  _instance = ^void(DINode* node,NSString*key,NSString* value)
					  {
						  value = [value trimEnd:@")"];
						  value = [value trimStart:@"("];
						  NSArray<NSString*>* sizeAry = [value componentsSeparatedByString:@","];
						  self.layoutKey(node,@"width",sizeAry[0]);
						  self.layoutKey(node,@"height",sizeAry[1]);
						  
						  [node.attributes removeObjectForKey:key];
					  } ;
				  });
	return _instance;
}

-(void)setAttributes:(NSMutableDictionary<NSString *,NSString *> *)attributes
{
	self->_attributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
	
	[self->_attributes removeObjectsForKeys:[self.class nodeKeyWord]];
	[self->_attributes enumerateKeysAndObjectsUsingBlock:
	 ^(NSString * _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop)
	 {
		 @try
		 {
			 UndefinedKeyHandlerBlock block = [self.class nodeBlocks][key];
			 if(block)
				 block(self,key,value);
		 }
		 @catch (NSException *exception)
		 {
			 WarnLog(@"set node<%@ %p> attribute[%@ => %@] failed\nException:%@",key,value,self.name,self,exception);
			 self->_exception=exception;
		 }
	 }];
}

@end
