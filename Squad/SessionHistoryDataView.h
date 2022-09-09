//
//  SessionHistoryDataView.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 27/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionHistoryDataView : UIView
@property (strong ,nonatomic) IBOutlet UILabel *sessionNameLabel;
+(SessionHistoryDataView *)instantiateView;
-(void)updateData:(NSDictionary*)dataDict;
@end
