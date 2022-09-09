//
//  MessageViewController.h
//  Ashy Bines Super Circuit
//
//  Created by AQB SOLUTIONS on 15/11/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol InboxDelegate

-(void) reloadInbox;

@end
@interface MessageViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) id<InboxDelegate>inboxDelegate;
@property () int receiverId;
@property (weak, nonatomic) NSString *receiverName;
@end
