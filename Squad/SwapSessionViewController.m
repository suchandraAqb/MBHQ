//
//  SwapSessionViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 04/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "SwapSessionViewController.h"
#import "ExerciseDetailsTableViewCell.h"

@interface SwapSessionViewController (){
    
    __weak IBOutlet UITableView *table;
    
}

@end

@implementation SwapSessionViewController
@synthesize delegate,sessionArray,swapDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    table.estimatedRowHeight = 35;
    table.rowHeight = UITableViewAutomaticDimension;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [table reloadData];
}
- (IBAction)crossButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -TableView Delegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sessionArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"ExerciseDetailsTableViewCell";
    ExerciseDetailsTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ExerciseDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.exerciseName.text = ![Utility isEmptyCheck:sessionArray[indexPath.row][@"ExerciseSessionDetails"][@"SessionTitle"]]?sessionArray[indexPath.row][@"ExerciseSessionDetails"][@"SessionTitle"]:@"";
    cell.detailsView.layer.borderWidth = 1;
    cell.detailsView.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    cell.detailsView.layer.masksToBounds = YES;
    cell.detailsView.layer.cornerRadius = 5;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self->delegate respondsToSelector:@selector(swapSessionPressed:swapDate:)]) {
                [self->delegate swapSessionPressed:self->sessionArray[indexPath.row] swapDate:self->swapDate];
            }
        }];
    });
}
#pragma mark -End


@end
