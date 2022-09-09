//
//  CourseArticleDetailsViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 23/02/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioVisualizer.h"

@protocol CourseArticleDetailsViewDelegate <NSObject>
@optional - (void)didCheckAnyChangeForCourseArticle:(BOOL)isreload;
@end
@interface CourseArticleDetailsViewController : UIViewController<NSURLSessionDelegate,AVPlayerViewControllerDelegate,AVAudioPlayerDelegate>{
    id<CourseArticleDetailsViewDelegate>courseArticleDelegate;
}
@property (nonatomic,strong)id courseArticleDelegate;
@property (strong, nonatomic) NSNumber *courseId;
@property (strong, nonatomic) NSNumber *articleId;
@property (strong, nonatomic) NSNumber *taskId;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSString *autherStr;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) AudioVisualizer *audioVisualizer;
@property (nonatomic, strong) NSString *imageUrl;

@end
