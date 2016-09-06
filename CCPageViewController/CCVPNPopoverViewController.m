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
#import <PINCache/PINCache.h>

#define kIndexNameOfMovie		0
#define kIndexYearOfMovie		1
#define kIndexRowHeightOfMovie  2

@interface CCVPNPopoverViewController () <UITableViewDelegate, UITableViewDataSource>
@property NSMutableArray *vpns;
@end

@implementation CCVPNPopoverViewController

- (IBAction)hidePopover:(UIBarButtonItem *)sender {
    self.view.superview.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSMutableArray *orderArray = [NSMutableArray arrayWithArray:@[@"3", @"5", @"1", @"2", @"4", @"0"]];
//    [[PINCache sharedCache] setObject:orderArray forKey:@"CCVPNSOrderKey"];
//    [[PINCache sharedCache] setObject:[NSNumber numberWithBool:YES] forKey:@"3"];
//    [[PINCache sharedCache] setObject:[NSNumber numberWithBool:YES] forKey:@"5"];
//    [[PINCache sharedCache] setObject:[NSNumber numberWithBool:YES] forKey:@"1"];
//    [[PINCache sharedCache] setObject:[NSNumber numberWithBool:YES] forKey:@"2"];
//    [[PINCache sharedCache] setObject:[NSNumber numberWithBool:YES] forKey:@"4"];
//    [[PINCache sharedCache] setObject:[NSNumber numberWithBool:YES] forKey:@"0"];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[PINCache sharedCache] objectForKey:@"CCVPNSOrderKey" block:^(PINCache * _Nonnull cache, NSString * _Nonnull key, id  _Nullable object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *orderArray1 = (NSMutableArray *) object;
            self.vpns = orderArray1;
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vpns.count;
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
        cell.nameLabel.text = self.vpns[indexPath.row];
        cell.shouldIndentWhileEditing = NO;
        cell.showsReorderControl = NO;
        
        [[PINCache sharedCache] objectForKey:self.vpns[indexPath.row] block:^(PINCache * _Nonnull cache, NSString * _Nonnull key, id  _Nullable object) {
            NSNumber *show = (NSNumber *) object;
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.accessoryType = show.boolValue ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            });
            
        }];
    }
    
    return cell;
}

- (void)moveTableView:(FMMoveTableView *)tableView moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *vpn = [self.vpns objectAtIndex:fromIndexPath.row];
    [self.vpns removeObjectAtIndex:fromIndexPath.row];
    [self.vpns insertObject:vpn atIndex:toIndexPath.row];
    [[PINCache sharedCache] setObject:self.vpns forKey:@"CCVPNSOrderKey"];
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
    [[PINCache sharedCache] setObject:[NSNumber numberWithBool:(cell.accessoryType == UITableViewCellAccessoryCheckmark)] forKey:self.vpns[indexPath.row]];
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
