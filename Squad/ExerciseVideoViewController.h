//
//  ExerciseVideoViewController.h
//  Ashy Bines Super Circuit
//
//  Created by AQB SOLUTIONS on 07/09/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MasterMenuViewController.h"

@class CircleProgressBar;

typedef enum : NSUInteger {
    CustomizationStateDefault = 0,
    CustomizationStateCustom,
    CustomizationStateCustomAttributed,
} CustomizationState;

@interface ExerciseVideoViewController : UIViewController<NSURLSessionDelegate, AVAudioPlayerDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) NSMutableArray *rowIdArray;
@property (strong, nonatomic) NSString *prepTime;
@property (strong, nonatomic) NSArray *mainDataArray;
@property (strong, nonatomic) NSString *sessionName;
@property (strong, nonatomic) NSString *sessionDate;
@property (strong, nonatomic) NSString *workoutType;    //ah 9.5
@property BOOL isFromCustom; //add_su_2/8/17
@property () int exSessionId;//AY 02112017
@property () int workoutTypeId; //AY 02112017
@property (strong, nonatomic) NSString *weekDate;    //AY 07112017
@property (strong, nonatomic) IBOutlet UIScrollView *parentScroll;
@property (strong, nonatomic) IBOutlet UIView *gameOnView;

@property (assign) NSInteger currentPage;
@property (assign) BOOL isWeightSheetButtonPressed;
@property () int completeSessionId; //AY 05012018
@property () int sessionFlowId;
@property () int sessionDuration;
@property (strong, nonatomic)NSDictionary *followAlongSessiondata;
@property()BOOL isAddedToCustomSession;


- (IBAction)changePage:(id)sender;
@end
