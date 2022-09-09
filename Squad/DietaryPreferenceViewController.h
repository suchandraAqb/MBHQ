//
//  DietaryPreferenceViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 28/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropdownViewController.h"

@interface DietaryPreferenceViewController : UIViewController<DropdownViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(assign,nonatomic) BOOL isfirstTime;//su22

@end
