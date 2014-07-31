//
//  SelfAssessViewController.h
//  RWMStudent
//
//  Created by Francisco Salazar on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
  

@interface SelfAssessViewController : UIViewController <NSURLConnectionDelegate>

{
    
         
}

@property (nonatomic, strong) IBOutlet UITextField *enterTokenField;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UITextView *contentTextView;
-(IBAction)setToken:(id)sender;
-(void)setTokenFromSegue:(NSString*)aToken;
//-(IBAction)speakThisText:(id)sender withText:(NSString*)aText;

-(id) initWithToken:(NSString*)aToken;

@end
