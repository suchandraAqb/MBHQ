//
//  ExerciseListTableViewCell.m
//  Squad
//
//  Created by AQB Mac 4 on 19/01/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "ExerciseListTableViewCell.h"
#import "Utility.h"
#import "EquipmentRequiredTableViewCell.h"
#import "EquipmentBasedTableViewCell.h"
#import "BodyWeightTableViewCell.h"
#import "IndividualExerciseViewController.h"
#import "ExerciseListViewController.h"

@implementation ExerciseListTableViewCell{
    int count;
    NSArray *equipments;
    NSArray *substituteEquipments;
    NSArray *AltBodyWeightExercises;
    int exerId;
    NSString *str;
}
@synthesize delegate;
-(void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    [self.eqRequirdTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL]; //add_add
    [self.eqBasedtable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [self.bodyWeightTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    UIView *cellContentView = self.contentView;
    cellContentView.translatesAutoresizingMaskIntoConstraints = false;
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[cellContentView]|"
                          options:0
                          metrics:0
                          views:NSDictionaryOfVariableBindings(cellContentView)]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|[cellContentView]|"
                          options:0
                          metrics:0
                          views:NSDictionaryOfVariableBindings(cellContentView)]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    
//    UIView * selectedBackgroundView = [[UIView alloc] init];
//    [selectedBackgroundView setBackgroundColor:[Utility colorWithHexString:@"7dc8dd"]]; // set color here
//    [self setSelectedBackgroundView:selectedBackgroundView];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([Utility isEmptyCheck:equipments] && [Utility isEmptyCheck:substituteEquipments]  && [Utility isEmptyCheck:AltBodyWeightExercises] ) {
        self.detailsview.hidden = true;
        self.detailsViewHeight.constant = 0;
    }else{
        self.detailsview.hidden = false;
        
        if ([str isEqualToString:@"Required"]) {
            self.detailsViewHeight.constant = self.eqRequirdTable.contentSize.height + 60;
            //            self.totalDetailsHeightConstant.constant = _playerContainer.frame.size.height+self.eqRequirdTable.contentSize.height+60;
        }else if ([str isEqualToString:@"Based"]){
            self.detailsViewHeight.constant = self.eqBasedtable.contentSize.height + 60;
            //            self.totalDetailsHeightConstant.constant = _playerContainer.frame.size.height+self.eqBasedtable.contentSize.height+60;
        }else if ([str isEqualToString:@"W"]){
            self.detailsViewHeight.constant = self.bodyWeightTable.contentSize.height + 60;
            //            self.totalDetailsHeightConstant.constant =_playerContainer.frame.size.height+ self.bodyWeightTable.contentSize.height+60;
        }
//        self.totalDetailsHeightConstant.constant = _playerContainer.frame.size.height+self.detailsViewHeight.constant+70;
        
    }
    NSLog(@"DetailsView--%f",self.eqBasedtable.contentSize.height);
    NSLog(@"++++%f",self.totalDetailsHeightConstant.constant);
}
-(void)setUpView:(NSDictionary*)circuitDict{
    equipments = [circuitDict objectForKey:@"Equipments"];
    substituteEquipments = [circuitDict objectForKey:@"SubstituteExercises"];
    AltBodyWeightExercises = [circuitDict objectForKey:@"AltBodyWeightExercises"];
    str = @"";
    [self.stack removeArrangedSubview:self.equipmentRequiredView];
    [self.equipmentRequiredView removeFromSuperview];
    [self.stack removeArrangedSubview:self.equipmentBasedView];
    [self.equipmentBasedView removeFromSuperview];
    [self.stack removeArrangedSubview:self.bodyWeightView];
    [self.bodyWeightView removeFromSuperview];
   
    if (equipments.count>substituteEquipments.count) {
        count = (int)equipments.count;
        str = @"Required";
    }else{
        count = (int)substituteEquipments.count;
        str = @"Based";
    }
    if (count<AltBodyWeightExercises.count) {
        count = (int)AltBodyWeightExercises.count;
        str = @"W";
    }
     if ([Utility isEmptyCheck:equipments] && [Utility isEmptyCheck:substituteEquipments]  && [Utility isEmptyCheck:AltBodyWeightExercises] ) {
         self.detailsview.hidden = true;
         self.detailsViewHeight.constant = 0;
     }else{
         if (![Utility isEmptyCheck:equipments] && equipments.count > 0) {
             [self.stack addArrangedSubview:self.equipmentRequiredView];
             [self.eqRequirdTable reloadData];
             
         }else{
             [self.stack removeArrangedSubview:self.equipmentRequiredView];
             [self.equipmentRequiredView removeFromSuperview];
         }
         
         if (![Utility isEmptyCheck:substituteEquipments] && substituteEquipments.count>0) {
             [self.stack addArrangedSubview:self.equipmentBasedView];
             [self.eqBasedtable reloadData];
         }else{
             [self.stack removeArrangedSubview:self.equipmentBasedView];
             [self.equipmentBasedView removeFromSuperview];
         }
         if (![Utility isEmptyCheck:AltBodyWeightExercises] && AltBodyWeightExercises.count > 0) {
             [self.stack addArrangedSubview:self.bodyWeightView];
             [self.bodyWeightTable reloadData];
         }else{
             [self.stack removeArrangedSubview:self.bodyWeightView];
             [self.bodyWeightView removeFromSuperview];
         }
     }
}

#pragma mark - TableView DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.eqRequirdTable) {
        return equipments.count;
    }else if (tableView == self.eqBasedtable){
        return substituteEquipments.count;
    }else{
        return AltBodyWeightExercises.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tablecell;
    if (tableView == self.eqRequirdTable) {
        EquipmentRequiredTableViewCell *cell = [self.eqRequirdTable dequeueReusableCellWithIdentifier:@"EquipmentRequiredTableViewCell"];
        if (cell == nil ) {
            cell = [[EquipmentRequiredTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EquipmentRequiredTableViewCell"];
        }
        
        cell.eqRequired.text = [@"  \u2022  " stringByAppendingString:[equipments objectAtIndex:indexPath.row]];
        tablecell = cell;
    }else if (tableView == self.eqBasedtable){
        EquipmentBasedTableViewCell *cell2 = [self.eqBasedtable dequeueReusableCellWithIdentifier:@"EquipmentBasedTableViewCell"];
        if (cell2 == nil ) {
            cell2 = [[EquipmentBasedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EquipmentBasedTableViewCell"];
        }
        cell2.eqBased.layer.borderColor = [UIColor whiteColor].CGColor;
        cell2.eqBased.layer.borderWidth=2.0;
        cell2.eqBased.text = [[substituteEquipments objectAtIndex:indexPath.row]objectForKey:@"SubstituteExerciseName"];
        tablecell=cell2;
    }else{
        BodyWeightTableViewCell *cell3 = [self.bodyWeightTable dequeueReusableCellWithIdentifier:@"BodyWeightTableViewCell"];
        if (cell3 == nil) {
            cell3 = [[BodyWeightTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BodyWeightTableViewCell"];
        }
        cell3.weight.layer.borderColor=[UIColor whiteColor].CGColor;
        cell3.weight.layer.borderWidth=2.0;
        cell3.weight.text = [[AltBodyWeightExercises objectAtIndex:indexPath.row]objectForKey:@"BodyWeightAltExerciseName"];
        tablecell =cell3;
    }
    [tablecell setNeedsLayout];
    [tablecell setNeedsUpdateConstraints];
    return tablecell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (tableView == self.eqBasedtable) {
            exerId = [[[substituteEquipments objectAtIndex:indexPath.row]objectForKey:@"SubstituteExerciseId"] intValue];
        }else if (tableView == self.bodyWeightTable){
            exerId = [[[AltBodyWeightExercises objectAtIndex:indexPath.row]objectForKey:@"BodyWeightAltExerciseId"] intValue];
            
        }
        [self.delegate loadNewScreen:exerId];
//        IndividualExerciseViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IndividualExercise"];
//        controller.modalPresentationStyle = UIModalPresentationCustom;
//        controller.exerciseId = exerId;
//        [self presentViewController:controller animated:YES completion:nil];
    });
}
@end
