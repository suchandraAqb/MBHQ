//
//  ExerciseEditTableViewCell.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 08/03/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "ExerciseEditTableViewCell.h"
#import "ExSubEditTableViewCell.h"
#import "ExerciseEditView.h"
static NSString *SectionHeaderViewIdentifier = @"ExerciseEditView";

@implementation ExerciseEditTableViewCell{
    IBOutlet UITableView *exSubTable;
    NSArray *typeDetailsArray;
    NSArray *targetArray;
    NSInteger selectedRow;
}
@synthesize delegate;
-(void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)setUpView:(NSArray*)typeArr{
    typeDetailsArray = [typeArr mutableCopy];
    selectedRow = -1;
    [exSubTable reloadData];
}
#pragma mark - TableView DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return typeDetailsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExSubEditTableViewCell *cell = [exSubTable dequeueReusableCellWithIdentifier:@"ExSubEditTableViewCell"];
    if (cell == nil ) {
        cell = [[ExSubEditTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExSubEditTableViewCell"];
    }

    cell.exSubLabel.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    if (selectedRow == indexPath.row) {
        cell.subView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
        cell.tickView.hidden = false;
        cell.tickViewWidthConstant.constant= 35;
        cell.exSubLabel.textColor = [UIColor whiteColor];
    }else{
        cell.subView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        cell.subView.layer.borderColor = [Utility colorWithHexString:@"231f20"].CGColor;
        cell.subView.layer.borderWidth=1.49;
        cell.tickView.hidden = true;
        cell.tickViewWidthConstant.constant = 0;
        cell.exSubLabel.textColor = [Utility colorWithHexString:@"58595b"];
        
    }
    if (![Utility isEmptyCheck:typeDetailsArray]) {
         cell.exSubLabel.text = [[typeDetailsArray objectAtIndex:indexPath.row]objectForKey:@"ExerciseName"];
    }
    [cell setNeedsLayout];
    [cell setNeedsUpdateConstraints];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedRow = indexPath.row;
    int indexValue = (int)indexPath.row;
    [exSubTable reloadData];
    [self.delegate selecedData:indexValue];
}

@end
