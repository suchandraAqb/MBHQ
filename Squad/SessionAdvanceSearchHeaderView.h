//
//  SessionAdvanceSearchHeaderView.h
//  Squad
//
//  Created by aqb-mac-mini3 on 02/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionAdvanceSearchHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *headerText;
@property (weak, nonatomic) IBOutlet UIButton *footerTypingButton;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;

@end
