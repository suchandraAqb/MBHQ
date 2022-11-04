//
//  BucketListNewViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 17/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface BucketListNewViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSArray *goalValueArray;

@end
