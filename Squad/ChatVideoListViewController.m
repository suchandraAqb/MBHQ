//
//  ChatVideoListViewController.m

//  Created by Admin on 19/11/20.
//  Copyright © 2020 Dhiman. All rights reserved.
//

#import "ChatVideoListViewController.h"
#import "ChatDetailsVideoViewController.h"
#import "TagView.h"


@interface ChatVideoListViewController (){
    
    IBOutlet UITableView *videoListTable;
    IBOutlet NSLayoutConstraint *videoListTableHeightConstraint;
    
    IBOutlet TagListView *tagListView;
    IBOutlet NSLayoutConstraint *tagListViewHeightConstraint;
    IBOutlet UIView *tagListSuperView;
    
    IBOutlet UIView *searchView;
    IBOutlet UITextField *searchTextField;
    IBOutlet UIButton *searchButton;
    
    IBOutlet UIButton *showHideTagViewButton;
    
    IBOutlet UIView *loadMoreView;
    IBOutlet UIButton *clearButton;
    IBOutlet UIButton *applyButton;
    
    
    AVPlayerViewController *avPlayerController;
    AVPlayer *videoPlayer;
    
    NSMutableArray *videoListArray;
    NSMutableArray *masterVideoListArray;
    NSMutableArray *taglistMainArray;
    NSMutableArray *taglistArray;
    NSMutableArray *selectedTagArray;
    UIView *contentView;
    UIToolbar *toolBar;
    UITextField *activeTextField;
    
    int pageCount;
    BOOL moreAvailable;
    AppDelegate *appDelegate;
    
    
}
@end


@implementation ChatVideoListViewController
#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    loadMoreView.hidden=true;
    pageCount=5;
    taglistArray=[[NSMutableArray alloc] init];
    selectedTagArray=[[NSMutableArray alloc] init];
    searchView.layer.borderColor=[Utility colorWithHexString:@"98d6d7"].CGColor;
    searchView.layer.borderWidth=1;
    searchView.layer.cornerRadius=searchView.frame.size.height/2;
    searchView.clipsToBounds=YES;
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    
    [searchTextField addTarget:self
                        action:@selector(changeText:)
              forControlEvents:UIControlEventEditingChanged];
    [self registerForKeyboardNotifications];
    
    tagListSuperView.hidden=true;
    showHideTagViewButton.selected=false;
    //    [showHideTagViewButton setTitle:@"V" forState:UIControlStateNormal];
    clearButton.layer.cornerRadius=15;
    clearButton.clipsToBounds=YES;
    applyButton.layer.cornerRadius=15;
    applyButton.clipsToBounds=YES;
    [self searchMbhqLiveChatByTag];
    [self getMbhqLiveChatTags];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    videoListTable.estimatedRowHeight = 253;
    videoListTable.rowHeight = UITableViewAutomaticDimension;
    [videoListTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [videoListTable removeObserver:self forKeyPath:@"contentSize"];
}
#pragma mark - End


#pragma mark - IBActions
- (IBAction)applyButtonPressed:(UIButton *)sender {
    self->pageCount=5;
    [self searchMbhqLiveChatByTag];
}
- (IBAction)clearButtonPressed:(UIButton *)sender {
    [self prepareView];
    [selectedTagArray removeAllObjects];
    searchTextField.text=@"";
    [self searchMbhqLiveChatByTag];
}
- (IBAction)logoPressed:(UIButton *)sender {
    NSArray *arr = [self.navigationController viewControllers];
    BOOL isCheck = false;
    for (UIViewController *controller in arr) {
        if ([controller isKindOfClass:[CommunityViewController class]]) {
            isCheck = true;
            [self.navigationController popToViewController:controller animated:NO];
        }
    }
    if (!isCheck) {
        CommunityViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CommunityView"];
//        [self.navigationController pushViewController:controller animated:NO];
    }
}
- (IBAction)searchButtonPressed:(UIButton *)sender {
    self->pageCount=5;
    [self searchMbhqLiveChatByTag];
}
-(IBAction)videoButtonPressed:(UIButton*)sender{
    CMTime startTime = CMTimeMake(0, 0);
    if ([defaults boolForKey:@"IsPlayingLiveChat"]) {
        [appDelegate.FBWAudioPlayer pause];
        startTime = appDelegate.playerController.player.currentTime;
    }
    ChatDetailsVideoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ChatDetailsVideo"];
    controller.videoDict = [videoListArray objectAtIndex:sender.tag];
    if (CMTimeGetSeconds(startTime)>0) {
        controller.videoTime = startTime;
    }
    controller.videoTime = startTime;
    [self.navigationController pushViewController:controller animated:NO];
    //    controller.modalPresentationStyle = UIModalPresentationCustom;
    //    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)loadMoreButtonPressed:(UIButton *)sender {
    pageCount=pageCount+5;
    [self searchMbhqLiveChatByTag];
}
- (IBAction)showHideTagViewButtonPressed:(UIButton *)sender {
    if (tagListSuperView.isHidden) {
        tagListSuperView.hidden=false;
        showHideTagViewButton.selected=true;
        //        [showHideTagViewButton setTitle:@"X" forState:UIControlStateNormal];
    }else{
        tagListSuperView.hidden=true;
        showHideTagViewButton.selected=false;
        //        [showHideTagViewButton setTitle:@"V" forState:UIControlStateNormal];
    }
}

-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
#pragma mark - End

#pragma mark - Private Methods
-(void)changeText:(UITextField *)textField{
    //    NSArray *filteredArray;
    //    if (![Utility isEmptyCheck:selectedTagArray] && selectedTagArray.count>0){
    //        filteredArray=[masterVideoListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"ANY %K IN %@",@"Tags",selectedTagArray]];
    //    }else{
    //        filteredArray=masterVideoListArray;
    //    }
    
    
    
//    if (textField.text.length > 0) {
//        videoListArray = [[masterVideoListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(EventName CONTAINS[c] %@)", textField.text]] mutableCopy];
//    } else {
//        videoListArray = [masterVideoListArray mutableCopy];
//    }
//    [videoListTable reloadData];
}

-(void)prepareView{
    tagListView.borderColor=[UIColor whiteColor];
    tagListView.borderWidth=2;
    tagListView.paddingX=25;
    tagListView.paddingY=13;
    tagListView.marginX=3;
    tagListView.marginY=5;
    //    tagListView.tagViewHeight=50;
    tagListView.cornerRadius=20;
    tagListView.textColor=[UIColor whiteColor];
    tagListView.backgroundColor=[UIColor clearColor];
    tagListView.textFont=[UIFont fontWithName:@"Raleway-SemiBold" size:17];
    
    //    TagView *tv=[[TagView alloc] initWithTitle:@"tagView"];
    //    tv.tag=1;
    [tagListView removeAllTags];
    if (![Utility isEmptyCheck:taglistArray] && taglistArray.count>0) {
        [tagListView addTagsAccordingToDataSourceArray:taglistArray withOnTapForEach:^(TagView *tagView) {
            NSString *tagStr=tagView.titleLabel.text;
            NSLog(@"%@",tagView.titleLabel.text);
            if ([selectedTagArray containsObject:tagStr]) {
                [self->selectedTagArray removeObject:tagStr];
                tagView.backgroundColor=[UIColor clearColor];;
            }else{
                [self->selectedTagArray addObject:tagStr];
                tagView.backgroundColor=[Utility colorWithHexString:@"98d6d7"];
            }
        }];
    }
    tagListViewHeightConstraint.constant=tagListView.intrinsicContentSize.height;
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == videoListTable){
        videoListTableHeightConstraint.constant=videoListTable.contentSize.height;
    }
    [videoListTable layoutIfNeeded];
    [self.view needsUpdateConstraints];
}
#pragma mark - End


#pragma mark - Webservice Call
-(void)searchMbhqLiveChatByTag{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc] init];
        
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"Email"] forKey:@"Email"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"BeyondEventId"];
        [mainDict setObject:[NSNumber numberWithInt:pageCount] forKey:@"Count"];
        [mainDict setObject:selectedTagArray forKey:@"Tags"];
        [mainDict setObject:searchTextField.text forKey:@"SearchText"];
//        if (![Utility isEmptyCheck:searchTextField.text]) {
//            
//        }
        //        [mainDict setObject:[NSArray arrayWithObject:@"BReath Control"] forKey:@"Tags"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SearchMbhqLiveChatByTag" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
                if(error == nil)
                {
                    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                        self->videoListArray = [[NSMutableArray alloc]initWithArray:[responseDict objectForKey:@"ChatList"]];
                        self->masterVideoListArray=[self->videoListArray mutableCopy];
                        if ([[responseDict objectForKey:@"MoreAvailable"]boolValue]) {
                            self->loadMoreView.hidden=false;
                        }else{
                            self->loadMoreView.hidden=true;
                        }
                        [self->videoListTable reloadData];
                    }else{
                        [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                        return;
                    }
                }else{
                    [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                }
            });
        }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

-(void)getMbhqLiveChatTags{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc] init];
        
//        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMbhqLiveChatTags" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
                if(error == nil)
                {
                    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                        self->taglistMainArray = [[responseDict objectForKey:@"TagList"] mutableCopy];
                        if (![Utility isEmptyCheck:self->taglistMainArray] && self->taglistMainArray.count>0) {
                            [self->taglistArray removeAllObjects];
                            for (NSDictionary *d in self->taglistMainArray) {
                                [self->taglistArray addObject:[d valueForKey:@"TagName"]];
                            }
                        }
                        [self prepareView];
                    }else{
                        [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                        return;
                    }
                }else{
                    [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                }
            });
        }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}

#pragma mark - End


#pragma mark - TableView Delegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return videoListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"ChatVideoListTableViewCell";
    ChatVideoListTableViewCell *cell = (ChatVideoListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ChatVideoListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict=[videoListArray objectAtIndex:indexPath.row];
    
    cell.videoTitleLabel.text =![Utility isEmptyCheck:dict[@"EventName"]] ? dict[@"EventName"] :@"";
    cell.videoAuthorLabel.text = ![Utility isEmptyCheck:dict[@"PresenterName"]] ? dict[@"PresenterName"] :@"";
    
    //    cell.tagButtonView.borderColor=[UIColor clearColor];
    //    cell.tagButtonView.borderWidth=2;
    cell.tagButtonView.paddingX=20;
    cell.tagButtonView.paddingY=11;
    cell.tagButtonView.marginX=6;
    cell.tagButtonView.marginY=5;
    //    tagListView.tagViewHeight=50;
    cell.tagButtonView.cornerRadius=18;
    cell.tagButtonView.textColor=[UIColor whiteColor];
    cell.tagButtonView.backgroundColor=[UIColor clearColor];
    cell.tagButtonView.tagBackgroundColor=[Utility colorWithHexString:@"98d6d7"];
    cell.tagButtonView.textFont=[UIFont fontWithName:@"Raleway-SemiBold" size:13];
    
    [cell.tagButtonView removeAllTags];
    
    NSArray *tags=dict[@"Tags"];
    if (![Utility isEmptyCheck:tags] && tags.count>0) {
        [cell.tagButtonView addTagsAccordingToDataSourceArray:tags withOnTapForEach:^(TagView *tagView) {
            NSLog(@"%@",tagView.titleLabel.text);
            NSLog(@"%ld",tagView.tag);
        }];
    }
    
    
    NSString *imageUrlString = [dict objectForKey:@"ImageUrl"];
    if (![Utility isEmptyCheck:imageUrlString]) {
        //            NSString *imageUrl= [@"" stringByAppendingFormat:@"%@/%@",BASEURL,[responseDict objectForKey:@"ProfilePhoto"]];
        
        [cell.placeholderImage sd_setImageWithURL:[NSURL URLWithString:[imageUrlString stringByAddingPercentEncodingWithAllowedCharacters:
                                                                        [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                 placeholderImage:nil
                                          options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
    }else{
        cell.placeholderImage.image = nil;
    }
    int row =  (int)[cell.tagButtonView rows];
      if (row == 1 && tags.count == 3) {
          row = row +1;
      }
    cell.tagButtonViewHeightConstraint.constant= row*40;
//    cell.tagButtonViewHeightConstraint.constant=cell.tagButtonView.intrinsicContentSize.height;
    
    cell.videoButton.tag = indexPath.row;
    
    /*
     if (![Utility isEmptyCheck:[dict objectForKey:@"EventItemVideoDetails"]] && ![Utility isEmptyCheck:[[dict objectForKey:@"EventItemVideoDetails"] objectAtIndex:0]]) {
     NSDictionary *videoDict=[[dict objectForKey:@"EventItemVideoDetails"] objectAtIndex:0];
     NSURL *videoURL=[NSURL URLWithString:[videoDict objectForKey:@"DownloadURL"]];
     //        NSURL *videoURL=[NSURL URLWithString:@"https://player.vimeo.com/external/391432653.sd.mp4?s=1405198804056d0157af37e37ae4b9d3bc032db2&profile_id=165&download=1"];
     //        NSURL *videoURL=[NSURL URLWithString:@"https://squad-live.s3-ap-southeast-2.amazonaws.com/MbHQ+Meditations/audio-1579947985.mp3"];
     // create an AVPlayer
     videoPlayer = [AVPlayer playerWithURL:videoURL];
     // create a player view controller
     avPlayerController = [[AVPlayerViewController alloc]init];
     avPlayerController.player = videoPlayer;
     avPlayerController.showsPlaybackControls = true;
     //        avPlayerController.view.backgroundColor = [Utility colorWithHexString:@"e5e5ed"];
     //loops
     videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndPause;
     
     // show the view controller
     [self addChildViewController:avPlayerController];
     [cell.videoView addSubview:avPlayerController.view];
     avPlayerController.view.frame = cell.videoView.bounds;
     [avPlayerController setVideoGravity:AVLayerVideoGravityResizeAspectFill];
     [videoPlayer pause];
     }
     */
    
    
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - End

#pragma mark - KeyboardNotifications -
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
}
#pragma mark - End

#pragma mark - textField Delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setInputAccessoryView:toolBar];
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField=nil;
}
#pragma mark - End

@end
