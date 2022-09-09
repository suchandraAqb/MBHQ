//
//  AnalyzeSearchViewController.m
//  Squad
//
//  Created by aqbsol iPhone on 28/05/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "AnalyzeSearchViewController.h"
#import "AnalyseTableViewCell.h"

@interface AnalyzeSearchViewController (){

    __weak IBOutlet UIImageView *arrowImage;
    __weak IBOutlet UITableView *analyseTable;
    __weak IBOutlet NSLayoutConstraint *analyseTableHeight;
    __weak IBOutlet UIView *tableSuperView;
    
    __weak IBOutlet UIScrollView *mainScroll;
    __weak IBOutlet UIView *saveAnalyseView;
    
    __weak IBOutlet UIButton *analyseButton;
    __weak IBOutlet UIButton *calHistoryButton;
    __weak IBOutlet UIView *analyseView;
    __weak IBOutlet UIView *historyView;
    IBOutletCollection(UIButton) NSArray *calToFromButton;
    __weak IBOutlet UIView *calListView;
    __weak IBOutlet UITableView *calTable;
    __weak IBOutlet UILabel *calHeaderLabel;
    
    __weak IBOutlet UIButton *lastDayButton;
    __weak IBOutlet UIButton *lastWeekButton;
    __weak IBOutlet UIButton *fromDateButton;
    __weak IBOutlet UIButton *toDateButton;
    __weak IBOutlet UIButton *mealButton;
    __weak IBOutlet UIButton *ingredientsButton;
    __weak IBOutlet UIButton *emotionButton;
    
    __weak IBOutlet UIView *associatedView;
    __weak IBOutlet UILabel *associatedLabel;
    __weak IBOutlet UIButton *associatedButton;
    IBOutletCollection(UIButton) NSArray *associatedCollectionButton;
    __weak IBOutlet UIStackView *associatedStackView;
    
    __weak IBOutlet UIView *searchView;
    __weak IBOutlet UILabel *searchHeaderLabel;
    __weak IBOutlet UITextField *searchNameTextField;
    __weak IBOutlet UITableView *searchTable;
    
    __weak IBOutlet UILabel *mealHeader;
    __weak IBOutlet UILabel *ratingHeader;
    __weak IBOutlet UIButton *calShareButton;
    
    int apiCount;
    UIView *contentView;
    NSArray *dateArray;
    NSArray *weekArray;
    int foT;
    NSDateFormatter *dailyDateformatter;
    NSArray *savedSearchArray;
    NSArray *showMeTypeArray;
    NSArray *associationArray;
    NSArray *associationArrayEm;
    NSArray *searchArray;
    int avgR, mealR;
    NSString *ingrText;
    __weak IBOutlet UIButton *searchButton;
    __weak IBOutlet UIButton *saveSearchButton;
    int oldMealId;
    
    NSArray *calHistoryArray;
    IBOutlet NSLayoutConstraint *daysViewHeightConstant;
    IBOutlet NSLayoutConstraint *weeksViewheightConstant;
    IBOutlet NSLayoutConstraint *datesViewHeightConstant;
    IBOutlet UIButton *daysWeeksDatesButton;
    IBOutlet UIStackView *daysStack;
    IBOutlet UIStackView *weeksStack;
    IBOutlet UIStackView *datesStack;
    NSArray *datesWeekDropArr;
}
@end

@implementation AnalyzeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dateArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28"];
    weekArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52"];
    showMeTypeArray = @[@"MEALS",@"INGREDIENTS",@"EMOTIONS"];
    associationArray = @[@"BAD BLOATING",@"NO/LOW BLOATING",@"GOOD ENERGY",@"LOW ENERGY",@"HIGH CRAVING",@"NO/LOW CRAVING"];
    associationArrayEm = @[@"HIGH CRAVING",@"NO/LOW CRAVING",@"GOOD ENERGY",@"LOW ENERGY",@"BAD BLOATING",@"NO/LOW BLOATING"];
    dailyDateformatter = [[NSDateFormatter alloc]init];
    [dailyDateformatter setDateFormat:@"dd-MMM-yyyy"];
    analyseTable.estimatedRowHeight = 44;
    analyseTable.rowHeight = UITableViewAutomaticDimension;
    searchTable.estimatedRowHeight = 65;
    searchTable.rowHeight = UITableViewAutomaticDimension;
    calTable.estimatedRowHeight = 60;
    calTable.rowHeight = UITableViewAutomaticDimension;
    fromDateButton.layer.borderWidth = 1;
    fromDateButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    toDateButton.layer.borderWidth = 1;
    toDateButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    associatedButton.layer.borderWidth = 1;
    associatedButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    lastWeekButton.layer.borderWidth = 1;
    lastWeekButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    lastDayButton.layer.borderWidth = 1;
    lastDayButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    searchNameTextField.layer.borderWidth = 1;
    searchNameTextField.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    mealButton.layer.borderWidth = 1;
    mealButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    ingredientsButton.layer.borderWidth = 1;
    ingredientsButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    emotionButton.layer.borderWidth = 1;
    emotionButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    calShareButton.layer.borderWidth = 1;
    calShareButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    searchButton.layer.cornerRadius = 8;
    searchButton.layer.masksToBounds = YES;
    saveSearchButton.layer.cornerRadius = 8;
    saveSearchButton.layer.masksToBounds = YES;
    oldMealId = -1;
    
    saveAnalyseView.hidden = true;
//    arrowImage.hidden = true;
    tableSuperView.hidden = true;
    analyseTableHeight.constant = 0;
    associatedView.hidden = true;
    
    for (UIButton *button in associatedCollectionButton) {
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
        [button setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
    }
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    searchNameTextField.leftView = paddingView;
    searchNameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self registerForKeyboardNotifications];
    [self getSavedAnalysingNutritionSearchList];
    analyseView.hidden = false;
    historyView.hidden = true;
    [analyseButton setBackgroundColor:[UIColor whiteColor]];
    [calHistoryButton setBackgroundColor:[Utility colorWithHexString:@"F5F5F5"]];
    
    for (UIButton *button in calToFromButton) {
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
        [button setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
    }
    calListView.hidden = true;
    daysWeeksDatesButton.layer.borderColor =[Utility colorWithHexString:@"E425A0"].CGColor;
    daysWeeksDatesButton.layer.borderWidth=1;
    datesWeekDropArr = @[@"DAYS",@"WEEKS",@"DATES"];
    
}
-(void)viewWillAppear:(BOOL)animated{
    daysViewHeightConstant.constant = 0;
    weeksViewheightConstant.constant = 0;
    datesViewHeightConstant.constant = 0;
    daysStack.hidden = true;
    weeksStack.hidden = true;
    datesStack.hidden = true;
    [analyseTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [analyseTable removeObserver:self forKeyPath:@"contentSize"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == analyseTable) {
        analyseTableHeight.constant = analyseTable.contentSize.height;
    }
}
#pragma mark -IBAction

- (IBAction)savedAnalyzePressed:(UIButton *)sender {
    tableSuperView.hidden = !tableSuperView.isHidden;
    if (tableSuperView.isHidden) {
        [arrowImage setImage:[UIImage imageNamed:@"down_arr.png"]];
    } else {
        [arrowImage setImage:[UIImage imageNamed:@"fp_up_arr.png"]];
        [analyseTable reloadData];
    }
}
- (IBAction)searchNamePressed:(UIButton *)sender {
    NSDictionary *dict = savedSearchArray[sender.tag];
    NSLog(@"%@",dict);
    int consumeType = [dict[@"ConsumeType"] intValue];
    int showMeType = [dict[@"ShowMeType"]intValue];
    int associationType = [dict[@"AssociationType"]intValue];
    lastDayButton.selected = false;
    [lastDayButton setTitle:[NSString stringWithFormat:@"SELECT"] forState:UIControlStateNormal];
    lastWeekButton.selected = false;
    [lastWeekButton setTitle:[NSString stringWithFormat:@"SELECT"] forState:UIControlStateNormal];
    fromDateButton.selected = false;
    [fromDateButton setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
    toDateButton.selected = false;
    [toDateButton setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
    [lastDayButton setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
    [lastDayButton setBackgroundColor:[UIColor whiteColor]];
    [lastWeekButton setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
    [lastWeekButton setBackgroundColor:[UIColor whiteColor]];
    lastDayButton.layer.borderWidth = 1;
    lastDayButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    lastWeekButton.layer.borderWidth = 1;
    lastWeekButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    if (consumeType == 1) {
        lastDayButton.selected = true;
        [lastDayButton setTitle:[NSString stringWithFormat:@"%@",dict[@"Days"]] forState:UIControlStateNormal];
        [lastDayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [lastDayButton setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
    } else if(consumeType == 2){
        lastWeekButton.selected = true;
        [lastWeekButton setTitle:[NSString stringWithFormat:@"%@",dict[@"Weeks"]] forState:UIControlStateNormal];
        [lastWeekButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [lastWeekButton setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
    }else if(consumeType == 3){
        [dailyDateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *fDate = [dailyDateformatter dateFromString:dict[@"ConsumeFromDate"]];
        NSDate *tDate = [dailyDateformatter dateFromString:dict[@"ConsumeToDate"]];
        [dailyDateformatter setDateFormat:@"dd-MMM-yyyy"];
        fromDateButton.selected = true;
        NSString *sDate = [dailyDateformatter stringFromDate:fDate];
        [fromDateButton setTitle:[NSString stringWithFormat:@"%@",sDate] forState:UIControlStateNormal];
        toDateButton.selected = true;
        sDate = [dailyDateformatter stringFromDate:tDate];
        [toDateButton setTitle:[NSString stringWithFormat:@"%@",sDate] forState:UIControlStateNormal];
        

    }
    mealButton.selected = false;
    ingredientsButton.selected = false;
    emotionButton.selected = false;
    [mealButton setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
    [mealButton setBackgroundColor:[UIColor whiteColor]];
    [ingredientsButton setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
    [ingredientsButton setBackgroundColor:[UIColor whiteColor]];
    [emotionButton setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
    [emotionButton setBackgroundColor:[UIColor whiteColor]];
    mealButton.layer.borderWidth = 1;
    mealButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    ingredientsButton.layer.borderWidth = 1;
    ingredientsButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    emotionButton.layer.borderWidth = 1;
    emotionButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    if (showMeType == 1) {
        mealButton.selected = true;
        [mealButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [mealButton setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
    } else if (showMeType == 2) {
        ingredientsButton.selected = true;
        [ingredientsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ingredientsButton setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
    } else if (showMeType == 3) {
        emotionButton.selected = true;
        [emotionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [emotionButton setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
    }
    if (showMeType == 3) {
        [associatedButton setTitle:[NSString stringWithFormat:@"%@",associationArrayEm[(associationType - 1)]] forState:UIControlStateNormal];
    } else {
        [associatedButton setTitle:[NSString stringWithFormat:@"%@",associationArray[(associationType - 1)]] forState:UIControlStateNormal];
    }
    [associatedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [associatedButton setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
    int bNo = -1;
    for (UIButton *btn in associatedCollectionButton) {
        [btn setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.selected = false;
        if (showMeType == 1 || showMeType == 2) {
            if(btn == associatedCollectionButton[(associationType - 1)]){
                btn.selected = true;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
            }
        }
        
    }
    if(showMeType == 3){
        if(associationType == 1){
            bNo = 4;
        }else if (associationType == 2){
            bNo = 5;
        }else if (associationType == 3){
            bNo = 2;
        }else if (associationType == 4){
            bNo = 3;
        }else if (associationType == 5){
            bNo = 0;
        }else if (associationType == 6){
            bNo = 1;
        }
    }
    if(bNo != -1){
        UIButton *btn = associatedCollectionButton[bNo];
        btn.selected = true;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
    }
    associatedView.hidden = false;
//    associatedStackView.hidden = true;
    [self searchButtonPressed:nil];
}
- (IBAction)deleteButtonPressed:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"Are you sure want to delete this save search ?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSDictionary *dict = self->savedSearchArray[sender.tag];
                                   [self deleteSavedAnalysingNutritionSearch:dict[@"Id"]];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   
                               }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)inTheLastButtonPressed:(UIButton *)sender {
    
    NSDate *currentDate = [NSDate date];
    [dailyDateformatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *dateString = [dailyDateformatter stringFromDate:currentDate];
    currentDate = [dailyDateformatter dateFromString:dateString];
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
//    controller.mainKey = @"CountryName";
//    controller.apiType = @"Country";
    
    DatePickerViewController *controllerC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controllerC.modalPresentationStyle = UIModalPresentationCustom;
    controllerC.datePickerMode = UIDatePickerModeDate;
    if(sender == lastDayButton){
        controller.dropdownDataArray = dateArray;
        if ([lastDayButton.currentTitle intValue] >= 1) {
            controller.selectedIndex = (int)[lastDayButton.currentTitle intValue] - 1;
        }else{
            controller.selectedIndex = -1;
        }
        controller.apiType = @"day";
        controller.delegate = self;
        controller.sender = sender;
        [self presentViewController:controller animated:YES completion:nil];
    }else if (sender == lastWeekButton){
        controller.dropdownDataArray = weekArray;
        if ([lastWeekButton.currentTitle intValue] >= 1) {
            controller.selectedIndex = (int)[lastDayButton.currentTitle intValue] - 1;
        }else{
            controller.selectedIndex = -1;
        }
        controller.apiType = @"week";
        controller.delegate = self;
        controller.sender = sender;
        [self presentViewController:controller animated:YES completion:nil];
    }else if (sender == fromDateButton){
        foT = 1;
        if (![Utility isEmptyCheck:fromDateButton.currentTitle] ) {
            controllerC.selectedDate = [dailyDateformatter dateFromString:fromDateButton.currentTitle];
        } else {
            controllerC.selectedDate = currentDate;
        }
        controllerC.delegate = self;
        [self presentViewController:controllerC animated:YES completion:nil];
    }else {
        foT = 2;
        if (![Utility isEmptyCheck:toDateButton.currentTitle] ) {
            controllerC.selectedDate = [dailyDateformatter dateFromString:toDateButton.currentTitle];
        } else {
            controllerC.selectedDate = currentDate;
        }
        controllerC.delegate = self;
        [self presentViewController:controllerC animated:YES completion:nil];
    }
    
}

- (IBAction)lastCalButtonPressed:(UIButton *)sender {
    foT = (int)sender.tag + 3;//3,4
    NSDate *currentDate = [NSDate date];
    [dailyDateformatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *dateString = [dailyDateformatter stringFromDate:currentDate];
    currentDate = [dailyDateformatter dateFromString:dateString];
    DatePickerViewController *controllerC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controllerC.modalPresentationStyle = UIModalPresentationCustom;
    controllerC.datePickerMode = UIDatePickerModeDate;
    if (![Utility isEmptyCheck:sender.currentTitle] ) {
        controllerC.selectedDate = [dailyDateformatter dateFromString:sender.currentTitle];
    } else {
        controllerC.selectedDate = currentDate;
    }
    controllerC.delegate = self;
    [self presentViewController:controllerC animated:YES completion:nil];
}
- (IBAction)showMeButtonPressed:(UIButton *)sender {
    associatedView.hidden = false;
//    associatedStackView.hidden = true;
    
    mealButton.selected = false;
    [mealButton setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
    [mealButton setBackgroundColor:[UIColor whiteColor]];
    ingredientsButton.selected = false;
    [ingredientsButton setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
    [ingredientsButton setBackgroundColor:[UIColor whiteColor]];
    emotionButton.selected = false;
    [emotionButton setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
    [emotionButton setBackgroundColor:[UIColor whiteColor]];
    mealButton.layer.borderWidth = 1;
    mealButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    ingredientsButton.layer.borderWidth = 1;
    ingredientsButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    emotionButton.layer.borderWidth = 1;
    emotionButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    for (UIButton *button in associatedCollectionButton) {
        if (button == associatedCollectionButton[0]) {
            button.selected = true;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
        } else {
            button.selected = false;
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
            [button setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
        }
    }
    [associatedButton setTitle:@"BAD BLOATING" forState:UIControlStateNormal];
    [associatedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [associatedButton setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
    
    sender.selected = true;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
    
    NSString *txt;
    if (mealButton.isSelected) {
        txt = @"MEAL";
    } else if(ingredientsButton.isSelected){
        txt = @"INGREDIENT";
    } else if(emotionButton.isSelected){
        txt = @"EMOTION";
    }
    associatedLabel.text = [NSString stringWithFormat:@"ARE ASSOCIATED WITH %@",txt];
}
- (IBAction)associatedButtonPressed:(UIButton *)sender {
    if (sender == associatedButton) {
//        associatedStackView.hidden = !associatedStackView.isHidden;
    } else {
//        associatedStackView.hidden = true;
        sender.selected = true;
        for (UIButton *button in associatedCollectionButton) {
            if (button == sender) {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
            } else {
                button.selected = false;
                button.layer.borderWidth = 1;
                button.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
                [button setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor whiteColor]];
            }
        }
        [associatedButton setTitle:sender.currentTitle forState:UIControlStateNormal];
        [associatedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [associatedButton setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
    }
}
- (IBAction)searchButtonPressed:(UIButton *)sender {
    if(calHistoryButton.isSelected){
        BOOL isValid = false;
        for (UIButton *button in calToFromButton) {
            if (![Utility isEmptyCheck:button.currentTitle]) {
                [dailyDateformatter setDateFormat:@"dd-MMM-yyyy"];
                NSDate *date = [dailyDateformatter dateFromString:button.currentTitle];
                if (date) {
                    isValid = true;
                }else{
                    isValid = false;
                    break;
                }
            }else{
                isValid = false;
                break;
            }
        }
        if (isValid) {
            [self searchCalHistory:false];//only search
        }else{
            [Utility msg:@"Please enter date range first." title:nil controller:self haveToPop:NO];
        }
        return;
    }
    avgR = -1;
    mealR = -1;
    BOOL valid = true;
    NSString *msg;
    if(!(lastDayButton.isSelected || lastWeekButton.isSelected || (toDateButton.isSelected && fromDateButton.isSelected))){
        valid = false;
        msg = @"Please select meal i have consumed in the last.";
    }else if (!(mealButton.isSelected || ingredientsButton.isSelected || emotionButton.isSelected)){
        valid = false;
        msg = @"Please select show me Type.";
    }
    if (valid) {
        if (emotionButton.isSelected) {
            [self emotionDetailSearchApi:[self prepareForApi]];
        }else if (ingredientsButton.isSelected) {
            [self ingredientDetailSearchApi:[self prepareForApi] mealId:-1 tag:-1];
        }else{
            [self mealDetailSearchApi:[self prepareForApi]];
        }
    } else {
        [Utility msg:msg title:@"" controller:self haveToPop:NO];
    }
}
- (IBAction)saveSearchPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    if (searchNameTextField.text.length>0) {
        [self saveSearchApi:[self prepareForApi]];
    } else {
        [Utility msg:@"Please enter search name." title:@"" controller:self haveToPop:NO];
    }
}
- (IBAction)crossButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    searchView.hidden = true;
    calListView.hidden = true;
}
- (IBAction)expandAvgPressed:(UIButton *)sender {
    if (sender.isSelected) {
        avgR = -1;
        //mealR = -1;
    }else{
        avgR = (int)sender.tag;
        //mealR = (int)sender.tag;
    }
    if (mealButton.isSelected) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [searchTable reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }else if(emotionButton.selected){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [searchTable reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    
}
- (IBAction)expandMealPressed:(UIButton *)sender {
    if (sender.isSelected) {
        //avgR = -1;
        mealR = -1;
    }else{
        //avgR = (int)sender.tag;
        mealR = (int)sender.tag;
    }
//    if(ingredientsButton.isSelected){
    if([sender.accessibilityHint isEqualToString:@"Ing"]){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [searchTable reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }else if([sender.accessibilityHint isEqualToString:@"Meal"]){//(mealButton.isSelected){
        if (sender.isSelected) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
            NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
            [searchTable reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        } else {
            NSDictionary *dict = searchArray[sender.tag];
            int mealId = [dict[@"Id"] intValue];
            if (oldMealId == mealId) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
                NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
                [self->searchTable reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            } else {
                oldMealId = mealId;
                [self ingredientDetailSearchApi:[self prepareForApi] mealId:mealId tag:(int)sender.tag];
            }
            
        }
    }
}

- (IBAction)analyseAndCalHistoryPressed:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    if(sender == analyseButton){
        [analyseButton setSelected:YES];
        [calHistoryButton setSelected:NO];
        historyView.hidden = true;
        analyseView.hidden = false;
        [analyseButton setBackgroundColor:[UIColor whiteColor]];
        [calHistoryButton setBackgroundColor:[Utility colorWithHexString:@"F5F5F5"]];

    }else if(sender == calHistoryButton){
        [analyseButton setSelected:NO];
        [calHistoryButton setSelected:YES];
        historyView.hidden = false;
        analyseView.hidden = true;
        [analyseButton setBackgroundColor:[Utility colorWithHexString:@"F5F5F5"]];
        [calHistoryButton setBackgroundColor:[UIColor whiteColor]];
    }
}

- (IBAction)shareButtonPressed:(UIButton *)sender {
    if (sender.tag == 0) {
        //analyse result share
        
    }else if (sender.tag == 1){
        //cal history list share
        [self searchCalHistory:true];//true for share
    }
}
-(IBAction)daysWeeksDatesDropDownButtobPressed:(id)sender{
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = datesWeekDropArr;
    controller.sender = daysWeeksDatesButton;
    controller.selectedIndex = (int)[datesWeekDropArr indexOfObject:[sender currentTitle]];;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
#pragma mark -End
#pragma mark -Private Method
-(NSDictionary *)prepareForApi{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if (lastDayButton.isSelected) {
        [dict setObject:[NSNumber numberWithInt:1]  forKey:@"ConsumeType"];
        [dict setObject:[NSNumber numberWithInt:[lastDayButton.currentTitle intValue]]  forKey:@"Days"];
    } else if (lastWeekButton.isSelected) {
        [dict setObject:[NSNumber numberWithInt:2]  forKey:@"ConsumeType"];
        [dict setObject:[NSNumber numberWithInt:[lastWeekButton.currentTitle intValue]]  forKey:@"Weeks"];
    } else {
        if(toDateButton.isSelected && fromDateButton.isSelected){
            [dict setObject:[NSNumber numberWithInt:3]  forKey:@"ConsumeType"];
            [dailyDateformatter setDateFormat:@"dd-MMM-yyyy"];
            NSDate *fDate = [dailyDateformatter dateFromString:fromDateButton.currentTitle];
            NSDate *tDate = [dailyDateformatter dateFromString:toDateButton.currentTitle];
            [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
            NSString *sDate = [dailyDateformatter stringFromDate:fDate];
            [dict setObject:sDate  forKey:@"ConsumeFromDate"];
            sDate = [dailyDateformatter stringFromDate:tDate];
            [dict setObject:sDate  forKey:@"ConsumeToDate"];
        }
    }
    if (mealButton.isSelected) {
        [dict setObject:[NSNumber numberWithInt:1]  forKey:@"ShowMeType"];
    } else if(ingredientsButton.isSelected){
        [dict setObject:[NSNumber numberWithInt:2]  forKey:@"ShowMeType"];
    } else if(emotionButton.isSelected){
        [dict setObject:[NSNumber numberWithInt:3]  forKey:@"ShowMeType"];
    }
    
    if (mealButton.isSelected || ingredientsButton.isSelected) {
        [dict setObject:[NSNumber numberWithInt:2]  forKey:@"MealWhereType"];
        for (UIButton *btn in associatedCollectionButton) {
            if (btn == associatedCollectionButton[0] && btn.isSelected) {
                [dict setObject:[NSNumber numberWithInt:1]  forKey:@"AssociationType"];
                [dict setObject:[NSNumber numberWithBool:true]  forKey:@"AfterMeal_BloatingWere"];
                [dict setObject:[NSNumber numberWithInt:3]  forKey:@"AfterMeal_Bloating"];
                [dict setObject:[NSNumber numberWithInt:2]  forKey:@"AfterMeal_BloatingRange"];
            } else if (btn == associatedCollectionButton[1] && btn.isSelected){
                [dict setObject:[NSNumber numberWithInt:2]  forKey:@"AssociationType"];
                [dict setObject:[NSNumber numberWithBool:true]  forKey:@"AfterMeal_BloatingWere"];
                [dict setObject:[NSNumber numberWithInt:3]  forKey:@"AfterMeal_Bloating"];
                [dict setObject:[NSNumber numberWithInt:1]  forKey:@"AfterMeal_BloatingRange"];
            }
            else if (btn == associatedCollectionButton[2] && btn.isSelected){
                [dict setObject:[NSNumber numberWithInt:3]  forKey:@"AssociationType"];
                [dict setObject:[NSNumber numberWithBool:true]  forKey:@"AfterMeal_EnergyWas"];
                [dict setObject:[NSNumber numberWithInt:3]  forKey:@"AfterMeal_Energy"];
                [dict setObject:[NSNumber numberWithInt:1]  forKey:@"AfterMeal_EnergyRange"];
            } else if (btn == associatedCollectionButton[3] && btn.isSelected){
                [dict setObject:[NSNumber numberWithInt:4]  forKey:@"AssociationType"];
                [dict setObject:[NSNumber numberWithBool:true]  forKey:@"AfterMeal_EnergyWas"];
                [dict setObject:[NSNumber numberWithInt:3]  forKey:@"AfterMeal_Energy"];
                [dict setObject:[NSNumber numberWithInt:2]  forKey:@"AfterMeal_EnergyRange"];
            }
            else if (btn == associatedCollectionButton[4] && btn.isSelected){
                [dict setObject:[NSNumber numberWithInt:5]  forKey:@"AssociationType"];
                [dict setObject:[NSNumber numberWithBool:true]  forKey:@"AfterMeal_CravingsWere"];
                [dict setObject:[NSNumber numberWithInt:3]  forKey:@"AfterMeal_Craving"];
                [dict setObject:[NSNumber numberWithInt:2]  forKey:@"AfterMeal_CravingRange"];
            } else if (btn == associatedCollectionButton[5] && btn.isSelected){
                [dict setObject:[NSNumber numberWithInt:6]  forKey:@"AssociationType"];
                [dict setObject:[NSNumber numberWithBool:true]  forKey:@"AfterMeal_CravingsWere"];
                [dict setObject:[NSNumber numberWithInt:3]  forKey:@"AfterMeal_Craving"];
                [dict setObject:[NSNumber numberWithInt:1]  forKey:@"AfterMeal_CravingRange"];
            }
        }
        
    }
    if (emotionButton.isSelected) {
        for (UIButton *btn in associatedCollectionButton) {
            if (btn == associatedCollectionButton[0] && btn.isSelected) {
                [dict setObject:[NSNumber numberWithInt:5]  forKey:@"AssociationType"];
                [dict setObject:[NSNumber numberWithInt:2]  forKey:@"MealWhereType"];
                [dict setObject:[NSNumber numberWithBool:true]  forKey:@"AfterMeal_BloatingWere"];
                [dict setObject:[NSNumber numberWithInt:3]  forKey:@"AfterMeal_Bloating"];
                [dict setObject:[NSNumber numberWithInt:2]  forKey:@"AfterMeal_BloatingRange"];
            } else if (btn == associatedCollectionButton[1] && btn.isSelected){
                [dict setObject:[NSNumber numberWithInt:6]  forKey:@"AssociationType"];
                [dict setObject:[NSNumber numberWithInt:2]  forKey:@"MealWhereType"];
                [dict setObject:[NSNumber numberWithBool:true]  forKey:@"AfterMeal_BloatingWere"];
                [dict setObject:[NSNumber numberWithInt:3]  forKey:@"AfterMeal_Bloating"];
                [dict setObject:[NSNumber numberWithInt:1]  forKey:@"AfterMeal_BloatingRange"];
            }
            else if (btn == associatedCollectionButton[2] && btn.isSelected){
                [dict setObject:[NSNumber numberWithInt:3]  forKey:@"AssociationType"];
                [dict setObject:[NSNumber numberWithInt:1]  forKey:@"MealWhereType"];
                [dict setObject:[NSNumber numberWithBool:true]  forKey:@"BetweenMeal_EnergyWas"];
                [dict setObject:[NSNumber numberWithInt:3]  forKey:@"BetweenMeal_Energy"];
                [dict setObject:[NSNumber numberWithInt:1]  forKey:@"BetweenMeal_EnergyRange"];
            } else if (btn == associatedCollectionButton[3] && btn.isSelected){
                [dict setObject:[NSNumber numberWithInt:4]  forKey:@"AssociationType"];
                [dict setObject:[NSNumber numberWithInt:1]  forKey:@"MealWhereType"];
                [dict setObject:[NSNumber numberWithBool:true]  forKey:@"BetweenMeal_EnergyWas"];
                [dict setObject:[NSNumber numberWithInt:3]  forKey:@"BetweenMeal_Energy"];
                [dict setObject:[NSNumber numberWithInt:2]  forKey:@"BetweenMeal_EnergyRange"];
            }
            else if (btn == associatedCollectionButton[4] && btn.isSelected){
                [dict setObject:[NSNumber numberWithInt:1]  forKey:@"AssociationType"];
                [dict setObject:[NSNumber numberWithInt:1]  forKey:@"MealWhereType"];
                [dict setObject:[NSNumber numberWithBool:true]  forKey:@"BetweenMeal_CravingsWere"];
                [dict setObject:[NSNumber numberWithInt:3]  forKey:@"BetweenMeal_Cravings"];
                [dict setObject:[NSNumber numberWithInt:2]  forKey:@"BetweenMeal_CravingRange"];
            } else if (btn == associatedCollectionButton[5] && btn.isSelected){
                [dict setObject:[NSNumber numberWithInt:2]  forKey:@"AssociationType"];
                [dict setObject:[NSNumber numberWithInt:1]  forKey:@"MealWhereType"];
                [dict setObject:[NSNumber numberWithBool:true]  forKey:@"BetweenMeal_CravingsWere"];
                [dict setObject:[NSNumber numberWithInt:3]  forKey:@"BetweenMeal_Cravings"];
                [dict setObject:[NSNumber numberWithInt:1]  forKey:@"BetweenMeal_CravingRange"];
            }
        }
        
    }

    return dict;
}
-(void)getSavedAnalysingNutritionSearchList{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            
            self->contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSavedAnalysingNutritionSearchList" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:responseDict[@"SavedAnalysingSearchList"]]) {
                                                                             self->savedSearchArray = responseDict[@"SavedAnalysingSearchList"];
                                                                             self->saveAnalyseView.hidden = false;
                                                                             [self->analyseTable reloadData];
//                                                                             self->analyseTable.hidden = true;
//                                                                             [self->analyseTable reloadData];
                                                                         } else {
                                                                             self->saveAnalyseView.hidden = true;
                                                                             self->tableSuperView.hidden = true;
                                                                         }
                                                                         
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
-(void)deleteSavedAnalysingNutritionSearch:(NSNumber *)saveId{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:saveId forKey:@"Id"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            
            self->contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteSavedAnalysingNutritionSearch" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self getSavedAnalysingNutritionSearchList];
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
-(void)mealDetailSearchApi:(NSDictionary *)dict{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:dict];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            
            self->contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetNutritionAnalysingMealDetail" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         NSMutableArray *tempArray = [NSMutableArray new];
                                                                         if (![Utility isEmptyCheck:responseDict[@"MealsRating"]]) {
                                                                             [tempArray addObjectsFromArray:responseDict[@"MealsRating"]];
                                                                         }
                                                                         if (![Utility isEmptyCheck:responseDict[@"IngredientsRating"]]) {
                                                                             [tempArray addObjectsFromArray:responseDict[@"IngredientsRating"]];
                                                                         }
                                                                         if (![Utility isEmptyCheck:tempArray]) {
                                                                             [self updateSearchView:tempArray];
                                                                         } else {
                                                                             [Utility msg:@"There are no meals or ingredient available with the filters you have chosen. Please change your search criteria and try again.\n(Tip: Reduce the filter options to just one or two)" title:@"" controller:self haveToPop:NO];
                                                                         }
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
-(void)ingredientDetailSearchApi:(NSDictionary *)dict mealId:(int)mealId tag:(int)tag{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:dict];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (mealButton.isSelected && mealId != -1) {
            [mainDict setObject:[NSNumber numberWithInt:mealId] forKey:@"MealId"];
        }
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            
            self->contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetNutritionAnalysingMealIngredientDetail" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:responseDict[@"IngredientsRating"]]) {
                                                                             if (self->mealButton.isSelected && mealId != -1) {
                                                                                 NSArray *tempArray = responseDict[@"IngredientsRating"];
                                                                                 NSSortDescriptor *sortByFreq = [NSSortDescriptor sortDescriptorWithKey:@"Quantity" ascending:NO];
                                                                                 NSArray *sortDescriptors = [NSArray arrayWithObject:sortByFreq];
                                                                                 tempArray = [tempArray sortedArrayUsingDescriptors:sortDescriptors];
                                                                                 self->ingrText = @"";
                                                                                 int i=0;
                                                                                 for (NSDictionary *temp in tempArray) {
                                                                                     self->ingrText = [self->ingrText stringByAppendingFormat:i==0?@"\u2022%@ %.2f ( %@ )":@"\n\u2022%@ %.2f ( %@ )", temp[@"IngredientName"], [temp[@"AverageRating"]floatValue], temp[@"Quantity"]];
                                                                                     i=1;
                                                                                 }
                                                                                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
                                                                                 NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
                                                                                 [self->searchTable reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                                                                             }else{
                                                                                 [self updateSearchView:responseDict[@"IngredientsRating"]];
                                                                             }
                                                                         } else {
                                                                             [Utility msg:@"There are no ingredients available with the filters you have chosen. Please change your search criteria and try again.\n(Tip: Reduce the filter options to just one or two)" title:@"" controller:self haveToPop:NO];
                                                                         }
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
-(void)emotionDetailSearchApi:(NSDictionary *)dict{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:dict];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            
            self->contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetNutritionAnalysingEmotionMealDetail" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:responseDict[@"EmotionRating"]]) {
                                                                             [self updateSearchView:responseDict[@"EmotionRating"]];
                                                                         } else {
                                                                             [Utility msg:@"There are no emotions available with the filters you have chosen. Please change your search criteria and try again.\n(Tip: Reduce the filter options to just one or two)" title:@"" controller:self haveToPop:NO];
                                                                         }
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
-(void)saveSearchApi:(NSDictionary *)dict{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:dict];

        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:searchNameTextField.text forKey:@"SearchName"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            
            self->contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SaveSearchAnalysingNutrition" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                             UIAlertController *alertController = [UIAlertController
                                                                                                                   alertControllerWithTitle:@""
                                                                                                                   message:@"Saved Successfully"
                                                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                                                                             UIAlertAction *okAction = [UIAlertAction
                                                                                                        actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                        handler:^(UIAlertAction *action)
                                                                                                        {
                                                                                                            self->searchView.hidden = true;
                                                                                                            [self getSavedAnalysingNutritionSearchList];
                                                                                                        }];
                                                                             
                                                                             [alertController addAction:okAction];
                                                                             [self presentViewController:alertController animated:YES completion:nil];
                                                                         
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
-(void)updateSearchView:(NSArray *)mArray{
    NSSortDescriptor *sortByFreq = [NSSortDescriptor sortDescriptorWithKey:@"Frequency" ascending:NO];
    NSSortDescriptor *sortByRating = [NSSortDescriptor sortDescriptorWithKey:@"AverageRating" ascending:NO];
    
    NSArray *sortDescriptors = @[sortByFreq, sortByRating];
    //perform sorting
    searchArray = [mArray sortedArrayUsingDescriptors:sortDescriptors];
    
    NSString *txt = [@"Show me " stringByAppendingString:@""];
    if (self->mealButton.isSelected) {
        txt = [txt stringByAppendingString:@"Foods"];
    } else if(self->ingredientsButton.isSelected){
        txt = [txt stringByAppendingString:@"Ingredients"];
    }else{
        txt = [txt stringByAppendingString:@"Emotions"];
    }
    txt = [txt stringByAppendingString:@"\nthat have consumed "];
    if(self->lastDayButton.isSelected){
        txt = [txt stringByAppendingString:[NSString stringWithFormat: @"in the last %@ days",self->lastDayButton.currentTitle]];
    }else if (self->lastWeekButton.isSelected){
        txt = [txt stringByAppendingString:[NSString stringWithFormat: @"in the last %@ weeks",self->lastWeekButton.currentTitle]];
    }else{
        txt = [txt stringByAppendingString:[NSString stringWithFormat: @"from %@ to %@ dates",self->fromDateButton.currentTitle,self->toDateButton.currentTitle]];
    }
    txt = [txt stringByAppendingString:@"\nare associated with "];
    if (self->mealButton.isSelected) {
        txt = [txt stringByAppendingString:@"Food"];
    } else if(self->ingredientsButton.isSelected){
        txt = [txt stringByAppendingString:@"Ingredient"];
    }else{
        txt = [txt stringByAppendingString:@"Emotion"];
    }
    int i = 0;
    for (UIButton *btn in self->associatedCollectionButton) {
        if (btn.isSelected) {
            txt = [txt stringByAppendingString:[NSString stringWithFormat: @" %@",associationArray[i]]];
            break;
        }
        i++;
    }
    self->searchNameTextField.text = @"";
    self->searchHeaderLabel.text = txt;
    self->searchView.hidden = false;
    [self->searchTable reloadData];
}
-(void)searchCalHistory:(BOOL)share{
    if (Utility.reachable) {
        NSString *apiName;
        if (share) {
            apiName = @"CalHistoryEmail";
        } else {
            apiName = @"SearchCalHistory";
        }
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        UIButton *buttonF = calToFromButton[0];
        UIButton *buttonT = calToFromButton[1];
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDateFormatter *df2 = [NSDateFormatter new];
        [df2 setDateFormat:@"dd-MMM-yyyy"];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[df stringFromDate:[df2 dateFromString:buttonF.currentTitle]] forKey:@"FromDate"];
        [mainDict setObject:[df stringFromDate:[df2 dateFromString:buttonT.currentTitle]] forKey:@"ToDate"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            
            self->contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:apiName append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         if (share) {
                                                                             [Utility msg:@"Search details sent to email." title:nil controller:self haveToPop:NO];
                                                                         } else {
                                                                             self->calListView.hidden = false;
                                                                             self->calHeaderLabel.text = [@"" stringByAppendingFormat:@"Cal history from %@ to %@",buttonF.currentTitle,buttonT.currentTitle];
                                                                             self->calHistoryArray = [responseDict objectForKey:@"HistoryList"];
                                                                             if (![Utility isEmptyCheck:self->calHistoryArray]) {
                                                                                 [self->calTable reloadData];
                                                                                 self->calTable.hidden = false;
                                                                             }else{
                                                                                 self->calTable.hidden = true;
                                                                             }
                                                                         }
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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

#pragma mark -End
#pragma mark -TableView Delegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:analyseTable]) {
        return savedSearchArray.count;
    } else if ([tableView isEqual:searchTable]) {
        return searchArray.count;
    } else if (tableView == calTable) {
        return calHistoryArray.count;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableCell;
    AnalyseTableViewCell *cell = (AnalyseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AnalyseTableViewCell"];
    
    NSDictionary *dict;
    if (tableView == analyseTable) {
        dict = [savedSearchArray objectAtIndex:indexPath.row];
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:dict[@"SearchName"] attributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}];
        cell.searchName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        cell.searchName.titleLabel.font =[UIFont fontWithName:@"Oswald-Regular" size:16];
        [cell.searchName setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cell.searchName setAttributedTitle: titleString forState:UIControlStateNormal];
        
        cell.type.text = showMeTypeArray[[dict[@"ShowMeType"] intValue] - 1];
        if ([dict[@"ShowMeType"] intValue] == 3) {
            cell.association.text = associationArrayEm[[dict[@"AssociationType"] intValue] - 1];
        } else {
            cell.association.text = associationArray[[dict[@"AssociationType"] intValue] - 1];
        }
        
        cell.searchName.tag = (int)indexPath.row;
        cell.action.tag = (int)indexPath.row;
        
        tableCell = cell;
    } else if (tableView == searchTable) {
        dict = [searchArray objectAtIndex:indexPath.row];
        cell.expAvgButton.layer.borderWidth = 1;
        cell.expAvgButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
        cell.expMealButton.layer.borderWidth = 1;
        cell.expMealButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
        [cell.expAvgButton setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
        [cell.expAvgButton setBackgroundColor:[UIColor whiteColor]];
        [cell.expMealButton setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
        [cell.expMealButton setBackgroundColor:[UIColor whiteColor]];

        NSLog(@"==========Dict1===%@",dict);
        if(emotionButton.isSelected){//emotions
            mealHeader.text = @"EMOTION";
            ratingHeader.text = @"EXP AV.RATING";
            cell.mealName.text = dict[@"EmotionName"];
            cell.avgRating.text = [NSString stringWithFormat:@"%.2f",[dict[@"AverageRating"]floatValue]];
            cell.frequency.text = [NSString stringWithFormat:@"%@",dict[@"Frequency"]];
            
            [cell.expAvgButton setTitle:@"EXP AV.RATING" forState:UIControlStateNormal];
            NSString *expTextDate = @"", *expTextRating = @"", *expTextRatingName = @"";
            if (avgR == indexPath.row) {
                NSArray *expandedArray = dict[@"SameMeals"];
                [dailyDateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                NSDateFormatter *tdf = [NSDateFormatter new];
                [tdf setDateFormat:@"dd/MM/yyyy"];
                NSString *stDate;
                int i = 0;
                for (NSDictionary *temp in expandedArray) {

                    stDate = temp[@"DateAddedString"];
                    NSDate *sDate = [dailyDateformatter dateFromString:stDate];
                    expTextDate = [expTextDate stringByAppendingFormat:i==0?@"%@":@"\n%@",[tdf stringFromDate:sDate]];
                    expTextRating =[expTextRating stringByAppendingFormat:i==0?@"%.2f":@"\n%.2f",[temp[@"AssociatedMealValue"]floatValue]];
                    NSString *mName = ![Utility isEmptyCheck:temp[@"MealName"]]?[@""stringByAppendingFormat:@"%@",temp[@"MealName"]]:(![Utility isEmptyCheck:temp[@"Meal"][@"MealName"]]?[@""stringByAppendingFormat:@"%@",temp[@"Meal"][@"MealName"]]:@"");
                    expTextRatingName =[expTextRatingName stringByAppendingFormat:i==0?@"\u2022 %@":@"\n\u2022 %@",mName];
                    i = 1;
                }
                
                [cell.expAvgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.expAvgButton setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
                [cell.expAvgButton setTitle:@"HIDE AV.RATING" forState:UIControlStateNormal];
                cell.expAvgButton.selected = true;
            } else {
                cell.expAvgButton.selected = false;
            }
            cell.expandedMealLabel.text = expTextDate;
            cell.expandedRatingLabel.text = expTextRating;
            cell.expandedIngredientsLabel.text = expTextRatingName;
            
            cell.expAvgButton.tag = (int)indexPath.row;
            cell.expAvgButton.hidden = false;
            cell.expMealButton.hidden = true;
            
            
        }else if (![Utility isEmptyCheck:[dict objectForKey:@"SameMeals"]]) {//for meals
            //        if (mealButton.isSelected) {//SameMeals
            mealHeader.text = @"MEAL/INGREDIENT";
            ratingHeader.text = @"EXP AV | EXP INGR";
            cell.mealName.text = dict[@"MealName"];
            cell.avgRating.text = [NSString stringWithFormat:@"%.2f",[dict[@"AverageRating"]floatValue]];
            cell.frequency.text = [NSString stringWithFormat:@"%@",dict[@"Frequency"]];
            
            [cell.expAvgButton setTitle:@"EXP AV" forState:UIControlStateNormal];
            [cell.expMealButton setTitle:@"EXP INGR" forState:UIControlStateNormal];
            NSString *expTextDate = @"", *expTextRating = @"", *expTextRatingName = @"";
            if (avgR == indexPath.row) {
                NSArray *expandedArray = dict[@"SameMeals"];
                [dailyDateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                NSDateFormatter *tdf = [NSDateFormatter new];
                [tdf setDateFormat:@"dd/MM/yyyy"];
                NSString *stDate;
                int i = 0;
                for (NSDictionary *temp in expandedArray) {
                    stDate = temp[@"DateAddedString"];
                    NSDate *sDate = [dailyDateformatter dateFromString:stDate];
                    expTextDate = [expTextDate stringByAppendingFormat:i==0?@"%@":@"\n%@",[tdf stringFromDate:sDate]];
                    expTextRating =[expTextRating stringByAppendingFormat:i==0?@"%.2f":@"\n%.2f",[temp[@"AssociatedMealValue"]floatValue]];
                    i = 1;
                }
                [cell.expAvgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.expAvgButton setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
                [cell.expAvgButton setTitle:@"HIDE AV" forState:UIControlStateNormal];
                cell.expAvgButton.selected = true;
            } else {
                cell.expAvgButton.selected = false;
            }
            if (mealR == indexPath.row) {
                expTextRatingName =[expTextRatingName stringByAppendingFormat:@"%@",ingrText];
            
                [cell.expMealButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.expMealButton setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
                [cell.expMealButton setTitle:@"HIDE INGR" forState:UIControlStateNormal];
                cell.expMealButton.selected = true;
            } else {
                cell.expMealButton.selected = false;
            }
            cell.expandedMealLabel.text = expTextDate;
            cell.expandedRatingLabel.text = expTextRating;
            cell.expandedIngredientsLabel.text = expTextRatingName;
            
            cell.expMealButton.tag = (int)indexPath.row;
            cell.expAvgButton.tag = (int)indexPath.row;
            cell.expMealButton.accessibilityHint = @"Meal";
            cell.expAvgButton.accessibilityHint = @"Meal";
            
            
//            cell.expAvgButton.hidden = false;
//            cell.expMealButton.hidden = false;
            if (![Utility isEmptyCheck:[dict objectForKey:@"MealType"]]) { //
                if (([[dict objectForKey:@"MealType"]intValue] == Quick) || ([[dict objectForKey:@"MealType"]intValue] == SqIngredient || ([[dict objectForKey:@"MealType"]intValue] == Nutritionix))) {
                    cell.expAvgButton.hidden = false;
                    cell.expMealButton.hidden = true;
                }else{
                    cell.expAvgButton.hidden = false;
                    cell.expMealButton.hidden = false;
                }
            }else{
                cell.expAvgButton.hidden = true;
                cell.expMealButton.hidden = true;
            }
        } else if (![Utility isEmptyCheck:[dict objectForKey:@"SameIngredient"]]) {//for ingredients
            mealHeader.text = @"MEAL/INGREDIENT";
            ratingHeader.text = @"EXP MEAL";
            cell.mealName.text = dict[@"IngredientName"];
            cell.avgRating.text = [NSString stringWithFormat:@"%.2f",[dict[@"AverageRating"]floatValue]];
            cell.frequency.text = [NSString stringWithFormat:@"%@",dict[@"Frequency"]];
            
            [cell.expAvgButton setTitle:@"EXP AV" forState:UIControlStateNormal];
            [cell.expMealButton setTitle:@"EXP MEAL" forState:UIControlStateNormal];
            NSString *expTextDate = @"", *expTextRating = @"", *expTextRatingName = @"";
            if (mealR == indexPath.row) {
                NSArray *expandedArray = dict[@"SameIngredient"];
                [dailyDateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                NSDateFormatter *tdf = [NSDateFormatter new];
                [tdf setDateFormat:@"dd/MM/yyyy"];
                NSString *stDate;
                int i = 0;
                for (NSDictionary *temp in expandedArray) {
                    stDate = temp[@"DateAddedString"];
                    NSDate *sDate = [dailyDateformatter dateFromString:stDate];
                    expTextDate = [expTextDate stringByAppendingFormat:i==0?@"%@":@"\n%@",[tdf stringFromDate:sDate]];
                    expTextRating =[expTextRating stringByAppendingFormat:i==0?@"%.2f":@"\n%.2f",[temp[@"AssociatedIngredientValue"]floatValue]];
                    expTextRatingName =[expTextRatingName stringByAppendingFormat:i==0?@"\u2022 %@":@"\n\u2022 %@",temp[@"IngredientName"]];
                    i = 1;
                }
                
                [cell.expMealButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.expMealButton setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
                [cell.expMealButton setTitle:@"HIDE MEAL" forState:UIControlStateNormal];
                cell.expMealButton.selected = true;
            } else {
                cell.expMealButton.selected = false;
            }
            if (avgR == indexPath.row) {
                NSArray *expandedArray = dict[@"SameIngredient"];
                [dailyDateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                NSDateFormatter *tdf = [NSDateFormatter new];
                [tdf setDateFormat:@"dd/MM/yyyy"];
                NSString *stDate;
                int i = 0;
                for (NSDictionary *temp in expandedArray) {
                    stDate = temp[@"DateAddedString"];
                    NSDate *sDate = [dailyDateformatter dateFromString:stDate];
                    expTextDate = [expTextDate stringByAppendingFormat:i==0?@"%@":@"\n%@",[tdf stringFromDate:sDate]];
                    expTextRating =[expTextRating stringByAppendingFormat:i==0?@"%.2f":@"\n%.2f",[temp[@"AssociatedIngredientValue"]floatValue]];
                    i = 1;
                }
                [cell.expAvgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.expAvgButton setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
                [cell.expAvgButton setTitle:@"HIDE AV" forState:UIControlStateNormal];
                cell.expAvgButton.selected = true;
            } else {
                cell.expAvgButton.selected = false;
            }
            cell.expandedMealLabel.text = expTextDate;
            cell.expandedRatingLabel.text = expTextRating;
            cell.expandedIngredientsLabel.text = expTextRatingName;
            
            cell.expMealButton.tag = (int)indexPath.row;
            cell.expAvgButton.tag = (int)indexPath.row;
            cell.expMealButton.accessibilityHint = @"Ing";
            cell.expAvgButton.accessibilityHint = @"Ing";
//            cell.expAvgButton.hidden = true;
//            cell.expMealButton.hidden = false;
            
            if (![Utility isEmptyCheck:[dict objectForKey:@"MealType"]]) { //
                if (([[dict objectForKey:@"MealType"]intValue] == Quick) || ([[dict objectForKey:@"MealType"]intValue] == SqIngredient || ([[dict objectForKey:@"MealType"]intValue] == Nutritionix))) {
                    cell.expAvgButton.hidden = false;
                    cell.expMealButton.hidden = true;
                }else{
                    cell.expAvgButton.hidden = false;
                    cell.expMealButton.hidden = false;
                }
            }else{
                cell.expAvgButton.hidden = true;
                cell.expMealButton.hidden = true;
            }
        }
       
        tableCell = cell;
    }else if (tableView == calTable){
        NSDictionary *dict = [calHistoryArray objectAtIndex:indexPath.row];
        if (![Utility isEmptyCheck:dict]) {
            
            NSString *dateString = [dict objectForKey:@"HistoryDate"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [dateFormatter dateFromString:dateString];
            // converting into our required date format
            [dateFormatter setDateFormat:@"EEEE, MMMM dd"];
            NSString *reqDateString = [dateFormatter stringFromDate:date];
            cell.mealName.text = ![Utility isEmptyCheck:reqDateString]?[@"" stringByAppendingFormat:@"%@  -  %@ Cal",reqDateString,[Utility customRoundNumber:[[dict objectForKey:@"TotalCalories"]floatValue]]]:@"";
            cell.frequency.text = [@"" stringByAppendingFormat:@"P: %@G   C: %@G   F: %@G",[Utility customRoundNumber:[[dict objectForKey:@"Protein"]floatValue]],[Utility customRoundNumber:[[dict objectForKey:@"Carbs"]floatValue]],[Utility customRoundNumber:[[dict objectForKey:@"Fat"]floatValue]]];
        }
        
        tableCell = cell;
    }
    
    return tableCell;
}
#pragma mark -End
#pragma mark - KeyboardNotifications -
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSInteger orientation=[UIDevice currentDevice].orientation;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        //ios7
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            kbSize=CGSizeMake(kbSize.height, kbSize.width);
        }else if (UIDeviceOrientationIsPortrait(orientation)){
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }
    }
    else {
        //iOS 8 specific code here
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }else if (UIDeviceOrientationIsPortrait(orientation)){
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }
    }
    
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    mainScroll.contentInset = contentInsets;
//    mainScroll.scrollIndicatorInsets = contentInsets;
//
//    if (activeTextField !=nil) {
//        CGRect aRect = mainScroll.frame;
//        CGRect frame = [mainScroll convertRect:activeTextField.frame fromView:activeTextField.superview];
//        aRect.size.height -= kbSize.height;
//        if (!CGRectContainsPoint(aRect,frame.origin) ) {
//            [mainScroll scrollRectToVisible:frame animated:YES];
//        }
//    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
}
#pragma mark - End -

#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [searchNameTextField becomeFirstResponder];
    searchNameTextField.textAlignment = NSTextAlignmentCenter;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length>0) {
        searchNameTextField.textAlignment = NSTextAlignmentCenter;
    } else {
        searchNameTextField.textAlignment = NSTextAlignmentLeft;
    }
}
#pragma mark - End -
#pragma mark -DropDownView Delegates
- (void) dropdownSelected:(NSString *)selectedValue sender:(UIButton *)sender type:(NSString *)type{
  
    if (sender == daysWeeksDatesButton) {
        [daysWeeksDatesButton setTitle:selectedValue forState:UIControlStateNormal];
        if ([selectedValue isEqualToString:@"DAYS"]) {
            daysViewHeightConstant.constant = 35;
            weeksViewheightConstant.constant = 0;
            datesViewHeightConstant.constant = 0;
            daysStack.hidden = false;
            weeksStack.hidden = true;
            datesStack.hidden = true;
        }else if ([selectedValue isEqualToString:@"WEEKS"]){
            daysViewHeightConstant.constant = 0;
            weeksViewheightConstant.constant = 35;
            datesViewHeightConstant.constant = 0;
            daysStack.hidden = true;
            weeksStack.hidden = false;
            datesStack.hidden = true;
        }else if ([selectedValue isEqualToString:@"DATES"]){
            daysViewHeightConstant.constant = 0;
            weeksViewheightConstant.constant = 0;
            datesViewHeightConstant.constant = 35;
            daysStack.hidden = true;
            weeksStack.hidden = true;
            datesStack.hidden = false;
        }
    }else{
        sender.selected = true;
        [sender setTitle:selectedValue forState:UIControlStateNormal];
        if ([type caseInsensitiveCompare:@"day"] == NSOrderedSame) {
            [lastWeekButton setTitle:@"SELECT" forState:UIControlStateNormal];
            lastWeekButton.selected = false;
            [lastWeekButton setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
            [lastWeekButton setBackgroundColor:[UIColor whiteColor]];
            lastWeekButton.layer.borderWidth = 1;
            lastWeekButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
        }else{
            [lastDayButton setTitle:@"SELECT" forState:UIControlStateNormal];
            lastDayButton.selected = false;
            [lastDayButton setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
            [lastDayButton setBackgroundColor:[UIColor whiteColor]];
            lastDayButton.layer.borderWidth = 1;
            lastDayButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
        }
        [fromDateButton setTitle:@"" forState:UIControlStateNormal];
        fromDateButton.selected = false;
        [toDateButton setTitle:@"" forState:UIControlStateNormal];
        toDateButton.selected = false;
        
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
    }
  
}

#pragma mark -End
#pragma mark -DatePicker Delegates
-(void)didSelectDate:(NSDate *)date{
    NSLog(@"%@",date);//yyyyMMdd
    if (date) {
        [dailyDateformatter setDateFormat:@"dd-MMM-yyyy"];
        NSString *strDate = [dailyDateformatter stringFromDate:date];
        if (calHistoryButton.isSelected) {
            UIButton *btn = [calToFromButton objectAtIndex:(foT-3)];
            [btn setTitle:strDate forState:UIControlStateNormal];
//            if (foT == 3) {
//                //from
//                [btn setTitle:strDate forState:UIControlStateNormal];
//            }else if (foT == 4){
//                //to
//            }
            return;
        }
        if (foT == 1) {
            //from
            [fromDateButton setTitle:strDate forState:UIControlStateNormal];
            fromDateButton.selected = true;
        } else {
            //to
            [toDateButton setTitle:strDate forState:UIControlStateNormal];
            toDateButton.selected = true;
        }
        [lastWeekButton setTitle:@"SELECT" forState:UIControlStateNormal];
        lastWeekButton.selected = false;
        [lastDayButton setTitle:@"SELECT" forState:UIControlStateNormal];
        lastDayButton.selected = false;
        lastDayButton.layer.borderWidth = 1;
        lastDayButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
        lastWeekButton.layer.borderWidth = 1;
        lastWeekButton.layer.borderColor = [UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
        [lastDayButton setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
        [lastDayButton setBackgroundColor:[UIColor whiteColor]];
        [lastWeekButton setTitleColor:[UIColor colorWithRed:288/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
        [lastWeekButton setBackgroundColor:[UIColor whiteColor]];
    }
}
#pragma mark -End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
