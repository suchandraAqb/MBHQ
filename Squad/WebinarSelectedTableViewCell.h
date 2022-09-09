//
//  WebinarSelectedTableViewCell.h
//  The Life
//
//  Created by AQB SOLUTIONS on 07/04/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebinarSelectedTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *moreListImage;
@property (strong, nonatomic) IBOutlet UILabel *moreListHeading;
@property (strong, nonatomic) IBOutlet UILabel *moreListSubheading;
@property (strong, nonatomic) IBOutlet UILabel *moreListDetails;

@property (strong, nonatomic) IBOutlet UILabel *tagView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UIButton *likeDislike;
@property (strong, nonatomic) IBOutlet UILabel *likeCount;
@property (strong, nonatomic) IBOutlet UIButton *watchListButton;
@property (strong, nonatomic) IBOutlet UIButton *downloadButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *watchListButtonConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *downloadButtonConstraint;
@property (strong, nonatomic) IBOutlet UIButton *podcastButton;


@property (strong, nonatomic) IBOutlet UIProgressView *progress;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) IBOutlet UILabel *status;





@end
