//
//  ExcerciseHistoryViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 26/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExcerciseHistoryViewController : UIViewController
@property int excerciseId;
@property (strong,nonatomic) NSString *exerciseName;
@property (strong,nonatomic) NSString *exerciseImageURL;//AY 21112017
@property() BOOL isShowImage;//AY 21112017

@end
