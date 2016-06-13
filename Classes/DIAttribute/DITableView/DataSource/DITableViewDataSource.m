//
//  DIDataSource.m
//  Pods
//
//  Created by Back on 16/6/12.
//
//

#import "DITableViewDataSource.h"
#import "DITableView.h"

@implementation DITableViewDataSource
-(NSInteger)tableView:(DITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 30;
}

- (UITableViewCell *)tableView:(DITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [tableView dequeueDefaultCell];
}

@end
