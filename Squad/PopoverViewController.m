//
//  PopoverViewController.m
//  The Life
//
//  Created by AQB Mac 4 on 06/09/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "PopoverViewController.h"
#import "ProfileTableViewCell.h"
@interface PopoverViewController (){

    IBOutlet UITableView *table;
    IBOutlet UIButton *cancelButton;
    int selectedindexpath;
}

@end

@implementation PopoverViewController
@synthesize tableDataArray,selectedIndex,settingIndex,delegate,isNutritionDietary;

- (void)viewDidLoad {
    [super viewDidLoad];
    cancelButton.layer.cornerRadius = 4;
    cancelButton.clipsToBounds = YES;
    table.layer.cornerRadius = 4;
    table.clipsToBounds = YES;
    if (isNutritionDietary) {
        [cancelButton setTitle:@"Close" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - TableView Datasource & Delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;

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
    cell.notificationDays.text=[tableDataArray objectAtIndex:indexPath.row];
    
    if (selectedIndex == indexPath.row) {
        
        cell.checkUncheckImage.image = [UIImage imageNamed:@"active_check.png"];
    }
    else{
        cell.checkUncheckImage.image = [UIImage imageNamed:@"inactive_check.png"];
    }
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex = (int) indexPath.row;
    if ([delegate respondsToSelector:@selector(didSelectAnyOption:option:)]) {
        NSString *indexpathString = [@"" stringByAppendingFormat:@"%d",selectedIndex];
        [delegate didSelectAnyOption:settingIndex option:indexpathString];
    }
    [table reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -IBAction
- (IBAction)cancelButtonPressed:(UIButton *)sender {
    if ([delegate respondsToSelector:@selector(didCancelOption)]) {
        [delegate didCancelOption];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -End

@end
