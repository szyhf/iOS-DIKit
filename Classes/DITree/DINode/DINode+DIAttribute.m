//
//  DINode_DIAttribute.h
//  DIKit
//
//  Created by Back on 16/6/3.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DINode.h"

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
									@"cX":self.layoutRelativeKey,
									@"centerY":self.layoutRelativeKey,
									@"cY":self.layoutRelativeKey,
									
									//仅支持相对值
									@"top":self.layoutRelativeKey,
									@"t":self.layoutRelativeKey,
									@"bottom":self.layoutRelativeKey,
									@"b":self.layoutRelativeKey,
									@"left":self.layoutRelativeKey,
									@"l":self.layoutRelativeKey,
									@"right":self.layoutRelativeKey,
									@"r":self.layoutRelativeKey,
									
									@"leading":self.layoutRelativeKey,
									@"ld":self.layoutRelativeKey,
									@"trailing":self.layoutRelativeKey,
									@"tl":self.layoutRelativeKey,
									
									//扩展属性
									@"edges":self.layoutEdgesKey,
									//@"size":@"",
									//@"center":@"",
									} ;
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
						  if([value isMatchRegular:@"^\\d*;?$"])
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
								  right=![right isEmpty]?[@"-" stringByAppendingString:right]:@"0";
							  }
							  case 3:
							  {
								  bottom = [edges[2] stringByTrimmingCharactersInSet:trimSet];
								  bottom=![bottom isEmpty]?[@"-"stringByAppendingString:bottom]:@"0";
							  }
							  case 2:
							  {
								  left = [edges[1] stringByTrimmingCharactersInSet:trimSet];
								  left=![left isEmpty]?left:@"0";
							  }
							  case 1:
							  {
								  top = [edges[0] stringByTrimmingCharactersInSet:trimSet];
								  top=![top isEmpty]?top:@"0";
								  break;
							  }
						  }
						  [node.attributes removeObjectForKey:key];
						  self.layoutRelativeKey(node,@"top",top);
						  self.layoutRelativeKey(node,@"left",left);
						  self.layoutRelativeKey(node,@"bottom",bottom);
						  self.layoutRelativeKey(node,@"right",right);
					  } ;
				  });
	return _instance;
}

@end
