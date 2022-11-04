//
//  CircuitDetailsViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 14/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "MasterMenuViewController.h"

@interface CircuitDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AVPlayerViewControllerDelegate>
@property (nonatomic,strong)NSDictionary *circuitDict;
@property BOOL isModal;     //ah se

@end
