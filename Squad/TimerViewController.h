//
//  TimerViewController.h
//  Squad
//
//  Created by aqb-mac-mini3 on 06/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerViewController : UIViewController<AVAudioPlayerDelegate>
@property (strong, nonatomic) NSMutableDictionary *dataDict;
@property (strong, nonatomic) NSMutableDictionary *roundEditDataDict;
@property (strong, nonatomic) NSMutableDictionary *stationEditdataDict;
@property (strong, nonatomic) NSString *mode;
@property (strong, nonatomic) NSString *roundPrepTime;

-(IBAction)playPauseButtonTapped:(id)sender;

@end
