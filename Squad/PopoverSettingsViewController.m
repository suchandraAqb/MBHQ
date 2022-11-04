//
//  PopoverSettingsViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 22/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "PopoverSettingsViewController.h"
#import "PopoverViewController.h"
#import "ProfileTableViewCell.h"

@interface PopoverSettingsViewController ()
{
    IBOutlet UITableView *table;
    IBOutlet UIButton *cancelButton;

}
@end

@implementation PopoverSettingsViewController

@synthesize tableDataArray,selectedIndex,settingIndex,delegate,sender;

- (void)viewDidLoad {
    [super viewDidLoad];
    cancelButton.layer.cornerRadius = 4;
    cancelButton.clipsToBounds = YES;
    table.layer.cornerRadius = 4;
    table.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - TableView Datasource & Delegates

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier =@"ProfileTableViewCell";
    ProfileTableViewCell *cell = (ProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = [tableDataArray objectAtIndex:indexPath.row];
    cell.notificationDays.text=[dict valueForKey:@"Value"];
    if (selectedIndex > -1 && selectedIndex == indexPath.row) {
        cell.checkButton.selected = YES;
    }else{
        cell.checkButton.selected = false;
    }
    cell.checkButton.tag = (int) indexPath.row;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        selectedIndex = (int) indexPath.row;
        [tableView reloadData];
        NSDictionary *dict = [tableDataArray objectAtIndex:selectedIndex];
        [table reloadData];
        if (!sender) {
            if ([delegate respondsToSelector:@selector(didSelectAnyOption:option:)]) {
                [delegate didSelectAnyOption:settingIndex option:[dict valueForKey:@"Key"]];
            }
        }else{
            if ([delegate respondsToSelector:@selector(didSelectAnyOptionWithSender:index:)]) {
                [delegate didSelectAnyOptionWithSender:sender index:selectedIndex];
            }
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
}
#pragma mark -IBAction
- (IBAction)checkUncheckButtonPressed:(UIButton *)sender1{
    dispatch_async(dispatch_get_main_queue(), ^{
        selectedIndex = (int) sender1.tag;
        NSDictionary *dict = [tableDataArray objectAtIndex:selectedIndex];
        [table reloadData];
        if (!sender) {
            if ([delegate respondsToSelector:@selector(didSelectAnyOption:option:)]) {
                [delegate didSelectAnyOption:settingIndex option:[dict valueForKey:@"Key"]];
            }
        }else{
            if ([delegate respondsToSelector:@selector(didSelectAnyOptionWithSender:index:)]) {
                [delegate didSelectAnyOptionWithSender:sender index:selectedIndex];
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
    });
}
- (IBAction)cancelButtonPressed:(UIButton *)sender1 {
    if ([delegate respondsToSelector:@selector(didCancelOption)]) {
        [delegate didCancelOption];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -End
@end
