//
//  RWMViewController.m
//  RWMStudent
//
//  Created by Francisco Salazar on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RWMViewController.h"
#import "SelfAssessViewController.h"
#import "AVCamViewController.h"
#import "RWMDashboardVC.h"
//#import "StudentHomeVC.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "OfflineSettings.h"
 

@interface RWMViewController ()

@property (nonatomic, strong) NSMutableData *responseData;

@end
                                                                                                                                                                                             
@implementation RWMViewController
@synthesize enterTokenField;
@synthesize userNameTextField;
@synthesize passwordTextField;
@synthesize avcamVC;
@synthesize responseData;
@synthesize teacherDashboard;
@synthesize studentVC;
@synthesize setTokenBtn;
@synthesize reachability;
@synthesize settingsVC;

@synthesize res;

BOOL isConnected=YES;
BOOL canLaunchAVCam=YES;

- (void)viewDidLoad
{
    
    // [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewDidLoad];
    
   
     reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    
    //check to see if there is an working internet connection
    
    //if no internet connect
     
    
    
    
    
    
    
}

-(IBAction)sendFeedback:(id)sender{
    
    NSArray*recipientsArray=[[NSArray alloc]initWithObjects:@"support@readwithmeapp.com" , nil];
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"Feedback from iPad user"];
    [controller setToRecipients:recipientsArray ];
    
    if (controller) [self presentModalViewController:controller animated:YES];
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void) reachabilityChanged:(NSNotification*) notification
{
	  reachability = notification.object;
    
	 
		 
	 
		 
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    if ([segue.identifier isEqualToString:@"selfAssessment"]) {
        
        
        
       [segue.destinationViewController setTokenFromSegue:enterTokenField.text];
        
    } else if ([segue.identifier isEqualToString:@"avCam"]) {
         
        
        
        
        [segue.destinationViewController setTokenFromSegue:enterTokenField.text];
        
       // [segue.destinationViewController setHappiness:0];
    }  else if  ([segue.identifier isEqualToString:@"TeacherOffline"]){
        
      

      //  [self LoginToServer];
        
    } else if  ([segue.identifier isEqualToString:@"OnlineAccess"]) {
        
        
         
        [segue.destinationViewController setIsLoggedin:NO];
        
        
        
    } else if  ([segue.identifier isEqualToString:@"StudentOfflinePassage"]) {
        
                
    }else if ([segue.identifier isEqualToString:@"AboutPage"]){
         
         
        
    } else if([segue.identifier isEqualToString:@"TermsOfUse"]){
        
        
        
    }
    
        
    
    else {
       
         
        
        
    }
}

/*


-(void)LoginToServer{
     NSLog(@"loginToServer");
    
         
     
     
    NSString *baseStringURL = @"http://readwithmeapp.com/api/v0/usertoken";
    
   
    
    NSString *apiKey = API_KEY;
    
    
    userName=userNameTextField.text;
    password=passwordTextField.text;
    
    NSDictionary * params= [[NSDictionary alloc] initWithObjectsAndKeys:userName, @"username", 
                            password, @"password", apiKey, @"apikey", nil];
    
     
    
    NSURL *url = [NSURL URLWithString:baseStringURL]; 
     
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [httpClient postPath:baseStringURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSString *text = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         
        
        NSError *myError = nil;
        
        if (res!=nil) {
            res=nil;
        }
         res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&myError];
        
        
     //   NSLog(@"JSON object includes: %@", res);
        
        NSString *accntType = [[res objectForKey:@"user"] objectForKey:@"accounttype"];
       // NSLog(@"accntType %@", accntType);
        
      //  NSString *userid=[[res objectForKey:@"user"] objectForKey:@"userid"];
       // NSLog(@"userid %@", userid);
        
       // NSString *firstname= [[res objectForKey:@"user"] objectForKey:@"firstname"];
       // NSLog(@"firstname %@", firstname);
        
       // NSString *lastname= [[res objectForKey:@"user"] objectForKey:@"lastname"];
       // NSLog(@"lastname %@", lastname);
        
      //  NSString *userFullName =[NSString stringWithFormat:@"%@ %@", firstname, lastname];
        
       // NSString *userTokenString = [res objectForKey:@"usertoken"];
      //  NSLog(@"userTokenSTring is= %@", userTokenString);

        
       //now we choose what screen to go next
        
        
        if ([accntType isEqualToString:@"teacher"]) {
            
            
            teacherDashboard=[self.storyboard instantiateViewControllerWithIdentifier:@"TeacherDashboard"];
           // teacherDashboard=[[RWMDashboardVC alloc] initWithNibName:nil bundle:nil];
            //take us to the teacher Dashboard
            [self.navigationController pushViewController:teacherDashboard animated:YES];
            
        } else if  ([accntType isEqualToString:@"student"]) {
            
            
            //take us to the student Home
         
        }

         
                 
        
        
    }  
                 
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      //  NSLog(@"%@", [error localizedDescription]);
                     
    }]; //back to the main thread?
    
   
    AFHTTPClient * httpClient = [AFHTTPClient clientWithBaseURL:url];
    
    NSMutableURLRequest *afRequest = [httpClient multipartFormRequestWithMethod:@"POST" path:baseStringURL parameters:params constructingBodyWithBlock:^(id <AFMultipartFormData>formData) 
                                      {
                                          
                                          [formData a
                                          
                                          [formData appendPartWithFileData:videodata name:@"uploadfile" fileName:aSessionID mimeType:@"video/quicktime"];
                                      }];
   
    
    NSMutableURLRequest *afRequest = [httpClient requestWithMethod:@"POST" path:baseStringURL parameters:params];
    
     
    
    AFHTTPRequestOperation  *anOpearation = [AFHTTPRequestOperation operationWithRequest:afRequest
                                                                              completion:^(NSURLRequest *req, NSHTTPURLResponse *response , NSData *data, NSError *error){
                                                                                  
                                                                                  
                                                                                  BOOL HTTPStatusCodeIsAcceptable = [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)] containsIndex:[response statusCode]];
                                                                                  
                                                                                  if (HTTPStatusCodeIsAcceptable) {
                                                                                      NSLog(@"Request Succesful");
                                                                                  } else {
                                                                                      NSLog(@"[Error]: (%@ %@) %@", [request HTTPMethod], [[request URL] relativePath], error);
                                                                                  }
                                                                              }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:afRequest];
    
    
    
    [operation setUploadProgressBlock:^(NSInteger bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite) 
     {
         
         NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
         
     }];
    
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {NSLog(@"Success");} 
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {NSLog(@"error: %@",  operation.responseString);}];
    [operation start];
    
    
    
   
    
   
     AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
     //NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"avatar.jpg"], 0.5);
     NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/uploadfile" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
     [formData appendPartWithFileData:videodata name:aSessionID fileName:afilePath mimeType:@"video/mov"];
     }];
     
     AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request] ;
     [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
     NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
     }];
     [operation start];
     
     
     
     
    
    
}
     */

- (IBAction)launchAVCam:(id)sender {
    
    
    canLaunchAVCam=NO;
     
    // Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachability  currentReachabilityStatus];
    if (netStatus == NotReachable) {
      //  NSLog(@"Not connected");
        
        UIAlertView *noConnectionAlert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Make sure you are connected to the internet before you continue" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [noConnectionAlert show];
        
    } else {
       // NSLog(@"Connected");
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    
        //now lets make an API call and check on our token...
        
        NSString *tokenToCheck=enterTokenField.text;
        
        
         //Make sure tokenToCheck is alphaNumeric
        
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"];
        
        set= [set invertedSet];
        
        NSRange r = [tokenToCheck rangeOfCharacterFromSet:set];
        if (r.location != NSNotFound) {
       //     NSLog(@"the string contains illegal characters");
            UIAlertView *alertNotValidchars =[[UIAlertView alloc] initWithTitle:@"Invalid Token" message:@"Token can only include numbers and letters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alertNotValidchars show];
            
        }else{
            
            [self submitToken:tokenToCheck];
 
        }
        
        
        
        
 
               
        
              
        
         }
    
}

 
 

-(void)submitToken:(NSString*)aToken{
    
    NSString *rwmGetContent= @"https://readwithmeapp.com/api/v0/activatesession/";
    
    //get the text in the field and concoctanate with rwm url
    NSString *tokenAndKey=[NSString stringWithFormat:@"%@?track=submittoken&apikey=%@",aToken, API_KEY];
    NSString *stringForURL = [rwmGetContent stringByAppendingString:tokenAndKey];
  // NSLog(@"url + token = %@", stringForURL);
    
    //call connectToURL with new url
    
    NSURL* theURL= [NSURL URLWithString:stringForURL];
    
    [self connectToUrl:theURL];
    
  //  NSLog(@"submit Token %@", theURL);
    
    
    
  //  NSLog(@"submitToken called");
     
}

#pragma mark Connection to URL

-(void)connectToUrl:(NSURL*)url {
    
    self.responseData = [NSMutableData data];
    
 
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLCacheStorageNotAllowed
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        self.responseData = [NSMutableData data];
        
        
    } else {
        // Inform the user that the connection failed.
      //  NSLog(@"Connection failed");
      //  NSLog(@"Connection failed");
        UIAlertView *noConnectionAlert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Make sure you are connected to the internet before you continue" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [noConnectionAlert show];
        
    }
    
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
   // NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  //  NSLog(@"didFailWithError");
   // NSString *errordesc= [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    if (isConnected){
        
        UIAlertView *noConnectionAlert = [[UIAlertView alloc] initWithTitle:@"Check Token" message:@"Make sure you entered the token correctly and try again" delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:nil, nil];
        
        [noConnectionAlert show];
    }
  //  NSLog(@"error is: %@", errordesc);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
   // NSLog(@"connectionDidFinishLoading");
  //  NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // setThe validToken Bool to YES
     
     NSError *myError = nil;
    res=nil;//empty it first.
    
    res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    
 //   NSLog(@"JSON object includes: %@", res);
    
    
    
    NSString *status=[res objectForKey:@"status"];
    
    if ([status isEqualToString:@"SESSION_NOT_FOUND"]) {
     //   NSLog(@"Status_NOT_FOUND");
        
        
        UIAlertView *noValidTokAlert=[[UIAlertView alloc]initWithTitle:@"Token Invalid" message:@"Please check your token and try again" delegate:self  cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [noValidTokAlert show];
        return;
        
    } else {
        
      //  NSLog(@"VALID ToKEN, LETS Launch!");
    //lets push this method to URL did finish with data...
    avcamVC= [self.storyboard instantiateViewControllerWithIdentifier:@"AVCAM"];
    
    [avcamVC setTheToken:enterTokenField.text];
    [avcamVC setTokenFromSegue:enterTokenField.text];
    [self.navigationController pushViewController:avcamVC animated:YES ];
    
    }
    
    
    
   
    
    
    
}



- (IBAction)launchOnlineDashboard:(id)sender {
    
    
    
    
    NetworkStatus netStatus = [reachability  currentReachabilityStatus];
    if (netStatus == NotReachable) {
     //   NSLog(@"Not connected");
        
        UIAlertView *noConnectionAlert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Make sure you are connected to the internet before you continue" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [noConnectionAlert show];
        
    } else {
       //  NSLog(@"Connected");
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        
        teacherDashboard= [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherDashboard"];
        
        [self.navigationController pushViewController:teacherDashboard animated:YES ];
        
       // teacherDashboard.navigationController.navigationBarHidden =YES;
       // [avcamVC setTheToken:enterTokenField.text];
        
        
    }
    
}

-(IBAction)loadWebVersion:(id)sender{
    
    
    //load the webversion
    /*
    
    //instatiate a new vc from storyboard if none exists
    if (teacherDashboard==nil) {
        NSLog(@" no dashboard so lets load");
       // UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
      teacherDashboard=  [self.storyboard instantiateViewControllerWithIdentifier:@"Dashboard"];
        
        
      //  teacherDashboard.delegate=self;
        teacherDashboard.isLoggedin=NO;
        
      // CGRect popOverRect= CGRectMake(0, 0, 780, 1000);
         
      //   _popverDashboard =[[UIPopoverController alloc] initWithContentViewController:teacherDashboard];
     //   [_popverDashboard presentPopoverFromRect:[self.launchAVCam bounds] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES  ];
        
               //  [ teacherDashboard.view setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+40, self.view.frame.size.width, self.view.frame.size.height)];
        
        [self.navigationController pushViewController:teacherDashboard animated:YES];
       // [self.view addSubview:teacherDashboard.view ];
        
        
    }  else {
        
        [self.navigationController pushViewController:teacherDashboard animated:YES];
      //  teacherDashboard.view.hidden=NO;
        NSLog(@" already loaded, so lets push");
      //  [_popverDashboard presentPopoverFromRect:[self.launchAVCam bounds] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES  ];
    }
    
    
    //if vc exists, show view
    
    //else load a new one and show it
    */
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://readwithmeapp.com/app"]];
}

-(void) dismissWebView{
    
    //dismiss the web view
   // NSLog(@"delegate Web View");
    teacherDashboard.view.hidden=YES;
    
    
}

-(IBAction)launchVideoAssessment:(id)sender withToken:(NSString*)aToken{
    
    
    
    
    
    
    
}
-(IBAction)loadSettings:(id)sender{
   // NSLog(@"laodSettings VC called");
    
    
    settingsVC=[self.storyboard instantiateViewControllerWithIdentifier:@"OfflineSettings"];
    
     [self.navigationController pushViewController:settingsVC animated:YES];
    
    
    
}

-(IBAction)submitLoginInfo:(id)sender{
    
  //  [self LoginToServer];
    
    
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    
   // [[self.navigationController navigationBar] setBarStyle:UIBArStyle];
   
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        
        NSLog(@"Do nothting to view, we are in ios 6");
        [self.view setFrame:CGRectMake(0, 0, 10, 10)    ];
    
    } else {
        
        
        NSLog(@"adjust the view for ios7");
    }

[super viewWillAppear:animated];
}


- (void)viewDidUnload
{
    
    enterTokenField=nil;
    [self setSetTokenBtn:nil];
    [self setUserNameTextField:nil];
    [self setPasswordTextField:nil];
    [self setLaunchAVCam:nil];
    [self setRes:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
     
}

@end
