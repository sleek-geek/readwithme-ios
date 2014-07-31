//
//  CustomTextField.h
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

 


@interface CustomTextField : UITextView

 

@property (nonatomic, strong) NSString *textForView;
@property (nonatomic, strong) UIMenuController *menu;
@property (nonatomic, strong)NSNumber *wordPositionNum ;
@property (nonatomic, strong) NSString *miscueString;
@property (nonatomic, strong) NSString *skippedString;
@property (nonatomic, strong) NSString *selfCorrectString;
@property (nonatomic, strong) NSString *gotHelpString;
@property (nonatomic, strong)NSNumber* menuIndexNUM;

@property (nonatomic, strong) NSNumber *fontSize;
@property (nonatomic, strong) NSNumber * wordsInPassage;

@property (nonatomic, strong) NSNumber * helpedNUM;
@property (nonatomic, strong) NSNumber * skippedNUM;
@property (nonatomic, strong) NSNumber * selfCorrectNUM;

@property (nonatomic, weak)  NSNumber *  isLastWord; //last word option for menu controller

@property (nonatomic, readwrite) NSMutableArray *wordPositionArray;

-(void) endInterface;

-(void) setLastWord:(NSNumber*)wordPosition;

@end
