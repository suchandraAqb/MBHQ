//
//  ChallengeSectionHeader.h
//  Squad
//
//  Created by Suchandra Bhattacharya on 17/02/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeSectionHeader : UITableViewHeaderFooterView
@property (strong,nonatomic) IBOutlet UILabel *exerciseNamelabel;
@property (strong,nonatomic) IBOutlet UIButton *sectionButton;
@property (strong,nonatomic) IBOutlet UIButton *leaderBoardButton;
@end
