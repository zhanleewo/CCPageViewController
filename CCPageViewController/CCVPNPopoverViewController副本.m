//
//  CCVPNPopoverViewController.m
//  CCPageViewController
//
//  Created by 詹林 on 16/8/15.
//  Copyright © 2016年 AOLC. All rights reserved.
//

#import "CCVPNPopoverViewController.h"
#import "CCVPNPopoverTableViewCell.h"
#import "FMMoveTableView.h"

#define kIndexNameOfMovie		0
#define kIndexYearOfMovie		1
#define kIndexRowHeightOfMovie  2

@interface CCVPNPopoverViewController ()
@end

@implementation CCVPNPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(FMMoveTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseIdentifier = @"vpn-item-cell";
    CCVPNPopoverTableViewCell *cell = (CCVPNPopoverTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    if ([tableView indexPathIsMovingIndexPath:indexPath])
    {
        [cell prepareForMove];
    }
    else
    {
        if (tableView.movingIndexPath != nil) {
            indexPath = [tableView adaptedIndexPathForRowAtIndexPath:indexPath];
        }
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.shouldIndentWhileEditing = NO;
        cell.showsReorderControl = NO;
    }
    
    return cell;
}

- (void)moveTableView:(FMMoveTableView *)tableView moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(FMMoveTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}


- (NSIndexPath *)moveTableView:(FMMoveTableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    //	Uncomment these lines to enable moving a row just within it's current section
    //	if ([sourceIndexPath section] != [proposedDestinationIndexPath section]) {
    //		proposedDestinationIndexPath = sourceIndexPath;
    //	}
    
    return proposedDestinationIndexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"Did select row at %@", indexPath);
    
    CCVPNPopoverTableViewCell *cell = (CCVPNPopoverTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType =  (cell.accessoryType == UITableViewCellAccessoryCheckmark) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
