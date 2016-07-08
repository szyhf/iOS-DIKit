//
//  DITableVIewModel.m
//  DIKit
//
//  Created by Back on 16/6/30.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DITableViewModel.h"
#import "DIContainer.h"
#import "DIArrayModel.h"
#import "NSObject+FBKVOController.h"
@interface DITableViewModel()
@property (nonatomic, strong)NSMutableArray* cells;
@end

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
		NSAssert([[self.class tableModelWatchClass]isSubclassOfClass:DIArrayModel.class], @"[DITableViewModel tableModelWatchClass] should be subclass of DIArrayModel");
		[self watchModelClass:[self.class tableModelWatchClass]];
	}
	return self;
}

+(BOOL)resolveInstanceMethod:(SEL)sel
{
	//动态拦截不同的setTableModelWatchClass_cellModels:方法
	if([NSStringFromSelector(sel) isEqualToString:[self di_setCollectionKeyPathMethod]])
	{
		IMP imp = class_getMethodImplementation(self, @selector(di_setCellModels:));
		class_addMethod(self, sel, imp, "v@:@");//格式为“返回值参数1参数2参数3参数...”参数1默认为当前对象，参数2默认为当前SEL，参数3开始是用户自定义的参数，@表示id类型，:表示SEL类型，v表示void，其他的参考苹果文档。
		return YES;
	}
	return [super resolveInstanceMethod:sel];
}

-(void)di_setCellModels:(NSArray*)models
{
	NSMutableArray* cellViewModels = [NSMutableArray arrayWithCapacity:models.count];
	for (DIModel* model in models)
	{
		DIViewModel* cellVM = [DIContainer makeInstance:[self.class cellViewModelClass]];
		[cellVM watchModel:model];
		[cellViewModels addObject:cellVM];
	}
	self.cells = cellViewModels;
	[self.watchMap setValue:cellViewModels forKeyPath:@"target.cellsViewModel"];
}

+(NSDictionary<NSString*,NSString*>*)bindingMap
{
	//虽然被拦截了，但target.可以确保目标存在的时候才绑定，即key仍然是有意义的
	//不能写静态，否则静态对象由父类持有，各个子类都会复写同一个
	//就无法动态生成了=。=
	return @{
			 @"target.cellsViewModel":[self collectionKeyPath],
			 };
}

+(NSString*)collectionKeyPath
{
	return [NSString stringWithFormat:@"%@.%@",[self tableModelWatchClass],[[self tableModelWatchClass] invokeMethod:@"collectionProperty"]];
}

+(NSString*)di_setCollectionKeyPathMethod
{
	return [NSString stringWithFormat:@"set%@_%@:",[self tableModelWatchClass],[[self tableModelWatchClass] invokeMethod:@"collectionProperty"]];

}
@end
