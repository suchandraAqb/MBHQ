//
//  ExerciseDetailsTableViewCell.m
//  ABBBCOnline
//
//  Created by AQB Mac 4 on 30/11/16.
//  Copyright © 2016 Aqb. All rights reserved.
//

#import "ExerciseDetailsTableViewCell.h"

@implementation ExerciseDetailsTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (self.lastContentOffset < scrollView.contentOffset.x){
//                NSLog(@"left");
//        NSLog(@"lco %f",_lastContentOffset);
        if (_lastContentOffset > 30) {
            CGRect frame = _cellScrollView.frame;
            frame.origin.x = frame.size.width - 62;
            frame.origin.y = 0;
            [_cellScrollView scrollRectToVisible:frame animated:YES];
//            NSLog(@"l => x %f w %f",frame.origin.x,frame.size.width);
        }
    } else if (self.lastContentOffset > scrollView.contentOffset.x) {
        //        NSLog(@"right");
        if (_lastContentOffset < 50) {
            CGRect frame = _cellScrollView.frame;
            frame.origin.x = 0.0;//frame.size.width +100;
            frame.origin.y = 0;
            [_cellScrollView scrollRectToVisible:frame animated:YES];
        }
//        NSLog(@"r => x %f w %f",frame.origin.x,frame.size.width);
    }
    self.lastContentOffset = scrollView.contentOffset.x;
}
@end
