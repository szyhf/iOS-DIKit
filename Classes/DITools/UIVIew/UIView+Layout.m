//
//  UIView+Layout.m
//  DIKit
//
//  Created by Back on 16/9/9.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIView.h"

@implementation UIView (Layout)
// 计算一个全支撑的视图的高度
-(CGSize)contentViewFittingSize:(UIView*)contentView
{
	CGFloat contentViewWidth = CGRectGetWidth(self.frame);
	//if (contentViewWidth > 0)
	{
		NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
		[contentView addConstraint:widthFenceConstraint];
		// Auto layout engine does its math
		CGSize fittingSize = [contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
		[contentView removeConstraint:widthFenceConstraint];
		
		return fittingSize;
	}
	return CGSizeZero;
}
@end
