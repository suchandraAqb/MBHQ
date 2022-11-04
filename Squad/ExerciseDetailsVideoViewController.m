//
//  ExerciseDetailsVideoViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 16/01/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "ExerciseDetailsVideoViewController.h"
#import "IndividualExerciseViewController.h"
#import "EquipmentBasedTableViewCell.h"
#import "EquipmentRequiredTableViewCell.h"
#import "BodyWeightTableViewCell.h"
#import "ExcerciseHistoryViewController.h"
#import "SessionHistoryViewController.h"
@interface ExerciseDetailsVideoViewController ()
{
    IBOutlet UIView *exerciseplayerView;
    IBOutlet UIView *playerContainer;
    IBOutlet NSLayoutConstraint *detailsViewHeight;
    IBOutlet UIStackView *stack;
    IBOutlet UIView *equipmentRequiredView;
    IBOutlet UIView *equipmentBasedView;
    IBOutlet UIView *bodyWeightView;
    IBOutlet UITableView *eqRequirdTable;
    IBOutlet UITableView *eqBasedtable;
    IBOutlet UITableView *bodyWeightTable;
    IBOutlet UIView *detailsview;
    IBOutlet UIView *historySessionHistoryView;
    IBOutlet UIButton *historybutton;
    IBOutlet UIButton *sessionButton;
    IBOutlet NSLayoutConstraint *historySessionHistoryHeight;
    IBOutlet NSLayoutConstraint *equipmentRequiredHeightConstant;
    IBOutlet NSLayoutConstraint *equipmentBasedHeightConstant;
    IBOutlet NSLayoutConstraint *bodyWeightAlternativeConstant;
    AVPlayer *player;
    int count;
    NSArray *equipments;
    NSArray *substituteEquipments;
    NSArray *AltBodyWeightExercises;
    int exerId;
    NSString *str;
}
@end

@implementation ExerciseDetailsVideoViewController
@synthesize circuitDict,playerController,fromExerciseList,fromChallenge;

#pragma mark - IBAction
-(IBAction)closeButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)substituteExercisesButtonPressed:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    dispatch_async(dispatch_get_main_queue(), ^{
        [player pause];
        IndividualExerciseViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IndividualExercise"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.exerciseId = (int)sender.tag;
        [self presentViewController:controller animated:YES completion:nil];
    });
}
- (IBAction)historyButtonPressed:(UIButton *)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [player pause];
        ExcerciseHistoryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExcerciseHistoryView"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.exerciseName = [circuitDict objectForKey:@"ExerciseName"];
        controller.excerciseId =[[circuitDict objectForKey:@"ExerciseId"]intValue];
        [self presentViewController:controller animated:YES completion:nil];
    });
}

-(IBAction)sessionHistoryButtonPressed:(UIButton*)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [player pause];
        SessionHistoryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SessionHistoryView"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.exerciseName = [circuitDict objectForKey:@"ExerciseName"];
        controller.excerciseId =[[circuitDict objectForKey:@"ExerciseId"]intValue];
        [self presentViewController:controller animated:YES completion:nil];
    });
}

#pragma mark - End

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [player pause];
    player = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    equipments = [circuitDict objectForKey:@"Equipments"];
    substituteEquipments = [circuitDict objectForKey:@"SubstituteExercises"];
    AltBodyWeightExercises = [circuitDict objectForKey:@"AltBodyWeightExercises"];
    
    if (![Utility isEmptyCheck:equipments] || ![Utility isEmptyCheck:substituteEquipments]) {
        if (equipments.count>substituteEquipments.count) {
            count = (int)equipments.count;
            str = @"Required";
        }else{
            count = (int)substituteEquipments.count;
            str = @"Based";
        }
    }
    if (![Utility isEmptyCheck:AltBodyWeightExercises]) {
        if (count<AltBodyWeightExercises.count) {
            count = (int)AltBodyWeightExercises.count;
            str = @"W";
        }
    }
    
    if (![Utility isEmptyCheck:equipments] && equipments.count > 0) {
        [eqRequirdTable reloadData];
    }else{
        [stack removeArrangedSubview:equipmentRequiredView];
        [equipmentRequiredView removeFromSuperview];
    }
    
    if (![Utility isEmptyCheck:substituteEquipments] && substituteEquipments.count>0) {
        [eqBasedtable reloadData];
    }else{
        [stack removeArrangedSubview:equipmentBasedView];
        [equipmentBasedView removeFromSuperview];
    }
    if (![Utility isEmptyCheck:AltBodyWeightExercises] && AltBodyWeightExercises.count > 0) {
        [bodyWeightTable reloadData];
    }else{
        [stack removeArrangedSubview:bodyWeightView];
        [bodyWeightView removeFromSuperview];
    }
    
    if ([Utility isEmptyCheck:equipments] && [Utility isEmptyCheck:substituteEquipments]  && [Utility isEmptyCheck:AltBodyWeightExercises] ) {
        equipmentRequiredHeightConstant.constant = 0;
        equipmentBasedHeightConstant.constant = 0;
        bodyWeightAlternativeConstant.constant = 0;
        detailsview.hidden = true;
        detailsViewHeight.constant = 0;
    }else{
        detailsview.hidden = false;
        equipmentRequiredHeightConstant.constant = 60;
        equipmentBasedHeightConstant.constant = 60;
        bodyWeightAlternativeConstant.constant = 60;
        [eqRequirdTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL]; //add_add
        [eqBasedtable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
        [bodyWeightTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    }
        [self setUpView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (![Utility isEmptyCheck:equipments] || ![Utility isEmptyCheck:substituteEquipments]  || ![Utility isEmptyCheck:AltBodyWeightExercises] ) {
          [eqRequirdTable removeObserver:self forKeyPath:@"contentSize"];
          [eqBasedtable removeObserver:self forKeyPath:@"contentSize"];
          [bodyWeightTable removeObserver:self forKeyPath:@"contentSize"];
      }
   
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat detailsContentSize;
    
    if ([str isEqualToString:@"Required"]) {
        detailsContentSize =  eqRequirdTable.contentSize.height+60;
    }else if ([str isEqualToString:@"Based"]){
        detailsContentSize =  eqBasedtable.contentSize.height+60;
    }else{
        detailsContentSize = bodyWeightTable.contentSize.height+60;
    }
    detailsContentSize = detailsContentSize+30;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    CGFloat screenHeightValue = screenHeight - (72+playerContainer.frame.size.height);
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    if (fromExerciseList) {
        if (detailsContentSize>screenHeightValue) {
            if (screenSize.height == 812.0f){
                if (@available(iOS 11.0, *)) {
                    detailsViewHeight.constant = screenHeightValue - (historySessionHistoryView.layer.frame.size.height + self.view.safeAreaInsets.bottom-50);
                }else{
                     // Fallback on earlier versions
                    detailsViewHeight.constant = screenHeightValue - historySessionHistoryView.bounds.size.height-50;

                }
            }else{
                detailsViewHeight.constant = screenHeightValue - historySessionHistoryView.bounds.size.height-50;
            }
            
        }else{
            CGFloat subtractValue = screenHeightValue - detailsContentSize;
            if (subtractValue<150) {
                CGFloat heightDiffer = 0.0;
                if (screenSize.height == 812.0f){
                    if (@available(iOS 11.0, *)) {
                        heightDiffer = 300 - (historySessionHistoryView.layer.frame.size.height + self.view.safeAreaInsets.bottom);
                        NSLog(@"%f",self.view.safeAreaInsets.bottom);
                    }else{
                        // Fallback on earlier versions
                        heightDiffer = 300 - historySessionHistoryView.layer.frame.size.height;

                    }
                }else{
                    heightDiffer = 300 - historySessionHistoryView.layer.frame.size.height;

                }
                detailsViewHeight.constant = heightDiffer;
            }else{
                detailsViewHeight.constant = detailsContentSize;
            }
        }
    }else{
        if (detailsContentSize>screenHeightValue) {
            if (screenSize.height == 812.0f){
                if (@available(iOS 11.0, *)) {
                    detailsViewHeight.constant = screenHeightValue - self.view.safeAreaInsets.bottom-50;
                } else {
                    // Fallback on earlier versions
                    detailsViewHeight.constant = screenHeightValue - 50;
                }
            }else{
                detailsViewHeight.constant = screenHeightValue - 50;
            }
        }else{
            CGFloat subtractValue = screenHeightValue - detailsContentSize;
            if (subtractValue<150) {
                 if (screenSize.height == 812.0f){
                     if (@available(iOS 11.0, *)) {
                         detailsViewHeight.constant = detailsContentSize - self.view.safeAreaInsets.bottom-50;
                     }else{
                         // Fallback on earlier versions
                         detailsViewHeight.constant = detailsContentSize - 50;
                     }
                 }else{
                     detailsViewHeight.constant = detailsContentSize - 50;
                 }
            }else{
                detailsViewHeight.constant = detailsContentSize;
            }
        }
    }

}
#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - End

#pragma mark - Private Function

-(void)setUpView{
    NSString  *videoUrlString = @"";
    if (fromExerciseList) {
        videoUrlString = [circuitDict objectForKey:@"PublicUrl"];
        historySessionHistoryView.hidden = false;
        historybutton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
        historybutton.layer.borderWidth = 1.0;
        sessionButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
        sessionButton.layer.borderWidth = 1.0;
        historySessionHistoryHeight.constant = 60;
    }else if(fromChallenge){
         videoUrlString = [circuitDict objectForKey:@"ExerciseVideo"];
         historySessionHistoryView.hidden = true;
         historySessionHistoryHeight.constant = 0;
    }else{
        videoUrlString = [circuitDict objectForKey:@"VideoUrlPublic"];
        historySessionHistoryView.hidden = true;
        historySessionHistoryHeight.constant = 0;
    }
    
    if (![Utility isEmptyCheck:videoUrlString]) {
        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc]init];
        NSURL *videoUrl = [NSURL URLWithString:videoUrlString];
        NSError *_error = nil;
        @try {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient    error:&_error];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
            
        } @catch (NSException *exception) {
            NSLog(@"Audio Session error %@, %@", exception.reason, exception.userInfo);
            
        } @finally {
            NSLog(@"Audio Session finally");
        }
        
        if(player){
            player=nil;
        }
        player = [[AVPlayer alloc]initWithURL:videoUrl];
        
        //                player = [AVPlayer playerWithURL:videoUrl];
        playerViewController.player = player;
        playerViewController.delegate = self;
        playerViewController.showsPlaybackControls = YES;
        [self addChildViewController:playerViewController];
        [playerViewController didMoveToParentViewController:self];
        playerViewController.view.frame = exerciseplayerView.bounds;
        [exerciseplayerView addSubview:playerViewController.view];
        playerController = playerViewController;
        [playerController.player play];
    }
}

#pragma mark - End
    
#pragma mark - TableView DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == eqRequirdTable) {
        return equipments.count;
    }else if (tableView == eqBasedtable){
        return substituteEquipments.count;
    }else{
        return AltBodyWeightExercises.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tablecell;
    if (tableView == eqRequirdTable) {
        EquipmentRequiredTableViewCell *cell = [eqRequirdTable dequeueReusableCellWithIdentifier:@"EquipmentRequiredTableViewCell"];
        if (cell == nil ) {
            cell = [[EquipmentRequiredTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EquipmentRequiredTableViewCell"];
        }
        
        cell.eqRequired.text = [@"\u2022  " stringByAppendingString:[equipments objectAtIndex:indexPath.row]];
        tablecell = cell;
    }else if (tableView == eqBasedtable){
        EquipmentBasedTableViewCell *cell2 = [eqBasedtable dequeueReusableCellWithIdentifier:@"EquipmentBasedTableViewCell"];
        if (cell2 == nil ) {
            cell2 = [[EquipmentBasedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EquipmentBasedTableViewCell"];
        }
        cell2.eqBased.layer.borderColor = [UIColor whiteColor].CGColor;
        cell2.eqBased.layer.borderWidth=2.0;
        cell2.eqBased.text = [[substituteEquipments objectAtIndex:indexPath.row]objectForKey:@"SubstituteExerciseName"];
        tablecell=cell2;
    }else{
        BodyWeightTableViewCell *cell3 = [bodyWeightTable dequeueReusableCellWithIdentifier:@"BodyWeightTableViewCell"];
        if (cell3 == nil) {
            cell3 = [[BodyWeightTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BodyWeightTableViewCell"];
        }
        cell3.weight.layer.borderColor=[UIColor whiteColor].CGColor;
        cell3.weight.layer.borderWidth=2.0;
        cell3.weight.text = [[AltBodyWeightExercises objectAtIndex:indexPath.row]objectForKey:@"BodyWeightAltExerciseName"];
        tablecell =cell3;
    }
    
    return tablecell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [player pause];
        if (tableView == eqBasedtable) {
           exerId = [[[substituteEquipments objectAtIndex:indexPath.row]objectForKey:@"SubstituteExerciseId"] intValue];
        }else if (tableView == bodyWeightTable){
            exerId = [[[AltBodyWeightExercises objectAtIndex:indexPath.row]objectForKey:@"BodyWeightAltExerciseId"] intValue];

        }
        IndividualExerciseViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IndividualExercise"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.exerciseId = exerId;
        [self presentViewController:controller animated:YES completion:nil];
    });
}

@end
