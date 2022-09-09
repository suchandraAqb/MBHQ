
//
//  MyPhotosViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 15/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "MyPhotosViewController.h"
#import "MyPhotosTableViewCell.h"
#import "GalleryViewController.h"
#import "MasterMenuViewController.h"
#import "MyPhotosCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CompareViewController.h"
#import "AppDelegate.h"

static CGFloat imageViewHeight = 350.0;

@interface MyPhotosViewController ()
{
    IBOutlet UITableView *table;
    BOOL shouldCellBeExpanded ;
    NSInteger indexOfExpandedCell;
    NSInteger sectionOfExpandedCell;
    UIView *contentView;
    
    NSMutableArray *frontArray;
    NSMutableArray *sideArray;
    NSMutableArray *backArray;
    NSMutableArray *finalArray;
    NSInteger bodyCatID;
    NSMutableArray *photoIDs;

    
}
@end

@implementation MyPhotosViewController

#pragma mark - IBAction

- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}
- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)galaryImageButtonPressed:(UIButton*)sender{
//    NSLog(@"tag %ld",(long)[sender tag]);
    NSInteger bodyCategoryID = [sender tag]-100;
    if (bodyCategoryID == 4)
        bodyCategoryID++;
    
    GalleryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GalleryView"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.bodyCategoryID = bodyCategoryID;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)addImageButtonPressed:(UIButton*)sender{
    AddImageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddImageView"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.addPhotoDelegate = self;
    NSLog(@"%ld",(long)sender.tag);
    NSString *bodyCatagoryString=@"";
    if (sender.tag == 0) { //Font
        bodyCatagoryString=@"Front";
    }else if (sender.tag == 1) //Side
        bodyCatagoryString=@"Side";
    else if (sender.tag == 2) //Back
        bodyCatagoryString=@"Back";
    else if (sender.tag == 3) //Final
        bodyCatagoryString=@"Final";
    
    controller.bodyCatagorystring=bodyCatagoryString;
    [self presentViewController:controller animated:YES completion:nil];

}
-(IBAction)expandButtonPressed:(UIButton*)sender{
    photoIDs = [NSMutableArray new];
    bodyCatID = [sender.accessibilityHint integerValue]+1;
    if (bodyCatID == 4)
        bodyCatID++;
    
    if (indexOfExpandedCell > -1 && sectionOfExpandedCell > -1 && shouldCellBeExpanded) {
        
        shouldCellBeExpanded = NO;
        [table beginUpdates];
        [table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem: indexOfExpandedCell inSection:sectionOfExpandedCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [table endUpdates];
        if (indexOfExpandedCell !=[sender tag] || sectionOfExpandedCell != [sender.accessibilityHint integerValue]) {
            shouldCellBeExpanded = YES;
            indexOfExpandedCell = [sender tag];
            sectionOfExpandedCell = [sender.accessibilityHint integerValue];
            
            [table beginUpdates];
            [table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem: indexOfExpandedCell inSection:sectionOfExpandedCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [table endUpdates];
        }
    }else{
        shouldCellBeExpanded = YES;
        indexOfExpandedCell = [sender tag];
        sectionOfExpandedCell = [sender.accessibilityHint integerValue];
        
        BOOL isEmptyArray = YES;
        switch ([sender.accessibilityHint integerValue]) {
            case 0:
                isEmptyArray = (frontArray.count == 0);
                break;
                
            case 1:
                isEmptyArray = (sideArray.count == 0);
                break;
                
            case 2:
                isEmptyArray = (backArray.count == 0);
                break;
                
            case 3:
                isEmptyArray = (finalArray.count == 0);
                break;
                
            default:
                break;
        }
        
        if (isEmptyArray) {
            [self getUserPhotosApiCallWithBodyCategoryID:[sender.accessibilityHint integerValue]+1];
        }
        
        [table beginUpdates];
        [table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem: indexOfExpandedCell inSection:sectionOfExpandedCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [table endUpdates];
    }
    
    [table reloadData];
}
- (IBAction)compareButtonPressed:(UIButton *)sender {
    NSLog(@"pi %@",photoIDs);
    
    BOOL isEmptyArray = YES;
    switch ([sender tag]) {
        case 1:
            isEmptyArray = (bodyCatID != 1);
            break;
            
        case 2:
            isEmptyArray = (bodyCatID != 2);
            break;
            
        case 3:
            isEmptyArray = (bodyCatID != 3);
            break;
            
        case 4:
            isEmptyArray = (bodyCatID != 5);
            break;
            
        default:
            break;
    }
    
    if (isEmptyArray) {
        [Utility msg:@"Please select pictures to compare" title:@"Oops!" controller:self haveToPop:NO];
    } else if ([Utility isEmptyCheck:photoIDs]) {
        [Utility msg:@"Please select atleast 2 pictures to compare" title:@"Oops!" controller:self haveToPop:NO];
    } else if (![Utility isEmptyCheck:photoIDs] && photoIDs.count < 2) {   //ah 22.3
        [Utility msg:@"Please select atleast 2 pictures to compare" title:@"Oops!" controller:self haveToPop:NO];
    } else if (![Utility isEmptyCheck:photoIDs] && photoIDs.count > 3) {
        [Utility msg:@"Maximum 3 pictures can be compared at a time" title:@"Oops!" controller:self haveToPop:NO];
    } else if (![Utility isEmptyCheck:photoIDs] && photoIDs.count > 1) {
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appdelegate.autoRotate=YES;
        
        CompareViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Compare"];
        controller.photoIDs = photoIDs;
        [self presentViewController:controller animated:YES completion:nil];
    }
}
#pragma mark - End

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    frontArray = [[NSMutableArray alloc] init];
    sideArray = [[NSMutableArray alloc] init];
    backArray = [[NSMutableArray alloc] init];
    finalArray = [[NSMutableArray alloc] init];
    photoIDs = [[NSMutableArray alloc] init];
    bodyCatID = 1;
    
    shouldCellBeExpanded = YES;
    indexOfExpandedCell = 0;
    sectionOfExpandedCell = 0;
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegate.autoRotate=NO;
    
    [self getUserPhotosApiCallWithBodyCategoryID:1];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - End
#pragma mark - AddPhotoDelegate
-(void) didPhotoAdded:(BOOL)isAdded {
    if (isAdded) {
        [self getUserPhotosApiCallWithBodyCategoryID:0];
    }
}

#pragma mark - API Call
-(void)getUserPhotosApiCallWithBodyCategoryID:(NSInteger)bodyCategoryID {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        if (bodyCategoryID == 4) {
            bodyCategoryID++;
        }
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
//        [mainDict setObject:[NSNumber numberWithInteger:bodyCategoryID] forKey:@"BodyCategoryID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetBodyPhotos" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         
                                                                         NSArray *photoArray = [[responseDictionary objectForKey:@"UserBodyPhotos"] objectForKey:@"PhotoList"];
                                                                         
                                                                         for (int i = 1; i < 5; i++) {
                                                                             
                                                                             if (i == 4) i++;
                                                                             
                                                                             NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(BodyCategoryID == %d)",(int)i];
                                                                             NSArray *filteredArray = [photoArray filteredArrayUsingPredicate:predicate];
                                                                             
                                                                             NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                                                                                 sortDescriptorWithKey:@"DateTaken"
                                                                                                                 ascending:NO];
                                                                             NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
                                                                             NSArray *sortedArray = [filteredArray
                                                                                                     sortedArrayUsingDescriptors:sortDescriptors];
                                                                             
                                                                             switch (i) {
                                                                                 case 1:
                                                                                     frontArray = [sortedArray mutableCopy];
                                                                                     break;
                                                                                     
                                                                                 case 2:
                                                                                     sideArray = [sortedArray mutableCopy];
                                                                                     break;
                                                                                     
                                                                                 case 3:
                                                                                     backArray = [sortedArray mutableCopy];
                                                                                     break;
                                                                                     
                                                                                 case 5:
                                                                                     finalArray = [sortedArray mutableCopy];
                                                                                     break;
                                                                                     
                                                                                 default:
                                                                                     break;
                                                                             }
                                                                         }
                                                                     
                                                                         [table reloadData];
                                                                         
                                                                     }else{
                                                                         [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                     
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                             
                                                         }];
        [dataTask resume];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
            return;
        });
    }
}
#pragma mark - End
#pragma mark  - TableView DataSource & Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float cellHeight  = 50;
    if(shouldCellBeExpanded && [indexPath row] == indexOfExpandedCell && [indexPath section] ==sectionOfExpandedCell){
        return cellHeight+imageViewHeight;
    }else{
        return cellHeight;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"MyPhotosTableViewCell";
    MyPhotosTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MyPhotosTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [[cell expandButton] setTag:[indexPath row]];
    cell.expandButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
    
    [cell.addImageButton setTag:indexPath.section];
    [cell.galaryImageButton setTag:indexPath.section+101];
    [cell.galaryImageButton addTarget:self action:@selector(galaryImageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.compareButton setTag:indexPath.section+1];
    [cell.compareButton addTarget:self action:@selector(compareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    /*
     Front = 1,
     Side,
     Back,
     Final = 5*/
    
    if (indexPath.section==0){
        [cell.expandButton setTitle:@"Front Pics" forState:UIControlStateNormal];
    }else if(indexPath.section==1){
        [cell.expandButton setTitle:@"Side Pics" forState:UIControlStateNormal];
    }else if(indexPath.section==2){
        [cell.expandButton setTitle:@"Back Pics" forState:UIControlStateNormal];
    }else if(indexPath.section==3){
        [cell.expandButton setTitle:@"Final Pics" forState:UIControlStateNormal];
    }
    
    if(shouldCellBeExpanded && [indexPath row] == indexOfExpandedCell && [indexPath section] ==sectionOfExpandedCell)
    {
        cell.bottomView.hidden=false;
        
        [cell.expandButton setImage:[UIImage imageNamed:@"s_down_arrow.png"] forState:UIControlStateNormal];
        
        /*if (indexPath.section==0 && indexPath.row==0) {
            cell.bodyImage.image=[UIImage imageNamed:@"front_pics.png"];

        }else if (indexPath.section==1 && indexPath.row==0){
            cell.bodyImage.image=[UIImage imageNamed:@"side_pics.png"];
            
        }else if (indexPath.section==2 && indexPath.row==0){
            cell.bodyImage.image=[UIImage imageNamed:@"back_pics.png"];
            
        }else if (indexPath.section==3 && indexPath.row==0){
            cell.bodyImage.image=[UIImage imageNamed:@"final_pics.png"];
        }*/
        
        cell.galaryCollectionView.allowsSelection = YES;
        cell.galaryCollectionView.allowsMultipleSelection = YES;
        [cell.galaryCollectionView reloadData];
    }else{
          cell.bottomView.hidden=true;
          [cell.expandButton setImage:[UIImage imageNamed:@"s_right_arrow.png"] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    MyPhotosTableViewCell *cell1 = cell;
//    [cell1.galaryCollectionView reloadData];
}

//ah 21.3

#pragma mark - CollectionView DataSource/Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (bodyCatID) {
        case 1:
            return frontArray.count;
            break;
            
        case 2:
            return sideArray.count;
            break;
            
        case 3:
            return backArray.count;
            break;
            
        case 5:
            return finalArray.count;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MyPhotosCollectionViewCell";
    
    MyPhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
//    cell.galaryImageView.image = [UIImage imageNamed:[[frontArray objectAtIndex:indexPath.section] objectForKey:@"Photo"]];
    
    NSMutableArray *picArray = [[NSMutableArray alloc] init];
    switch (bodyCatID) {
        case 1:
            picArray = frontArray;
            break;
            
        case 2:
            picArray =  sideArray;
            break;
            
        case 3:
            picArray =  backArray;
            break;
            
        case 5:
            picArray =  finalArray;
            break;
            
        default:
            break;
    }
    
    if (![Utility isEmptyCheck:[picArray objectAtIndex:indexPath.section]] && ![Utility isEmptyCheck:[[picArray objectAtIndex:indexPath.section] objectForKey:@"Photo"]]) {
        [cell.galaryImageView sd_setImageWithURL:[NSURL URLWithString:[[picArray objectAtIndex:indexPath.row] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
            cell.galaryImageView.image = [[UIImage alloc] initWithData:imageData];
        }];
    }
    cell.layer.borderWidth = 0.0;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"ip %ld",(long)indexPath.row);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    switch (bodyCatID) {
        case 1:
        
            if (cell.layer.borderWidth == 0)
                [photoIDs addObject:[[frontArray objectAtIndex:indexPath.row] objectForKey:@"UserBodyPhotoID"]];
            else
                [photoIDs removeObject:[[frontArray objectAtIndex:indexPath.row] objectForKey:@"UserBodyPhotoID"]];
            break;

        case 2:
            if (cell.layer.borderWidth == 0)
                [photoIDs addObject:[[sideArray objectAtIndex:indexPath.row] objectForKey:@"UserBodyPhotoID"]];
            else
                [photoIDs removeObject:[[sideArray objectAtIndex:indexPath.row] objectForKey:@"UserBodyPhotoID"]];
            break;
            
        case 3:
            if (cell.layer.borderWidth == 0)
                [photoIDs addObject:[[backArray objectAtIndex:indexPath.row] objectForKey:@"UserBodyPhotoID"]];
            else
                [photoIDs removeObject:[[backArray objectAtIndex:indexPath.row] objectForKey:@"UserBodyPhotoID"]];
            break;
            
        case 5:
            if (cell.layer.borderWidth == 0)
                [photoIDs addObject:[[finalArray objectAtIndex:indexPath.row] objectForKey:@"UserBodyPhotoID"]];
            else
                [photoIDs removeObject:[[finalArray objectAtIndex:indexPath.row] objectForKey:@"UserBodyPhotoID"]];
            break;
            
        default:
            break;
    }
    
    if (cell.layer.borderWidth > 0) {
        [cell.layer setBorderColor:[[UIColor clearColor] CGColor]];
        [cell.layer setBorderWidth:0.0];
        
    } else {
        [cell.layer setBorderColor:[[Utility colorWithHexString:@"ED039B"] CGColor]];
        [cell.layer setBorderWidth:2.0];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat divisor = 2.0;
    if (screenWidth > 320) {
        divisor = 3.0;
    }
    float cellWidth = (screenWidth-40) / divisor; //Replace the divisor with the column count requirement. Make sure to have it in float.
    CGSize size = CGSizeMake(cellWidth, cellWidth*1.5);
    
    return size;
}
@end
