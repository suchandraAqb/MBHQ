//
//  BucketListNewTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 17/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BucketListNewTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *bucketName;
@property (strong, nonatomic) IBOutlet UILabel *bucketDueDate;
@property(strong,nonatomic) IBOutlet UIButton *bucketImage;
@property(strong,nonatomic) IBOutlet UIButton *notificationImagebutton;
@end
