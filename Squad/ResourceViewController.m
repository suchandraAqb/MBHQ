//
//  ResourceViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 05/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "ResourceViewController.h"
#import "ResourceTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ResourceViewController (){
    
    __weak IBOutlet UIView *pdfView;
    __weak IBOutlet UIWebView *myWebView;
//    __weak IBOutlet UITableView *table;
    __weak IBOutlet UICollectionView *myCollection;
    UIView *contentView;
    
    NSArray *pdfArray;
    int selectedRow;
}

@end

@implementation ResourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pdfView.hidden = true;
//    table.estimatedRowHeight = 260;
//    table.rowHeight = UITableViewAutomaticDimension;
    pdfArray = @[@{@"pdf":@"/Resources/ASHY BINES Recipe Book CEDP.pdf",@"name":@"Clean Eating Recipe Book",@"image":@"/Content/images/download_icons/recipebookcedp.jpg"},
                 @{@"pdf":@"/Resources/Ashy Bines Vegan Clean Eating_Meal_Plan V3.pdf",@"name":@"Vegan Clean Eating Meal Plan",@"image":@"/Content/images/download_icons/veganmealplan.jpg"},
                 @{@"pdf":@"/Resources/CLEAN-EATING-GUIDE.pdf",@"name":@"Clean Eating Diet Program",@"image":@"/Content/images/download_icons/CleanEatingGuide.jpg"},
                 @{@"pdf":@"/Resources/ASHY BINES_CLEAN EATING_LIFESTYLE2.pdf",@"name":@"Clean Eating Lifestyle",@"image":@"/Content/images/download_icons/cleaneatinglifestyle.jpg"},
                 @{@"pdf":@"/Resources/ASHY BINES 7DK_WORKOUTS.pdf",@"name":@"7 Day Kickstarter Workouts",@"image":@"/Content/images/download_icons/7dkworkouts.jpg"},
                 @{@"pdf":@"/Resources/Motivation Boosters to Stick It Out_b.pdf",@"name":@"Motivation Boosters to Stick It Out",@"image":@"/Content/images/download_icons/Motivation Boosters to Stick It Out_b_thumb.jpg"},
                 @{@"pdf":@"/Resources/Flatten Your Lower Tummy Bump_b.pdf",@"name":@"Flatten Your Lower Tummy Bump",@"image":@"/Content/images/download_icons/Flatten Your Lower Tummy Bump_b_thumb.jpg"},
                 @{@"pdf":@"/Resources/7 HEALTHY FOODS RUINING YOUR ABS_oct15.pdf",@"name":@"7 Healthy Foods Ruining Your Abs",@"image":@"/Content/images/download_icons/7 HEALTHY FOODS RUINING YOUR ABS_oct15_thumb.jpg"},
                 @{@"pdf":@"/Resources/ULTIMATERESULTSPACK/ASHY BINES_RESULTS MANUAL.pdf",@"name":@"Ashy Bines Results Manual",@"image":@"/Content/images/download_icons/ASHY BINES_RESULTS MANUAL_thumb.jpg"},
                 @{@"pdf":@"https://abbbc-pt.leadpages.co/results-video-series/",@"name":@"Results Manual - Seminars",@"image":@"/Content/images/download_icons/Seminar_thumb.jpg"},];
    selectedRow = -1;
}

- (IBAction)crossButtonPressed:(UIButton *)sender {
    pdfView.hidden = true;
}

#pragma mark -CollectionView Delegate & Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return pdfArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    int sWidth = screenSize.width - 30;
    sWidth /= 2;
    return CGSizeMake(sWidth, 280);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ResourceTableViewCell *cell = (ResourceTableViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ResourceTableViewCell" forIndexPath:indexPath];
    
    [cell.resourceImage sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",BASEURL,pdfArray[indexPath.row][@"image"]] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"new_image_loading.png"] options:SDWebImageScaleDownLargeImages];
    cell.resourceName.text = pdfArray[indexPath.row][@"name"];
    cell.mainView.layer.borderWidth = 1;
    cell.mainView.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    cell.mainView.layer.masksToBounds = YES;
    cell.mainView.layer.cornerRadius = 5;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    pdfView.hidden = false;
    if (selectedRow == indexPath.row) {
        return;
    }
    selectedRow = (int)indexPath.row;
    NSURL *url;
    if (indexPath.row == 9) {
        url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",pdfArray[indexPath.row][@"pdf"]] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]]];
    } else {
        url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",BASEURL,pdfArray[indexPath.row][@"pdf"]] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]]];
        
    }
    if (![Utility isEmptyCheck:url]) {
        if ([Utility reachable]) {
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [myWebView loadRequest:request];
            [myWebView setScalesPageToFit:YES];
        }
    }else{
        pdfView.hidden = true;
        [Utility msg:@"Something went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
    }
}
#pragma mark -End

//#pragma mark -TableView Delegate & Datasource
//- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return pdfArray.count;
//}
//- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    ResourceTableViewCell *cell = (ResourceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ResourceTableViewCell"];
//
//
//
//    [cell.resourceImage sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",BASEURL,pdfArray[indexPath.row][@"image"]] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"new_image_loading.png"] options:SDWebImageProgressiveDownload];
//    cell.resourceName.text = pdfArray[indexPath.row][@"name"];
//    cell.mainView.layer.borderWidth = 1;
//    cell.mainView.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
//    cell.mainView.layer.masksToBounds = YES;
//    cell.mainView.layer.cornerRadius = 5;
//    return cell;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    pdfView.hidden = false;
//    NSURL *url;
//    if (indexPath.row == 9) {
//        url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",pdfArray[indexPath.row][@"pdf"]] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]]];
//    } else {
//        url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",BASEURL,pdfArray[indexPath.row][@"pdf"]] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]]];
//
//    }
//    if (![Utility isEmptyCheck:url]) {
//        if ([Utility reachable]) {
//            if (contentView) {
//                [contentView removeFromSuperview];
//            }
//            contentView = [Utility activityIndicatorView:self];
//            NSURLRequest *request = [NSURLRequest requestWithURL:url];
//            [myWebView loadRequest:request];
//            [myWebView setScalesPageToFit:YES];
//        }
//    }else{
//        pdfView.hidden = true;
//        [Utility msg:@"Something went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:YES];
//    }
//}
//#pragma mark -End

#pragma mark - WebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (contentView) {
        [contentView removeFromSuperview];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (contentView) {
        [contentView removeFromSuperview];
    }
    pdfView.hidden = true;
    [Utility msg:@"Something went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
    
}

#pragma mark - End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
