//
//  ExerciseEditView.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 08/03/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseEditView : UITableViewHeaderFooterView
@property (strong,nonatomic) IBOutlet UILabel *exerciseTypeLabel;
@property (strong ,nonatomic) IBOutlet UIImageView *arrowImage;
@property (strong,nonatomic) IBOutlet UIButton *headerButton;
@property (strong,nonatomic) IBOutlet UIView *sectionDividerView;
@end
