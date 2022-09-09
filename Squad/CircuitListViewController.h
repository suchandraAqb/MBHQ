//
//  CircuitListViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 10/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "MasterMenuViewController.h"
#import "EditCircuitViewController.h" //Local_catch
#import "CreateCircuitViewController.h"//Local_catch

@interface CircuitListViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,EditCktDelegate,CreateCircuitDelegate>//Local_catch
-(IBAction)circuitOrMyCircuitListButtonPressed:(UIButton *)sender;  //ah 4.5
@property (strong, nonatomic) IBOutlet UIButton *mycircuitButton;   //ah 4.5

@end
