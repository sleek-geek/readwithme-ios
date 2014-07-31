//
//  RRCurlPageVC.m
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RRCurlPageVC.h"

@interface RRCurlPageVC ()

@end

@implementation RRCurlPageVC
@synthesize compButton1, compButton2, goBackBtn, q1TextView,  q2TextView , question2Label, question1Label, delegate;
@synthesize q1segment, q2segment, q3segment;
@synthesize q3TextView, question3Label, question1, question2, question3;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
     
    
     self.contentSizeForViewInPopover=CGSizeMake(594, 520);
    
     
    
    
  //  NSLog(@" 3 questions are: %@ and %@, and %@", question1, question2, question3);
    
    q1segment.selectedSegmentIndex=2;
    q2segment.selectedSegmentIndex=2;
    q3segment.selectedSegmentIndex=2;
     
    
    [super viewDidLoad];
    
    question1Label.text=question1;
    question2Label.text=question2;
    question3Label.text=question3;
    // Do any additional setup after loading the view from its nib.
}



 

-(IBAction)cancelAndDismiss:(id)sender{
    
    
  //  NSLog(@"cancel and dismiss");
    
    [self.delegate compQuestionsDidCancel];
}

-(IBAction)saveAndReturn:(id)sender{
    
    
    
    int q1Int = [q1segment selectedSegmentIndex ];
    int q2Int = [q2segment selectedSegmentIndex];
    int q3Int = [q3segment selectedSegmentIndex];
    
    
    int q1score =0;
    int q2score =0;
    int q3score =0;
    
    
    if (q1Int==0) {
        //answer is incorrect
        
        q1score=0;
        
    } else if (q1Int==1){
        
        //answer is correct
        q1score=1;
        
    } else{
        
        //answer N/A
        q1score=0;
    }
    
    
    //question 2
    if (q2Int==0) {
        //answer is incorrect
        
        q2score=0;
        
    } else if (q2Int==1){
        
        //answer is correct
        q2score=1;
        
    } else{
        
        //answer N/A
        q2score=0;
    }
    
    //question 3
    if (q3Int==0) {
        //answer is incorrect
        
        q3score=0;
        
    } else if (q3Int==1){
        
        //answer is correct
        q3score=1;
        
    } else{
        
        //answer N/A
        q3score=0;
    }
    
    
    int totalScoreInt =q1score+q2score+q3score;
    
    NSNumber *totalCompScore =[NSNumber numberWithInt:totalScoreInt];
    
    
    
    
    
    [self.delegate compQuestionsDidFinishWithQuestions:totalCompScore q1Text:q1TextView.text q2text:q2TextView.text q3text:q3TextView.text];
   // NSLog(@"save and return");
    
    
}

-(IBAction)answerQuestion:(id)sender{
    
     
      if ([sender isSelected]==YES)
          
      {
          
          
          [sender setSelected:NO];
           
          
      } else {
          
          
          [sender setSelected:YES];
           
      }
    
    
    
  //  NSLog(@"Answer Question called");
}





- (void)viewDidUnload
{
    [self setQuestion3Label:nil];
    [self setQ1segment:nil];
    [self setQ2segment:nil];
    [self setQ3segment:nil];
    [self setQ3TextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
