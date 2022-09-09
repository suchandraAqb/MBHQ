CHAT SDK Customised Code and POD install/update Instructions

STEPS REQUIRED BEFORE POD UPDATE 

1. Take Back Up of Current Project. (Make a Zip)
2. Pod Update
3. Download the source code for the Chat SDK that matches the version you are instlling using CocoaPods from this loction(https://github.com/chat-sdk/chat-sdk-ios/releases). Copy the FirebaseNetworkAdapter and FirebaseFileStorage folders into the source code directory of your Xcode project. From inside Xcode, right click in the left panel click Add Files and add the FirebaseNetworkAdapter folder.

4. Change the CHATSDK according to below given instruction from back project CHATSDK.



CHATSDKUI:

1. BTextInputView.m : =>  Custom Send Button Added in initWithFrame: and setMicButtonEnabled Method

2. BMessageCell.m : => Profile Picture Button User Interaction Enabled False


3. BTextMessageCell.m : => Text Message customised for friend request message in setMessage: method

4. BThreadsViewController.m :=>Text Message customised for friend request message in cellForRowAtIndexPath: method under if (lastMessage) { condition. & _slideToDeleteDisabled = true;  in ViewDidLoad & noDataLabel Added for Blank List in .h & .m//Added by AY

5. ElmChatViewController.h: => Add headerView and chatNameButton IBOutlet

6. ElmChatViewController.m : => canEditRowAtIndexPath: set NO & find by Comment “Added By AY”

7. BPrivateThreadsViewController.m : => canEditRowAtIndexPath: set NO & find by Comment “Added By AY”

8. BChatViewController.m : => Add Action -(IBAction)chatTitlepressed:(UIButton *)sender

9. Replace BChatViewController.xib

10. BMessageLayout.m : => Create Custom Friend Request Message Height (getTextHeightWithWidth & getTextHeightWithFont Methods)

11. BSelectLocationAction.m : => Location Permission changed to always

CHATSDKCORE:

12. BChatSDK.m. : => Comment registerForPushNotificationsWithApplication method call

FirebasePush:

13. BFirebasePushHandler.m : => Added code using tag “Added By AY”

FirebaseNetworkAdapter->Handler:

14. BFirebaseAuthenticationHandler.m :=> Added code using tag “Added By AY”


