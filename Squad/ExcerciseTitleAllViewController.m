//
//  ExcerciseTitleAllViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 28/02/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "ExcerciseTitleAllViewController.h"
#import "ExcerciseFinisherTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface ExcerciseTitleAllViewController ()
{
    IBOutlet UITableView *table;
    IBOutlet UILabel *exerName;
}
@end

@implementation ExcerciseTitleAllViewController
@synthesize arr,finisherName;
#pragma mark - View Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (![Utility isEmptyCheck:finisherName]) {
        exerName.text = finisherName;
    }
}
#pragma mark - End

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"ExcerciseFinisherTableViewCell";
    ExcerciseFinisherTableViewCell *finisherCell = (ExcerciseFinisherTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (finisherCell == nil) {
        finisherCell = [[ExcerciseFinisherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *individualLeaderDict = [arr objectAtIndex:indexPath.row];
    
    finisherCell.indexAlllabel.text = [@"" stringByAppendingFormat:@"%ld",indexPath.row+1];
    finisherCell.exerciseNameAllLabel.text = [@"" stringByAppendingFormat:@"%@ %@",[individualLeaderDict objectForKey:@"FirstName"],[individualLeaderDict objectForKey:@"LastName"]];
    //ImageAdded
    if (![Utility isEmptyCheck:[individualLeaderDict objectForKey:@"Picturepath"]]) {
        finisherCell.userImage.layer.cornerRadius=finisherCell.profileImage.frame.size.height/2;
        finisherCell.userImage.layer.masksToBounds = YES;
        finisherCell.userImage.clipsToBounds  = YES;
        NSString *imageUrl= [@"" stringByAppendingFormat:@"%@/%@",BASEIMAGE_URL,[individualLeaderDict objectForKey:@"Picturepath"]];
        
        [finisherCell.userImage sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEncodingWithAllowedCharacters:
                                                                            [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                     placeholderImage:[UIImage imageNamed:@"profile_icon.png"] options:SDWebImageScaleDownLargeImages];
        
    }else{
        finisherCell.userImage.image = [UIImage imageNamed:@"profile_icon.png"];
    }
    //---End
    
    if (![Utility isEmptyCheck:[individualLeaderDict objectForKey:@"Timetaken"]]) {
        NSArray* timeTakenArray = [[individualLeaderDict objectForKey:@"Timetaken"] componentsSeparatedByString: @":"];
        NSString *unitKey=@"";
        int hour = [[timeTakenArray objectAtIndex: 0]intValue];//hour
        int min = [[timeTakenArray objectAtIndex:1]intValue];//min
        int sec = [[timeTakenArray objectAtIndex:2]intValue];//sec
        if (hour>0) {
            unitKey = @"hrs";
        }else if (min>0){
            unitKey = @"min";
        }else if (sec>0){
            unitKey = @"sec";
        }
        if (hour == 0 && min == 0 && sec == 0) {
            finisherCell.timeAllLabel.text =@"";
        }else{
            finisherCell.timeAllLabel.text =[@"" stringByAppendingFormat:@"%@ %@",[individualLeaderDict objectForKey:@"Timetaken"],unitKey];
        }
    }else{
        finisherCell.timeAllLabel.text =@"";
    }
    return finisherCell;
}

@end
