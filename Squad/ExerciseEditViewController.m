//
//  ExerciseEditViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 08/03/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "ExerciseEditViewController.h"
#import "ExerciseEditView.h"
//#import "TargetAreaView.h"
#import "ExSubEditTableViewCell.h"
static NSString *SectionHeaderViewIdentifier = @"ExerciseEditView";
//static NSString *ViewIdentifier = @"TargetAreaView";

@interface ExerciseEditViewController ()
{
    IBOutlet UITableView *exerciseEditTable;
    IBOutlet UILabel *selectedExercisename;
    IBOutlet UILabel *replaceExerciseLabel;
    IBOutlet UIButton *applyButton;
    IBOutlet UILabel *applyTextLabel;
    IBOutlet UIView *applyLineView;
    NSArray *exerciseEditArray;
    NSMutableArray  *arrayForBool;
    NSMutableArray  *arrayForSubBool;;
    NSArray *substituteEquipments;
    NSArray *AltBodyWeightExercises;
    NSMutableArray *exerciseListArray;
    NSArray *targetArray;
    NSArray *lowerBodyArray;
    NSArray *upperBodyArray;
    NSArray *coreArray;
    UIView *contentView;
    int apiCount;
    NSInteger indexValue;
    NSInteger selectedSubIndex;
    NSInteger selectedSubRow;
    NSInteger selectedSecion;
    NSInteger selectedRow;
}
@end

@implementation ExerciseEditViewController
@synthesize circuitDict,exercisedelegate;

#pragma mark - Private Function
-(void)getExerciseList {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
             apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];   //ah 17
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:@"" forKey:@"SearchText"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSURLSession *exListUrlSession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetExercises" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[exListUrlSession dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 dispatch_async(dispatch_get_main_queue(),^ {
                                                                     apiCount--;
                                                                     if (contentView && apiCount == 0) {
                                                                         [contentView removeFromSuperview];
                                                                     }
                                                                     if(error == nil)
                                                                     {
                                                                         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [exerciseListArray removeAllObjects];
                                                                             [exerciseListArray addObjectsFromArray:[responseDictionary objectForKey:@"Exercises"]];
                                                                             if (apiCount == 0) {
                                                                                 [exerciseEditTable reloadData];
                                                                             }
                                                                         }else{
                                                                             [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                         
                                                                     }else{
                                                                         [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                     }
                                                                 });
                                                             }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

-(void)getTargetExercises {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        
        NSURLSession *exListUrlSession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetTargetExercises" append:[@"" stringByAppendingFormat:@"%@", [defaults objectForKey:@"ABBBCOnlineUserId"]] forAction:@"GET"];
        NSURLSessionDataTask * dataTask =[exListUrlSession dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 dispatch_async(dispatch_get_main_queue(),^ {
                                                                     apiCount--;
                                                                     if (contentView && apiCount == 0) {
                                                                         [contentView removeFromSuperview];
                                                                     }
                                                                     if(error == nil)
                                                                     {
                                                                         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             NSArray *objArray = [responseDictionary objectForKey:@"obj"];
                                                                             
                                                                             NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"LowerBody == true"];
                                                                             lowerBodyArray = [objArray filteredArrayUsingPredicate:newPredicate];
                                                                             
                                                                             NSPredicate *upperPredicate = [NSPredicate predicateWithFormat:@"UpperBody == true"];
                                                                             upperBodyArray = [objArray filteredArrayUsingPredicate:upperPredicate];
                                                                             
                                                                             NSPredicate *corePredicate = [NSPredicate predicateWithFormat:@"Core == true"];
                                                                             coreArray = [objArray filteredArrayUsingPredicate:corePredicate];
                                                                             
                                                                             if (apiCount == 0) {
                                                                                 [exerciseEditTable reloadData];
                                                                             }
                                                                             
                                                                         }else{
                                                                             [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                         
                                                                     }else{
                                                                         [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                     }
                                                                 });
                                                             }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

-(IBAction)headerButtonTapped:(UIButton*)sender{
    selectedSubIndex = -1;
    if ([arrayForBool containsObject:[NSNumber numberWithBool:YES]]) {
        NSInteger indexBool = [arrayForBool indexOfObject:[NSNumber numberWithBool:YES]];
        NSInteger mainIndexValue = sender.tag;
        if (indexBool != mainIndexValue) {
            [arrayForBool replaceObjectAtIndex:indexBool withObject:[NSNumber numberWithBool:NO]];
        }
    }
    BOOL isExpandable = [[arrayForBool objectAtIndex:sender.tag]boolValue];
    [arrayForBool replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithBool:!isExpandable]];
    [exerciseEditTable reloadData];
}
-(IBAction)expandButtonPressed:(UIButton*)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:exerciseEditTable];
    NSIndexPath *indexPath = [exerciseEditTable indexPathForRowAtPoint:buttonPosition];
    ExerciseEditTableViewCell *cell = (ExerciseEditTableViewCell *)[exerciseEditTable cellForRowAtIndexPath:indexPath];
    [cell.outerStack insertArrangedSubview:cell.subView atIndex:1];
    NSArray *temparr;
    selectedSubIndex = sender.tag;
    if (sender.tag == 0) {
        temparr = [lowerBodyArray mutableCopy];
    }else if (sender.tag == 1){
        temparr = [upperBodyArray mutableCopy];
    }else if (sender.tag == 2){
        temparr = [coreArray mutableCopy];
    }
    [cell setNeedsLayout];
    [cell setNeedsUpdateConstraints];
    [exerciseEditTable reloadData];
    [(ExerciseEditTableViewCell*)cell setUpView:temparr];
}
-(void)getSelectedExercise{
    applyButton.userInteractionEnabled = true;
    applyTextLabel.textColor = [UIColor whiteColor];
    applyLineView.backgroundColor = [UIColor whiteColor];
    NSString *exName=@"";
    if (selectedSecion == 0){
       exName = [[substituteEquipments objectAtIndex:selectedRow]objectForKey:@"SubstituteExerciseName"];
    }else if (selectedSecion == 1){
       exName = [[AltBodyWeightExercises objectAtIndex:selectedRow]objectForKey:@"BodyWeightAltExerciseName"];

    }else if (selectedSecion == 2){
            if (selectedSubIndex == 0) {
            exName = [[lowerBodyArray objectAtIndex:selectedSubRow]objectForKey:@"ExerciseName"];
        }else if (selectedSubIndex == 1){
            exName = [[upperBodyArray objectAtIndex:selectedSubRow]objectForKey:@"ExerciseName"];
        }else{
            exName = [[coreArray objectAtIndex:selectedSubRow]objectForKey:@"ExerciseName"];
        }
        
    }else if(selectedSecion == 3){
        exName = [[substituteEquipments objectAtIndex:selectedRow]objectForKey:@"SubstituteExerciseName"];
    }else{
        exName = [[exerciseListArray objectAtIndex:selectedRow]objectForKey:@"ExerciseName"];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[@"YOU’VE SELECTED:"uppercaseString]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-ExtraLight" size:16] range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"231f20"] range:NSMakeRange(0, [attributedString length])];
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[@""stringByAppendingFormat:@"\n%@",[exName uppercaseString]]];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:20] range:NSMakeRange(0, [attributedString2 length])];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"E425A0"] range:NSMakeRange(0, [attributedString2 length])];
    
    [attributedString appendAttributedString:attributedString2];
    selectedExercisename.attributedText = attributedString;
}
#pragma mark - End

#pragma mark - IBAction

-(IBAction)applyButtonTapped:(id)sender{
    if ((selectedSecion >=0 && selectedRow >=0)|| selectedSubRow>=0) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSMutableDictionary *replacedetailsDict = [[NSMutableDictionary alloc]init];
            NSDictionary *subDict;
            if (selectedSecion == 0) {//EquipMent
                subDict = [substituteEquipments objectAtIndex:selectedRow];
                [replacedetailsDict setObject:[subDict objectForKey:@"SubstituteExerciseName"]forKey:@"ExerciseName"];
                [replacedetailsDict setObject:[subDict objectForKey:@"SubstituteExerciseId"] forKey:@"ExerciseId"];
                
            }else if (selectedSecion == 1){//BodyWeight
                subDict = [AltBodyWeightExercises objectAtIndex:selectedRow];
                [replacedetailsDict setObject:[subDict objectForKey:@"BodyWeightAltExerciseName"] forKey:@"ExerciseName"];
                [replacedetailsDict setObject:[subDict objectForKey:@"BodyWeightAltExerciseId"] forKey:@"ExerciseId"];
                
            }else if(selectedSecion == 2){//Target
                if (selectedSubIndex == 0) { //LowerBody
                    subDict = [lowerBodyArray objectAtIndex:selectedSubRow];
                }else if (selectedSubIndex == 1){
                    subDict = [upperBodyArray objectAtIndex:selectedSubRow];
                }else{
                    subDict = [coreArray objectAtIndex:selectedSubRow];
                }
                [replacedetailsDict setObject:[subDict objectForKey:@"ExerciseName"] forKey:@"ExerciseName"];
                [replacedetailsDict setObject:[subDict objectForKey:@"ExerciseId"] forKey:@"ExerciseId"];
                
            }else if (selectedSecion == 3){//Standard
                subDict = [substituteEquipments objectAtIndex:selectedRow];
                [replacedetailsDict setObject:[subDict objectForKey:@"SubstituteExerciseName"]forKey:@"ExerciseName"];
                [replacedetailsDict setObject:[subDict objectForKey:@"SubstituteExerciseId"] forKey:@"ExerciseId"];
                
            }else{ //All
                subDict = [exerciseListArray objectAtIndex:selectedRow];
                [replacedetailsDict setObject:[subDict objectForKey:@"ExerciseName"] forKey:@"ExerciseName"];
                [replacedetailsDict setObject:[subDict objectForKey:@"ExerciseId"] forKey:@"ExerciseId"];
            }
            if ([exercisedelegate respondsToSelector:@selector(selecedExerciseData:)]) {
                [exercisedelegate selecedExerciseData:replacedetailsDict];
            }
            [[self navigationController] popViewControllerAnimated:YES];
            
        });
    }
}

#pragma mark - End

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    arrayForBool=[[NSMutableArray alloc]init];
    arrayForSubBool = [[NSMutableArray alloc]init];
    exerciseListArray = [[NSMutableArray alloc]init];
    lowerBodyArray = [[NSArray alloc]init];
    upperBodyArray = [[NSArray alloc]init];
    coreArray = [[NSArray alloc]init];
    exerciseEditTable.estimatedSectionHeaderHeight = 50;
    exerciseEditTable.sectionHeaderHeight = UITableViewAutomaticDimension;
    exerciseEditTable.estimatedRowHeight = 45;
    exerciseEditTable.rowHeight = UITableViewAutomaticDimension;
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ExerciseEditView" bundle:nil];
    [exerciseEditTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
//    UINib *viewNib = [UINib nibWithNibName:@"TargetAreaView" bundle:nil];
//    [exerciseEditTable registerNib:viewNib forHeaderFooterViewReuseIdentifier:ViewIdentifier];
    
    selectedExercisename.text = @"";
    if (![Utility isEmptyCheck:[circuitDict objectForKey:@"ExerciseName"]]) {
        replaceExerciseLabel.text =[[@"" stringByAppendingFormat:@"REPLACE %@",[circuitDict objectForKey:@"ExerciseName"]]uppercaseString];
    }

    exerciseEditArray = [[NSArray alloc]initWithObjects:@"EQUIPMENT BASED ALTERNATIVES",@"BODY WEIGHT ALTERNATIVES",@"TARGET AREA",@"STANDARD EXERCISES",@"All EXERCISES", nil];
    targetArray = [[NSArray alloc]initWithObjects:@"LOWER BODY",@"UPPER BODY",@"CORE", nil];

    if (![Utility isEmptyCheck:circuitDict]) {
        if (![Utility isEmptyCheck:[circuitDict objectForKey:@"SubstituteExercises"]]) {
            substituteEquipments = [circuitDict objectForKey:@"SubstituteExercises"];
        }
        if (![Utility isEmptyCheck:[circuitDict objectForKey:@"AltBodyWeightExercises"]]) {
            AltBodyWeightExercises = [circuitDict objectForKey:@"AltBodyWeightExercises"];
        }
    }
    if (![Utility isEmptyCheck:arrayForBool] && arrayForBool.count>0) {
        [arrayForBool removeAllObjects];
    }
    for (int i=0; i<[exerciseEditArray count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    for (int j=0; j<targetArray.count; j++) {
        [arrayForSubBool addObject:[NSNumber numberWithBool:NO]];
    }
    apiCount= 0;
    selectedSubIndex = -1;
    selectedSecion = -1;
    applyButton.userInteractionEnabled = false;
    applyTextLabel.textColor = [Utility colorWithHexString:@"f087cb"];
    applyLineView.backgroundColor = [Utility colorWithHexString:@"f087cb"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getExerciseList];
            [self getTargetExercises];
         });
}

#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - End

#pragma mark -  TableView Datasource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return exerciseEditArray.count;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ExerciseEditView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    headerView.headerButton.tag = section;
    [headerView.headerButton addTarget:self action:@selector(headerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    headerView.exerciseTypeLabel.text = [exerciseEditArray objectAtIndex:section];
    
    if (section == 0) {
        if (![Utility isEmptyCheck:substituteEquipments]) {
            headerView.arrowImage.alpha = 1;
            headerView.userInteractionEnabled = true;
            
        }else{
            headerView.arrowImage.alpha = 0.5;
            headerView.userInteractionEnabled = false;
        }
    }else if (section == 1){
        if (![Utility isEmptyCheck:AltBodyWeightExercises]) {
            headerView.arrowImage.alpha = 1;
            headerView.userInteractionEnabled = true;
            
        }else{
            headerView.arrowImage.alpha = 0.5;
            headerView.userInteractionEnabled = false;
        }
    }else if (section == 2){
        if (![Utility isEmptyCheck:targetArray]) {
            headerView.arrowImage.alpha = 1;
            headerView.userInteractionEnabled = true;
            
        }else{
            headerView.arrowImage.alpha = 0.5;
            headerView.userInteractionEnabled = false;
            
        }
    }else if (section == 3){
        if (![Utility isEmptyCheck:AltBodyWeightExercises]) {
            headerView.arrowImage.alpha = 1;
            headerView.userInteractionEnabled = true;
            
        }else{
            headerView.arrowImage.alpha = 0.5;
            headerView.userInteractionEnabled = false;
            
        }
    }else  if (section == 4){
        if (![Utility isEmptyCheck:exerciseListArray]) {
            headerView.arrowImage.alpha = 1;
            headerView.userInteractionEnabled = true;
            
        }else{
            headerView.arrowImage.alpha = 0.5;
            headerView.userInteractionEnabled = false;
            
        }
    }
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        headerView.sectionDividerView.hidden = true;
        headerView.arrowImage.image = [UIImage imageNamed:@"exedit_pink_up.png"];
    }else{
        headerView.sectionDividerView.hidden = false;
        headerView.arrowImage.image = [UIImage imageNamed:@"exedit_pink_dropdown.png"];
    }
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        if ([[arrayForBool objectAtIndex:section] boolValue]) {
            if (section == 0) {
                return substituteEquipments.count;
            }else if (section == 1) {
                return AltBodyWeightExercises.count;
            }else if (section == 2) {
                return targetArray.count;
            }else if (section == 3) {
                return substituteEquipments.count;
            }else {
                return exerciseListArray.count;
            }
        }else{
            return 0;
        }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier =@"ExerciseEditTableViewCell";
    ExerciseEditTableViewCell *cell = (ExerciseEditTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[ExerciseEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
 
    cell.mainView.layer.borderColor = [Utility colorWithHexString:@"231f20"].CGColor;
    cell.mainView.layer.borderWidth=1.49;
    cell.mainView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    cell.exerciseName.textColor = [Utility colorWithHexString:@"58595B"];
    
    cell.tickView.hidden = true;
    cell.tickViewWeightConstant.constant  = 0;
    cell.dropImage.hidden = true;
    cell.exerciseName.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    if (selectedSecion == indexPath.section && selectedRow == indexPath.row) {
        cell.tickView.hidden = false;
        cell.tickViewWeightConstant.constant = 35;
        cell.mainView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
        cell.exerciseName.textColor = [UIColor whiteColor];
        [self getSelectedExercise];
       
    }else{
        cell.tickView.hidden = true;
        cell.tickViewWeightConstant.constant = 0;
        cell.mainView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        cell.exerciseName.textColor = [Utility colorWithHexString:@"58595b"];
    }
    
    if (indexPath.section == 0) {
        cell.expandButton.hidden = true;
        cell.exerciseName.text = [[substituteEquipments objectAtIndex:indexPath.row]objectForKey:@"SubstituteExerciseName"];
        [cell.outerStack removeArrangedSubview:cell.subView];
        [cell.subView removeFromSuperview];
    }else if (indexPath.section == 1){
        cell.expandButton.hidden = true;
        cell.exerciseName.text = [[AltBodyWeightExercises objectAtIndex:indexPath.row]objectForKey:@"BodyWeightAltExerciseName"];
        [cell.outerStack removeArrangedSubview:cell.subView];
        [cell.subView removeFromSuperview];

    }else if (indexPath.section == 2){
        cell.expandButton.hidden = false;
        cell.exerciseName.text = [targetArray objectAtIndex:indexPath.row];
//        [cell.outerStack removeArrangedSubview:cell.subView];
//        [cell.subView removeFromSuperview];
        cell.tickView.hidden = true;
        cell.tickViewWeightConstant.constant  = 0;
        cell.dropImage.hidden = false;

        cell.expandButton.tag = indexPath.row;
        cell.mainView.layer.backgroundColor = [Utility colorWithHexString:@"bbbdbf"].CGColor;
        cell.mainView.layer.borderColor = [UIColor clearColor].CGColor;
        cell.exerciseName.textColor = [UIColor whiteColor];
        cell.delegate = self;

        if (selectedSubIndex == indexPath.row) {
            if (cell.detailsViewHeight.constant == 0) {
                cell.detailsViewHeight.constant=184;
            }else{
                cell.detailsViewHeight.constant=0;
            }
        }else{
            cell.detailsViewHeight.constant = 0;
        }
        [cell.outerStack insertArrangedSubview:cell.subView atIndex:1];
        [cell.expandButton addTarget:self action:@selector(expandButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if (indexPath.section == 3){
        cell.expandButton.hidden = true;
        cell.exerciseName.text = [[substituteEquipments objectAtIndex:indexPath.row]objectForKey:@"SubstituteExerciseName"];
        [cell.outerStack removeArrangedSubview:cell.subView];
        [cell.subView removeFromSuperview];
        
    }else if (indexPath.section == 4){
        cell.expandButton.hidden = true;
        cell.exerciseName.text = [[exerciseListArray objectAtIndex:indexPath.row] objectForKey:@"ExerciseName"];
        [cell.outerStack removeArrangedSubview:cell.subView];
        [cell.subView removeFromSuperview];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ExerciseEditTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    selectedSecion = indexPath.section;
    selectedRow = indexPath.row;
    [exerciseEditTable reloadData];
}
#pragma mark - End

#pragma mark - ExerciseEditProtocol

-(void)selecedData:(int)index{
    selectedSubRow = index;
    selectedSecion = 2;
    [self getSelectedExercise];
    NSLog(@"%d",index);
}

@end
