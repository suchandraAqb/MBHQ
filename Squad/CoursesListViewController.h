//
//  CoursesListViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 21/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"

@interface CoursesListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property BOOL fromSetProgram; //SetProgram_In
@property (strong,nonatomic) NSString *courseName; //SetProgram_In
@property BOOL isRedirectToSetProgram; //SetProgram_In
@end
