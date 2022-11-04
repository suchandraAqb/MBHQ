//
//  VitaminEditViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 20/03/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "VitaminEditViewController.h"
#import "VitaminEditCollectionViewCell.h"
@interface VitaminEditViewController ()
{
    IBOutlet UICollectionView *vitaminEditCollection;
    IBOutlet UILabel *vitamiName;
    NSArray *individualTaskArray;
    UIView *contentView;
}
@end

@implementation VitaminEditViewController
@synthesize editDict,vitaminEditDelegate;

#pragma mark  - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if (![Utility isEmptyCheck:editDict]) {
        individualTaskArray = [editDict objectForKey:@"IndividualTasks"];
        if (![Utility isEmptyCheck:individualTaskArray]) {
            vitamiName.text = [@"" stringByAppendingFormat:@"Vitamin Name : %@", [[individualTaskArray objectAtIndex:0]objectForKey:@"VitaminName"]];
        }
        [vitaminEditCollection reloadData];
    }
}
#pragma mark - End

#pragma mark - IBAction
-(IBAction)checkUncheckButtonPressed:(UIButton*)sender{
    sender.selected = !sender.selected;
    [self webSerViceCall_UpdateTaskStatus:individualTaskArray[sender.tag]];
}
#pragma mark - End
#pragma mark - Private Function

-(void)webSerViceCall_UpdateTaskStatus:(NSDictionary*)dict{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[dict objectForKey:@"VitaminTaskId"] forKey:@"TaskId"];
        if ([[dict objectForKey:@"IsTaskDone"]boolValue]) {
            [mainDict setObject:[NSNumber numberWithBool:false] forKey:@"IsDone"];
        }else{
            [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"IsDone"];
        }
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateTaskStatus" append:@""forAction:@"POST"];
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
                                                                         
                                                                         if ([self->vitaminEditDelegate respondsToSelector:@selector(dataReload)]) {
                                                                             [self->vitaminEditDelegate dataReload];
                                                                         }
//                                                                         [self.navigationController popViewControllerAnimated:YES];
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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

#pragma mark  - Collection View DataSource & Delegates
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return individualTaskArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    VitaminEditCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VitaminEditCollectionViewCell" forIndexPath:indexPath];
    if (![Utility isEmptyCheck:[individualTaskArray objectAtIndex:indexPath.row]]) {
        NSDictionary *individualDict = [individualTaskArray objectAtIndex:indexPath.row];
        if ([Utility isEmptyCheck:[individualDict objectForKey:@"DayNotActive"]]) {
            cell.userInteractionEnabled= true;
            if ([[individualDict objectForKey:@"IsTaskDone"]boolValue]) {
                cell.taskDoneButton.selected = true;
            }else{
                cell.taskDoneButton.selected = false;
            }
        }else{
            cell.userInteractionEnabled= false;
        }
    }
    cell.taskDoneButton.tag =indexPath.row;
    return cell;
}
//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenWidth = screenRect.size.width;
//    CGFloat divisor = 5.0;
//
//    float cellWidth = (screenWidth-10) / divisor; //Replace the divisor with the column count requirement. Make sure to have it in float.
//    CGSize size = CGSizeMake(cellWidth,60);
//
//    return size;
//}
#pragma mark - End
@end
