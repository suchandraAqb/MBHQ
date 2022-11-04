//
//  DropdownViewController.m
//  The Life
//
//  Created by AQB Mac 4 on 21/09/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "DropdownViewController.h"
#import "DropdownTableViewCell.h"
#import "DropdownMasterTableViewCell.h"

@interface DropdownViewController (){
    
    IBOutlet UITableView *table;
    IBOutlet UIButton *cancelButton;
    NSMutableArray *multiselectedArray;
    BOOL isAdd;
    int count;
}

@end

@implementation DropdownViewController
@synthesize dropdownDataArray,selectedIndex,delegate,mainKey,subKey,apiType,sender,selectedIndexes,multiSelect,userPromptRandom;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"MainKey-%@",mainKey);
    cancelButton.layer.cornerRadius = 4;
    cancelButton.clipsToBounds = YES;
    table.layer.cornerRadius = 4;
    table.clipsToBounds = YES;
    isAdd = YES;
    if (multiSelect) {
        if (selectedIndexes.count > 0) {
            multiselectedArray = [[NSMutableArray alloc]initWithArray:selectedIndexes];
        }else{
            multiselectedArray = [[NSMutableArray alloc]init];
        }
        table.allowsMultipleSelection = true;
    }else{
        multiselectedArray = [[NSMutableArray alloc]init];
        table.allowsMultipleSelection = false;
    }
    
}
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (_shouldScrollToIndexpath && selectedIndex >= 0 && selectedIndex < [table numberOfRowsInSection:1]) {
        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];    //ah edit
    }
    count = 0;
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
    if([apiType  isEqual: @"Growth"]){
        if (indexPath.row == 3 || indexPath.row == 13) {
            return 20;
        }else{
            return UITableViewAutomaticDimension;
        }
        
    }
    
    return UITableViewAutomaticDimension;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

        return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return dropdownDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *commonCell;
    if (![Utility isEmptyCheck:mainKey] || ![Utility isEmptyCheck:subKey]) {
        NSDictionary *dict = [dropdownDataArray objectAtIndex:indexPath.row];
        if ([[dict valueForKey:@"isMaster"] boolValue]) {
            NSString *CellIdentifier =@"DropdownMasterTableViewCell";
            DropdownMasterTableViewCell *cell = (DropdownMasterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[DropdownMasterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            if (![Utility isEmptyCheck:mainKey]) {
                id dropdownName = [dict valueForKey:mainKey];
                if (![Utility isEmptyCheck:dropdownName]) {
                    if ([dropdownName isKindOfClass:[NSString class]]) {
                        cell.dropdownMasterName.text = dropdownName;
                    }else if([dropdownName isKindOfClass:[NSNumber class]]){
                        cell.dropdownMasterName.text = [dropdownName stringValue];
                    }
                }
            }
            commonCell = cell;
        }else{
            NSString *CellIdentifier =@"DropdownTableViewCell";
            DropdownTableViewCell *cell = (DropdownTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[DropdownTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            NSString *appendString = @"";
            if (_haveMaster) {
                appendString  = @"   ";
            }
            if (![Utility isEmptyCheck:mainKey]) {
                id dropdownName = [dict valueForKey:mainKey];
                if (![Utility isEmptyCheck:dropdownName]) {
                    if ([dropdownName isKindOfClass:[NSString class]]) {
                        cell.dropdownName.text = [appendString stringByAppendingString:dropdownName];
                    }else if([dropdownName isKindOfClass:[NSNumber class]]){
                        cell.dropdownName.text = [appendString stringByAppendingString:[dropdownName stringValue]];
                    }
                }
            }
            if (![Utility isEmptyCheck:subKey]) {
                id dropdownMoreInfo = [dict valueForKey:subKey];
                if (![Utility isEmptyCheck:dropdownMoreInfo]) {
                    if ([dropdownMoreInfo isKindOfClass:[NSString class]]) {
                        cell.dropdownMoreInfo.text = dropdownMoreInfo;
                        
                    }else if([dropdownMoreInfo isKindOfClass:[NSNumber class]]){
                        cell.dropdownMoreInfo.text = [dropdownMoreInfo stringValue];
                    }
                }
            }
            if (multiSelect) {
                if ([multiselectedArray containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
                    cell.checkButton.selected = YES;
                }else{
                    cell.checkButton.selected = false;
                }
            }else{
                if (selectedIndex > -1 && selectedIndex == indexPath.row) {
                    cell.checkButton.selected = YES;
                }else{
                    cell.checkButton.selected = false;
                }
            }
            cell.checkButton.tag = (int) indexPath.row;
            commonCell = cell;
        }
    }else{
        NSString *CellIdentifier =@"DropdownTableViewCell";
        DropdownTableViewCell *cell = (DropdownTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DropdownTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        id dropdownName= [dropdownDataArray objectAtIndex:indexPath.row];
        if (![Utility isEmptyCheck:dropdownName]) {
            if ([dropdownName isKindOfClass:[NSString class]]) {
                    cell.dropdownName.text = dropdownName;
            }else if([dropdownName isKindOfClass:[NSNumber class]]){
                cell.dropdownName.text = [dropdownName stringValue];
            }
        }
        if([apiType  isEqual: @"Growth"]){
            if([cell.dropdownName.text isEqual: @" "]){
                    cell.userInteractionEnabled = false;
                    [cell.checkButton setImage:nil forState:UIControlStateNormal];
                cell.backgroundColor = [UIColor colorWithRed: 0.84 green: 0.83 blue: 0.83 alpha: 1.00];
                cell.devider.hidden = true;
                    NSLog(@"Indexpath.row ====>%ld",(long)indexPath.row);
                    NSLog(@"");
            }else{
                if([cell.dropdownName.text isEqual: @"Today I'm Feeling"] || [cell.dropdownName.text isEqual: @"The story I've told myself is"]){
                    cell.devider.hidden = true;
                }else{
                    cell.devider.hidden = false;
                }
                cell.backgroundColor = [UIColor whiteColor];
                [cell.checkButton setImage:[UIImage imageNamed:@"untick_mbhq.png"] forState:UIControlStateNormal];
                cell.userInteractionEnabled = true;
            }
        }
        
        if (multiSelect) {
            if ([multiselectedArray containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
                cell.checkButton.selected = YES;
            }else{
                cell.checkButton.selected = false;
            }
        }else{
            if(selectedIndex > -1 && selectedIndex == indexPath.row) {
                cell.checkButton.selected = YES;
            }else{
                cell.checkButton.selected = false;
            }
        }
        
        cell.checkButton.tag = (int) indexPath.row;

        commonCell = cell;
    }
    
    
    return commonCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self->_haveMaster){
            NSDictionary *dict = [self->dropdownDataArray objectAtIndex:indexPath.row];
            if ([[dict objectForKey:@"isMaster"] boolValue] && ![[dict objectForKey:@"haveAction"] boolValue]) {
                return ;
            }
        }
        if (self->multiSelect) {
            self->selectedIndex = (int) indexPath.row;
            if ([self->multiselectedArray containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
                [self->multiselectedArray removeObject:[NSNumber numberWithInteger:indexPath.row]];
                self->isAdd = NO;
            }else{
                [self->multiselectedArray addObject:[NSNumber numberWithInteger:indexPath.row]];
                self->isAdd = YES;
            }
            if (![Utility isEmptyCheck:self->mainKey] || ![Utility isEmptyCheck:self->subKey]) {
                
                [self->table reloadData];
//                NSDictionary *dict = [dropdownDataArray objectAtIndex:selectedIndex];
                
                //ah goal
                NSDictionary *dict = [[NSDictionary alloc] init];
                if (![Utility isEmptyCheck:self->dropdownDataArray] && self->selectedIndex >= 0 && self->selectedIndex < self->dropdownDataArray.count) {
                    dict = [self->dropdownDataArray objectAtIndex:self->selectedIndex];
                }
                //ah goal
                
                [self->table reloadData];
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([self->delegate respondsToSelector:@selector(didSelectAnyDropdownOptionMultiSelect:data:isAdd:)]) {
                        [self->delegate didSelectAnyDropdownOptionMultiSelect:self->apiType data:dict isAdd:isAdd];
                    }
                    
                    //chayan
                    else if ([delegate respondsToSelector:@selector(didSelectAnyDropdownOptionMultiSelect:isAdd:)]){
                        [delegate didSelectAnyDropdownOptionMultiSelect:dict isAdd:isAdd];
                    }
                }];
            }else{
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([delegate respondsToSelector:@selector(dropdownSelected: sender: type:)]) {
                        NSMutableArray *array = [[NSMutableArray alloc]init];
                        for (NSNumber *i in multiselectedArray) {
                            [array addObject:[dropdownDataArray objectAtIndex:[i integerValue]]];
                        }
                        if (array.count > 0) {
                            [delegate dropdownSelected:[array componentsJoinedByString:@", "] sender:sender type:apiType];
                        }else{
                            [delegate dropdownSelected:@"" sender:sender type:apiType];
                        }
                    }
                    [table reloadData];

                }];
            }
        }else{
            self->selectedIndex = (int) indexPath.row;
            if(self->sender && (![Utility isEmptyCheck:mainKey] || ![Utility isEmptyCheck:self->subKey])){
                NSDictionary *dict = [self->dropdownDataArray objectAtIndex:self->selectedIndex];
                [self->table reloadData];
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([self->delegate respondsToSelector:@selector(didSelectAnyDropdownOption:data: sender:)]) {
                        [self->delegate didSelectAnyDropdownOption:apiType data:dict sender:self->sender];
                    }
                }];
            }else if (![Utility isEmptyCheck:self->mainKey] || ![Utility isEmptyCheck:self->subKey]) {
                NSDictionary *dict = [self->dropdownDataArray objectAtIndex:self->selectedIndex];
                [self->table reloadData];
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([self->delegate respondsToSelector:@selector(didSelectAnyDropdownOption:data:)]) {
                        [self->delegate didSelectAnyDropdownOption:self->apiType data:dict];
                    }
                }];
            }else{
                [self->table reloadData];
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([self->delegate respondsToSelector:@selector(dropdownSelected: sender:type:)]) {
//                        if ([[self->dropdownDataArray objectAtIndex:self->selectedIndex] isEqual:@"Prompt of the Day"]) {
//
//                            [self->delegate dropdownSelected:self->userPromptRandom sender:self->sender type:self->apiType];
//                        }else{
                            [self->delegate dropdownSelected:[self->dropdownDataArray objectAtIndex:self->selectedIndex ] sender:self->sender type:self->apiType];
//                        }
                        
                    }
                    
                    //chayan : 21/9/2017
                    else if ([delegate respondsToSelector:@selector(tagSelected:)]){
                        [delegate tagSelected:selectedIndex];
                    }
                    //chayan 30/10/2017
                    else if ([delegate respondsToSelector:@selector(tagSelected:type:)]){
                        [delegate tagSelected:selectedIndex type:apiType];
                    }
                    else{
                        NSString *str = [dropdownDataArray objectAtIndex:selectedIndex];
                        [delegate didSelectAnyDropdownOption:str data:nil];
                    }

                }];
            }
        }

        
    });
}
#pragma mark -IBAction
- (IBAction)checkUncheckButtonPressed:(UIButton *)sender1{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->multiSelect) {
            self->selectedIndex = (int) sender1.tag;
            if ([self->multiselectedArray containsObject:[NSNumber numberWithInteger:sender1.tag]]) {
                [self->multiselectedArray removeObject:[NSNumber numberWithInteger:sender1.tag]];
                self->isAdd = NO;
            }else{
                [self->multiselectedArray addObject:[NSNumber numberWithInteger:sender1.tag]];
                self->isAdd = YES;
            }
            if (![Utility isEmptyCheck:mainKey] || ![Utility isEmptyCheck:self->subKey]) {
                
                [self->table reloadData];
                //                NSDictionaself->ry *dict = [dropdownDataArray objectAtIndex:selectedIndex];
                
                //ah goal
                NSDictionary *dict = [[NSDictionary alloc] init];
                if (![Utility isEmptyCheck:dropdownDataArray] && selectedIndex >= 0 && selectedIndex < self->dropdownDataArray.count) {
                    dict = [dropdownDataArray objectAtIndex:self->selectedIndex];
                }
                //ah goal
                
                [table reloadData];
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([delegate respondsToSelector:@selector(didSelectAnyDropdownOptionMultiSelect:data:isAdd:)]) {
                        [delegate didSelectAnyDropdownOptionMultiSelect:apiType data:dict isAdd:isAdd];
                    }
                    
                    //chayan
                    else if ([delegate respondsToSelector:@selector(didSelectAnyDropdownOptionMultiSelect:isAdd:)]){
                        [delegate didSelectAnyDropdownOptionMultiSelect:dict isAdd:isAdd];
                    }
                }];
            }else{
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([delegate respondsToSelector:@selector(dropdownSelected: sender:type:)]) {
                        NSMutableArray *array = [[NSMutableArray alloc]init];
                        for (NSNumber *i in multiselectedArray) {
                            [array addObject:[dropdownDataArray objectAtIndex:[i integerValue]]];
                        }
                        if (array.count > 0) {
                            [delegate dropdownSelected:[array componentsJoinedByString:@", "] sender:sender type:apiType];
                        }else{
                            [delegate dropdownSelected:userPromptRandom sender:sender type:apiType];
                        }
                    }
                    [table reloadData];
                    
                }];
            }
        }else{
            selectedIndex = (int) sender1.tag;
            if(sender && (![Utility isEmptyCheck:mainKey] || ![Utility isEmptyCheck:subKey])){
                NSDictionary *dict = [dropdownDataArray objectAtIndex:selectedIndex];
                [table reloadData];
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([delegate respondsToSelector:@selector(didSelectAnyDropdownOption:data: sender:)]) {
                        [delegate didSelectAnyDropdownOption:apiType data:dict sender:sender];
                    }
                }];
            }else if (![Utility isEmptyCheck:mainKey] || ![Utility isEmptyCheck:subKey]) {
                NSDictionary *dict = [dropdownDataArray objectAtIndex:selectedIndex];
                [table reloadData];
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([self->delegate respondsToSelector:@selector(didSelectAnyDropdownOption:data:)]) {
                        [self->delegate didSelectAnyDropdownOption:apiType data:dict];
                    }
                }];
            }else{
                [self->table reloadData];
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([self->delegate respondsToSelector:@selector(dropdownSelected: sender:type:)]) {
//                        if ([[self->dropdownDataArray objectAtIndex:self->selectedIndex] isEqual:@"Prompt of the Day"]) {
//
//                            [self->delegate dropdownSelected:self->userPromptRandom sender:self->sender type:self->apiType];
//                        }else{
                        [self->delegate dropdownSelected:[dropdownDataArray objectAtIndex:selectedIndex ] sender:self->sender type:self->apiType];
//                        }
                    }
                    //chayan : 21/9/2017
                    else if ([delegate respondsToSelector:@selector(tagSelected:)]){
                        [delegate tagSelected:selectedIndex];
                    }
                    //chayan 30/10/2017
                    else if ([delegate respondsToSelector:@selector(tagSelected:type:)]){
                        [delegate tagSelected:selectedIndex type:apiType];
                    }
                }];
            }
        }
        
        
    });
}
- (IBAction)cancelButtonPressed:(UIButton *)sender1 {
    if ([delegate respondsToSelector:@selector(didCancelDropdownOption)]) {
        [delegate didCancelDropdownOption];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -End

@end
