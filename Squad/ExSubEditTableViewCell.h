//
//  ExSubEditTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 13/03/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExSubEditTableViewCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UILabel *exSubLabel;
@property (strong,nonatomic) IBOutlet UIView *subView;
@property (strong,nonatomic) IBOutlet UIView *tickView;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *tickViewWidthConstant;
@end
