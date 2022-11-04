//
//  ExerciseDetailsVideoViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 16/01/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface ExerciseDetailsVideoViewController : UIViewController<AVPlayerViewControllerDelegate>
@property (strong,nonatomic) NSDictionary *circuitDict;
@property (strong, nonatomic)  AVPlayerViewController *playerController;
@property BOOL fromExerciseList; //Change_new_27032018
@property BOOL fromChallenge;
@end
