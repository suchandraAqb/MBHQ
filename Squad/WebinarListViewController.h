//
//  WebinarListViewController.h
//  The Life
//
//  Created by AQB SOLUTIONS on 04/04/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import "Utility.h"
#import "FilterViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface WebinarListViewController : UIViewController<UIScrollViewDelegate,FilterViewDelegate,NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSDictionary *selectedFilterDict;
@property (nonatomic) BOOL isNotFromHome;
@property (nonatomic) BOOL isLoadTagBreath;
@property (nonatomic) BOOL isLoadTagMorning;
@property (nonatomic) BOOL isLoadTagPower;
@property (nonatomic) BOOL isFromCourse;
@property (nonatomic) BOOL isFromDetails;
@property (nonatomic, strong) NSURLSession *session1;


@end
