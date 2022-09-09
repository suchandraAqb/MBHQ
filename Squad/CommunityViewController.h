//
//  CommunityViewController.h
//  
//
//  Created by Suchandra Bhattacharya on 14/02/2020.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CommunityViewController : UIViewController

@property (nonatomic) BOOL isFromCourse;
@property (nonatomic,strong) NSString *liveForumUrlStr;
-(void)viewDidLoad;
@end

NS_ASSUME_NONNULL_END
