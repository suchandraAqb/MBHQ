//
//  ExerciseEditViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 08/03/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseEditTableViewCell.h"
@protocol ExerciseEditDetailsProtocol <NSObject>
-(void)selecedExerciseData:(NSDictionary*)dict;
@end

@interface ExerciseEditViewController : UIViewController<ExerciseEditProtocol>{
     id<ExerciseEditDetailsProtocol>exercisedelegate;
}
@property (nonatomic,strong)id exercisedelegate;

@property (strong,nonatomic) NSDictionary *circuitDict;
@end
