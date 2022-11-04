//
//  RoundListViewController.h
//  Squad
//
//  Created by aqb-mac-mini3 on 06/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickersViewController.h"
#import "SettingsViewController.h"

@interface RoundListViewController : UIViewController<CustomPickerDelegate,RoundListDelegate>
@property () int sessionID;
@property (strong, nonatomic) NSString *sessionName;
@property (strong, nonatomic) NSString *fromController;
@property (strong, nonatomic) NSString *prepTime;
@property (strong, nonatomic) NSString *modeID;
@property (strong, nonatomic) NSMutableDictionary *idDict;
@end
