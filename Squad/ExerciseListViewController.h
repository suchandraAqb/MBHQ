//
//  ExerciseListViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 19/01/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "MasterMenuViewController.h"
#import "ExerciseListTableViewCell.h"

@interface ExerciseListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AVPlayerViewControllerDelegate,IndividualExerciseProtocol>

@end
