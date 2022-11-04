//
//  ExerciseDetailsViewController.h
//  ABBBCOnline
//
//  Created by AQB Mac 4 on 30/11/16.
//  Copyright © 2016 Aqb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "MasterMenuViewController.h"
#import "ExerciseEditViewController.h" //EDIT_NEW_ADD
#import "AddCustomSessionViewController.h" //Feedback - 28032018
#import "SwapSessionViewController.h"

@protocol ExerciseDetailsDelegate <NSObject>
@optional - (void) didCheckAnyChange:(BOOL)ischanged;
@optional - (void) loadSelectedDate:(BOOL)isLoad;
@end

@interface ExerciseDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AVPlayerViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ExerciseEditDetailsProtocol,AddCustomSessionViewProtocol,DropdownViewDelegate,SwapSessionViewDelegate>{
    id<ExerciseDetailsDelegate>delegate;
}
@property (nonatomic,strong)id delegate;
@property (strong, nonatomic) NSDictionary *exerciseData;
@property (nonatomic, assign) CGFloat lastContentOffset;    //arnab 17
@property () int exSessionId;
@property (strong, nonatomic) NSString *sessionDate;    //ah 2.2
@property(strong,nonatomic) NSString *fromWhere; //add_su_2/8/17
@property (strong, nonatomic) NSString *exerciseSessionType; //AY 23102017
@property () int workoutTypeId; //AY 02112017
@property (strong, nonatomic) NSString *weekDate;    //AY 07112017
@property BOOL isExDetails;
@property () int completeSessionId; //AY 05012018
@property BOOL isHome;
@property BOOL isChanged;
@property()BOOL isEditSession;

@property BOOL loadForSelected;
@end
