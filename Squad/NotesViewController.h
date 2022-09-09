//
//  NotesViewController.h
//  Squad
//
//  Created by Suchandra Bhattacharya on 04/09/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol NotesViewDeleagte <NSObject>
@optional -(void)saveButtonDetails:(NSString*)saveText;
@optional -(void)reloadData:(BOOL)isreload;
@optional - (void) setStatementText:(NSString *) statementText atIndex:(NSInteger) index forKey:(NSString *)key;
@optional - (void) setHabitText:(NSString *) habitText textViewName:(NSString *) textViewName;
@end

@interface NotesViewController : UIViewController<UITextViewDelegate>{
    id<NotesViewDeleagte>notesDelegate;
}
@property (strong,nonatomic) id notesDelegate;
@property (strong,nonatomic) NSDate *currentDate;
@property (strong,nonatomic) NSString *selectGrowth;
@property (strong,nonatomic) NSString *fromStr;
@property (strong,nonatomic) NSString *growthStr;

@property (assign,nonatomic) NSInteger visionStatementIndex;
@property (strong,nonatomic) NSString *visionStatementText;
@property (strong,nonatomic) NSString *visionStatementKey;
@property (strong,nonatomic) NSString *textViewName;
@property (strong,nonatomic) NSString *habitText;
@property (strong,nonatomic) NSString *habitQuestionText;
@property BOOL isFromTitle;
@property (strong,nonatomic) NSDictionary *addEditPageDict;


@end

NS_ASSUME_NONNULL_END
