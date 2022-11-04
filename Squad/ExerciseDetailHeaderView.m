//
//  ExerciseDetailHeaderView.m
//  ABBBCOnline
//
//  Created by AQB Mac 4 on 30/11/16.
//  Copyright © 2016 Aqb. All rights reserved.
//

#import "ExerciseDetailHeaderView.h"

@implementation ExerciseDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (self.lastContentOffset > scrollView.contentOffset.x)
//        NSLog(@"right");
//    else if
    if (_previousContentView != self.contentView) {
        NSLog(@"diff");
        CGRect frame = _previousContentView.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        [_previousScrollView scrollRectToVisible:frame animated:YES];
//        NSLog(@"psv1 %@",_previousScrollView);
        self.previousContentView = self.contentView;
        self.previousScrollView = scrollView;
    }
    if (self.lastContentOffset < scrollView.contentOffset.x){
        //        NSLog(@"left");
        if (_lastContentOffset > 30) {
            CGRect frame = _detailScroll.frame;
            frame.origin.x = frame.size.width - 62;
            frame.origin.y = 0;
            [_detailScroll scrollRectToVisible:frame animated:YES];
        }
    }
    self.lastContentOffset = scrollView.contentOffset.x;
    self.previousContentView = self.contentView;
    self.previousScrollView = scrollView;
//    NSLog(@"psv2 %@",_previousScrollView);
}
@end
