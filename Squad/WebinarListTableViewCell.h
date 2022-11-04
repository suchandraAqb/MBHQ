//
//  WebinarListTableViewCell.h
//  The Life
//
//  Created by AQB SOLUTIONS on 04/04/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebinarListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *listImageView;
@property (strong, nonatomic) IBOutlet UILabel *listHeadingTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *listSubheadingTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *listDetailsTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *listTimeTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UIButton *likeDislike;
@property (strong, nonatomic) IBOutlet UILabel *likeCount;
@property (strong, nonatomic) IBOutlet UIButton *watchListButton;
@property (strong, nonatomic) IBOutlet UIButton *downloadButton;
@property (strong, nonatomic) IBOutlet UIButton *podcastButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *watchListButtonConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *downloadButtonConstraint;
@property (strong, nonatomic) IBOutlet UIButton *isViewedButton;
@property (strong, nonatomic) IBOutlet UILabel *status;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *isViewedWidthConstraint;
@property (strong, nonatomic) IBOutlet UIProgressView *progress;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (strong, nonatomic) IBOutlet UIButton *meditationActionButton;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIButton *favButton;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UILabel *webinarTypeLabel;



@end
