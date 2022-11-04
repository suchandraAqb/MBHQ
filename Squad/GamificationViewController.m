//
//  GamificationViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 19/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "GamificationViewController.h"
#import "GamificationTableViewCell.h"
#import "GamificationCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyProfileSettingsViewController.h"
#import "BadgePopUpViewController.h"
@interface GamificationViewController ()
{
    UIView *contentView;
    NSArray *actionArray;
    NSArray *earnRewardsArray;
    NSDate *currentDate;
    NSDate *weekDate;
    int dayNumber;
    IBOutlet UITableView *gamificationTable;
    IBOutlet UICollectionView *gamificationCollection;
    IBOutlet UIImageView *profileImage;
    IBOutlet UILabel *allTimeLabel;
    IBOutlet UIButton *editProfile;
    IBOutlet UIButton *earnMoreButton;
    IBOutlet UITableView *earnMoreTable;
    IBOutlet UIView *earnMoreView;
    IBOutlet UIView *actionView;
    IBOutlet UILabel *thisMonthLabel;
    //shabbir
    IBOutlet UIButton *userName;
    IBOutlet UILabel *thisWeekLabel;
    __weak IBOutlet UIButton *levelRangeButton;
    __weak IBOutlet UIImageView *levelImage;
    __weak IBOutlet UILabel *levelImageColor;
    __weak IBOutlet UIView *levelView;
    IBOutlet UIButton *backUserName;
    __weak IBOutlet UITableView *levelTable;
    __weak IBOutlet NSLayoutConstraint *gamificationTableHeight;
    NSMutableArray *badgeList;
    IBOutlet UILabel *badgeCollectionNodataLabel;
    NSArray *badgeArr;
    
    IBOutlet UILabel *popUpDetailsLabel;
    IBOutlet UIView *popDayView;
    IBOutlet UILabel *noOfdaysLabel;
    IBOutlet UILabel *userNameLabel;
    IBOutlet UIButton *readMoreButton;
    IBOutlet UIButton *shareButton;
    IBOutlet UIButton *currentstreakButton;
    IBOutlet UIButton *pbStreakButton;
    IBOutlet UILabel *challengeNameLabel;
    
    IBOutlet UIImageView *rewards3Img;
    IBOutlet UIImageView *rewards7Img;
    IBOutlet UIImageView *rewards14Img;
    IBOutlet UIImageView *rewards28Img;
    IBOutlet UIImageView *rewards100Img;
    IBOutlet UIImageView *rewards150Img;
    IBOutlet UIImageView *rewards200Img;
    IBOutlet UIImageView *rewards300Img;
    IBOutlet UIImageView *rewards400Img;
    IBOutlet UIImageView *rewards500Img;
    IBOutlet UIImageView *rewards750Img;
    IBOutlet UIImageView *rewards1000Img;
    IBOutlet UIImageView *rewards1250Img;
    IBOutlet UIImageView *rewards1500Img;
    IBOutlet UIImageView *rewards1750Img;
    IBOutlet UIImageView *rewards2000Img;
    IBOutlet UIImageView *rewards5000Img;
    IBOutlet UIImageView *rewards10000Img;
    
    IBOutlet UILabel *reward3Label;
    IBOutlet UILabel *reward7Label;
    IBOutlet UILabel *reward14Label;
    IBOutlet UILabel *reward28Label;
    IBOutlet UILabel *reward100Label;
    IBOutlet UILabel *reward150Label;
    IBOutlet UILabel *reward200Label;
    IBOutlet UILabel *reward300Label;
    IBOutlet UILabel *reward400Label;
    IBOutlet UILabel *reward500Label;
    IBOutlet UILabel *reward750Label;
    IBOutlet UILabel *reward1000Label;
    IBOutlet UILabel *reward1250Label;
    IBOutlet UILabel *reward1500Label;
    IBOutlet UILabel *reward1750Label;
    IBOutlet UILabel *reward2000Label;
    IBOutlet UILabel *reward5000Label;
    IBOutlet UILabel *reward10000Label;


    
    IBOutlet UIImageView *lock3Img;
    IBOutlet UIImageView *lock7Img;
    IBOutlet UIImageView *lock14Img;
    IBOutlet UIImageView *lock28Img;
    IBOutlet UIImageView *lock100Img;
    IBOutlet UIImageView *lock150Img;
    IBOutlet UIImageView *lock200Img;
    IBOutlet UIImageView *lock300Img;
    IBOutlet UIImageView *lock400Img;
    IBOutlet UIImageView *lock500Img;
    IBOutlet UIImageView *lock750Img;
    IBOutlet UIImageView *lock1000Img;
    IBOutlet UIImageView *lock1250Img;

    IBOutlet UIImageView *lock1500Img;
    IBOutlet UIImageView *lock1750Img;
    IBOutlet UIImageView *lock2000Img;
    IBOutlet UIImageView *lock5000Img;
    IBOutlet UIImageView *lock10000Img;
    
    IBOutletCollection(NSLayoutConstraint) NSArray *yconstraintForReward;
    

    IBOutlet UIButton *totalButtonStreak;
    IBOutlet UICollectionView *mileStoneCollection;
    int currentStreak;
    int pbStreak;
    int laststreak;
    int totalStreak;
    BOOL previousStreakBroken;
    
    NSArray *mileStoneArr;
    
}
@end

@implementation GamificationViewController
@synthesize streakDict;
#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    actionArray = [[NSArray alloc]init];
    
    earnRewardsArray = [[NSArray alloc]init];
    self->popDayView.hidden = true;
    
    //change_rewards
    readMoreButton.layer.cornerRadius = 8;
    readMoreButton.layer.masksToBounds = YES;
    shareButton.layer.cornerRadius = 8;
    shareButton.layer.masksToBounds=YES;
    
    readMoreButton.selected = false;//change_rewards
    
    currentstreakButton.layer.cornerRadius = currentstreakButton.frame.size.height/2;
    currentstreakButton.layer.masksToBounds = YES;
    currentstreakButton.layer.backgroundColor = [Utility colorWithHexString:@"93E2DD"].CGColor;
//    currentstreakButton.layer.borderWidth=1;
    
    pbStreakButton.layer.cornerRadius = pbStreakButton.frame.size.height/2;
    pbStreakButton.layer.masksToBounds = YES;
    pbStreakButton.layer.backgroundColor = [Utility colorWithHexString:@"93E2DD"].CGColor;
    
    totalButtonStreak.layer.cornerRadius = totalButtonStreak.frame.size.height/2;
    totalButtonStreak.layer.masksToBounds = YES;
    totalButtonStreak.layer.backgroundColor = [Utility colorWithHexString:@"93E2DD"].CGColor;
    
    
//    currentstreakButton.titleLabel.textColor=[Utility colorWithHexString:@"93E2DD"];
//    currentstreakButton.titleLabel.textColor=[UIColor whiteColor];
   
    //change_rewards
    gamificationTable.estimatedRowHeight = 40;
    gamificationTable.rowHeight = UITableViewAutomaticDimension;
    profileImage.layer.cornerRadius = profileImage.layer.frame.size.height/2;
    profileImage.layer.masksToBounds = YES;
    [userName setTitle:[[NSString stringWithFormat:@"%@ %@",[defaults objectForKey:@"FirstName"],[defaults objectForKey:@"LastName"]] uppercaseString] forState:UIControlStateNormal];    //shabbir
//    [backUserName setTitle:[[NSString stringWithFormat:@"BACK TO %@ %@",[defaults objectForKey:@"FirstName"],[defaults objectForKey:@"LastName"]] uppercaseString] forState:UIControlStateNormal];
    [backUserName setTitle:@"BACK TO REWARDS CENTRE" forState:UIControlStateNormal];
    
    levelView.hidden = true;
    if (![Utility isEmptyCheck:[defaults objectForKey:@"ProfilePicUrl"]]) {
        
        NSString *imageUrl= [@"" stringByAppendingFormat:@"%@/%@",BASEURL,[defaults objectForKey:@"ProfilePicUrl"]];
        
        [profileImage sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEncodingWithAllowedCharacters:
                                                               [NSCharacterSet URLQueryAllowedCharacterSet]]]
                        placeholderImage:[UIImage imageNamed:@"avtarimg.png"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   
                               }];
    }else{
        profileImage.image = [UIImage imageNamed:@"avtarimg.png"];
    }

    editProfile.layer.cornerRadius = 8;
    editProfile.layer.masksToBounds =
    editProfile.layer.borderColor = [Utility colorWithHexString:@"e427a0"].CGColor;
    editProfile.layer.borderWidth = 1;
    
    backUserName.layer.cornerRadius = 8;
    backUserName.layer.masksToBounds = YES;
    backUserName.layer.borderColor = [Utility colorWithHexString:@"e427a0"].CGColor;
    backUserName.layer.borderWidth = 1;
    
    earnMoreView.hidden = true;
    earnMoreTable.hidden = true;
    
    actionView.hidden = false;
    gamificationTable.hidden = false;
    
   
//    [self getSquadUserActionProfile_webServiceCall];

}
-(void)viewDidAppear:(BOOL)animated{
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    badgeCollectionNodataLabel.hidden = true;
    badgeCollectionNodataLabel.text = @"";
    badgeArr = @[@{@"imageStr":@"SAPPHIRE",@"colorcode":@"333398",@"pointRange":@"0 - 50"},@{@"imageStr":@"RUBY",@"colorcode":@"bb1a43",@"pointRange":@"50 - 100"},@{@"imageStr":@"EMERALD",@"colorcode":@"019775",@"pointRange":@"100 - 200"},@{@"imageStr":@"SILVER",@"colorcode":@"d7d7d7",@"pointRange":@"200 - 300"},@{@"imageStr":@"GOLD",@"colorcode":@"c9af63",@"pointRange":@"300 - 400"},@{@"imageStr":@"PURPLE",@"colorcode":@"663398",@"pointRange":@"400 - 500"},@{@"imageStr":@"TURQUOISE",@"colorcode":@"64aea7",@"pointRange":@"500 - 750"},@{@"imageStr":@"ORANGE",@"colorcode":@"ff7300",@"pointRange":@"750 - 1000"},@{@"imageStr":@"GREEN",@"colorcode":@"31a200",@"pointRange":@"1000 - 1500"},@{@"imageStr":@"NAVY BLUE",@"colorcode":@"142954",@"pointRange":@"1500 - 2000"},@{@"imageStr":@"SKY BLUE",@"colorcode":@"91e1fc",@"pointRange":@"2000 - 3000"},@{@"imageStr":@"YELLOW",@"colorcode":@"ffd402",@"pointRange":@"3000 - 5000"},@{@"imageStr":@"RED",@"colorcode":@"e21c45",@"pointRange":@"5000 - 10000"},@{@"imageStr":@"PINK",@"colorcode":@"ee9cb3",@"pointRange":@"10000 - 25000"},@{@"imageStr":@"BLACK",@"colorcode":@"231f20",@"pointRange":@"25000"}];
    mileStoneArr = @[@3,@7,@14,@21,@28,@35,@42,@50,@75,@100,@125,@150,@175,@200,@225,@250,@275,@300,@325,@350,@375,@400,@425,@450,@475,@500,@550,@600,@650,@700,@750,@800,@850,@900,@950,@1000,@1100,@1200,@1300,@1400,@1500,@1600,@1700,@1800,@1900,@2000,@2250,@2500,@2750,@3000,@5000,@10000];
    reward3Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward3Label.layer.masksToBounds = YES;
    reward7Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward7Label.layer.masksToBounds = YES;
    reward14Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward14Label.layer.masksToBounds = YES;
    reward28Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward28Label.layer.masksToBounds = YES;
    reward100Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward100Label.layer.masksToBounds = YES;
    reward150Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward150Label.layer.masksToBounds = YES;
    reward200Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward200Label.layer.masksToBounds = YES;
    reward300Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward300Label.layer.masksToBounds = YES;
    reward400Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward400Label.layer.masksToBounds = YES;
    reward500Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward500Label.layer.masksToBounds = YES;
    reward750Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward750Label.layer.masksToBounds = YES;
    reward1000Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward1000Label.layer.masksToBounds = YES;
    reward1250Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward1250Label.layer.masksToBounds = YES;
    reward1500Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward1500Label.layer.masksToBounds = YES;
    reward1750Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward1750Label.layer.masksToBounds = YES;
    reward2000Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward2000Label.layer.masksToBounds = YES;
    reward5000Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward5000Label.layer.masksToBounds = YES;
    reward10000Label.layer.cornerRadius = reward3Label.frame.size.height/2;
    reward10000Label.layer.masksToBounds = YES;
//    [gamificationTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
//    [self GetSquadMoreRewards_webServiceCall];
    
    [self GetStreakData_webServiceCall];
    [mileStoneCollection reloadData];

//    if (![Utility isEmptyCheck:streakDict]) {
//           [self setUpStreakDetails];
////           [self lockUnlockDetails];
//    }else{
//        [self GetStreakData_webServiceCall];
//    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [gamificationTable removeObserver:self forKeyPath:@"contentSize"];
}
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    if (object == gamificationTable) {
//        gamificationTableHeight.constant = gamificationTable.contentSize.height;
//    }
//}
#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - End

#pragma mark - IBAction

-(IBAction)editProfileButtonPressed:(id)sender{
    dispatch_async(dispatch_get_main_queue(),^ {
        MyProfileSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyProfileSettingsView"];
        [self.navigationController pushViewController:controller animated:YES];
    });
}

-(IBAction)earnMoreButton:(id)sender{
    if (earnRewardsArray.count>0) {
        actionView.hidden= true;
        gamificationTable.hidden = true;
        
        earnMoreView.hidden = false;
        earnMoreTable.hidden = false;
        
        [earnMoreTable reloadData];
    }
}

-(IBAction)crossButtonPressed:(id)sender{
    earnMoreView.hidden = true;
    earnMoreTable.hidden = true;
    
    actionView.hidden = false;
    gamificationTable.hidden = false;
    
    [gamificationTable reloadData];
}
- (IBAction)seeAllButtonPressed:(UIButton *)sender {
    levelView.hidden = false;
    [userName setTitle:@"LEVELS" forState:UIControlStateNormal];
    [levelTable reloadData];
}
- (IBAction)backToUserPressed:(UIButton *)sender {
    levelView.hidden = true;
    [userName setTitle:[[NSString stringWithFormat:@"%@ %@",[defaults objectForKey:@"FirstName"],[defaults objectForKey:@"LastName"]] uppercaseString] forState:UIControlStateNormal];
}
- (IBAction)infoButtonPressed:(UIButton *)sender {
    NSDictionary *dict;
    if ([sender.accessibilityHint isEqualToString:@"earnMore"]) {
        dict = [earnRewardsArray objectAtIndex:sender.tag];
    } else {
        dict = [badgeList objectAtIndex:sender.tag];
    }
    [Utility msg:[dict objectForKey:@"Specification"] title:@"" controller:self haveToPop:NO];
}

-(IBAction)readMoreButtonPressed:(id)sender{ //change_rewards
    if (readMoreButton.selected) {
        readMoreButton.selected = false;
    }else{
        readMoreButton.selected = true;
    }
    [self setUpRewardsView];
}
-(IBAction)crossDayButtonPressed:(id)sender{ //change_rewards
    popDayView.hidden = true;
}
-(IBAction)shareButtonPressed:(id)sender{
    
}
-(IBAction)informationVideoButtonPressed:(id)sender{
    NSString *urlStr = @"https://player.vimeo.com/external/220933773.m3u8?s=04d41e4e04fa8ce700db0f52f247acce968b72e5";
    [Utility showHelpAlertWithURL:urlStr controller:self haveToPop:YES];
}
#pragma mark - End

#pragma mark - PrivateFunction

-(void)setUpView{
    currentDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:currentDate];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    if ([weekdayComponents weekday] == 1) {
        [componentsToSubtract setDay:-6];
    }else{
        [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
    }
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:currentDate options:0];
    
    if (beginningOfWeek) {
        weekDate = beginningOfWeek;
    }
    NSTimeInterval interval = 6*24*60*60;
    NSDate *endOfWeek = [beginningOfWeek
                       dateByAddingTimeInterval:interval];
    NSLog(@"%@ - %@",beginningOfWeek,endOfWeek);
    
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
//    dueDate = [df dateFromString:dueDateStr];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSString *beginDateString = [df stringFromDate:beginningOfWeek];
    beginningOfWeek = [df dateFromString:beginDateString];
    
    if(![Utility isEmptyCheck:actionArray]){
        int numberOfmonth=0;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        NSInteger month = [components month];
        NSString *currentMonth = [@"" stringByAppendingFormat:@"%02ld",(long)month];
        for (NSDictionary *dict in actionArray) {
            NSString *dateStr = [@"" stringByAppendingFormat:@"%@",dict[@"DateCreated"]];
            NSString * month = [dateStr substringWithRange:NSMakeRange(5, 2)];
            if ([month isEqualToString:currentMonth]) {
                int points = [[dict objectForKey:@"Point"] intValue];
                numberOfmonth = numberOfmonth + points;
            }
        }
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d",numberOfmonth]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:18] range:NSMakeRange(0, [attributedString length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"E425A0"] range:NSMakeRange(0, [attributedString length])];
        
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@",@"This Month"]];
        [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Light" size:13] range:NSMakeRange(0, [attributedString2 length])];
        [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString2 length])];
        [attributedString appendAttributedString:attributedString2];
        thisMonthLabel.attributedText = attributedString;
        
    }else{
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"0"];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:18] range:NSMakeRange(0, [attributedString length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"E425A0"] range:NSMakeRange(0, [attributedString length])];
        
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@",@"This Month"]];
        [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Light" size:13] range:NSMakeRange(0, [attributedString2 length])];
        [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString2 length])];
        [attributedString appendAttributedString:attributedString2];
        thisMonthLabel.attributedText = attributedString;
    }
    //shabbir
    if(![Utility isEmptyCheck:actionArray]){
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(DateCreated >= %@) AND (DateCreated <= %@)", [formatter stringFromDate:beginningOfWeek], [formatter stringFromDate:endOfWeek]];
        NSArray *thisWeekArray = [actionArray filteredArrayUsingPredicate:predicate];
        NSNumber *pointOfWeek = [thisWeekArray valueForKeyPath:@"@sum.Point"];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",pointOfWeek]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:18] range:NSMakeRange(0, [attributedString length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"E425A0"] range:NSMakeRange(0, [attributedString length])];
        
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@",@"This Week"]];
        [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Light" size:13] range:NSMakeRange(0, [attributedString2 length])];
        [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString2 length])];
        [attributedString appendAttributedString:attributedString2];
        thisWeekLabel.attributedText = attributedString;
        
    }else{
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"0"];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:18] range:NSMakeRange(0, [attributedString length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"E425A0"] range:NSMakeRange(0, [attributedString length])];
        
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@",@"This Week"]];
        [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Light" size:13] range:NSMakeRange(0, [attributedString2 length])];
        [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString2 length])];
        [attributedString appendAttributedString:attributedString2];
        thisWeekLabel.attributedText = attributedString;
    }
    if (![Utility isEmptyCheck:actionArray]) {
        NSNumber * allTime = [actionArray valueForKeyPath:@"@sum.Point"];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",allTime]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:18] range:NSMakeRange(0, [attributedString length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"E425A0"] range:NSMakeRange(0, [attributedString length])];
        
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@",@"All Time"]];
        [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Light" size:13] range:NSMakeRange(0, [attributedString2 length])];
        [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString2 length])];
        [attributedString appendAttributedString:attributedString2];
        allTimeLabel.attributedText = attributedString;
        
        NSDictionary *badgeDict = [Utility getPointsImage:[allTime doubleValue]];
        if ([allTime doubleValue] >= 25000) {
            [levelImage setImage:[UIImage imageNamed:@"black_gm_for_all.png"]];
        } else {
            [levelImage setImage:[[UIImage imageNamed:@"black_gm_for_all.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [levelImage setTintColor:[Utility colorWithHexString:[badgeDict objectForKey:@"colorCode"]]];
        }
        levelImageColor.text = [badgeDict objectForKey:@"imageText"];
        [levelRangeButton setTitle:[badgeDict objectForKey:@"pointRange"] forState:UIControlStateNormal];
    }else{
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"0"];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:18] range:NSMakeRange(0, [attributedString length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"E425A0"] range:NSMakeRange(0, [attributedString length])];
        
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@",@"All Time"]];
        [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Light" size:13] range:NSMakeRange(0, [attributedString2 length])];
        [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString2 length])];
        [attributedString appendAttributedString:attributedString2];
        allTimeLabel.attributedText = attributedString;
        
        NSDictionary *badgeDict = [Utility getPointsImage:0];
        [levelImage setImage:[[UIImage imageNamed:@"black_gm_for_all.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [levelImage setTintColor:[Utility colorWithHexString:[badgeDict objectForKey:@"colorCode"]]];
        levelImageColor.text = @"SAPPHIRE";
        [levelRangeButton setTitle:[badgeDict objectForKey:@"pointRange"] forState:UIControlStateNormal];
        
    }
}
-(void)makeGroupArray:(NSArray *)actionArray{
    NSPredicate *predicate;
    NSArray *filteredArray;
    badgeList = [[NSMutableArray alloc]init];
    NSArray *uniqueBadge = [actionArray valueForKeyPath:@"@distinctUnionOfObjects.Badge"];
    for (NSString *temp in uniqueBadge) {
        predicate = [NSPredicate predicateWithFormat:@"Badge == %@",temp];
        filteredArray = [actionArray filteredArrayUsingPredicate:predicate];
        if (filteredArray.count>0) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[filteredArray objectAtIndex:0]];
            
            [dict setObject:[NSNumber numberWithInt:(int)filteredArray.count] forKey:@"BadgeCount"];
            [badgeList addObject:dict];
        }
    }
    badgeList = [[badgeList sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"DateCreated" ascending:NO]]]mutableCopy];
    
    if (![Utility isEmptyCheck:badgeList]) {
        badgeCollectionNodataLabel.hidden = true;
        badgeCollectionNodataLabel.text = @"";
    }else{
        badgeCollectionNodataLabel.hidden = false;
        badgeCollectionNodataLabel.text = @"No Badges Found";
    }
}
-(NSArray*)daysInWeek:(int)weekOffset fromDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";//yyyy-MM-dd'T'HH:mm:ss.SSS
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    //create date on week start
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:(0 - ([comps weekday] - weekOffset))];
    NSDate *weekstart = [calendar dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
    //add 7 days
    NSMutableArray* week=[NSMutableArray arrayWithCapacity:7];
    for (int i=0; i<7; i++) {
        NSDateComponents *compsToAdd = [[NSDateComponents alloc] init];
        compsToAdd.day=i;
        NSDate *nextDate = [calendar dateByAddingComponents:compsToAdd toDate:weekstart options:0];
        [week addObject:[formatter stringFromDate:nextDate ]];
    }
    return [NSArray arrayWithArray:week];
}
-(void)setUpStreakDetails{
    if (![Utility isEmptyCheck:[streakDict objectForKey:@"TopStreak"]]) {
        [self->pbStreakButton setTitle:[@"" stringByAppendingFormat:@"%@",[streakDict objectForKey:@"TopStreak"]] forState:UIControlStateNormal];
    }else{
        [self->pbStreakButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    if (![Utility isEmptyCheck:[streakDict objectForKey:@"CurrentStreak"]]) {
        [self->currentstreakButton setTitle:[@"" stringByAppendingFormat:@"%@",[streakDict objectForKey:@"CurrentStreak"]] forState:UIControlStateNormal];
    }else{
        [self->currentstreakButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    if(![Utility isEmptyCheck:[streakDict objectForKey:@"Total"]]){
        [totalButtonStreak setTitle:[@"" stringByAppendingFormat:@"%@",[streakDict objectForKey:@"Total"]] forState:UIControlStateNormal];
        totalStreak = [[streakDict objectForKey:@"Total"]intValue];
    }else{
        [totalButtonStreak setTitle:@"" forState:UIControlStateNormal];
        totalStreak = 0;
    }
    
    self->currentStreak = [[streakDict objectForKey:@"CurrentStreak"]intValue];
    self->pbStreak = [[streakDict objectForKey:@"TopStreak"]intValue];
    
    if ([[streakDict objectForKey:@"PreviousStreakBroken"]boolValue]) {
        self->previousStreakBroken = true;
    }else{
        self->previousStreakBroken = false;
    }
    if (![Utility isEmptyCheck:[streakDict objectForKey:@"LastStreak"]]) {
        self->laststreak = [[streakDict objectForKey:@"LastStreak"]intValue];
    }else{
        self->laststreak = 0;
    }
  
    
//    if (self->currentStreak>=1 && self->currentStreak<=21) {
//        self->popDayView.hidden = false;
//        [self setUpRewardsView];
//    }else{
//        self->popDayView.hidden = true;
//    }
}
-(void)setUpRewardsView{ //change_rewards
    NSString *dayStr=@"";
    shareButton.hidden =true;
    readMoreButton.hidden = true;
    popDayView.hidden =false;
    if (currentStreak == 1) {
        if (!previousStreakBroken) {
            noOfdaysLabel.text =@"1 DAY IN A ROW";
            readMoreButton.hidden = false;
            if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
                userNameLabel.text =[[NSString stringWithFormat:@"%@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
            }
            if (readMoreButton.selected) {
                dayStr = @"Your goal if you chose to accept it, is to use the app for 21 days in a row to create a new habit and change your body.\n\nIt’s simple... All you need to do is open the app each day for 21 days... That’s it!.\n\nIf you do this we know you are more likely to achieve your goals.\n\nWe have found the number 1 factor to long term success in our community is simply creating the habit of using the app and connecting with the community.\n\nSo even if you’ve had a tough day, even if you can’t do a workout even if all you can do is read the quote of the day then thats great.\n\nIt may not seem like much, but the health habit you are creating is incredibly powerful and by just your 21st day in a row you will be seeing big changes in yourself.\n\nYour streak can be seen in the top right of your app and if you click on this you can see your streak history and create other motivating streaks too\n\nLove Ashy xx";
            }else{
                dayStr = @"Your goal if you chose to accept it, is to use the app for 21 days in a row to create a new habit and change your body.\n\nIt’s simple... All you need to do is open the app each day for 21 days... That’s it!";
            }
        }else{
            noOfdaysLabel.text =@"STREAK DAY 1";
            readMoreButton.hidden = true;
            if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
                userNameLabel.text =[[NSString stringWithFormat:@"Hey %@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
            }
            dayStr = [@"" stringByAppendingFormat:@"Your last Squad Streak was %d days and your pb is %d days \n\n Are you ready to smash a new pb? What should we do first ? \n\n You got this!",laststreak,pbStreak];
        }
    }else if (currentStreak == 2){
        noOfdaysLabel.text =@"2 DAYS IN A ROW";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =[[NSString stringWithFormat:@"Oh yeah %@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
        }
        dayStr = @"Now you're on a real streak.\n\nKeep it up, and watch the changes occur!\n\nLove Ashy xx";
    }else if (currentStreak == 3){
        noOfdaysLabel.text =@"3 DAYS IN A ROW";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =[[NSString stringWithFormat:@"Damn %@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
        }
        dayStr = @"I love your commitment!\n\nKeep it up!.\n\nLove Ashy xx";
    }else if (currentStreak == 4){
        noOfdaysLabel.text =@"";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =@"";
        }
        dayStr = @"Can i get a HELL YEAH!\n\nYou're over half way to completing one week in a row.\n\nI hope you're pretty dam impressed with yourself.\n\nI am\n\nKeep it up!\n\nLove Ashy xx";
    }else if (currentStreak == 5){
        noOfdaysLabel.text =@"5 DAYS IN A ROW";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =@"";
        }
        dayStr = @"Ever heard the word 'unstoppable'?\n\nLook it up, I'm pretty sure there will be a picture of you next to the definition!\n\nKeep it up!\n\nLove Ashy xx";
    }else if (currentStreak == 6){
        noOfdaysLabel.text =@"";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =[[NSString stringWithFormat:@"%@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
        }
        dayStr = @"Just 6 days ago you decided to change your health.\n\nYou have done everything I've asked of you thus far.\n\nCan you believe tomorrow is 1 week already?\n\nYou're on fire girl!\n\nKeep it up!\n\nLove Ashy xx";
    }else if (currentStreak == 7){
        noOfdaysLabel.text =@"";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =[[NSString stringWithFormat:@"Happy 1 week anniversary %@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
        }
        dayStr = @"1 week of using the app and committing to yourself, your new body and your health.\n\nPretty impressive and you know what.... The hardest part has been done!\n\nIf you can make 7 days, you can do 14. If you can do 14 you can do 21. if you can do 21 you can do 42 and before you know it a new you will be looking back in the mirror!\n\nKeep it up! I love your determination\n\nLove Ashy xx\n\n[Share your streak now]";
        shareButton.hidden = false;
    }else if (currentStreak == 8){
        noOfdaysLabel.text =@"8 DAYS";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =@"";
        }
        dayStr = @"1 week and 1 day down and you're so close to the first and biggest goal for every new Squad member.  21 days in a row.\n\nYou're pretty impressive. I hope you know that\n\nLove Ashy xx";
    }else if (currentStreak == 9){
        noOfdaysLabel.text =@"9 DAYS IN A ROW";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =@"";
        }
        dayStr =[@"" stringByAppendingFormat:@"Keep it up %@ !",[defaults objectForKey:@"FirstName"]];
    }
    else if (currentStreak == 10){
        noOfdaysLabel.text =@"10 DAYS IN A ROW";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =@"";
        }
        dayStr =[@"" stringByAppendingFormat:@"Keep it up %@ !",[defaults objectForKey:@"FirstName"]];
    }else if (currentStreak == 11){
        noOfdaysLabel.text =@"Day 11";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =[[NSString stringWithFormat:@"%@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
        }
        dayStr =@"Today is officially half way to your first big goal. 21 days in a row of using Squad.\n\nKeep it up! Every day you are getting fitter, healthier, more educated and self aware.\n\nHave you started one of my courses yet to increase your knowledge? Why not try one today. Click here.\n\nLove Ashy xx";
    }else if (currentStreak == 12){
        noOfdaysLabel.text =@"12 DAYS IN A ROW";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =@"";
        }
        dayStr =[@"" stringByAppendingFormat:@"Keep it up %@ !",[defaults objectForKey:@"FirstName"]];
    }else if (currentStreak == 13){
        noOfdaysLabel.text =@"13 DAYS IN A ROW";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =[[NSString stringWithFormat:@"%@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
        }
        dayStr =[@"" stringByAppendingFormat:@"Keep it up %@ !\n\nLove Ashy xx",userNameLabel.text];
    }else if (currentStreak == 14){
        noOfdaysLabel.text =@"";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =@"";
        }
        dayStr =@"Day 14 done and dusted!\n\nThat's 2 full weeks of using Squad daily.\n\nI hope you are as impressed with yourself as much as I am.\n\nKeep it up!\n\nDid you know tracking your food is a great way to improve your results. Try my meal tracker today [click here]\n\nLove Ashy xx\n\n[Share your streak now]";
        shareButton.hidden= false;
    }else if (currentStreak == 15){
        noOfdaysLabel.text =@"15 DAYS IN A ROW";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =[[NSString stringWithFormat:@"%@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
        }
        dayStr =[@"" stringByAppendingFormat:@"Keep it up %@ !",userNameLabel.text];
    }else if (currentStreak == 16){
        noOfdaysLabel.text =@"16 DAYS IN A ROW";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =[[NSString stringWithFormat:@"%@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
        }
        dayStr =[@"" stringByAppendingFormat:@"Keep it up %@ !",userNameLabel.text];
    }else if (currentStreak == 17){
        noOfdaysLabel.text =@"17 DAYS IN A ROW";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =[[NSString stringWithFormat:@"%@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
        }
        dayStr =@"Just let that sink in for a while. 17 days in a row. Are you sure you're not part machine!!\n\nHave you tried a fitness challenge yet? My finishers take between 3 and 5 minutes and are great at the end of a workout or on days when you don't have time to workout but want to do something!";
    }else if (currentStreak == 18){
        noOfdaysLabel.text =@"Day 18";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =@"";
        }
        dayStr =@"Motivation is what gets us started, habit is what keeps us going!\n\nCongratulations babe, you're commitment to the new you is inspiring and your new habits are getting stronger and stronger every day\n\nKeep it up\n\n3 days til you achieve the first Squad goal!  21 days in a row";
    }else if (currentStreak == 19){
        popDayView.hidden =true;
    }else if (currentStreak == 20){
        popDayView.hidden =true;
    }else if (currentStreak == 21){
        noOfdaysLabel.text =@"";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
            userNameLabel.text =@"";
        }
        dayStr = [@"" stringByAppendingFormat:@"ACHIEVEMENT UNLOCKED\n\nYou did it!\n\n21 days in a row and the first step in creating the new fitter, stronger, healthier you has been ticked off.\n\nThat doesn't mean you can get complacent, we're only just getting started!\n\nYour next target is 42 days in a row!\n\nAre you ready?\n\n[please share your success on the forum now] and tell us about the journey thus far. What you are doing, what you are feeling and where you are heading.\n\n %@,I am so excited for you. Congratulations once again on achieving the first goal for my squad babes to tick off.",[defaults objectForKey:@"FirstName"]];
        shareButton.hidden=false;
    }
    popUpDetailsLabel.text = dayStr;
}

-(void)lockUnlockDetails{
//     NSString *challengeName = @"GRATITUDE RANKING";
    
    if (totalStreak<3) {
//        challengeName= @"21 Day Challenge";
        lock3Img.hidden = false;
        reward3Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards3Img setImage:[[UIImage imageNamed:@"rewards_badge.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
        NSLayoutConstraint *constant1 = yconstraintForReward[0];
        constant1.constant = -9;
        
        lock7Img.hidden = false;
        reward7Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards7Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
        NSLayoutConstraint *constant2 = yconstraintForReward[1];
        constant2.constant = -9;
        
        lock14Img.hidden = false;
        reward14Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards14Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
        NSLayoutConstraint *constant3 = yconstraintForReward[2];
        constant3.constant = -9;
        
        lock28Img.hidden = false;
        reward28Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards28Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
        NSLayoutConstraint *constant4 = yconstraintForReward[3];
        constant4.constant = -9;
        
        lock100Img.hidden = false;
        reward100Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards100Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
        NSLayoutConstraint *constant5 = yconstraintForReward[4];
        constant5.constant = -9;
        
        lock150Img.hidden = false;
        reward150Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards150Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
        NSLayoutConstraint *constant6 = yconstraintForReward[5];
        constant6.constant = -9;
        
        lock200Img.hidden = false;
        reward200Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards200Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
        NSLayoutConstraint *constant7 = yconstraintForReward[6];
        constant7.constant = -9;
        
        lock300Img.hidden = false;
        reward300Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards300Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
        NSLayoutConstraint *constant8 = yconstraintForReward[7];
        constant8.constant = -9;
        
        lock400Img.hidden = false;
        reward400Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards400Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
        NSLayoutConstraint *constant9 = yconstraintForReward[8];
        constant9.constant = -9;
        
        lock500Img.hidden = false;
        reward500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
        NSLayoutConstraint *constant10 = yconstraintForReward[9];
        constant10.constant = -9;
        
        lock750Img.hidden = false;
        reward750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
        NSLayoutConstraint *constant11 = yconstraintForReward[10];
        constant11.constant = -9;
        
        lock1000Img.hidden = false;
        reward1000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards1000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
        NSLayoutConstraint *constant12 = yconstraintForReward[11];
        constant12.constant = -9;
        
        lock1250Img.hidden = false;
        reward1250Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards1250Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
        NSLayoutConstraint *constant13 = yconstraintForReward[12];
        constant13.constant = -9;
        
        lock1500Img.hidden = false;
        reward1500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards1500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
        NSLayoutConstraint *constant14 = yconstraintForReward[13];
        constant14.constant = -9;
        
        lock1750Img.hidden = false;
        reward1750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards1750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
        NSLayoutConstraint *constant15 = yconstraintForReward[14];
        constant15.constant = -9;

        lock2000Img.hidden = false;
        reward2000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards2000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
        NSLayoutConstraint *constant16 = yconstraintForReward[15];
        constant16.constant = -9;
        
        
        lock5000Img.hidden = false;
        reward5000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards5000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
        NSLayoutConstraint *constant17 = yconstraintForReward[16];
        constant17.constant = -9;
        
        lock10000Img.hidden = false;
        reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
        [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
        NSLayoutConstraint *constant18 = yconstraintForReward[17];
        constant18.constant = -9;
        
    }else if (totalStreak>=3 && totalStreak<7){
    //        challengeName= @"21 Day Challenge";
            lock3Img.hidden = true;
            reward3Label.textColor = [UIColor blackColor];//[Utility colorWithHexString:BlueBadgeColor];
            [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
            //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
            NSLayoutConstraint *constant1 = yconstraintForReward[0];
            constant1.constant = 70;
            
            lock7Img.hidden = false;
            reward7Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
            [rewards7Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
            NSLayoutConstraint *constant2 = yconstraintForReward[1];
            constant2.constant = -9;
            
            lock14Img.hidden = false;
            reward14Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
            [rewards14Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
            NSLayoutConstraint *constant3 = yconstraintForReward[2];
            constant3.constant = -9;
            
            lock28Img.hidden = false;
            reward28Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
            [rewards28Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
            NSLayoutConstraint *constant4 = yconstraintForReward[3];
            constant4.constant = -9;
            
            lock100Img.hidden = false;
            reward100Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
            [rewards100Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
            NSLayoutConstraint *constant5 = yconstraintForReward[4];
            constant5.constant = -9;
            
            lock150Img.hidden = false;
            reward150Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
            [rewards150Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
            NSLayoutConstraint *constant6 = yconstraintForReward[5];
            constant6.constant = -9;
            
            lock200Img.hidden = false;
            reward200Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
            [rewards200Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
            NSLayoutConstraint *constant7 = yconstraintForReward[6];
            constant7.constant = -9;
            
            lock300Img.hidden = false;
            reward300Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
            [rewards300Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
            NSLayoutConstraint *constant8 = yconstraintForReward[7];
            constant8.constant = -9;
            
            lock400Img.hidden = false;
            reward400Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
            [rewards400Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
            NSLayoutConstraint *constant9 = yconstraintForReward[8];
            constant9.constant = -9;
            
            lock500Img.hidden = false;
            reward500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
            [rewards500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
            NSLayoutConstraint *constant10 = yconstraintForReward[9];
            constant10.constant = -9;
            
            lock750Img.hidden = false;
            reward750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
            [rewards750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
            NSLayoutConstraint *constant11 = yconstraintForReward[10];
            constant11.constant = -9;
            
            lock1000Img.hidden = false;
            reward1000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
            [rewards1000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
            NSLayoutConstraint *constant12 = yconstraintForReward[11];
            constant12.constant = -9;
            
            lock1250Img.hidden = false;
            reward1250Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
            [rewards1250Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
            NSLayoutConstraint *constant13 = yconstraintForReward[12];
            constant13.constant = -9;
            
            lock1500Img.hidden = false;
            reward1500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
            [rewards1500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
            NSLayoutConstraint *constant14 = yconstraintForReward[13];
            constant14.constant = -9;
            
            lock1750Img.hidden = false;
            reward1750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
            [rewards1750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
            NSLayoutConstraint *constant15 = yconstraintForReward[14];
            constant15.constant = -9;

            lock2000Img.hidden = false;
            reward2000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
            [rewards2000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
            NSLayoutConstraint *constant16 = yconstraintForReward[15];
            constant16.constant = -9;
            
            
            lock5000Img.hidden = false;
            reward5000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
            [rewards5000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
            NSLayoutConstraint *constant17 = yconstraintForReward[16];
            constant17.constant = -9;
            
            lock10000Img.hidden = false;
            reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
            [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
            NSLayoutConstraint *constant18 = yconstraintForReward[17];
            constant18.constant = -9;
            
        }else if (totalStreak>=7 && totalStreak<14){
        //        challengeName= @"21 Day Challenge";
                lock3Img.hidden = true;
                reward3Label.textColor = [UIColor blackColor];//[Utility colorWithHexString:BlueBadgeColor];
                [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                NSLayoutConstraint *constant1 = yconstraintForReward[0];
                constant1.constant = -9;
                
                lock7Img.hidden = true;
                reward7Label.textColor = [UIColor blackColor]; // [Utility colorWithHexString:BlueBadgeColor];
                [rewards7Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                NSLayoutConstraint *constant2 = yconstraintForReward[1];
                constant2.constant = 70;
                
                lock14Img.hidden = false;
                reward14Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                [rewards14Img setImage:[UIImage imageNamed:@"rewards_badge.png"]];
//                [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                NSLayoutConstraint *constant3 = yconstraintForReward[2];
                constant3.constant = -9;
                
                lock28Img.hidden = false;
                reward28Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                [rewards28Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                NSLayoutConstraint *constant4 = yconstraintForReward[3];
                constant4.constant = -9;
                
                lock100Img.hidden = false;
                reward100Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                [rewards100Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                NSLayoutConstraint *constant5 = yconstraintForReward[4];
                constant5.constant = -9;
                
                lock150Img.hidden = false;
                reward150Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                [rewards150Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                NSLayoutConstraint *constant6 = yconstraintForReward[5];
                constant6.constant = -9;
                
                lock200Img.hidden = false;
                reward200Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                [rewards200Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                NSLayoutConstraint *constant7 = yconstraintForReward[6];
                constant7.constant = -9;
                
                lock300Img.hidden = false;
                reward300Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                [rewards300Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                NSLayoutConstraint *constant8 = yconstraintForReward[7];
                constant8.constant = -9;
                
                lock400Img.hidden = false;
                reward400Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                [rewards400Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                NSLayoutConstraint *constant9 = yconstraintForReward[8];
                constant9.constant = -9;
                
                lock500Img.hidden = false;
                reward500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                [rewards500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                NSLayoutConstraint *constant10 = yconstraintForReward[9];
                constant10.constant = -9;
                
                lock750Img.hidden = false;
                reward750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                [rewards750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                NSLayoutConstraint *constant11 = yconstraintForReward[10];
                constant11.constant = -9;
                
                lock1000Img.hidden = false;
                reward1000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                [rewards1000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                NSLayoutConstraint *constant12 = yconstraintForReward[11];
                constant12.constant = -9;
                
                lock1250Img.hidden = false;
                reward1250Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                [rewards1250Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                NSLayoutConstraint *constant13 = yconstraintForReward[12];
                constant13.constant = -9;
                
                lock1500Img.hidden = false;
                reward1500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                [rewards1500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                NSLayoutConstraint *constant14 = yconstraintForReward[13];
                constant14.constant = -9;
                
                lock1750Img.hidden = false;
                reward1750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                [rewards1750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                NSLayoutConstraint *constant15 = yconstraintForReward[14];
                constant15.constant = -9;

                lock2000Img.hidden = false;
                reward2000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                [rewards2000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                NSLayoutConstraint *constant16 = yconstraintForReward[15];
                constant16.constant = -9;
                
                
                lock5000Img.hidden = false;
                reward5000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                [rewards5000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                NSLayoutConstraint *constant17 = yconstraintForReward[16];
                constant17.constant = -9;
                
                lock10000Img.hidden = false;
                reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                NSLayoutConstraint *constant18 = yconstraintForReward[17];
                constant18.constant = -9;
                
            }else if (totalStreak>=14 && totalStreak<28){
            //        challengeName= @"21 Day Challenge";
                    lock3Img.hidden = true;
                    reward3Label.textColor = [UIColor blackColor];//[Utility colorWithHexString:BlueBadgeColor];
                    [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                    //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                    NSLayoutConstraint *constant1 = yconstraintForReward[0];
                    constant1.constant = 70;
                    
                    lock7Img.hidden = true;
                    reward7Label.textColor = [UIColor blackColor];//[Utility colorWithHexString:BlueBadgeColor];
                    [rewards7Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                    [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                    NSLayoutConstraint *constant2 = yconstraintForReward[1];
                    constant2.constant = 70;
                    
                    lock14Img.hidden = true;
                    reward14Label.textColor = [UIColor blackColor];//[Utility colorWithHexString:BlueBadgeColor];
                    [rewards14Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                    [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                    NSLayoutConstraint *constant3 = yconstraintForReward[2];
                    constant3.constant = 70;
                    
                    lock28Img.hidden = false;
                    reward28Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                    [rewards28Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                    NSLayoutConstraint *constant4 = yconstraintForReward[3];
                    constant4.constant = -9;
                    
                    lock100Img.hidden = false;
                    reward100Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                    [rewards100Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                    NSLayoutConstraint *constant5 = yconstraintForReward[4];
                    constant5.constant = -9;
                    
                    lock150Img.hidden = false;
                    reward150Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                    [rewards150Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                    NSLayoutConstraint *constant6 = yconstraintForReward[5];
                    constant6.constant = -9;
                    
                    lock200Img.hidden = false;
                    reward200Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                    [rewards200Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                    NSLayoutConstraint *constant7 = yconstraintForReward[6];
                    constant7.constant = -9;
                    
                    lock300Img.hidden = false;
                    reward300Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                    [rewards300Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                    NSLayoutConstraint *constant8 = yconstraintForReward[7];
                    constant8.constant = -9;
                    
                    lock400Img.hidden = false;
                    reward400Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                    [rewards400Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                    NSLayoutConstraint *constant9 = yconstraintForReward[8];
                    constant9.constant = -9;
                    
                    lock500Img.hidden = false;
                    reward500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                    [rewards500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                    NSLayoutConstraint *constant10 = yconstraintForReward[9];
                    constant10.constant = -9;
                    
                    lock750Img.hidden = false;
                    reward750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                    [rewards750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                    NSLayoutConstraint *constant11 = yconstraintForReward[10];
                    constant11.constant = -9;
                    
                    lock1000Img.hidden = false;
                    reward1000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                    [rewards1000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                    NSLayoutConstraint *constant12 = yconstraintForReward[11];
                    constant12.constant = -9;
                    
                    lock1250Img.hidden = false;
                    reward1250Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                    [rewards1250Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                    NSLayoutConstraint *constant13 = yconstraintForReward[12];
                    constant13.constant = -9;
                    
                    lock1500Img.hidden = false;
                    reward1500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                    [rewards1500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                    NSLayoutConstraint *constant14 = yconstraintForReward[13];
                    constant14.constant = -9;
                    
                    lock1750Img.hidden = false;
                    reward1750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                    [rewards1750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                    NSLayoutConstraint *constant15 = yconstraintForReward[14];
                    constant15.constant = -9;

                    lock2000Img.hidden = false;
                    reward2000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                    [rewards2000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                    NSLayoutConstraint *constant16 = yconstraintForReward[15];
                    constant16.constant = -9;
                    
                    
                    lock5000Img.hidden = false;
                    reward5000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                    [rewards5000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                    NSLayoutConstraint *constant17 = yconstraintForReward[16];
                    constant17.constant = -9;
                    
                    lock10000Img.hidden = false;
                    reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                    [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                    NSLayoutConstraint *constant18 = yconstraintForReward[17];
                    constant18.constant = -9;
                    
                }else if (totalStreak>=28 && totalStreak<100){
                //        challengeName= @"21 Day Challenge";
                        lock3Img.hidden = true;
                        reward3Label.textColor = [UIColor blackColor];//[Utility colorWithHexString:BlueBadgeColor];
                        [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                        //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                        NSLayoutConstraint *constant1 = yconstraintForReward[0];
                        constant1.constant = 70;
                        
                        lock7Img.hidden = true;
                        reward7Label.textColor = [UIColor blackColor];//[Utility colorWithHexString:BlueBadgeColor];
                        [rewards7Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                        [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                        NSLayoutConstraint *constant2 = yconstraintForReward[1];
                        constant2.constant = 70;
                        
                        lock14Img.hidden = true;
                        reward14Label.textColor = [UIColor blackColor]; //[Utility colorWithHexString:BlueBadgeColor];
                        [rewards14Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                        [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                        NSLayoutConstraint *constant3 = yconstraintForReward[2];
                        constant3.constant = 70;
                        
                        lock28Img.hidden = true;
                        reward28Label.textColor = [UIColor blackColor];//[Utility colorWithHexString:BlueBadgeColor];
                        [rewards28Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                        [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                        NSLayoutConstraint *constant4 = yconstraintForReward[3];
                        constant4.constant = 70;
                        
                        lock100Img.hidden = false;
                        reward100Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                        [rewards100Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                        [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                        NSLayoutConstraint *constant5 = yconstraintForReward[4];
                        constant5.constant = -9;
                        
                        lock150Img.hidden = false;
                        reward150Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                        [rewards150Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                        [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                        NSLayoutConstraint *constant6 = yconstraintForReward[5];
                        constant6.constant = -9;
                        
                        lock200Img.hidden = false;
                        reward200Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                        [rewards200Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                        [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                        NSLayoutConstraint *constant7 = yconstraintForReward[6];
                        constant7.constant = -9;
                        
                        lock300Img.hidden = false;
                        reward300Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                        [rewards300Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                        [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                        NSLayoutConstraint *constant8 = yconstraintForReward[7];
                        constant8.constant = -9;
                        
                        lock400Img.hidden = false;
                        reward400Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                        [rewards400Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                        [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                        NSLayoutConstraint *constant9 = yconstraintForReward[8];
                        constant9.constant = -9;
                        
                        lock500Img.hidden = false;
                        reward500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                        [rewards500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                        [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                        NSLayoutConstraint *constant10 = yconstraintForReward[9];
                        constant10.constant = -9;
                        
                        lock750Img.hidden = false;
                        reward750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                        [rewards750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                        [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                        NSLayoutConstraint *constant11 = yconstraintForReward[10];
                        constant11.constant = -9;
                        
                        lock1000Img.hidden = false;
                        reward1000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                        [rewards1000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                        [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                        NSLayoutConstraint *constant12 = yconstraintForReward[11];
                        constant12.constant = -9;
                        
                        lock1250Img.hidden = false;
                        reward1250Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                        [rewards1250Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                        [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                        NSLayoutConstraint *constant13 = yconstraintForReward[12];
                        constant13.constant = -9;
                        
                        lock1500Img.hidden = false;
                        reward1500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                        [rewards1500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                        [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                        NSLayoutConstraint *constant14 = yconstraintForReward[13];
                        constant14.constant = -9;
                        
                        lock1750Img.hidden = false;
                        reward1750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                        [rewards1750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                        [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                        NSLayoutConstraint *constant15 = yconstraintForReward[14];
                        constant15.constant = -9;

                        lock2000Img.hidden = false;
                        reward2000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                        [rewards2000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                        [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                        NSLayoutConstraint *constant16 = yconstraintForReward[15];
                        constant16.constant = -9;
                        
                        
                        lock5000Img.hidden = false;
                        reward5000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                        [rewards5000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                        [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                        NSLayoutConstraint *constant17 = yconstraintForReward[16];
                        constant17.constant = -9;
                        
                        lock10000Img.hidden = false;
                        reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                        [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                        [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                        NSLayoutConstraint *constant18 = yconstraintForReward[17];
                        constant18.constant = -9;
                        
                    }else if(totalStreak>=100 && totalStreak<150){
                    //        challengeName= @"21 Day Challenge";
                            lock3Img.hidden = true;
                            reward3Label.textColor =[UIColor blackColor];// [Utility colorWithHexString:BlueBadgeColor];
                            [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                            //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                            NSLayoutConstraint *constant1 = yconstraintForReward[0];
                            constant1.constant = 70;
                            
                            lock7Img.hidden = true;
                            reward7Label.textColor = [UIColor blackColor];//[Utility colorWithHexString:BlueBadgeColor];
                            [rewards7Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                            [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                            NSLayoutConstraint *constant2 = yconstraintForReward[1];
                            constant2.constant = 70;
                            
                            lock14Img.hidden = true;
                            reward14Label.textColor = [UIColor blackColor];//[Utility colorWithHexString:BlueBadgeColor];
                            [rewards14Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                            [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                            NSLayoutConstraint *constant3 = yconstraintForReward[2];
                            constant3.constant = 70;
                            
                            lock28Img.hidden = true;
                            reward28Label.textColor = [UIColor blackColor];//[Utility colorWithHexString:BlueBadgeColor];
                            [rewards28Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                            [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                            NSLayoutConstraint *constant4 = yconstraintForReward[3];
                            constant4.constant = 70;
                            
                            lock100Img.hidden = true;
                            reward100Label.textColor = [UIColor blackColor];
                            [rewards100Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                            [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                            NSLayoutConstraint *constant5 = yconstraintForReward[4];
                            constant5.constant = 70;
                            
                            lock150Img.hidden = false;
                            reward150Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                            [rewards150Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                            [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                            NSLayoutConstraint *constant6 = yconstraintForReward[5];
                            constant6.constant = -9;
                            
                            lock200Img.hidden = false;
                            reward200Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                            [rewards200Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                            [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                            NSLayoutConstraint *constant7 = yconstraintForReward[6];
                            constant7.constant = -9;
                            
                            lock300Img.hidden = false;
                            reward300Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                            [rewards300Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                            [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                            NSLayoutConstraint *constant8 = yconstraintForReward[7];
                            constant8.constant = -9;
                            
                            lock400Img.hidden = false;
                            reward400Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                            [rewards400Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                            [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                            NSLayoutConstraint *constant9 = yconstraintForReward[8];
                            constant9.constant = -9;
                            
                            lock500Img.hidden = false;
                            reward500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                            [rewards500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                            [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                            NSLayoutConstraint *constant10 = yconstraintForReward[9];
                            constant10.constant = -9;
                            
                            lock750Img.hidden = false;
                            reward750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                            [rewards750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                            [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                            NSLayoutConstraint *constant11 = yconstraintForReward[10];
                            constant11.constant = -9;
                            
                            lock1000Img.hidden = false;
                            reward1000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                            [rewards1000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                            [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                            NSLayoutConstraint *constant12 = yconstraintForReward[11];
                            constant12.constant = -9;
                            
                            lock1250Img.hidden = false;
                            reward1250Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                            [rewards1250Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                            [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                            NSLayoutConstraint *constant13 = yconstraintForReward[12];
                            constant13.constant = -9;
                            
                            lock1500Img.hidden = false;
                            reward1500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                            [rewards1500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                            [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                            NSLayoutConstraint *constant14 = yconstraintForReward[13];
                            constant14.constant = -9;
                            
                            lock1750Img.hidden = false;
                            reward1750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                            [rewards1750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                            [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                            NSLayoutConstraint *constant15 = yconstraintForReward[14];
                            constant15.constant = -9;

                            lock2000Img.hidden = false;
                            reward2000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                            [rewards2000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                            [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                            NSLayoutConstraint *constant16 = yconstraintForReward[15];
                            constant16.constant = -9;
                            
                            
                            lock5000Img.hidden = false;
                            reward5000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                            [rewards5000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                            [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                            NSLayoutConstraint *constant17 = yconstraintForReward[16];
                            constant17.constant = -9;
                            
                            lock10000Img.hidden = false;
                            reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                            [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                            [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                            NSLayoutConstraint *constant18 = yconstraintForReward[17];
                            constant18.constant = -9;
                            
                        }else if(totalStreak>=150 && totalStreak<200){
                                            //        challengeName= @"21 Day Challenge";
                                                    lock3Img.hidden = true;
                                                    reward3Label.textColor = [UIColor blackColor];
                                                    [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                                                    //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                    NSLayoutConstraint *constant1 = yconstraintForReward[0];
                                                    constant1.constant = 70;
                                                    
                                                    lock7Img.hidden = true;
                                                    reward7Label.textColor = [UIColor blackColor];
                                                    [rewards7Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                        //                            [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant2 = yconstraintForReward[1];
                                                    constant2.constant = 70;
                                                    
                                                    lock14Img.hidden = true;
                                                    reward14Label.textColor = [UIColor blackColor];
                                                    [rewards14Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                        //                            [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant3 = yconstraintForReward[2];
                                                    constant3.constant = 70;
                                                    
                                                    lock28Img.hidden = true;
                                                    reward28Label.textColor = [UIColor blackColor];
                                                    [rewards28Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                        //                            [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant4 = yconstraintForReward[3];
                                                    constant4.constant = 70;
                                                    
                                                    lock100Img.hidden = true;
                                                    reward100Label.textColor = [UIColor blackColor];
                                                    [rewards100Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                        //                            [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant5 = yconstraintForReward[4];
                                                    constant5.constant = 70;
                                                    
                                                    lock150Img.hidden = true;
                                                    reward150Label.textColor = [UIColor blackColor];
                                                    [rewards150Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                    [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant6 = yconstraintForReward[5];
                                                    constant6.constant = 70;
                                                    
                                                    lock200Img.hidden = false;
                                                    reward200Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards200Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant7 = yconstraintForReward[6];
                                                    constant7.constant = -9;
                                                    
                                                    lock300Img.hidden = false;
                                                    reward300Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards300Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant8 = yconstraintForReward[7];
                                                    constant8.constant = -9;
                                                    
                                                    lock400Img.hidden = false;
                                                    reward400Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards400Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant9 = yconstraintForReward[8];
                                                    constant9.constant = -9;
                                                    
                                                    lock500Img.hidden = false;
                                                    reward500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant10 = yconstraintForReward[9];
                                                    constant10.constant = -9;
                                                    
                                                    lock750Img.hidden = false;
                                                    reward750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant11 = yconstraintForReward[10];
                                                    constant11.constant = -9;
                                                    
                                                    lock1000Img.hidden = false;
                                                    reward1000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards1000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant12 = yconstraintForReward[11];
                                                    constant12.constant = -9;
                                                    
                                                    lock1250Img.hidden = false;
                                                    reward1250Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards1250Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant13 = yconstraintForReward[12];
                                                    constant13.constant = -9;
                                                    
                                                    lock1500Img.hidden = false;
                                                    reward1500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards1500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant14 = yconstraintForReward[13];
                                                    constant14.constant = -9;
                                                    
                                                    lock1750Img.hidden = false;
                                                    reward1750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards1750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant15 = yconstraintForReward[14];
                                                    constant15.constant = -9;

                                                    lock2000Img.hidden = false;
                                                    reward2000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards2000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant16 = yconstraintForReward[15];
                                                    constant16.constant = -9;
                                                    
                                                    
                                                    lock5000Img.hidden = false;
                                                    reward5000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards5000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant17 = yconstraintForReward[16];
                                                    constant17.constant = -9;
                                                    
                                                    lock10000Img.hidden = false;
                                                    reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant18 = yconstraintForReward[17];
                                                    constant18.constant = -9;
                                                    
                                                }else if(totalStreak>=200 && totalStreak<300){
                        //        challengeName= @"21 Day Challenge";
                                lock3Img.hidden = true;
                                reward3Label.textColor = [UIColor blackColor];
                                [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                                //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                NSLayoutConstraint *constant1 = yconstraintForReward[0];
                                constant1.constant = 70;
                                
                                lock7Img.hidden = true;
                                reward7Label.textColor = [UIColor blackColor];
                                [rewards7Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                NSLayoutConstraint *constant2 = yconstraintForReward[1];
                                constant2.constant = 70;
                                
                                lock14Img.hidden = true;
                                reward14Label.textColor = [UIColor blackColor];
                                [rewards14Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                NSLayoutConstraint *constant3 = yconstraintForReward[2];
                                constant3.constant = 70;
                                
                                lock28Img.hidden = true;
                                reward28Label.textColor = [UIColor blackColor];
                                [rewards28Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                NSLayoutConstraint *constant4 = yconstraintForReward[3];
                                constant4.constant = 70;
                                
                                lock100Img.hidden = true;
                                reward100Label.textColor = [UIColor blackColor];
                                [rewards100Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                NSLayoutConstraint *constant5 = yconstraintForReward[4];
                                constant5.constant = 70;
                                
                                lock150Img.hidden = true;
                                reward150Label.textColor = [UIColor blackColor];
                                [rewards150Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                NSLayoutConstraint *constant6 = yconstraintForReward[5];
                                constant6.constant = 70;
                                
                                lock200Img.hidden = true;
                                reward200Label.textColor = [UIColor blackColor];
                                [rewards200Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                NSLayoutConstraint *constant7 = yconstraintForReward[6];
                                constant7.constant = 70;
                                
                                lock300Img.hidden = false;
                                reward300Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                [rewards300Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                NSLayoutConstraint *constant8 = yconstraintForReward[7];
                                constant8.constant = -9;
                                
                                lock400Img.hidden = false;
                                reward400Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                [rewards400Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                NSLayoutConstraint *constant9 = yconstraintForReward[8];
                                constant9.constant = -9;
                                
                                lock500Img.hidden = false;
                                reward500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                [rewards500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                NSLayoutConstraint *constant10 = yconstraintForReward[9];
                                constant10.constant = -9;
                                
                                lock750Img.hidden = false;
                                reward750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                [rewards750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                NSLayoutConstraint *constant11 = yconstraintForReward[10];
                                constant11.constant = -9;
                                
                                lock1000Img.hidden = false;
                                reward1000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                [rewards1000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                NSLayoutConstraint *constant12 = yconstraintForReward[11];
                                constant12.constant = -9;
                                
                                lock1250Img.hidden = false;
                                reward1250Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                [rewards1250Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                NSLayoutConstraint *constant13 = yconstraintForReward[12];
                                constant13.constant = -9;
                                
                                lock1500Img.hidden = false;
                                reward1500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                [rewards1500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                NSLayoutConstraint *constant14 = yconstraintForReward[13];
                                constant14.constant = -9;
                                
                                lock1750Img.hidden = false;
                                reward1750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                [rewards1750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                NSLayoutConstraint *constant15 = yconstraintForReward[14];
                                constant15.constant = -9;

                                lock2000Img.hidden = false;
                                reward2000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                [rewards2000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                NSLayoutConstraint *constant16 = yconstraintForReward[15];
                                constant16.constant = -9;
                                
                                
                                lock5000Img.hidden = false;
                                reward5000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                [rewards5000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                NSLayoutConstraint *constant17 = yconstraintForReward[16];
                                constant17.constant = -9;
                                
                                lock10000Img.hidden = false;
                                reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                NSLayoutConstraint *constant18 = yconstraintForReward[17];
                                constant18.constant = -9;
                                
                            }else if(totalStreak>=300 && totalStreak<400){
                            //        challengeName= @"21 Day Challenge";
                                    lock3Img.hidden = true;
                                    reward3Label.textColor = [UIColor blackColor];
                                    [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                                    //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                    NSLayoutConstraint *constant1 = yconstraintForReward[0];
                                    constant1.constant = 70;
                                    
                                    lock7Img.hidden = true;
                                    reward7Label.textColor = [UIColor blackColor];
                                    [rewards7Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                    [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                    NSLayoutConstraint *constant2 = yconstraintForReward[1];
                                    constant2.constant = 70;
                                    
                                    lock14Img.hidden = true;
                                    reward14Label.textColor = [UIColor blackColor];
                                    [rewards14Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                    [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                    NSLayoutConstraint *constant3 = yconstraintForReward[2];
                                    constant3.constant = 70;
                                    
                                    lock28Img.hidden = true;
                                    reward28Label.textColor = [UIColor blackColor];
                                    [rewards28Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                    [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                    NSLayoutConstraint *constant4 = yconstraintForReward[3];
                                    constant4.constant = 70;
                                    
                                    lock100Img.hidden = true;
                                    reward100Label.textColor = [UIColor blackColor];
                                    [rewards100Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                    [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                    NSLayoutConstraint *constant5 = yconstraintForReward[4];
                                    constant5.constant = 70;
                                    
                                    lock150Img.hidden = true;
                                    reward150Label.textColor = [UIColor blackColor];
                                    [rewards150Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                    [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                    NSLayoutConstraint *constant6 = yconstraintForReward[5];
                                    constant6.constant = 70;
                                    
                                    lock200Img.hidden = true;
                                    reward200Label.textColor = [UIColor blackColor];
                                    [rewards200Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                    [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                    NSLayoutConstraint *constant7 = yconstraintForReward[6];
                                    constant7.constant = 70;
                                    
                                    lock300Img.hidden = true;
                                    reward300Label.textColor = [UIColor blackColor];
                                    [rewards300Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                    [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                    NSLayoutConstraint *constant8 = yconstraintForReward[7];
                                    constant8.constant = 70;
                                    
                                    lock400Img.hidden = false;
                                    reward400Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                    [rewards400Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                    [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                    NSLayoutConstraint *constant9 = yconstraintForReward[8];
                                    constant9.constant = -9;
                                    
                                    lock500Img.hidden = false;
                                    reward500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                    [rewards500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                    [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                    NSLayoutConstraint *constant10 = yconstraintForReward[9];
                                    constant10.constant = -9;
                                    
                                    lock750Img.hidden = false;
                                    reward750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                    [rewards750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                    [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                    NSLayoutConstraint *constant11 = yconstraintForReward[10];
                                    constant11.constant = -9;
                                    
                                    lock1000Img.hidden = false;
                                    reward1000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                    [rewards1000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                    [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                    NSLayoutConstraint *constant12 = yconstraintForReward[11];
                                    constant12.constant = -9;
                                    
                                    lock1250Img.hidden = false;
                                    reward1250Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                    [rewards1250Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                    [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                    NSLayoutConstraint *constant13 = yconstraintForReward[12];
                                    constant13.constant = -9;
                                    
                                    lock1500Img.hidden = false;
                                    reward1500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                    [rewards1500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                    [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                    NSLayoutConstraint *constant14 = yconstraintForReward[13];
                                    constant14.constant = -9;
                                    
                                    lock1750Img.hidden = false;
                                    reward1750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                    [rewards1750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                    [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                    NSLayoutConstraint *constant15 = yconstraintForReward[14];
                                    constant15.constant = -9;

                                    lock2000Img.hidden = false;
                                    reward2000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                    [rewards2000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                    [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                    NSLayoutConstraint *constant16 = yconstraintForReward[15];
                                    constant16.constant = -9;
                                    
                                    
                                    lock5000Img.hidden = false;
                                    reward5000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                    [rewards5000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                    [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                    NSLayoutConstraint *constant17 = yconstraintForReward[16];
                                    constant17.constant = -9;
                                    
                                    lock10000Img.hidden = false;
                                    reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                    [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                    [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                    NSLayoutConstraint *constant18 = yconstraintForReward[17];
                                    constant18.constant = -9;
                                    
                                }else if(totalStreak>=400 && totalStreak<500){
                                //        challengeName= @"21 Day Challenge";
                                        lock3Img.hidden = true;
                                        reward3Label.textColor = [UIColor blackColor];
                                        [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                                        //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                        NSLayoutConstraint *constant1 = yconstraintForReward[0];
                                        constant1.constant =70;
                                        
                                        lock7Img.hidden = true;
                                        reward7Label.textColor = [UIColor blackColor];
                                        [rewards7Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                        [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                        NSLayoutConstraint *constant2 = yconstraintForReward[1];
                                        constant2.constant = 70;
                                        
                                        lock14Img.hidden = true;
                                        reward14Label.textColor = [UIColor blackColor];
                                        [rewards14Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                        [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                        NSLayoutConstraint *constant3 = yconstraintForReward[2];
                                        constant3.constant = 70;
                                        
                                        lock28Img.hidden = true;
                                        reward28Label.textColor = [UIColor blackColor];
                                        [rewards28Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                        [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                        NSLayoutConstraint *constant4 = yconstraintForReward[3];
                                        constant4.constant = 70;
                                        
                                        lock100Img.hidden = true;
                                        reward100Label.textColor = [UIColor blackColor];
                                        [rewards100Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                        [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                        NSLayoutConstraint *constant5 = yconstraintForReward[4];
                                        constant5.constant = 70;
                                        
                                        lock150Img.hidden = true;
                                        reward150Label.textColor = [UIColor blackColor];
                                        [rewards150Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                        [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                        NSLayoutConstraint *constant6 = yconstraintForReward[5];
                                        constant6.constant = 70;
                                        
                                        lock200Img.hidden = true;
                                        reward200Label.textColor = [UIColor blackColor];
                                        [rewards200Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                        [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                        NSLayoutConstraint *constant7 = yconstraintForReward[6];
                                        constant7.constant = 70;
                                        
                                        lock300Img.hidden = true;
                                        reward300Label.textColor = [UIColor blackColor];
                                        [rewards300Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                        [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                        NSLayoutConstraint *constant8 = yconstraintForReward[7];
                                        constant8.constant = 70;
                                        
                                        lock400Img.hidden = true;
                                        reward400Label.textColor = [UIColor blackColor];
                                        [rewards400Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                        [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                        NSLayoutConstraint *constant9 = yconstraintForReward[8];
                                        constant9.constant = 70;
                                        
                                        lock500Img.hidden = false;
                                        reward500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                        [rewards500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                        [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                        NSLayoutConstraint *constant10 = yconstraintForReward[9];
                                        constant10.constant = -9;
                                        
                                        lock750Img.hidden = false;
                                        reward750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                        [rewards750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                        [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                        NSLayoutConstraint *constant11 = yconstraintForReward[10];
                                        constant11.constant = -9;
                                        
                                        lock1000Img.hidden = false;
                                        reward1000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                        [rewards1000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                        [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                        NSLayoutConstraint *constant12 = yconstraintForReward[11];
                                        constant12.constant = -9;
                                        
                                        lock1250Img.hidden = false;
                                        reward1250Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                        [rewards1250Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                        [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                        NSLayoutConstraint *constant13 = yconstraintForReward[12];
                                        constant13.constant = -9;
                                        
                                        lock1500Img.hidden = false;
                                        reward1500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                        [rewards1500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                        [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                        NSLayoutConstraint *constant14 = yconstraintForReward[13];
                                        constant14.constant = -9;
                                        
                                        lock1750Img.hidden = false;
                                        reward1750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                        [rewards1750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                        [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                        NSLayoutConstraint *constant15 = yconstraintForReward[14];
                                        constant15.constant = -9;

                                        lock2000Img.hidden = false;
                                        reward2000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                        [rewards2000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                        [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                        NSLayoutConstraint *constant16 = yconstraintForReward[15];
                                        constant16.constant = -9;
                                        
                                        
                                        lock5000Img.hidden = false;
                                        reward5000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                        [rewards5000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                        [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                        NSLayoutConstraint *constant17 = yconstraintForReward[16];
                                        constant17.constant = -9;
                                        
                                        lock10000Img.hidden = false;
                                        reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                        [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                        [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                        NSLayoutConstraint *constant18 = yconstraintForReward[17];
                                        constant18.constant = -9;
                                        
                                    }else if(totalStreak>=500 && totalStreak<750){
                                    //        challengeName= @"21 Day Challenge";
                                            lock3Img.hidden = true;
                                            reward3Label.textColor = [UIColor blackColor];
                                            [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                                            //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                            NSLayoutConstraint *constant1 = yconstraintForReward[0];
                                            constant1.constant = 70;
                                            
                                            lock7Img.hidden = true;
                                            reward7Label.textColor = [UIColor blackColor];
                                            [rewards7Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                            [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                            NSLayoutConstraint *constant2 = yconstraintForReward[1];
                                            constant2.constant = 70;
                                            
                                            lock14Img.hidden = true;
                                            reward14Label.textColor = [UIColor blackColor];
                                            [rewards14Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                            [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                            NSLayoutConstraint *constant3 = yconstraintForReward[2];
                                            constant3.constant = 70;
                                            
                                            lock28Img.hidden = true;
                                            reward28Label.textColor = [UIColor blackColor];
                                            [rewards28Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                            [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                            NSLayoutConstraint *constant4 = yconstraintForReward[3];
                                            constant4.constant = 70;
                                            
                                            lock100Img.hidden = true;
                                            reward100Label.textColor = [UIColor blackColor];
                                            [rewards100Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                            [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                            NSLayoutConstraint *constant5 = yconstraintForReward[4];
                                            constant5.constant = 70;
                                            
                                            lock150Img.hidden = true;
                                            reward150Label.textColor = [UIColor blackColor];
                                            [rewards150Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                            [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                            NSLayoutConstraint *constant6 = yconstraintForReward[5];
                                            constant6.constant = 70;
                                            
                                            lock200Img.hidden = true;
                                            reward200Label.textColor = [UIColor blackColor];
                                            [rewards200Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                            [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                            NSLayoutConstraint *constant7 = yconstraintForReward[6];
                                            constant7.constant = 70;
                                            
                                            lock300Img.hidden = true;
                                            reward300Label.textColor = [UIColor blackColor];
                                            [rewards300Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                            [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                            NSLayoutConstraint *constant8 = yconstraintForReward[7];
                                            constant8.constant = 70;
                                            
                                            lock400Img.hidden = true;
                                            reward400Label.textColor = [UIColor blackColor];
                                            [rewards400Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                            [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                            NSLayoutConstraint *constant9 = yconstraintForReward[8];
                                            constant9.constant = 70;
                                            
                                            lock500Img.hidden = true;
                                            reward500Label.textColor = [UIColor blackColor];
                                            [rewards500Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                            [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                            NSLayoutConstraint *constant10 = yconstraintForReward[9];
                                            constant10.constant = 70;
                                            
                                            lock750Img.hidden = false;
                                            reward750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                            [rewards750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                            [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                            NSLayoutConstraint *constant11 = yconstraintForReward[10];
                                            constant11.constant = -9;
                                            
                                            lock1000Img.hidden = false;
                                            reward1000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                            [rewards1000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                            [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                            NSLayoutConstraint *constant12 = yconstraintForReward[11];
                                            constant12.constant = -9;
                                            
                                            lock1250Img.hidden = false;
                                            reward1250Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                            [rewards1250Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                            [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                            NSLayoutConstraint *constant13 = yconstraintForReward[12];
                                            constant13.constant = -9;
                                            
                                            lock1500Img.hidden = false;
                                            reward1500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                            [rewards1500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                            [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                            NSLayoutConstraint *constant14 = yconstraintForReward[13];
                                            constant14.constant = -9;
                                            
                                            lock1750Img.hidden = false;
                                            reward1750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                            [rewards1750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                            [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                            NSLayoutConstraint *constant15 = yconstraintForReward[14];
                                            constant15.constant = -9;

                                            lock2000Img.hidden = false;
                                            reward2000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                            [rewards2000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                            [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                            NSLayoutConstraint *constant16 = yconstraintForReward[15];
                                            constant16.constant = -9;
                                            
                                            
                                            lock5000Img.hidden = false;
                                            reward5000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                            [rewards5000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                            [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                            NSLayoutConstraint *constant17 = yconstraintForReward[16];
                                            constant17.constant = -9;
                                            
                                            lock10000Img.hidden = false;
                                            reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                            [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                            [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                            NSLayoutConstraint *constant18 = yconstraintForReward[17];
                                            constant18.constant = -9;
                                            
                                        }else if(totalStreak>=750 && totalStreak<1000){
                                        //        challengeName= @"21 Day Challenge";
                                                lock3Img.hidden = true;
                                                reward3Label.textColor = [UIColor blackColor];
                                                [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                                                //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                NSLayoutConstraint *constant1 = yconstraintForReward[0];
                                                constant1.constant = 70;
                                                
                                                lock7Img.hidden = true;
                                                reward7Label.textColor = [UIColor blackColor];
                                                [rewards7Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                NSLayoutConstraint *constant2 = yconstraintForReward[1];
                                                constant2.constant = 70;
                                                
                                                lock14Img.hidden = true;
                                                reward14Label.textColor = [UIColor blackColor];
                                                [rewards14Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                NSLayoutConstraint *constant3 = yconstraintForReward[2];
                                                constant3.constant = 70;
                                                
                                                lock28Img.hidden = true;
                                                reward28Label.textColor = [UIColor blackColor];
                                                [rewards28Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                NSLayoutConstraint *constant4 = yconstraintForReward[3];
                                                constant4.constant = 70;
                                                
                                                lock100Img.hidden = true;
                                                reward100Label.textColor = [UIColor blackColor];
                                                [rewards100Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                NSLayoutConstraint *constant5 = yconstraintForReward[4];
                                                constant5.constant = 70;
                                                
                                                lock150Img.hidden = true;
                                                reward150Label.textColor = [UIColor blackColor];
                                                [rewards150Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                NSLayoutConstraint *constant6 = yconstraintForReward[5];
                                                constant6.constant = 70;
                                                
                                                lock200Img.hidden = true;
                                                reward200Label.textColor = [UIColor blackColor];
                                                [rewards200Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                NSLayoutConstraint *constant7 = yconstraintForReward[6];
                                                constant7.constant = 70;
                                                
                                                lock300Img.hidden = true;
                                                reward300Label.textColor = [UIColor blackColor];
                                                [rewards300Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                NSLayoutConstraint *constant8 = yconstraintForReward[7];
                                                constant8.constant = 70;
                                                
                                                lock400Img.hidden = true;
                                                reward400Label.textColor = [UIColor blackColor];
                                                [rewards400Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                NSLayoutConstraint *constant9 = yconstraintForReward[8];
                                                constant9.constant = 70;
                                                
                                                lock500Img.hidden = true;
                                                reward500Label.textColor = [UIColor blackColor];
                                                [rewards500Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                NSLayoutConstraint *constant10 = yconstraintForReward[9];
                                                constant10.constant = 70;
                                                
                                                lock750Img.hidden = true;
                                                reward750Label.textColor = [UIColor blackColor];
                                                [rewards750Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                NSLayoutConstraint *constant11 = yconstraintForReward[10];
                                                constant11.constant = 70;
                                                
                                                lock1000Img.hidden = false;
                                                reward1000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                [rewards1000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                NSLayoutConstraint *constant12 = yconstraintForReward[11];
                                                constant12.constant = -9;
                                                
                                                lock1250Img.hidden = false;
                                                reward1250Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                [rewards1250Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                NSLayoutConstraint *constant13 = yconstraintForReward[12];
                                                constant13.constant = -9;
                                                
                                                lock1500Img.hidden = false;
                                                reward1500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                [rewards1500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                NSLayoutConstraint *constant14 = yconstraintForReward[13];
                                                constant14.constant = -9;
                                                
                                                lock1750Img.hidden = false;
                                                reward1750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                [rewards1750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                NSLayoutConstraint *constant15 = yconstraintForReward[14];
                                                constant15.constant = -9;

                                                lock2000Img.hidden = false;
                                                reward2000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                [rewards2000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                NSLayoutConstraint *constant16 = yconstraintForReward[15];
                                                constant16.constant = -9;
                                                
                                                
                                                lock5000Img.hidden = false;
                                                reward5000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                [rewards5000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                NSLayoutConstraint *constant17 = yconstraintForReward[16];
                                                constant17.constant = -9;
                                                
                                                lock10000Img.hidden = false;
                                                reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                NSLayoutConstraint *constant18 = yconstraintForReward[17];
                                                constant18.constant = -9;
                                                
                                            }else if(totalStreak>=1000 && totalStreak<1250){
                                            //        challengeName= @"21 Day Challenge";
                                                    lock3Img.hidden = true;
                                                    reward3Label.textColor = [UIColor blackColor];
                                                    [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                                                    //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                    NSLayoutConstraint *constant1 = yconstraintForReward[0];
                                                    constant1.constant = -9;
                                                    
                                                    lock7Img.hidden = true;
                                                    reward7Label.textColor = [UIColor blackColor];
                                                    [rewards7Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                    [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant2 = yconstraintForReward[1];
                                                    constant2.constant = 70;
                                                    
                                                    lock14Img.hidden = true;
                                                    reward14Label.textColor = [UIColor blackColor];
                                                    [rewards14Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                    [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant3 = yconstraintForReward[2];
                                                    constant3.constant = 70;
                                                    
                                                    lock28Img.hidden = true;
                                                    reward28Label.textColor = [UIColor blackColor];
                                                    [rewards28Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                    [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant4 = yconstraintForReward[3];
                                                    constant4.constant = 70;
                                                    
                                                    lock100Img.hidden = true;
                                                    reward100Label.textColor = [UIColor blackColor];
                                                    [rewards100Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                    [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant5 = yconstraintForReward[4];
                                                    constant5.constant = 70;
                                                    
                                                    lock150Img.hidden = true;
                                                    reward150Label.textColor = [UIColor blackColor];
                                                    [rewards150Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                    [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant6 = yconstraintForReward[5];
                                                    constant6.constant = 70;
                                                    
                                                    lock200Img.hidden = true;
                                                    reward200Label.textColor = [UIColor blackColor];
                                                    [rewards200Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                    [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant7 = yconstraintForReward[6];
                                                    constant7.constant = 70;
                                                    
                                                    lock300Img.hidden = true;
                                                    reward300Label.textColor = [UIColor blackColor];
                                                    [rewards300Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                    [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant8 = yconstraintForReward[7];
                                                    constant8.constant = 70;
                                                    
                                                    lock400Img.hidden = true;
                                                    reward400Label.textColor = [UIColor blackColor];
                                                    [rewards400Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                    [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant9 = yconstraintForReward[8];
                                                    constant9.constant = 70;
                                                    
                                                    lock500Img.hidden = true;
                                                    reward500Label.textColor = [UIColor blackColor];
                                                    [rewards500Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                    [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant10 = yconstraintForReward[9];
                                                    constant10.constant = 70;
                                                    
                                                    lock750Img.hidden = true;
                                                    reward750Label.textColor = [UIColor blackColor];
                                                    [rewards750Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                    [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant11 = yconstraintForReward[10];
                                                    constant11.constant = 70;
                                                    
                                                    lock1000Img.hidden = true;
                                                    reward1000Label.textColor = [UIColor blackColor];
                                                    [rewards1000Img setImage:[[UIImage imageNamed:@"manny_trophy.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant12 = yconstraintForReward[11];
                                                    constant12.constant = 70;
                                                    
                                                    lock1250Img.hidden = false;
                                                    reward1250Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards1250Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant13 = yconstraintForReward[12];
                                                    constant13.constant = -9;
                                                    
                                                    lock1500Img.hidden = false;
                                                    reward1500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards1500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant14 = yconstraintForReward[13];
                                                    constant14.constant = -9;
                                                    
                                                    lock1750Img.hidden = false;
                                                    reward1750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards1750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant15 = yconstraintForReward[14];
                                                    constant15.constant = -9;

                                                    lock2000Img.hidden = false;
                                                    reward2000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards2000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant16 = yconstraintForReward[15];
                                                    constant16.constant = -9;
                                                    
                                                    
                                                    lock5000Img.hidden = false;
                                                    reward5000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards5000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant17 = yconstraintForReward[16];
                                                    constant17.constant = -9;
                                                    
                                                    lock10000Img.hidden = false;
                                                    reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                    [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                    [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                    NSLayoutConstraint *constant18 = yconstraintForReward[17];
                                                    constant18.constant = -9;
                                                    
                                                }else if(totalStreak>=1250 && totalStreak<1500){
                                                //        challengeName= @"21 Day Challenge";
                                                        lock3Img.hidden = true;
                                                        reward3Label.textColor = [UIColor blackColor];
                                                        [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                                                        //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                        NSLayoutConstraint *constant1 = yconstraintForReward[0];
                                                        constant1.constant = 70;
                                                        
                                                        lock7Img.hidden = true;
                                                        reward7Label.textColor = [UIColor blackColor];
                                                        [rewards7Img setImage:[[UIImage imageNamed:@"manny_trophy.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
//                                                        [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                        NSLayoutConstraint *constant2 = yconstraintForReward[1];
                                                        constant2.constant = 70;
                                                        
                                                        lock14Img.hidden = true;
                                                        reward14Label.textColor = [UIColor blackColor];
                                                        [rewards14Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                        [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                        NSLayoutConstraint *constant3 = yconstraintForReward[2];
                                                        constant3.constant = 70;
                                                        
                                                        lock28Img.hidden = true;
                                                        reward28Label.textColor = [UIColor blackColor];
                                                        [rewards28Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                        [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                        NSLayoutConstraint *constant4 = yconstraintForReward[3];
                                                        constant4.constant = 70;
                                                        
                                                        lock100Img.hidden = true;
                                                        reward100Label.textColor = [UIColor blackColor];
                                                        [rewards100Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                        [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                        NSLayoutConstraint *constant5 = yconstraintForReward[4];
                                                        constant5.constant = 70;
                                                        
                                                        lock150Img.hidden = true;
                                                        reward150Label.textColor = [UIColor blackColor];
                                                        [rewards150Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                        [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                        NSLayoutConstraint *constant6 = yconstraintForReward[5];
                                                        constant6.constant = 70;
                                                        
                                                        lock200Img.hidden = true;
                                                        reward200Label.textColor = [UIColor blackColor];
                                                        [rewards200Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                        [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                        NSLayoutConstraint *constant7 = yconstraintForReward[6];
                                                        constant7.constant = 70;
                                                        
                                                        lock300Img.hidden = true;
                                                        reward300Label.textColor = [UIColor blackColor];
                                                        [rewards300Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                        [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                        NSLayoutConstraint *constant8 = yconstraintForReward[7];
                                                        constant8.constant = 70;
                                                        
                                                        lock400Img.hidden = true;
                                                        reward400Label.textColor = [UIColor blackColor];
                                                        [rewards400Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                        [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                        NSLayoutConstraint *constant9 = yconstraintForReward[8];
                                                        constant9.constant = 70;
                                                        
                                                        lock500Img.hidden = true;
                                                        reward500Label.textColor = [UIColor blackColor];
                                                        [rewards500Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                        [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                        NSLayoutConstraint *constant10 = yconstraintForReward[9];
                                                        constant10.constant = 70;
                                                        
                                                        lock750Img.hidden = true;
                                                        reward750Label.textColor = [UIColor blackColor];
                                                        [rewards750Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                        [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                        NSLayoutConstraint *constant11 = yconstraintForReward[10];
                                                        constant11.constant = 70;
                                                        
                                                        lock1000Img.hidden = true;
                                                        reward1000Label.textColor = [UIColor blackColor];
                                                        [rewards1000Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                        [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                        NSLayoutConstraint *constant12 = yconstraintForReward[11];
                                                        constant12.constant = 70;
                                                        
                                                        lock1250Img.hidden = true;
                                                        reward1250Label.textColor = [UIColor blackColor];
                                                        [rewards1250Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                        [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                        NSLayoutConstraint *constant13 = yconstraintForReward[12];
                                                        constant13.constant = 70;
                                                        
                                                        lock1500Img.hidden = false;
                                                        reward1500Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                        [rewards1500Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                        [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                        NSLayoutConstraint *constant14 = yconstraintForReward[13];
                                                        constant14.constant = -9;
                                                        
                                                        lock1750Img.hidden = false;
                                                        reward1750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                        [rewards1750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                        [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                        NSLayoutConstraint *constant15 = yconstraintForReward[14];
                                                        constant15.constant = -9;

                                                        lock2000Img.hidden = false;
                                                        reward2000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                        [rewards2000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                        [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                        NSLayoutConstraint *constant16 = yconstraintForReward[15];
                                                        constant16.constant = -9;
                                                        
                                                        
                                                        lock5000Img.hidden = false;
                                                        reward5000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                        [rewards5000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                        [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                        NSLayoutConstraint *constant17 = yconstraintForReward[16];
                                                        constant17.constant = -9;
                                                        
                                                        lock10000Img.hidden = false;
                                                        reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                        [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                        [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                        NSLayoutConstraint *constant18 = yconstraintForReward[17];
                                                        constant18.constant = -9;
                                                        
                                                    }else if(totalStreak>=1500 && totalStreak<1750){
                                                    //        challengeName= @"21 Day Challenge";
                                                            lock3Img.hidden = true;
                                                            reward3Label.textColor = [UIColor blackColor];
                                                            [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                                                            //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                            NSLayoutConstraint *constant1 = yconstraintForReward[0];
                                                            constant1.constant = 70;
                                                            
                                                            lock7Img.hidden = true;
                                                            reward7Label.textColor = [UIColor blackColor];
                                                            [rewards7Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                            [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                            NSLayoutConstraint *constant2 = yconstraintForReward[1];
                                                            constant2.constant = 70;
                                                            
                                                            lock14Img.hidden = true;
                                                            reward14Label.textColor = [UIColor blackColor];
                                                            [rewards14Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                            [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                            NSLayoutConstraint *constant3 = yconstraintForReward[2];
                                                            constant3.constant = 70;
                                                            
                                                            lock28Img.hidden = true;
                                                            reward28Label.textColor = [UIColor blackColor];
                                                            [rewards28Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                            [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                            NSLayoutConstraint *constant4 = yconstraintForReward[3];
                                                            constant4.constant = 70;
                                                            
                                                            lock100Img.hidden = true;
                                                            reward100Label.textColor = [UIColor blackColor];
                                                            [rewards100Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                            [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                            NSLayoutConstraint *constant5 = yconstraintForReward[4];
                                                            constant5.constant = 70;
                                                            
                                                            lock150Img.hidden = true;
                                                            reward150Label.textColor = [UIColor blackColor];
                                                            [rewards150Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                            [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                            NSLayoutConstraint *constant6 = yconstraintForReward[5];
                                                            constant6.constant = 70;
                                                            
                                                            lock200Img.hidden = true;
                                                            reward200Label.textColor = [UIColor blackColor];
                                                            [rewards200Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                            [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                            NSLayoutConstraint *constant7 = yconstraintForReward[6];
                                                            constant7.constant = 70;
                                                            
                                                            lock300Img.hidden = true;
                                                            reward300Label.textColor = [UIColor blackColor];
                                                            [rewards300Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                            [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                            NSLayoutConstraint *constant8 = yconstraintForReward[7];
                                                            constant8.constant = 70;
                                                            
                                                            lock400Img.hidden = true;
                                                            reward400Label.textColor = [UIColor blackColor];
                                                            [rewards400Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                            [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                            NSLayoutConstraint *constant9 = yconstraintForReward[8];
                                                            constant9.constant = 70;
                                                            
                                                            lock500Img.hidden = true;
                                                            reward500Label.textColor = [UIColor blackColor];
                                                            [rewards500Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                            [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                            NSLayoutConstraint *constant10 = yconstraintForReward[9];
                                                            constant10.constant = 70;
                                                            
                                                            lock750Img.hidden = true;
                                                            reward750Label.textColor = [UIColor blackColor];
                                                            [rewards750Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                            [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                            NSLayoutConstraint *constant11 = yconstraintForReward[10];
                                                            constant11.constant = 70;
                                                            
                                                            lock1000Img.hidden = true;
                                                            reward1000Label.textColor = [UIColor blackColor];
                                                            [rewards1000Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                            [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                            NSLayoutConstraint *constant12 = yconstraintForReward[11];
                                                            constant12.constant = 70;
                                                            
                                                            lock1250Img.hidden = true;
                                                            reward1250Label.textColor = [UIColor blackColor];
                                                            [rewards1250Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                            [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                            NSLayoutConstraint *constant13 = yconstraintForReward[12];
                                                            constant13.constant = 70;
                                                            
                                                            lock1500Img.hidden = true;
                                                            reward1500Label.textColor = [UIColor blackColor];
                                                            [rewards1500Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                            [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                            NSLayoutConstraint *constant14 = yconstraintForReward[13];
                                                            constant14.constant = 70;
                                                            
                                                            lock1750Img.hidden = false;
                                                            reward1750Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                            [rewards1750Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                            [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                            NSLayoutConstraint *constant15 = yconstraintForReward[14];
                                                            constant15.constant = -9;

                                                            lock2000Img.hidden = false;
                                                            reward2000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                            [rewards2000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                            [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                            NSLayoutConstraint *constant16 = yconstraintForReward[15];
                                                            constant16.constant = -9;
                                                            
                                                            
                                                            lock5000Img.hidden = false;
                                                            reward5000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                            [rewards5000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                            [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                            NSLayoutConstraint *constant17 = yconstraintForReward[16];
                                                            constant17.constant = -9;
                                                            
                                                            lock10000Img.hidden = false;
                                                            reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                            [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                            [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                            NSLayoutConstraint *constant18 = yconstraintForReward[17];
                                                            constant18.constant = -9;
                                                            
                                                        }else if(totalStreak>=1750 && totalStreak<2000){
                                                        //        challengeName= @"21 Day Challenge";
                                                                lock3Img.hidden = true;
                                                                reward3Label.textColor = [UIColor blackColor];
                                                                [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                                                                //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                                NSLayoutConstraint *constant1 = yconstraintForReward[0];
                                                                constant1.constant = 70;
                                                                
                                                                lock7Img.hidden = true;
                                                                reward7Label.textColor = [UIColor blackColor];
                                                                [rewards7Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                NSLayoutConstraint *constant2 = yconstraintForReward[1];
                                                                constant2.constant = 70;
                                                                
                                                                lock14Img.hidden = true;
                                                                reward14Label.textColor = [UIColor blackColor];
                                                                [rewards14Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                NSLayoutConstraint *constant3 = yconstraintForReward[2];
                                                                constant3.constant = 70;
                                                                
                                                                lock28Img.hidden = true;
                                                                reward28Label.textColor = [UIColor blackColor];
                                                                [rewards28Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                NSLayoutConstraint *constant4 = yconstraintForReward[3];
                                                                constant4.constant = 70;
                                                                
                                                                lock100Img.hidden = true;
                                                                reward100Label.textColor = [UIColor blackColor];
                                                                [rewards100Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                NSLayoutConstraint *constant5 = yconstraintForReward[4];
                                                                constant5.constant = 70;
                                                                
                                                                lock150Img.hidden = true;
                                                                reward150Label.textColor = [UIColor blackColor];
                                                                [rewards150Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                NSLayoutConstraint *constant6 = yconstraintForReward[5];
                                                                constant6.constant = 70;
                                                                
                                                                lock200Img.hidden = true;
                                                                reward200Label.textColor = [UIColor blackColor];
                                                                [rewards200Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                NSLayoutConstraint *constant7 = yconstraintForReward[6];
                                                                constant7.constant = 70;
                                                                
                                                                lock300Img.hidden = true;
                                                                reward300Label.textColor = [UIColor blackColor];
                                                                [rewards300Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                NSLayoutConstraint *constant8 = yconstraintForReward[7];
                                                                constant8.constant = 70;
                                                                
                                                                lock400Img.hidden = true;
                                                                reward400Label.textColor = [UIColor blackColor];
                                                                [rewards400Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                NSLayoutConstraint *constant9 = yconstraintForReward[8];
                                                                constant9.constant = 70;
                                                                
                                                                lock500Img.hidden = true;
                                                                reward500Label.textColor = [UIColor blackColor];
                                                                [rewards500Img setImage:[[UIImage imageNamed:@"manny_trophy.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                                [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                NSLayoutConstraint *constant10 = yconstraintForReward[9];
                                                                constant10.constant = 70;
                                                                
                                                                lock750Img.hidden = true;
                                                                reward750Label.textColor = [UIColor blackColor];
                                                                [rewards750Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                NSLayoutConstraint *constant11 = yconstraintForReward[10];
                                                                constant11.constant = 70;
                                                                
                                                                lock1000Img.hidden = true;
                                                                reward1000Label.textColor = [UIColor blackColor];
                                                                [rewards1000Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                NSLayoutConstraint *constant12 = yconstraintForReward[11];
                                                                constant12.constant = 70;
                                                                
                                                                lock1250Img.hidden = true;
                                                                reward1250Label.textColor = [UIColor blackColor];
                                                                [rewards1250Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                NSLayoutConstraint *constant13 = yconstraintForReward[12];
                                                                constant13.constant = 70;
                                                                
                                                                lock1500Img.hidden = true;
                                                                reward1500Label.textColor = [UIColor blackColor];
                                                                [rewards1500Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                NSLayoutConstraint *constant14 = yconstraintForReward[13];
                                                                constant14.constant = 70;
                                                                
                                                                lock1750Img.hidden = true;
                                                                reward1750Label.textColor = [UIColor blackColor];
                                                                [rewards1750Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                NSLayoutConstraint *constant15 = yconstraintForReward[14];
                                                                constant15.constant = 70;

                                                                lock2000Img.hidden = false;
                                                                reward2000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                                [rewards2000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                                [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                NSLayoutConstraint *constant16 = yconstraintForReward[15];
                                                                constant16.constant = -9;
                                                                
                                                                
                                                                lock5000Img.hidden = false;
                                                                reward5000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                                [rewards5000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                                [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                NSLayoutConstraint *constant17 = yconstraintForReward[16];
                                                                constant17.constant = -9;
                                                                
                                                                lock10000Img.hidden = false;
                                                                reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                                [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                                [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                NSLayoutConstraint *constant18 = yconstraintForReward[17];
                                                                constant18.constant = -9;
                                                                
                                                            }else if(totalStreak>=2000 && totalStreak<5000){
                                                            //        challengeName= @"21 Day Challenge";
                                                                    lock3Img.hidden = true;
                                                                    reward3Label.textColor = [UIColor blackColor];
                                                                    [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                                                                    //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                                    NSLayoutConstraint *constant1 = yconstraintForReward[0];
                                                                    constant1.constant = 70;
                                                                    
                                                                    lock7Img.hidden = true;
                                                                    reward7Label.textColor = [UIColor blackColor];
                                                                    [rewards7Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                    [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                    NSLayoutConstraint *constant2 = yconstraintForReward[1];
                                                                    constant2.constant = 70;
                                                                    
                                                                    lock14Img.hidden = true;
                                                                    reward14Label.textColor = [UIColor blackColor];
                                                                    [rewards14Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                    [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                    NSLayoutConstraint *constant3 = yconstraintForReward[2];
                                                                    constant3.constant = 70;
                                                                    
                                                                    lock28Img.hidden = true;
                                                                    reward28Label.textColor = [UIColor blackColor];
                                                                    [rewards28Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                    [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                    NSLayoutConstraint *constant4 = yconstraintForReward[3];
                                                                    constant4.constant = 70;
                                                                    
                                                                    lock100Img.hidden = true;
                                                                    reward100Label.textColor = [UIColor blackColor];
                                                                    [rewards100Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                    [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                    NSLayoutConstraint *constant5 = yconstraintForReward[4];
                                                                    constant5.constant = 70;
                                                                    
                                                                    lock150Img.hidden = true;
                                                                    reward150Label.textColor = [UIColor blackColor];
                                                                    [rewards150Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                    [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                    NSLayoutConstraint *constant6 = yconstraintForReward[5];
                                                                    constant6.constant = 70;
                                                                    
                                                                    lock200Img.hidden = true;
                                                                    reward200Label.textColor = [UIColor blackColor];
                                                                    [rewards200Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                    [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                    NSLayoutConstraint *constant7 = yconstraintForReward[6];
                                                                    constant7.constant = 70;
                                                                    
                                                                    lock300Img.hidden = true;
                                                                    reward300Label.textColor = [UIColor blackColor];
                                                                    [rewards300Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                    [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                    NSLayoutConstraint *constant8 = yconstraintForReward[7];
                                                                    constant8.constant = 70;
                                                                    
                                                                    lock400Img.hidden = true;
                                                                    reward400Label.textColor = [UIColor blackColor];
                                                                    [rewards400Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                    [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                    NSLayoutConstraint *constant9 = yconstraintForReward[8];
                                                                    constant9.constant = 70;
                                                                    
                                                                    lock500Img.hidden = true;
                                                                    reward500Label.textColor = [UIColor blackColor];
                                                                    [rewards500Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                    [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                    NSLayoutConstraint *constant10 = yconstraintForReward[9];
                                                                    constant10.constant = 70;
                                                                    
                                                                    lock750Img.hidden = true;
                                                                    reward750Label.textColor = [UIColor blackColor];
                                                                    [rewards750Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                    [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                    NSLayoutConstraint *constant11 = yconstraintForReward[10];
                                                                    constant11.constant = 70;
                                                                    
                                                                    lock1000Img.hidden = true;
                                                                    reward1000Label.textColor = [UIColor blackColor];
                                                                    [rewards1000Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                    [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                    NSLayoutConstraint *constant12 = yconstraintForReward[11];
                                                                    constant12.constant = 70;
                                                                    
                                                                    lock1250Img.hidden = true;
                                                                    reward1250Label.textColor = [UIColor blackColor];
                                                                    [rewards1250Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                    [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                    NSLayoutConstraint *constant13 = yconstraintForReward[12];
                                                                    constant13.constant = 70;
                                                                    
                                                                    lock1500Img.hidden = true;
                                                                    reward1500Label.textColor = [UIColor blackColor];
                                                                    [rewards1500Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                    [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                    NSLayoutConstraint *constant14 = yconstraintForReward[13];
                                                                    constant14.constant = 70;
                                                                    
                                                                    lock1750Img.hidden = true;
                                                                    reward1750Label.textColor = [UIColor blackColor];
                                                                    [rewards1750Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                    [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                    NSLayoutConstraint *constant15 = yconstraintForReward[14];
                                                                    constant15.constant = 70;

                                                                    lock2000Img.hidden = true;
                                                                    reward2000Label.textColor = [UIColor blackColor];
                                                                    [rewards2000Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                    [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                    NSLayoutConstraint *constant16 = yconstraintForReward[15];
                                                                    constant16.constant = 70;
                                                                    
                                                                    
                                                                    lock5000Img.hidden = false;
                                                                    reward5000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                                    [rewards5000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                                    [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                    NSLayoutConstraint *constant17 = yconstraintForReward[16];
                                                                    constant17.constant = -9;
                                                                    
                                                                    lock10000Img.hidden = false;
                                                                    reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                                    [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                                    [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                    NSLayoutConstraint *constant18 = yconstraintForReward[17];
                                                                    constant18.constant = -9;
                                                                    
                                                                }else if(totalStreak>=5000 && totalStreak<10000){
                                                                //        challengeName= @"21 Day Challenge";
                                                                        lock3Img.hidden = true;
                                                                        reward3Label.textColor = [UIColor blackColor];
                                                                        [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                                                                        //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                                        NSLayoutConstraint *constant1 = yconstraintForReward[0];
                                                                        constant1.constant = 70;
                                                                        
                                                                        lock7Img.hidden = true;
                                                                        reward7Label.textColor = [UIColor blackColor];
                                                                        [rewards7Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                        [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                        NSLayoutConstraint *constant2 = yconstraintForReward[1];
                                                                        constant2.constant = 70;
                                                                        
                                                                        lock14Img.hidden = true;
                                                                        reward14Label.textColor = [UIColor blackColor];
                                                                        [rewards14Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                        [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                        NSLayoutConstraint *constant3 = yconstraintForReward[2];
                                                                        constant3.constant = 70;
                                                                        
                                                                        lock28Img.hidden = true;
                                                                        reward28Label.textColor = [UIColor blackColor];
                                                                        [rewards28Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                        [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                        NSLayoutConstraint *constant4 = yconstraintForReward[3];
                                                                        constant4.constant = 70;
                                                                        
                                                                        lock100Img.hidden = true;
                                                                        reward100Label.textColor = [UIColor blackColor];
                                                                        [rewards100Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                        [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                        NSLayoutConstraint *constant5 = yconstraintForReward[4];
                                                                        constant5.constant = 70;
                                                                        
                                                                        lock150Img.hidden = true;
                                                                        reward150Label.textColor = [UIColor blackColor];
                                                                        [rewards150Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                        [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                        NSLayoutConstraint *constant6 = yconstraintForReward[5];
                                                                        constant6.constant = 70;
                                                                        
                                                                        lock200Img.hidden = true;
                                                                        reward200Label.textColor = [UIColor blackColor];
                                                                        [rewards200Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                        [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                        NSLayoutConstraint *constant7 = yconstraintForReward[6];
                                                                        constant7.constant = 70;
                                                                        
                                                                        lock300Img.hidden = true;
                                                                        reward300Label.textColor = [UIColor blackColor];
                                                                        [rewards300Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                        [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                        NSLayoutConstraint *constant8 = yconstraintForReward[7];
                                                                        constant8.constant = 70;
                                                                        
                                                                        lock400Img.hidden = true;
                                                                        reward400Label.textColor = [UIColor blackColor];
                                                                        [rewards400Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                        [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                        NSLayoutConstraint *constant9 = yconstraintForReward[8];
                                                                        constant9.constant = 70;
                                                                        
                                                                        lock500Img.hidden = true;
                                                                        reward500Label.textColor = [UIColor blackColor];
                                                                        [rewards500Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                        [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                        NSLayoutConstraint *constant10 = yconstraintForReward[9];
                                                                        constant10.constant = 70;
                                                                        
                                                                        lock750Img.hidden = true;
                                                                        reward750Label.textColor = [UIColor blackColor];
                                                                        [rewards750Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                        [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                        NSLayoutConstraint *constant11 = yconstraintForReward[10];
                                                                        constant11.constant = 70;
                                                                        
                                                                        lock1000Img.hidden = true;
                                                                        reward1000Label.textColor = [UIColor blackColor];
                                                                        [rewards1000Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                        [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                        NSLayoutConstraint *constant12 = yconstraintForReward[11];
                                                                        constant12.constant = 70;
                                                                        
                                                                        lock1250Img.hidden = true;
                                                                        reward1250Label.textColor = [UIColor blackColor];
                                                                        [rewards1250Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                        [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                        NSLayoutConstraint *constant13 = yconstraintForReward[12];
                                                                        constant13.constant = 70;
                                                                        
                                                                        lock1500Img.hidden = true;
                                                                        reward1500Label.textColor = [UIColor blackColor];
                                                                        [rewards1500Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                        [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                        NSLayoutConstraint *constant14 = yconstraintForReward[13];
                                                                        constant14.constant = 70;
                                                                        
                                                                        lock1750Img.hidden = true;
                                                                        reward1750Label.textColor = [UIColor blackColor];
                                                                        [rewards1750Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                        [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                        NSLayoutConstraint *constant15 = yconstraintForReward[14];
                                                                        constant15.constant = 70;

                                                                        lock2000Img.hidden = true;
                                                                        reward2000Label.textColor = [UIColor blackColor];
                                                                        [rewards2000Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                        [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                        NSLayoutConstraint *constant16 = yconstraintForReward[15];
                                                                        constant16.constant = 70;
                                                                        
                                                                        
                                                                        lock5000Img.hidden = true;
                                                                        reward5000Label.textColor = [UIColor blackColor];
                                                                        [rewards5000Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                        [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                        NSLayoutConstraint *constant17 = yconstraintForReward[16];
                                                                        constant17.constant = 70;
                                                                        
                                                                        lock10000Img.hidden = false;
                                                                        reward10000Label.textColor = [Utility colorWithHexString:BlueBadgeColor];
                                                                        [rewards10000Img setImage:[[UIImage imageNamed:@"rewards_badge.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                                                                        [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                        NSLayoutConstraint *constant18 = yconstraintForReward[17];
                                                                        constant18.constant = -9;
                                                                        
                                                                    }else{
                                                                    //        challengeName= @"21 Day Challenge";
                                                                            lock3Img.hidden = true;
                                                                            reward3Label.textColor = [UIColor blackColor];
                                                                            [rewards3Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
                                                                            //[rewards3Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];//imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                                            NSLayoutConstraint *constant1 = yconstraintForReward[0];
                                                                            constant1.constant = 70;
                                                                            
                                                                            lock7Img.hidden = true;
                                                                            reward7Label.textColor = [UIColor blackColor];
                                                                            [rewards7Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                            [rewards7Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                            NSLayoutConstraint *constant2 = yconstraintForReward[1];
                                                                            constant2.constant = 70;
                                                                            
                                                                            lock14Img.hidden = true;
                                                                            reward14Label.textColor = [UIColor blackColor];
                                                                            [rewards14Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                            [rewards14Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                            NSLayoutConstraint *constant3 = yconstraintForReward[2];
                                                                            constant3.constant = 70;
                                                                            
                                                                            lock28Img.hidden = true;
                                                                            reward28Label.textColor = [UIColor blackColor];
                                                                            [rewards28Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                            [rewards28Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                            NSLayoutConstraint *constant4 = yconstraintForReward[3];
                                                                            constant4.constant = 70;
                                                                            
                                                                            lock100Img.hidden = true;
                                                                            reward100Label.textColor = [UIColor blackColor];
                                                                            [rewards100Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                            [rewards100Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                            NSLayoutConstraint *constant5 = yconstraintForReward[4];
                                                                            constant5.constant = 70;
                                                                            
                                                                            lock150Img.hidden = true;
                                                                            reward150Label.textColor = [UIColor blackColor];
                                                                            [rewards150Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                            [rewards150Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                            NSLayoutConstraint *constant6 = yconstraintForReward[5];
                                                                            constant6.constant = 70;
                                                                            
                                                                            lock200Img.hidden = true;
                                                                            reward200Label.textColor = [UIColor blackColor];
                                                                            [rewards200Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                            [rewards200Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                            NSLayoutConstraint *constant7 = yconstraintForReward[6];
                                                                            constant7.constant = 70;
                                                                            
                                                                            lock300Img.hidden = true;
                                                                            reward300Label.textColor = [UIColor blackColor];
                                                                            [rewards300Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                            [rewards300Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                            NSLayoutConstraint *constant8 = yconstraintForReward[7];
                                                                            constant8.constant = 70;
                                                                            
                                                                            lock400Img.hidden = true;
                                                                            reward400Label.textColor = [UIColor blackColor];
                                                                            [rewards400Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                            [rewards400Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                            NSLayoutConstraint *constant9 = yconstraintForReward[8];
                                                                            constant9.constant = 70;
                                                                            
                                                                            lock500Img.hidden = true;
                                                                            reward500Label.textColor = [UIColor blackColor];
                                                                            [rewards500Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                            [rewards500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                            NSLayoutConstraint *constant10 = yconstraintForReward[9];
                                                                            constant10.constant = 70;
                                                                            
                                                                            lock750Img.hidden = true;
                                                                            reward750Label.textColor = [UIColor blackColor];
                                                                            [rewards750Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                            [rewards750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                            NSLayoutConstraint *constant11 = yconstraintForReward[10];
                                                                            constant11.constant = 70;
                                                                            
                                                                            lock1000Img.hidden = true;
                                                                            reward1000Label.textColor = [UIColor blackColor];
                                                                            [rewards1000Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                            [rewards1000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                            NSLayoutConstraint *constant12 = yconstraintForReward[11];
                                                                            constant12.constant = 70;
                                                                            
                                                                            lock1250Img.hidden = true;
                                                                            reward1250Label.textColor = [UIColor blackColor];
                                                                            [rewards1250Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                            [rewards1250Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                            NSLayoutConstraint *constant13 = yconstraintForReward[12];
                                                                            constant13.constant = 70;
                                                                            
                                                                            lock1500Img.hidden = true;
                                                                            reward1500Label.textColor = [UIColor blackColor];
                                                                            [rewards1500Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                            [rewards1500Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                            NSLayoutConstraint *constant14 = yconstraintForReward[13];
                                                                            constant14.constant = 70;
                                                                            
                                                                            lock1750Img.hidden = true;
                                                                            reward1750Label.textColor = [UIColor blackColor];
                                                                            [rewards1750Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                            [rewards1750Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                            NSLayoutConstraint *constant15 = yconstraintForReward[14];
                                                                            constant15.constant = 70;

                                                                            lock2000Img.hidden = true;
                                                                            reward2000Label.textColor = [UIColor blackColor];
                                                                            [rewards2000Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                            [rewards2000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                            NSLayoutConstraint *constant16 = yconstraintForReward[15];
                                                                            constant16.constant = 70;
                                                                            
                                                                            
                                                                            lock5000Img.hidden = true;
                                                                            reward5000Label.textColor = [UIColor blackColor];
                                                                            [rewards5000Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                            [rewards5000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                            NSLayoutConstraint *constant17 = yconstraintForReward[16];
                                                                            constant17.constant = 70;
                                                                            
                                                                            lock10000Img.hidden = true;
                                                                            reward10000Label.textColor = [UIColor blackColor];
                                                                            [rewards10000Img setImage:[UIImage imageNamed:@"manny_trophy.png"]];
//                                                                            [rewards10000Img setTintColor:[Utility colorWithHexString:ShedBadgeBule]];
                                                                            NSLayoutConstraint *constant18 = yconstraintForReward[17];
                                                                            constant18.constant = 70;
                                                                            
                                                                        }
    challengeNameLabel.text = @"";
}
#pragma mark - End

#pragma mark - WebService Call

-(void)GetStreakData_webServiceCall{//BADGE
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString *todayStr = [df stringFromDate:[NSDate date]];
        [mainDict setObject:todayStr forKey:@"UserCurrentDate"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetGratitudeStreakData" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                        self->streakDict = [responseDict objectForKey:@"StreakData"];
                                                                         [self setUpStreakDetails];
                                                                      [self->mileStoneCollection reloadData];
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
        
    }
}


-(void)getSquadUserActionProfile_webServiceCall{ //gami_badge_popup_train //14may2018
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadUserActionProfile" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->actionArray = [responseDict objectForKey:@"UserActionProfileList"];
                                                                         
                                                                         [self setUpView];
                                                                         
                                                                         if (![Utility isEmptyCheck:self->actionArray]) {
                                                                             [self makeGroupArray:self->actionArray];
                                                                             [self->gamificationTable reloadData];
                                                                             [self->gamificationCollection reloadData];
                                                                         }else{
                                                                             self->badgeCollectionNodataLabel.hidden = false;
                                                                             self->badgeCollectionNodataLabel.text = @"No Badges Found";
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


-(void)GetSquadMoreRewards_webServiceCall{
    if (Utility.reachable) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (contentView) {
//                [contentView removeFromSuperview];
//            }
//            contentView = [Utility activityIndicatorView:self];
//        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadMoreRewards" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
//                                                                 if (contentView) {
//                                                                     [contentView removeFromSuperview];
//                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->earnRewardsArray = [responseDict objectForKey:@"SquadEarnMoreRewardsList"];
                                                                         if (![Utility isEmptyCheck:self->earnRewardsArray] && self->actionView.hidden) {
                                                                             [self->earnMoreTable reloadData];
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

#pragma mark - End

#pragma mark - TableView DataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == gamificationTable) {
        return badgeList.count;
    }else if (tableView == earnMoreTable){
        return earnRewardsArray.count;
    }else{
        return 15;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tablecell;
    if (tableView == gamificationTable) {
        NSString *CellIdentifier =@"GamificationTableViewCell";
        GamificationTableViewCell *cell = (GamificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[GamificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (![Utility isEmptyCheck:badgeList]) {
            NSDictionary *dict = [badgeList objectAtIndex:indexPath.row];
            if (![Utility isEmptyCheck:[dict objectForKey:@"Action"]]) {
                cell.actionName.text = [dict objectForKey:@"Action"];
                
            }
            if (![Utility isEmptyCheck:[dict objectForKey:@"Point"]]) {
                cell.pointName.text = [@"" stringByAppendingFormat:@"%g ( %@ )",[[dict objectForKey:@"Point"] doubleValue]*[[dict objectForKey:@"BadgeCount"]doubleValue],[dict objectForKey:@"BadgeCount"]];
            }
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
            NSDate *strD = [formatter dateFromString:[dict objectForKey:@"DateCreated"]];
            formatter.dateFormat = @"dd-MMM-yyyy";
            cell.dateLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:strD]];
            //[ substringWithRange:NSMakeRange(0, 10)];
        }
        cell.infoButton.tag = indexPath.row;
        tablecell = cell;
    }else if (tableView == earnMoreTable){
        NSString *CellIdentifier =@"GamificationTableViewCell";
        GamificationTableViewCell *cell = (GamificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[GamificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (![Utility isEmptyCheck:earnRewardsArray]) {
            NSDictionary *dict = [earnRewardsArray objectAtIndex:indexPath.row];
            if (![Utility isEmptyCheck:[dict objectForKey:@"Action"]]) {
                cell.earnActionName.text = [dict objectForKey:@"Action"];
            }
            cell.infoButton.tag = indexPath.row;
            cell.infoButton.accessibilityHint = @"earnMore";
        }
        tablecell = cell;
    }else{
        NSString *CellIdentifier =@"GamificationTableViewCell";
        GamificationTableViewCell *cell = (GamificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[GamificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSDictionary *badgeDict = [badgeArr objectAtIndex:indexPath.row];
//        [cell.badgeImage setImage:[[UIImage imageNamed:@"black_gm_for_all.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        if (indexPath.row == 14) {
            [cell.badgeImage setImage:[UIImage imageNamed:@"black_gm_for_all.png"]];
        } else {
            [cell.badgeImage setImage:[[UIImage imageNamed:@"black_gm_for_all.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [cell.badgeImage setTintColor:[Utility colorWithHexString:[badgeDict objectForKey:@"colorcode"]]];
        }
        cell.actionName.text = [badgeDict objectForKey:@"imageStr"];
        cell.pointName.text = [badgeDict objectForKey:@"pointRange"];
        tablecell = cell;
    }
    return tablecell;
}
#pragma mark - End

#pragma mark - UIcollectionView DataSource & Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0,0,0,0);
//
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//  return 0.0; // This is the minimum inter item spacing, can be more
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 0.0;
//}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return mileStoneArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"GamificationCollectionViewCell";
    
    GamificationCollectionViewCell *collectionCell = (GamificationCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
     if (![Utility isEmptyCheck:mileStoneArr]) {
         collectionCell.badgeName.text = [@"" stringByAppendingFormat:@"%@", mileStoneArr[indexPath.row]];
         int value = [mileStoneArr[indexPath.row]intValue];
         if (value <= totalStreak) {
             [collectionCell.badgesImage setImage:[UIImage imageNamed:@"manny_trophy.png"]];
             collectionCell.lockImg.hidden = true;
             collectionCell.badgeName.textColor = [UIColor blackColor];
             collectionCell.badgeNameYConstraint.constant = 70;
             
         }else{
             [collectionCell.badgesImage setImage:[[UIImage imageNamed:@"rewards_badge.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
             collectionCell.badgesImage.tintColor = [Utility colorWithHexString:ShedBadgeBule];
             collectionCell.lockImg.hidden = false;
             collectionCell.badgeName.textColor = [Utility colorWithHexString:mbhqBaseColor];
             collectionCell.badgeNameYConstraint.constant = 0;

         }
//         NSDictionary *dict = [badgeList objectAtIndex:indexPath.row];
//         if (![Utility isEmptyCheck:[dict objectForKey:@"Badge"]]) {
//             collectionCell.badgeName.text = [NSString stringWithFormat:@"%@ ( %@ )",[dict objectForKey:@"Badge"],[dict objectForKey:@"BadgeCount"]];
//         }
//
//         collectionCell.badgesImage.layer.cornerRadius = collectionCell.badgesImage.layer.frame.size.height/2;
//         collectionCell.badgesImage.layer.masksToBounds = YES;
//         //collectionCell.badgesImage.contentMode = UIViewContentModeScaleAspectFit;
//
//         if (![Utility isEmptyCheck:[dict objectForKey:@"IconImageName"]]) {
//             //NSLog(@"%@",[NSURL URLWithString:[@"" stringByAppendingFormat:@"%@%@",BASEGAMIFICATIONIMAGE_URL,[dict objectForKey:@"IconImageName"]]]);
//             NSString *badgeName = [dict objectForKey:@"IconImageName"];
//             badgeName = [badgeName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
//
//             NSString *urlString = [@"" stringByAppendingFormat:@"%@%@",BASEGAMIFICATIONIMAGE_URL,badgeName];
//
//
//             [collectionCell.badgesImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageScaleDownLargeImages];
//         }else{
//             collectionCell.badgesImage.image = [UIImage imageNamed:@"EXERCISE-picture-coming.jpg"];
//         }
     }
    return collectionCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGRect screenRect = [mileStoneCollection bounds];
    CGFloat screenWidth = screenRect.size.width;
//    CGFloat divisor;
//    if ([UIScreen mainScreen].bounds.size.width>=414) {
//        divisor = 10.0;
//    }else{
//        divisor = 9.0;
//    }
    float cellWidth = screenWidth / 2; //Replace the divisor with the column count requirement. Make sure to have it in float.
    CGSize size = CGSizeMake(cellWidth,200);

    return size;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    int value = [mileStoneArr[indexPath.row]intValue];
    if (value <= totalStreak) {
        BadgePopUpViewController *custom = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BadgePopUpView"];
        custom.modalPresentationStyle = UIModalPresentationCustom;
        custom.streakDict = self->streakDict;
        custom.isFromGami = YES;
        custom.parentcontroller = self.parentViewController;
        [self presentViewController:custom animated:YES completion:nil];
    }
}
@end
