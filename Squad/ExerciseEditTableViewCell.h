//
//  ExerciseEditTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 08/03/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ExerciseEditProtocol <NSObject>
-(void)selecedData:(int)index;
@end

@interface ExerciseEditTableViewCell : UITableViewCell{
    id<ExerciseEditProtocol>delegate;
}
@property (nonatomic,strong)id delegate;

@property (strong,nonatomic) IBOutlet UILabel *exerciseName;
@property (strong,nonatomic) IBOutlet UIStackView *stack;
@property (strong,nonatomic) IBOutlet UIButton *expandButton;
@property (strong,nonatomic) IBOutlet UIView *mainView;
@property (strong,nonatomic) IBOutlet UIView *subView;
@property (strong,nonatomic) IBOutlet UIStackView *outerStack;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *detailsViewHeight;
@property (strong,nonatomic) IBOutlet UIView *tickView;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *tickViewWeightConstant;
@property (strong,nonatomic) IBOutlet UIImageView *dropImage;
-(void)setUpView:(NSArray*)typeArr;

@end
