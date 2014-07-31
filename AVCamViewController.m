/*
     File: AVCamViewController.m
 Abstract: A view controller that coordinates the transfer of information between the user interface and the capture manager.
  Version: 1.2
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2011 Apple Inc. All Rights Reserved.
 
 */

#import "AVCamViewController.h"
#import "AVCamCaptureManager.h"
#import "AVCamRecorder.h"
#import <AVFoundation/AVFoundation.h>
 
#import "RWMReportVCViewController.h"

 
 

static void *AVCamFocusModeObserverContext = &AVCamFocusModeObserverContext;

@interface AVCamViewController () <UIGestureRecognizerDelegate>
@end

@interface AVCamViewController ()
@property (nonatomic, strong) NSMutableData *responseData;
 

@end


@interface AVCamViewController (InternalMethods)
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates;
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer;
- (void)tapToContinouslyAutoFocus:(UIGestureRecognizer *)gestureRecognizer;
- (void)updateButtonStates;
@end

@interface AVCamViewController (AVCamCaptureManagerDelegate) <AVCamCaptureManagerDelegate>
@end

@implementation AVCamViewController

@synthesize recorderTextView;
@synthesize uploadVideoBtn;
@synthesize captureManager;
@synthesize cameraToggleButton;
@synthesize recordButton;
@synthesize stillButton;
@synthesize focusModeLabel;
@synthesize videoPreviewView;
@synthesize captureVideoPreviewLayer;
@synthesize tokenString;
@synthesize titleLabel;
@synthesize responseData;
@synthesize theToken;
@synthesize reportVC;
@synthesize res;

@synthesize plusTextSize;
@synthesize minusTextSizeBtn;
@synthesize showReportButton;
@synthesize notMeButton;
@synthesize studentNameLbl;
@synthesize helperOverlayImg;

BOOL isConnected;
//ADDED THE INIT WITH NIB NAMBE METHOD IN ORDER TO USE OPERATION QUEUE
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        operationQueue                             = [NSOperationQueue new];
        operationQueue.maxConcurrentOperationCount = 3;
    }
    return self;
}

- (NSString *)stringForFocusMode:(AVCaptureFocusMode)focusMode
{
	NSString *focusString = @"";
	
	switch (focusMode) {
		case AVCaptureFocusModeLocked:
			focusString = @"locked";
			break;
		case AVCaptureFocusModeAutoFocus:
			focusString = @"auto";
			break;
		case AVCaptureFocusModeContinuousAutoFocus:
			focusString = @"continuous";
			break;
	}
	
	return focusString;
}
/*
-(void)viewWillAppear:(BOOL)animated{
    
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        
        NSLog(@"Do nothting to view, we are in ios 6");
    } else {
        
        
        NSLog(@"adjust the view for ios7");
    }
    
    
}
*/
- (void)viewDidLoad


{
    
    
    helperOverlayImg.hidden=YES;
    
    
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    
    
    [reachability startNotifier];
    
    // Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachability  currentReachabilityStatus];
    if (netStatus == NotReachable) {
       // NSLog(@"Not connected");
        isConnected=NO;
        
        UIAlertView *noConnectionAlert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Make sure you are connected to the internet before you continue, or try the offline mode" delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:nil, nil];
        
        [noConnectionAlert show];
        
    } else {
        // NSLog(@"Connected");
        isConnected=YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    fontSize=DEFAULT_FONT_SIZE;
    
    
    recorderTextView.font =[UIFont fontWithName:@"Gill Sans" size:fontSize];
    
    
    
    [[self cameraToggleButton] setTitle:NSLocalizedString(@"Camera", @"Toggle camera button title")];
    [[self recordButton] setTitle:NSLocalizedString(@"Record", @"Toggle recording button record title")];
    [[self stillButton] setTitle:NSLocalizedString(@"Photo", @"Capture still image button title")];
    
    
    
	if ([self captureManager] == nil) {
        
       // NSLog(@"capture manager set to NIL");
		AVCamCaptureManager *manager = [[AVCamCaptureManager alloc] init];
		[self setCaptureManager:manager];
		//[manager release];
        
        
		
		[[self captureManager] setDelegate:self];
        
		if ([[self captureManager] setupSession]) {
            // Create video preview layer and add it to the UI
			AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[[self captureManager] session]];
			UIView *view = [self videoPreviewView];
			CALayer *viewLayer = [view layer];
			[viewLayer setMasksToBounds:YES];
			
			CGRect bounds = [view bounds];
			[newCaptureVideoPreviewLayer setFrame:bounds];
			
			//if ([newCaptureVideoPreviewLayer isOrientationSupported]) {
			//	[newCaptureVideoPreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
			//}
			
			[newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
			
			[viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
			
			[self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
            //  [newCaptureVideoPreviewLayer release];
			
            // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				[[[self captureManager] session] startRunning];
			});
			
            [self updateButtonStates];
          
		}		
	}
    
    
    
    cameraToggleButton.enabled=NO;
    cameraToggleButton.title=@"";
    
    
    isVideoViewHidden=NO;
    
    
    [super viewDidLoad];
    
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        
      //  NSLog(@"Do nothting to view, we are in ios 6");
    } else {
        [self.view setFrame:CGRectMake(self.view.bounds.origin.x, 120, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        
        self.navigationController.navigationBarHidden=NO;
        
      //  NSLog(@"adjust the view for ios7");
    }
    
    if (recordButton.enabled==NO) {
        
    
      [recordButton setEnabled:YES];
        
        }
    
}
- (void) reachabilityChanged:(NSNotification*) notification
{
	Reachability* reachability = notification.object;
    
	if(reachability.currentReachabilityStatus == NotReachable){
		//NSLog(@"Internet off");
    }
        else{
		//NSLog(@"Internet on");
            
        }
}

/*

-(IBAction)uploadVideo:(id)sender{
    
    
    
    //call another function to check the location of the outgoing video
        
    //upload data
    
    
    AsyncImageUploader *videoUploader =[[AsyncImageUploader alloc] initWithURL:urlToUpload progressView:uploadProgress1];
    
    
    [operationQueue addOperation:videoUploader];
    
}
 */

-(void) goToReportsScreenWithSessionID:(NSString*)sessionID{
    
     
    
    reportVC.aSessionID=sessionID;
    
         
}

-(IBAction)goToReports:(id)sender withSessionID: (NSString*)sessionID{
    
    
    reportVC.aSessionID=sessionID;
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender


{
   
    //[self getUserInfo];
        
    
    if ([segue.identifier isEqualToString:@"Report"]) {
        
        
        if (recordingStarted==YES) {
            UIAlertView *youAreStillRecordingAlert=[[UIAlertView alloc] initWithTitle:@"You are still recording" message:@"stop recording before continuing" delegate:self cancelButtonTitle:@"Stop" otherButtonTitles:nil];
            
            [youAreStillRecordingAlert show];
            
        }
        
        else {
             
           
        
        [segue.destinationViewController setASessionID:theToken];
        [segue.destinationViewController setLastRecordingURL:urlToUpload];
        [segue.destinationViewController setAfilePath:filePathToforVid];
        
        
        //Here we add all the report info:
         
        [segue.destinationViewController setAssessmentText:aContent];
            
            [recordButton setEnabled:NO];
            
            
           // recorderTextView.text=@"This assessment is finished.;
                           
        
            
            }
        
    }   else {
        
        
        
        
    }
}
 /*
-(void) getUserInfo {
    
    
    //need to run [self connectToUrl: and give the url for getting user info: 
    
    NSString *baseURL = [NSString stringWithFormat:@"https://readwithmeapp.com/api/v0/assessment/%@", theToken];
    
    NSString *urlWithKey = [baseURL stringByAppendingString:API_KEY];
    
     
    
    NSURL *userInfoURL = [NSURL URLWithString:urlWithKey];
    
    [self connectToUrl:userInfoURL];
    
    //get the response data from res
    
     
    
    //now query name of this person...
    
    
    
    
    
}
  
  */
          

-(void) showEndAlert{
    
    //if still recording...
   
    {
        
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stop?" message:nil delegate:self cancelButtonTitle:@"No, Try again" otherButtonTitles:@"See Report"  , nil];
    [alert show];
    
    }
    //if test is graded, then show this
    //first condition : you finished? No Yes. 
    
    
    //second condition : your test has not been scored. 
    //if wait, then it runs a timeout loop and launches the REport View when status returns OK or corrected. 
    //do this with blocks?
    
    
    /*
    if ([[res objectForKey:@"assessment"] objectForKey:@"reviewed"] !=nil)  {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Finished?" message:nil delegate:self cancelButtonTitle:@"No, Try again" otherButtonTitles:@"See Report"  , nil];
        [alert show];
        sessionHasBeenEvaluated=YES;
    
    
    } else { //report has not been scored
        
        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"No report. Continue?" message:@"Your reading has not been score" delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:@"Continue"  , nil];
        [alert2 show];
        sessionHasBeenEvaluated=NO;
        
    }
     
     */
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"No, Try again"] || [title isEqualToString:@"Try again"])
    {
        
        //now its dismissed
    }
    else if([title isEqualToString:@"Yes"])
    {
        
        //lets launch it
      //  [self goToReportsScreenWithSessionID:theToken];
        [self performSegueWithIdentifier:@"Report" sender:self];
        
    } else if ([title isEqualToString:@"Continue"] || [title isEqualToString:@"See Report"] ){
        
        [self performSegueWithIdentifier:@"Report" sender:nil];
        
        
        
        
        
        
    }
    else if([title isEqualToString:@""])
    {
         
    } else if ([title isEqualToString:@"Go Back"]){
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
    
}

 /*
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"captureManager.videoInput.device.focusMode"];
	[captureManager release];
    [videoPreviewView release];
	[captureVideoPreviewLayer release];
    [cameraToggleButton release];
    [recordButton release];
    [stillButton release];	
	[focusModeLabel release];
	
    [super dealloc];
}
 */




-(void)setTokenFromSegue:(NSString*)aToken{
    
    
    
    NSString *rwmGetContent= @"https://readwithmeapp.com/api/v0/activatesession/";
    
    //get the text in the field and concoctanate with rwm url
    
    NSString*key=[NSString stringWithFormat:@"%@?apikey=%@&track=videotoken&v=3", aToken, API_KEY];
    
    NSString *stringForURL = [rwmGetContent stringByAppendingString:key];
    
    
    //call connectToURL with new url
    
    NSURL* theURL= [NSURL URLWithString:stringForURL];
    
    [self connectToUrl:theURL];
    
  //  NSLog(@"SET TOKEN from SEGUE: %@", theURL);
     
    theToken=aToken;

 


}


#pragma mark Connection to URL

-(void)connectToUrl:(NSURL*)url {
    
    self.responseData = [NSMutableData data];
    
    textFinishedLoading=NO;
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
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
       // NSLog(@"Connection failed");
      //  NSLog(@"Connection failed");
        UIAlertView *noConnectionAlert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Make sure you are connected to the internet before you continue" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [noConnectionAlert show];
    
    }
    
   
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [self.responseData setLength:0];
    
     
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {        
    [self.responseData appendData:data]; 
    //makes sure we start with REAR CAMera
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {    
     
  //  NSString *errordesc= [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    if (isConnected){
    
    UIAlertView *noConnectionAlert = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"Make sure you entered the token correctly and try again" delegate:self cancelButtonTitle:@"Go Back" otherButtonTitles:nil, nil];
    
    [noConnectionAlert show];
    }
     }

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    // convert to JSON
    NSError *myError = nil;
    
    
    res=nil;//empty it first. 
    
    res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
   // NSLog(@"res has : %@", res)  ;
    
    NSString *content=[res objectForKey:@"content"];
    
    aContent=content;
    
    NSString *title= [res objectForKey:@"title"];
    aTitle=title;
    
    [self setTextAndTitle:content andTitle:title];
    
    NSString *nameOfKid=[[res objectForKey:@"user"] objectForKey:@"name"];
    studentNameLbl.text= [NSString stringWithFormat:@"  Welcome, %@ ", nameOfKid];
    
    
   
}


-(IBAction)wrongName:(id)sender{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

-(IBAction)hideScreen:(id)sender{
    //when user touches the screen view, it will hide the underlying view, which contains the video display. 
    
    if (isVideoViewHidden==NO) {
     
    videoPreviewView.hidden=YES;
    isVideoViewHidden=YES;
    
    } else {
        videoPreviewView.hidden=NO;
        isVideoViewHidden=NO;
    }
    
    
}
    

-(void) setTextAndTitle:(NSString*) theContent andTitle:(NSString*)theTitle{
    
    titleLabel.text=theTitle;
    recorderTextView.text=theContent;
    
    
    if ([theContent isEqualToString:recorderTextView.text]) {
         textFinishedLoading=YES;
    }
    
    
    
    
}

-(BOOL) isTextFinished{
    
    if (textFinishedLoading==NO) {
        return NO;
         
        
    } else {
        [[self captureManager] toggleCamera];//yes, so lets start it. 
       
        return YES;
    }
    
    
}

 
 
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == AVCamFocusModeObserverContext) {
        // Update the focus UI overlay string when the focus mode changes
		[focusModeLabel setText:[NSString stringWithFormat:@"focus: %@", [self stringForFocusMode:(AVCaptureFocusMode)[[change objectForKey:NSKeyValueChangeNewKey] integerValue]]]];
	} else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Toolbar Actions
- (IBAction)toggleCamera:(id)sender
{
    // Toggle between cameras when there is more than one
    [[self captureManager] toggleCamera];
    
    // Do an initial focus
    [[self captureManager] continuousFocusAtPoint:CGPointMake(.5f, .5f)];
}

- (IBAction)toggleRecording:(id)sender
{
    // Start recording if there isn't a recording running. Stop recording if there is.
    [[self recordButton] setEnabled:NO];
    if (![[[self captureManager] recorder] isRecording]){
        [[self captureManager] startRecording];
    recordingStarted=YES;
        
        //change the image to stop
        
         
        recordButton.image=[UIImage imageNamed:@"button-stop.png"];
         recordButton.tintColor=[UIColor blueColor];
        showReportButton.enabled=NO;
        self.toolBar.tintColor=[UIColor redColor];
        
        UIImage *recImage=[UIImage imageNamed:@"Drawing 41.png"];
        [ showReportButton setBackgroundImage:recImage forState:UIControlStateDisabled];
        [showReportButton setTitle:@"Recording" forState:UIControlStateDisabled];
        
        
    }
    else{
        [[self captureManager] stopRecording];
            
        recordingStarted=NO;
        recordButton.image=[UIImage imageNamed:@"button-record.png"];
        recordButton.tintColor=[UIColor grayColor];
        showReportButton.enabled=YES;
        self.toolBar.tintColor=[UIColor grayColor];
        
        
   //     [self showEndAlert];
            
        }
}

- (IBAction)captureStillImage:(id)sender
{
    // Capture a still image
    [[self stillButton] setEnabled:NO];
    [[self captureManager] captureStillImage];
    
    // Flash the screen white and fade it out to give UI feedback that a still image was taken
    UIView *flashView = [[UIView alloc] initWithFrame:[[self videoPreviewView] frame]];
    [flashView setBackgroundColor:[UIColor whiteColor]];
    [[[self view] window] addSubview:flashView];
    
    [UIView animateWithDuration:.4f
                     animations:^{
                         [flashView setAlpha:0.f];
                     }
                     completion:^(BOOL finished){
                        // [flashView removeFromSuperview];
                        // [flashView release];
                     }
     ];
}

#pragma mark font size

-(IBAction)increaseTextSize:(id)sender{
    
    int currentFontSize =fontSize;
    
    int newSize = currentFontSize+1;
    
    if (fontSize<=MAX_FONT_SIZE) {
        
        recorderTextView.font =[UIFont fontWithName:@"Gill Sans" size:newSize];
        
        fontSize=newSize;
    }
    
    
    
    
}
-(IBAction)decreaseTextSize:(id)sender{
    int currentFontSize =fontSize;
    
    int newSize = currentFontSize-1;
    
    if (fontSize>=MIN_FONT_SIZE) {
        
        recorderTextView.font =[UIFont fontWithName:@"Gill Sans" size:newSize];
        fontSize=newSize;
    }
    
    
}

- (IBAction)showHelp:(id)sender {
    
    
    if (helperOverlayImg.hidden==YES) {
        helperOverlayImg.hidden=NO;
    } else
    helperOverlayImg.hidden=YES;
    
    
}


- (void)viewDidUnload {
    [self setRecorderTextView:nil];
    [self setUploadVideoBtn:nil];
    [self setNotMeButton:nil];
    [self setStudentNameLbl:nil];
    [self setHelperOverlayImg:nil];
    [super viewDidUnload];
}
@end

@implementation AVCamViewController (InternalMethods)

// Convert from view coordinates to camera coordinates, where {0,0} represents the top left of the picture area, and {1,1} represents
// the bottom right in landscape mode with the home button on the right.
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates 
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = [[self videoPreviewView] frame].size;
    
    if ([captureVideoPreviewLayer isMirrored]) {
        viewCoordinates.x = frameSize.width - viewCoordinates.x;
    }    

    if ( [[captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize] ) {
		// Scale, switch x and y, and reverse x
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for (AVCaptureInputPort *port in [[[self captureManager] videoInput] ports]) {
            if ([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;

                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if ( [[captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect] ) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
						// If point is inside letterboxed area, do coordinate conversion; otherwise, don't change the default value returned (.5,.5)
                        if (point.x >= blackBar && point.x <= blackBar + x2) {
							// Scale (accounting for the letterboxing on the left and right of the video preview), switch x and y, and reverse x
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
						// If point is inside letterboxed area, do coordinate conversion. Otherwise, don't change the default value returned (.5,.5)
                        if (point.y >= blackBar && point.y <= blackBar + y2) {
							// Scale (accounting for the letterboxing on the top and bottom of the video preview), switch x and y, and reverse x
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if ([[captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
					// Scale, switch x and y, and reverse x
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2; // Account for cropped height
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2); // Account for cropped width
                        xc = point.y / frameSize.height;
                    }
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}

// Auto focus at a particular point. The focus mode will change to locked once the auto focus happens.
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[[captureManager videoInput] device] isFocusPointOfInterestSupported]) {
        CGPoint tapPoint = [gestureRecognizer locationInView:[self videoPreviewView]];
        CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:tapPoint];
        [captureManager autoFocusAtPoint:convertedFocusPoint];
    }
}

// Change to continuous auto focus. The camera will constantly focus at the point choosen.
- (void)tapToContinouslyAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[[captureManager videoInput] device] isFocusPointOfInterestSupported])
        [captureManager continuousFocusAtPoint:CGPointMake(.5f, .5f)];
}

// Update button states based on the number of available cameras and mics
- (void)updateButtonStates
{
	NSUInteger cameraCount = [[self captureManager] cameraCount];
	NSUInteger micCount = [[self captureManager] micCount];
    
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        if (cameraCount < 2) {
            [[self cameraToggleButton] setEnabled:NO]; 
            
            if (cameraCount < 1) {
                [[self stillButton] setEnabled:NO];
                
                if (micCount < 1)
                    [[self recordButton] setEnabled:NO];
                else
                    [[self recordButton] setEnabled:YES];
            } else {
                [[self stillButton] setEnabled:YES];
                [[self recordButton] setEnabled:YES];
            }
        } else {
            [[self cameraToggleButton] setEnabled:YES];
            [[self stillButton] setEnabled:YES];
            [[self recordButton] setEnabled:YES];
        }
    });
}

@end

@implementation AVCamViewController (AVCamCaptureManagerDelegate)

- (void)captureManager:(AVCamCaptureManager *)captureManager didFailWithError:(NSError *)error
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                            message:[error localizedFailureReason]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                                                  otherButtonTitles:nil];
        [alertView show];
        //[alertView release];
    });
}

- (void)captureManagerRecordingBegan:(AVCamCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        [[self recordButton] setTitle:NSLocalizedString(@"Stop", @"Toggle recording button stop title")];
        [[self recordButton] setEnabled:YES];
    });
}

- (void)captureManagerRecordingFinished:(AVCamCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        [[self recordButton] setTitle:NSLocalizedString(@"Record", @"Toggle recording button record title")];
        [[self recordButton] setEnabled:YES];
    });
}

- (void)captureManagerStillImageCaptured:(AVCamCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        [[self stillButton] setEnabled:YES];
    });
}

- (void)captureManagerDeviceConfigurationChanged:(AVCamCaptureManager *)captureManager
{
	[self updateButtonStates];
}
-(void) captureManagerRecordingDidFinish:(AVCamCaptureManager*) captureManager withURL:(NSURL*)url andFilePath:(NSString*)filepth {
    
    //This delegate Method will be used to store the URL of the video we are saving....
    
    //IT will set a Declared URL as this URL, 
    
     
   // NSLog(@"filepth: %@", filepth);
    filePathToforVid=filepth;
    urlToUpload=url;
    
    
}

@end
