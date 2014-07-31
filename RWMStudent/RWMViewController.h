//
//  RWMViewController.h
//  RWMStudent
//
//  Created by Francisco Salazar on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define API_KEY @"c40b0c360f3d4959b53b103b25759542"
#import "Reachability.h"
#import <MessageUI/MFMailComposeViewController.h>

#import "RWMDashboardVC.h"

@class AVCamViewController;
@class StudentHomeVC;

@class Reachability;
@class OfflineSettings;//actually online and Offline settings


@interface RWMViewController : UIViewController <NSURLConnectionDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, RWMDashboardVCDelegate, UIPopoverControllerDelegate>{
    
    
    
    NSString *nameOfStudent;

    NSString *userName;
    NSString *password;
    
    
    
    
}
//@property (strong, nonatomic) UIPopoverController *popverDashboard ;

@property (strong, nonatomic) IBOutlet UIButton *setTokenBtn;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) AVCamViewController *avcamVC;
@property (nonatomic, strong) StudentHomeVC *studentVC;
@property (nonatomic, strong) RWMDashboardVC *teacherDashboard;
@property (nonatomic, strong) Reachability* reachability ;
@property (nonatomic, strong) OfflineSettings* settingsVC ;

@property (nonatomic, strong) IBOutlet UITextField *enterTokenField;

@property (strong, nonatomic) IBOutlet UIButton *launchAVCam;

@property (nonatomic, copy) NSDictionary *res;
-(IBAction)launchVideoAssessment:(id)sender withToken:(NSString*)aToken;
-(IBAction)submitLoginInfo:(id)sender;
//-(void)LoginToServer;
- (IBAction)launchAVCam:(id)sender;
- (IBAction)launchOnlineDashboard:(id)sender;

-(IBAction)loadSettings:(id)sender;
-(IBAction)sendFeedback:(id)sender;
-(void)submitToken:(NSString*)aToken; //checks to see if a token is valid before loading the next screen....


-(IBAction)loadWebVersion:(id)sender;


@end
