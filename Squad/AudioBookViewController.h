//
//  AudioBookViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 04/08/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioBookViewController : UIViewController<UIWebViewDelegate>{

}
@property (strong, nonatomic) IBOutlet UITableView *audioListTable;

- (void) playAudioWithUrl:(NSString *) urlString;

//ah 14.8(storyboard)
@end
