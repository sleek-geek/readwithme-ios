//
//  RWMDashboardVC.m
//  RWMStudent
//
//  Created by Francisco Salazar on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RWMDashboardVC.h"
#import "Const.h"


@interface RWMDashboardVC ()
@property (nonatomic, strong) NSMutableData *responseData;
@end

@implementation RWMDashboardVC
@synthesize theToken;
@synthesize teacherWebView;
@synthesize theUserID;
@synthesize responseData =_responseData;
@synthesize connectingOverlayImageView;
@synthesize activityIndicator;
@synthesize isLoggedin;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        
       // NSLog(@"Do nothting to view, we are in ios 6");
         [teacherWebView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 760)];
        self.navigationController.toolbar.hidden = NO;
    } else {
        
        
        [teacherWebView setFrame:CGRectMake(0, 60, 768, 760)];
        
      //  NSLog(@"adjust the view for ios7");
    }
    
    
    
    
}

- (void)viewDidLoad
{
 //   NSLog(@"View Did Load");
  // self.contentSizeForViewInPopover=CGSizeMake(760, 980);
    
    //[[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    
    
    
    if (isLoggedin==NO) {
      
        [activityIndicator startAnimating];
        connectingOverlayImageView.hidden=NO;
        
        
         
       
        NSString *dashboardURLFull=RWMVersionURL;
        
        
        
      //  RWM_URL_VERSION;
        
        NSURL* theURL= [NSURL URLWithString:dashboardURLFull];
        
        NSLog(@"The BASE URL IS: %@", dashboardURLFull);
        
        [self connectToURL:theURL];
        
       // NSLog(@"is Logged in==NO");
        
        isLoggedin=YES;
    }
    else{//if we are logged in,just show the stuff
        
        connectingOverlayImageView.hidden=YES;
      //  NSLog(@"Is already Connected");
        
    }
    
    
    
    
    
    [super viewDidLoad];
    
   
    
    
    
    
	// Do any additional setup after loading the view.
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    connectingOverlayImageView.alpha=0;
    
    [UIView commitAnimations];
    [activityIndicator stopAnimating];
    activityIndicator.hidden=YES;
     //connectingOverlayImageView.hidden=YES;

}

//The following methods were compied from AVCamViewController, and modified 
-(void)connectToURL:(NSURL*)connectWithURL{
     
 //   NSLog(@"Connect to URL");
    //need to save this web view in this state
     
    teacherWebView.delegate=self;
    
    
    [teacherWebView  loadRequest:[NSURLRequest requestWithURL:connectWithURL]];
    
    
 //  NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:connectWithURL];
    
  //  NSLog(@"COOKIES: %@", cookies);
}

 
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [self.responseData setLength:0];
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {        
    [self.responseData appendData:data]; 
    //makes sure we start with REAR CAMera
    connectingOverlayImageView.hidden=YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {    
    
    NSString *errordesc= [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    
    UIAlertView *noConnecttionAlert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:errordesc delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [noConnecttionAlert show];
     
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    //remove the overlay
    
    
    // convert to JSON
  //  NSError *myError = nil;
    //NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    
   // NSLog(@"JSON object includes: %@", res);
    
    
     
    
    // [self setTextAndTitle:content andTitle:title];
    
        
    
}
-(IBAction)goBack:(id)sender
{
    
    
    //going back
   // NSLog(@"Going BAck!")   ;
    [ self.delegate dismissWebView];
    
    
    
}


- (void)viewDidUnload
{
    [self setTeacherWebView:nil];
    [self setConnectingOverlayImageView:nil];
    [self setActivityIndicator:nil];
    [self setBackButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
