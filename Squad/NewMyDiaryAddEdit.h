//
//  NewMyDiaryAddEdit.h
//  Squad
//
//  Created by AQB Mac 4 on 30/11/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Foundation/Foundation.h"
#import "ZSSRichTextEditor.h"

@protocol NewMyDiaryAddEditDelegate
@optional -(void)isTextChanged:(BOOL)value;

@end


@interface NewMyDiaryAddEdit : ZSSRichTextEditor{
    id<NewMyDiaryAddEditDelegate>delegate;
}
@property (nonatomic,strong)id delegate;


@end
