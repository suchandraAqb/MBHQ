//
//  ParentLearnMoreViewController.m
//  Squad
//
//  Created by Suchandra Bhattacharya on 15/10/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "ParentLearnMoreViewController.h"

@interface ParentLearnMoreViewController ()
{
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIView *lastView;
    IBOutlet UIButton *backBtn;
    int currentPage;
    BOOL pageControlIsChangingPage;
    NSMutableArray *pageImages;
}

@end

@implementation ParentLearnMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    backBtn.layer.cornerRadius = 15;
    backBtn.layer.masksToBounds = YES;
    lastView.hidden = true;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [mainScroll addGestureRecognizer:tapGesture];
}
- (void)viewDidLayoutSubviews
{
    [self setUpView];
}
#pragma mark - IBAction
-(IBAction)backPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - End
#pragma mark - Private Function

-(void)setUpView{
    mainScroll.hidden = false;
    lastView.hidden = true;
    pageImages = [[NSMutableArray alloc]init];

    if (_selectIndex == 0) {
        for (int i=0; i<_pageCount; i++) {
            [pageImages addObject:[@"" stringByAppendingFormat:@"workout_%d",(i+1)]];
        }
        
    }else if(_selectIndex == 1){
            for (int i=0; i<_pageCount; i++) {
                [pageImages addObject:[@"" stringByAppendingFormat:@"nutrition_Tracker_%d",(i+1)]];
            }
    }else if(_selectIndex == 2){
        for (int i=0; i<_pageCount; i++) {
            [pageImages addObject:[@"" stringByAppendingFormat:@"ultimate_%d",(i+1)]];
        }
    }
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageImages.count;
    mainScroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*pageImages.count, mainScroll.bounds.size.height);
    for (int i = 0; i<pageImages.count;i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*i, 0, mainScroll.frame.size.width, mainScroll.frame.size.height)];
        [imageView setImage:[UIImage imageNamed:pageImages[i]]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        NSURL *url;
        if (i == 4 && _selectIndex == 0) {
            url = [[NSBundle mainBundle] URLForResource:@"workout" withExtension:@"gif"];
            
        }else if (i == 4 && _selectIndex == 1){
            url = [[NSBundle mainBundle] URLForResource:@"nutrition" withExtension:@"gif"];

        }
        UIImageView *gifImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 120, mainScroll.frame.size.width, mainScroll.frame.size.height-120)];
        gifImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
        gifImageView.contentMode = UIViewContentModeScaleAspectFit;
        gifImageView.clipsToBounds = YES;
        [imageView addSubview:gifImageView];
        [mainScroll addSubview:imageView];
    }
    [self changePage:0];
}
#pragma mark - UITapGesture Action
- (void)tapAction:(UITapGestureRecognizer *)tap
{
   
    if(self.pageControl.currentPage == _pageCount){
        mainScroll.hidden = true;
        self.pageControl.hidden = true;
        //lastView.hidden = false;
        return;
    }
    self.pageControl.currentPage = self.pageControl.currentPage+1;
    [self changePage:0];
}
-(IBAction)changePage:(id)sender
{
    //move the scroll view
   
    CGRect frame = mainScroll.frame;
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    //    frame.origin.x = frame.size.width * 1;
    [mainScroll scrollRectToVisible:frame animated:YES];
    //scrollViewDidEndDecelerating will turn this off
    pageControlIsChangingPage = YES;
}
#pragma mark - UIScrollViewDelegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if ((scrollView.contentOffset.x + scrollView.frame.size.width) > scrollView.contentSize.width) {
//        mainScroll.hidden = true;
//        self.pageControl.hidden = true;
//        //lastView.hidden = false;
//        return;
//    }
    if (pageControlIsChangingPage) {
        return;
    }
    CGFloat pageWidth = mainScroll.frame.size.width;
    float fractionalPage = mainScroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlIsChangingPage = NO;
    CGFloat pageWidth = mainScroll.frame.size.width;
    float fractionalPage = mainScroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
    //    uint page = mainScroll.contentOffset.x / SCROLLWIDTH;
    //    [self.pageControl setCurrentPage:page];
}

@end
