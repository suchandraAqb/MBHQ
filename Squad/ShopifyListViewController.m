//
//  ShopifyListViewController.m
//  The Life
//
//  Created by AQB Mac 4 on 17/10/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "ShopifyListViewController.h"
#import "ShopifyCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProductViewController.h"
#import "Theme.h"
#import <Buy/Buy.h>



//@import Buy;

@interface ShopifyListViewController (){
    UIView *contentView;
    IBOutlet UIImageView *headerBg;
    IBOutlet UICollectionView *shopifyCollectionView;
    NSArray *allCollections;
    NSArray *productsList;

}
@property (nonatomic, strong) BUYClient *client;

@end

@implementation ShopifyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        headerBg.image = [UIImage imageNamed:@"header-4s.png"];
    }else{
        headerBg.image = [UIImage imageNamed:@"header.png"];
    }
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
            self.client = [[BUYClient alloc] initWithShopDomain:SHOP_DOMAIN
                                                         apiKey:API_KEY
                                                          appId:APP_ID];
            [self.client getProductsPage:1 completion:^(NSArray *products, NSUInteger page, BOOL reachedEnd, NSError *error) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
                if (error == nil && products) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (contentView) {
                            [contentView removeFromSuperview];
                        }
                    });
                    productsList = products;
                    [shopifyCollectionView reloadData];
                }
                else {
                    NSLog(@"Error fetching products: %@", error);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (contentView) {
                            [contentView removeFromSuperview];
                            [Utility msg:error.localizedDescription title:@"Oops! " controller:self haveToPop:NO];
                            return;
                        }
                    });
                }
            }];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
            return;
        });
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MasterMenuViewController class]]) {
        MasterMenuViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterMenuView"];
        controller.delegateMasterMenu=self;
        self.slidingViewController.underLeftViewController  = controller;
    }
//    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}
-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}


#pragma -mark CollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return productsList.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"ShopifyCollectionViewCell";
    ShopifyCollectionViewCell *cell = (ShopifyCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    BUYProduct *product = productsList[indexPath.row];
    if (![Utility isEmptyCheck:product]) {
        cell.productTitle.text = product.title;
        NSArray *imageArray =product.imagesArray;
        if (imageArray.count > 0) {
            BUYImageLink *imageLink = imageArray.firstObject;
            NSURL *imageUrl = [imageLink imageURLWithSize:BUYImageURLSize160x160];
            if (![Utility isEmptyCheck:imageUrl]) {
                [cell.productImage sd_setImageWithURL:imageUrl
                                     placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
            }else{
                cell.productImage.image = [UIImage imageNamed:@"place_holder1.png"];
            }
        }
    }
    
    
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BUYProduct *product = productsList[indexPath.row];
    Theme *theme = [Theme new];
    theme.style = ThemeStyleLight;
    theme.tintColor = [UIColor colorWithRed:126.0f/255.0f green:200.0f/255.0f blue:222.0f/255.0f alpha:1];
    theme.showsProductImageBackground = YES;
    ProductViewController *productViewController = [[ProductViewController alloc] initWithClient:self.client theme:theme];
    productViewController.merchantId = MERCHANT_ID;
    [productViewController loadWithProduct:product completion:^(BOOL success, NSError *error) {
        if (error == nil) {
            [productViewController presentPortraitInViewController:self];
        }
    }];

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w1 = (CGRectGetWidth(shopifyCollectionView.frame)-21)/2;
    return CGSizeMake(w1, w1);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 7;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
