//
//  ExcerciseTitleViewController.h
//  ABS Finisher
//
//  Created by AQB Solutions-Mac Mini 2 on 16/05/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExcerciseTitleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)NSString *buttontag;
@property(nonatomic, assign) int indexValue;
@property(strong,nonatomic) NSString *mainFinishSquadWowButtonTag;
@end
