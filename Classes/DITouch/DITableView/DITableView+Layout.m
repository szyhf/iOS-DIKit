//
//  DITableView+Layout.m
//  Pods
//
//  Created by Back on 16/6/22.
//
//

#import "DITableView.h"

@implementation DITableView (Layout)
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
