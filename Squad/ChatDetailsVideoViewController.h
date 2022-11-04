//
//  ChatDetailsVideoViewController.h
//  TRANSFORM ASHY BINES
//
//  Created by Dhiman on 22/12/20.
//  Copyright © 2020 Dhiman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatDetailsVideoViewController : UIViewController<AVPlayerViewControllerDelegate,NSURLSessionDelegate>
@property (strong,nonatomic) NSDictionary *videoDict;
@property (strong, nonatomic)  AVPlayerViewController *playerController;
@property (nonatomic,strong) NSURLSession *session1;
@property CMTime videoTime;
@end

NS_ASSUME_NONNULL_END
