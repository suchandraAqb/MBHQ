//
//  HomeTableSectionHeader.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 22/08/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableSectionHeader : UITableViewHeaderFooterView
@property (strong,nonatomic) IBOutlet UIImageView *titleImage;
@property (strong,nonatomic) IBOutlet UILabel *titlelabel;
@property (strong,nonatomic) IBOutlet UIButton *titleButton;
@property (strong,nonatomic) IBOutlet UIView *overlayView;
@end
