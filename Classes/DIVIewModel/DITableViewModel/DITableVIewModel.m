//
//  DITableVIewModel.m
//  DIKit
//
//  Created by Back on 16/6/30.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DITableVIewModel.h"
#import "DIContainer.h"
#import "DIArrayModel.h"
#import "NSObject+FBKVOController.h"

@implementation DITableViewModel
+(Class)cellViewModelClass
{
	return DIViewModel.class;
}

+(Class)tableModelWatchClass
{
	return DIArrayModel.class;
}

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		[self watchModelClass:[self.class tableModelWatchClass]];
	}
	return self;
}

+(BOOL)resolveInstanceMethod:(SEL)sel
{
	//动态拦截不同的setTableModelWatchClass_cellModels:方法
	if([NSStringFromSelector(sel) hasSuffix:@"_cellModels:"])
	{
		//严格来说不应该这样做。。但方便先用着呗=。=
		IMP imp = class_getMethodImplementation(self, @selector(setCellModels:));
		class_addMethod(self, sel, imp, "v@:@");
		return YES;
	}
	return [super resolveInstanceMethod:sel];
}

-(void)setCellModels:(NSArray*)models
{
	NSMutableArray* cellViewModels = [NSMutableArray arrayWithCapacity:models.count];
	for (DIModel* model in models)
	{
		DIViewModel* cellVM = [DIContainer makeInstance:[self.class cellViewModelClass]];
		[cellVM watchModel:model];
		[cellViewModels addObject:cellVM];
	}
	[self.watchMap setValue:cellViewModels forKeyPath:@"target.cellsViewModel"];
}

+(NSDictionary<NSString*,NSString*>*)bindingMap
{
	//虽然被拦截了，但target.可以确保目标存在的时候才绑定
	return @{
			 @"target.cellsViewModel":[NSString stringWithFormat:@"%@.cellModels",[self tableModelWatchClass]],
			 };
}
@end
