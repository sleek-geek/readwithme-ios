//
//  RRCurlPageVC.h
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RRCurlPageVCDelegate <NSObject>

-(void) compQuestionsDidFinishWithQuestions:(NSNumber*)score q1Text:(NSString*) question1Text q2text:(NSString*) question2Text q3text:(NSString*)question3Text;

-(void) compQuestionsDidCancel;

@end


@interface RRCurlPageVC : UIViewController
{
    
    BOOL isQuestion1Correct;
    BOOL isQuestion2Correct;
    NSNumber * score; 
    
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *q1segment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *q2segment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *q3segment;

@property (nonatomic, strong) IBOutlet NSString *question1;
@property (nonatomic, strong) IBOutlet NSString *question2;
@property (nonatomic, strong) IBOutlet NSString *question3;
@property (nonatomic, strong) id <RRCurlPageVCDelegate>delegate;
@property (nonatomic, strong) IBOutlet UILabel *question1Label;

@property (nonatomic, strong) IBOutlet UILabel *question2Label;

@property (strong, nonatomic) IBOutlet UILabel *question3Label;

@property (nonatomic, strong) IBOutlet UIButton *compButton1;
@property (nonatomic, strong) IBOutlet UIButton *compButton2;
@property (nonatomic, strong) IBOutlet UITextView *q1TextView;
@property (nonatomic, strong) IBOutlet UITextView *q2TextView;
@property (strong, nonatomic) IBOutlet UITextView *q3TextView;

@property (nonatomic, weak) IBOutlet UIButton *goBackBtn;
 

-(IBAction)answerQuestion:(id)sender;
-(IBAction)cancelAndDismiss:(id)sender;
-(IBAction)saveAndReturn:(id)sender;

@end
