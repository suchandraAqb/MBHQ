//
//  LeaderBoardDetailsViewController.h
//  ABS Finisher
//
//  Created by AQB Solutions-Mac Mini 2 on 17/10/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PopoverViewController.h"

@interface LeaderBoardDetailsViewController : UIViewController<PopoverViewDelegate>
@property(strong,nonatomic) NSDictionary *leaderBoardDetailsDict;
@property(nonatomic,assign) BOOL isbattle;
@end
