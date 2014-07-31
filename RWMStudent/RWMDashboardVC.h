//
//  RWMDashboardVC.h
//  RWMStudent
//
//  Created by Francisco Salazar on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject_Constants.h"


@protocol RWMDashboardVCDelegate;

@interface RWMDashboardVC : UIViewController<UIWebViewDelegate>


@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSString *theUserID;
@property (strong, nonatomic) NSString *theToken;
@property (strong, nonatomic) IBOutlet UIWebView *teacherWebView;
@property (strong, nonatomic) IBOutlet UIImageView *connectingOverlayImageView;

-(void)connectToURL:(NSURL*)connectWithURL;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;

@property (nonatomic, assign) BOOL isLoggedin;

@property (nonatomic, strong) id<RWMDashboardVCDelegate> delegate;

-(IBAction)goBack:(id)sender;




@end


@protocol RWMDashboardVCDelegate <NSObject>

-(void) dismissWebView;


@end

