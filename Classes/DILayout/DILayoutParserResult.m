//
//  DILayoutParserResult.m
//  DIKit
//
//  Created by Back on 16/5/31.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DILayoutParserResult.h"

@implementation DILayoutParserResult
+(instancetype)newParserResult
{
	DILayoutParserResult* newResult = [[DILayoutParserResult alloc]init];
	return newResult;
}

-(NSString*)description
{
	return [NSString stringWithFormat:@"%@%@%@:%@*%.2f%+.2f @%.0f",self.oriAttribute,self.relation==-1?@"<":(self.relation == 0?@"=":@">"),self.target,self.targetAttribute,self.mutiply,self.offset,self.priority];
}

- (NSString *)target {
	return _target;
}

- (NSLayoutRelation)relation {
	if(!_relation) {
		_relation = NSLayoutRelationEqual;
	}
	return _relation;
}

- (NSString *)oriAttribute {
	if(_oriAttribute == nil) {
		_oriAttribute = [[NSString alloc] init];
	}
	return _oriAttribute;
}

- (NSString *)targetAttribute {
	if(_targetAttribute == nil) {
		_targetAttribute = [[NSString alloc] init];
	}
	return _targetAttribute;
}

- (CGFloat)mutiply {
	if(!_mutiply) {
		_mutiply = 1;
	}
	return _mutiply;
}

- (CGFloat)offset {
	if(!_offset) {
		_offset = 0;
	}
	return _offset;
}

- (CGFloat)priority {
	if(!_priority) {
		_priority = 1000;
	}
	return _priority;
}
@end
