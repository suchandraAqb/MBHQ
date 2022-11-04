//
//  SessionListViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 15/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import "AdvanceSearchForSessionViewController.h"
#import "DropdownViewController.h"
#import "ExerciseDetailsViewController.h"

@protocol SessionListDelegate <NSObject>
@optional - (void)didSelectSession:(NSDictionary *)dataDict;
@end

@interface SessionListViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,AdvanceSearchForSessionDelegate,DropdownViewDelegate,ExerciseDetailsDelegate>{
    id<SessionListDelegate>delegate;
}
@property (nonatomic,strong)id delegate;
-(IBAction)sessionOrMysessionListButtonPressed:(UIButton *)sender;  //ah 4.5
@property (strong, nonatomic) IBOutlet UIButton *mySessionButton;
@property()BOOL isFromAddEditSession;
@property()BOOL isMySessionSelected;
@end


