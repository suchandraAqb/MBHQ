//
//  WeightRecordSheetViewController.h
//  Squad
//
//  Created by AQB-Mac-Mini 3 on 23/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddWeightDataView.h"

@interface WeightRecordSheetViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AddWeightDataViewDelegate>
@property () int exSessionId;
@property (strong, nonatomic) NSString *sessionDate;
@property () int workoutTypeId; //AY 02112017
@property (strong, nonatomic) NSString *fromWhere;//AY 02112017
@property() BOOL isPlaySession;//AY 02112017
@property() BOOL isCircuit;//AY 02112017
@property () int exerciseId; //AY 02112017
@property () int exerciseCircuitId; //AY 02112017
@property (strong, nonatomic) NSArray *exerciseListArray; //AY 21112017

@end
