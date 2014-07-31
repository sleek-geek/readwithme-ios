//
//  RWMReportVCViewController.m
//  RWMStudent
//
//  Created by Francisco Salazar on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RWMReportVCViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "RJGoogleTTS.h"

 
@interface RWMReportVCViewController ()
@property (nonatomic, strong) NSMutableData *responseData;


@end

@implementation RWMReportVCViewController
@synthesize studentNameLabel;
@synthesize dateLabel;
@synthesize feedbackReadingLbl;
@synthesize feedbackBenchmarkLbl;
@synthesize statusImageView;
@synthesize wpmLabel;
@synthesize numberErrorsLbl;
@synthesize cwpmLbl;
@synthesize accuracyLbl;
@synthesize passageTitleLbl;
@synthesize passageTextLbl;
@synthesize aSessionID;
@synthesize lastRecordingURL;
@synthesize errorBoxTextView;
@synthesize afilePath;
@synthesize moviePlayer;
 @synthesize assessmentText;
@synthesize studentName;
@synthesize reportWebView;
@synthesize jsonDataDict;
@synthesize responseData;
@synthesize  responseDataDict;
@synthesize videoView;
@synthesize downloadedData;
@synthesize rJGoogleTTS;
@synthesize shareButton;
@synthesize uploadButton;
@synthesize dismissVidButton;
@synthesize playMovieBtn;
@synthesize playaVidButton2;
@synthesize pauseVidButton;
@synthesize progressView;

BOOL isUploading=NO;
BOOL isPlaying=NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
      // NSString *baseStringURL = @"https://readwithmeapp.com/api/v0/assessment/";
        
        
        
        
     //   NSString *tokenAndKey = [baseStringURL stringByAppendingString:(@"@%?apikey=%@&extras=html&track=viewreport&v=3",aSessionID, API_KEY)];
        
        
        
        
      //  NSString *baseStringWithSessionID=[baseStringURL stringByAppendingString:aSessionID];
        
     //   NSString *apiKey = API_KEY;
        
      //  NSString *urlWithKey = [baseStringWithSessionID stringByAppendingString:apiKey];
    //    NSString *urlWithKeyAndHtml = [urlWithKey stringByAppendingString:@"&extras=html"];
        
         
        
       // NSURL *url = [NSURL URLWithString:tokenAndKey];//I added this
        
     //   NSLog(@"Report: URL: %@", url);
     //   [self connectToUrl:url];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    
     
    isAssessmentGraded=NO;
    
        
    studentNameLabel.text=studentName; 
     
    passageTextLbl.text=assessmentText; 
    
  

}

- (void)viewDidLoad
{
    progressView.hidden=YES;
   feedbackBenchmarkLbl.hidden=YES;
       
    uploadButton.hidden=YES;
    
    if (afilePath==nil) {
        uploadButton.hidden=YES;
        playMovieBtn.hidden=YES;
        
    }
    
    //Lets clear all the values from the labels:
    
     wpmLabel.text=@"--";
    cwpmLbl.text=@"--";
    passageTextLbl.hidden=YES;
    
    
    numberErrorsLbl.text=@"--";
    
    accuracyLbl.text=@"--";
    
    NSString *baseStringURL = @"https://readwithmeapp.com/api/v0/assessment/";
    
    //NSString *token=aSessionID;
    
    
    
    NSString *baseStringWithSessionID=[baseStringURL stringByAppendingString:aSessionID];
    
   // NSString *apiKey = API_KEY;
    
    
    NSString *urlWithAPI=[NSString stringWithFormat:@"%@?apikey=%@",baseStringWithSessionID, API_KEY   ];
    
    
    
    NSString *urlWithKeyAndHtml = [urlWithAPI stringByAppendingString:@"&extras=html&track=viewreport&v=3"];
    
     
    
    
    NSURL *url = [NSURL URLWithString:urlWithKeyAndHtml];//I added this
    [self connectToUrl:url];
    
    
  //  NSLog(@"Report url: %@", url);
    
        //make a url and send it to the connect to url method
    
  
 
    
    [super viewDidLoad];
    
   // NSLog(@"view did load finished");
	// Do any additional setup after loading the view.
}

-(void)connectToUrl:(NSURL*)url {
    
    self.responseData = [NSMutableData data];
    
    
    
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
    }
    
    //now lets start another one to handle the email share function...
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
     
    [self.responseData setLength:0];
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {        
    [self.responseData appendData:data]; 
    //makes sure we start with REAR CAMera
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {    
    
    NSString *errordesc= [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    
    UIAlertView *connectErrorAlert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:errordesc delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [connectErrorAlert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    // convert to JSON
    NSError *myError = nil;
    
    
    
    isAssessmentGraded=YES;
    //show the share and upload button:
   // if ([[NSUserDefaults standardUserDefaults] boolForKey:@"WantsStudentsToSendEmail"] == NO) {
         
    
        shareButton.hidden=YES;
        
        int origin=uploadButton.frame.origin.x;
        
        uploadButton.center=CGPointMake(origin-200, uploadButton.frame.origin.y+50);
        
      //  }
    uploadButton.hidden=NO;
    
    
  responseDataDict = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
  
    
    
    //get user info, then get name. 
    
    
    
    //The following info is displayed regardless if the assessment has been scored. 
    
    NSString *name=[[[responseDataDict objectForKey:@"assessment"] objectForKey:@"user"] objectForKey:@"name"];
    
         
    NSString *title= [[[responseDataDict objectForKey:@"assessment"] objectForKey:@"passage"] objectForKey:@"title"];
     
    NSString *dateString= [[[responseDataDict objectForKey:@"assessment"] objectForKey:@"submitted"] objectForKey:@"time"];
    
    NSTimeInterval intervalDate =[dateString  doubleValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:intervalDate];
    
     
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *dateToDisplay=[formatter stringFromDate:date];
    
    
    
    
     
    studentNameLabel.text=name;
    
    passageTitleLbl.text=title;
    
    
    
    
    
    
    dateLabel.text= dateToDisplay;
    
   
    
    
    //if the response data exists, the assessment has been reviewd and we can populate labels
    if ([[responseDataDict objectForKey:@"assessment"] objectForKey:@"reviewed"] !=nil)  {
        
         
        
        //Words Read
        
        NSString * wordsReadString =[[[responseDataDict objectForKey:@"assessment"] objectForKey:@"summary"] objectForKey:@"wordsread"];
        
         
        
        //this is tricky, wpm is words read, actually.
        wpmLabel.text= [NSString stringWithFormat:@"%@", wordsReadString]; //What is wrong?
        double wordsReadDbl = [wordsReadString doubleValue];
        
        //data required for email:
        assessedByString=[[[responseDataDict objectForKey:@"assessment"]objectForKey:@"reviewed"]objectForKey:@"name"];
        
        //Errors
        
        NSArray *errorsArray = [[responseDataDict objectForKey:@"assessment"] objectForKey:@"errors"];
        
        
        NSString * errorsString =[[[responseDataDict objectForKey:@"assessment"] objectForKey:@"summary"] objectForKey:@"errors"];
        
         
        
         numberErrorsLbl.text= [NSString stringWithFormat:@"%@", errorsString]; //this needs no formatting
        double errorsMadeDbl = [errorsString doubleValue];
        
        //Time taken
        
        NSString *timeTakenString = [[[responseDataDict objectForKey:@"assessment"] objectForKey:@"summary"] objectForKey:@"timetaken"];
        
         
        double timeTakenDbl = [timeTakenString doubleValue];
        
        
        
        

      double wordsReadCorretlyDouble = (wordsReadDbl-errorsMadeDbl);
        
        //accuracy is more complicated...
        
        
       double wordsPerMinRead = (wordsReadCorretlyDouble / timeTakenDbl)*60;
        
        
        cwpmLbl.text= [NSString stringWithFormat:@"%.0lf", wordsPerMinRead];
        
        
        
        double accuracyDouble =( wordsReadCorretlyDouble /wordsReadDbl )*100;
        
       accuracyLbl.text=[NSString stringWithFormat:@"%.0lf ", accuracyDouble];
        
        
        //Feedback message needs to run from a smarter array
        
        NSString *readingLevelString = [[[responseDataDict objectForKey:@"assessment"] objectForKey:@"benchmark"] objectForKey:@"level"];
        
        NSNumber *wpm  = [[[responseDataDict objectForKey:@"assessment"] objectForKey:@"benchmark"] objectForKey:@"wpm"];
         
        
        if ([readingLevelString isEqualToString:@"independent"] && wordsPerMinRead>=[wpm doubleValue] ) {
            
            feedbackReadingLbl.text= @"Great Job! You passed benchmark!";
            
            
        } else if ([readingLevelString isEqualToString:@"independent"] && wordsPerMinRead<[wpm doubleValue] ){
            
            
            feedbackReadingLbl.text= @"Wow, you did pretty well. Just practice a bit more.";
            
            
        } else if ([readingLevelString isEqualToString:@"instructional"] && wordsPerMinRead>=[wpm doubleValue] ){
            
            feedbackReadingLbl.text= @"Nice work! This is a good level for you.";
            
            
        } else if ([readingLevelString isEqualToString:@"instructional"] && wordsPerMinRead<[wpm doubleValue] ){
            
            feedbackReadingLbl.text= @"That wasn't so bad, You should probably try an easier passage.";
            
            
        } else if ([readingLevelString isEqualToString:@"frustration"] && wordsPerMinRead>=[wpm doubleValue]  )  {
            
            
            feedbackReadingLbl.text= @"Slow down! you are making a lot of mistakes.";
            
        }  else if ([readingLevelString isEqualToString:@"frustration"] && wordsPerMinRead<[wpm doubleValue]  )  {
            
            
            feedbackReadingLbl.text= @"Sorry, this reading level is too hard for you.";
        }
        
        
        
        
        
        
        
        NSString *htmlStringFromJsonObject = [[responseDataDict objectForKey:@"assessment"] objectForKey:@"html"];
                
        
        NSString * largeTextStringBeginning = [NSString stringWithFormat:@"<h2>%@", htmlStringFromJsonObject];
        
        
        
        NSString *largeTextStringComplete = [largeTextStringBeginning stringByAppendingString:@"</h2>"];
        
        //NSString *myHTML = @"<html><body><strike>This is what should be loaded into the web view!</strike></body></html>";
        [reportWebView loadHTMLString:largeTextStringComplete baseURL:nil];
        
        
      //  NSLog(@"loading HTML %@ >>>> ", largeTextStringComplete );
        
      //  [reportWebView  stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '150%' "];        
    
    
        //make 
        NSMutableArray * errorArray=[[NSMutableArray alloc] init];
      //   NSString *errorStringWithSpaces=@"";
        
        stringForBox=@"";
        
        
        NSString *theError= @"";
        
       // int i= 0;
        
        for (NSDictionary *dict in errorsArray)    {
            
         //    
            theError= [dict objectForKey:@"word"];
            
            
            
            if ([errorArray containsObject:theError]==NO) {
                
                [errorArray addObject:theError];
                
                
                
                
            }
            
            
               
            }
            
              
    for (NSString *anError in errorArray) {
        
        stringForBox = [NSString stringWithFormat:@"%@        %@", stringForBox, anError];      
        //stringForBox= [NSString stringWithFormat:@"%@          %@"     ,errorBoxTextView.text,  anError  ] ;
        
        
         
            
        }
              
       
        
        errorBoxTextView.text=stringForBox;
        
    } else {
        //this has not been reviewed:
        
        //load the text into the UITEXTVIEW and hide the webView
        reportWebView.hidden=YES;
        passageTextLbl.hidden=NO;
        passageTextLbl.text=assessmentText;
        uploadButton.enabled=NO;
        shareButton.enabled=NO;
        NSDate *date = [NSDate date];
        
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        
        NSString *dateToDisplay=[formatter stringFromDate:date];
        
        dateLabel.text=dateToDisplay;
        feedbackReadingLbl.text=@"This passage has not been scored";
        feedbackReadingLbl.textColor=[UIColor redColor];
        uploadButton.hidden=YES;
        shareButton.hidden=YES; //hide both buttons, we don't need them now. 
        feedbackBenchmarkLbl.text=@"";
        
        
    }
    
    
    
    
    

}



-(void) setText:(NSString*) theContent andResults:(NSDictionary*)theResults{
    
     
    
    
    
}

#pragma  mark speech
-(IBAction)readToMe:(id)sender{
    
    
    [self speakPassageWithString:assessmentText];
    
}
-(void) speakPassageWithString:(NSString *) aString{
    
    
  /*
    NSString *urlString = [NSString stringWithFormat:@"http://www.translate.google.com/translate_tts?t1=en&q=%@",  aString];
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString* userAgent = @"Mozilla/5.0";
    
    [urlRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSURLResponse *response = nil;
    
    NSError *anError = nil;
    
    NSData *data= [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&anError];
    
 */
    
    

rJGoogleTTS =[[RJGoogleTTS alloc] initWithString:assessmentText];

rJGoogleTTS.delegate=self;
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    //here we delete the video if the user does not want to save it to device. We should warn the user that it is about to happen.
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"WantsToSaveVideo"] == NO) {
        
        
        //lets remove the video
        NSString *path=afilePath;
        
        
        
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        
        NSString *filepathToDelete = [documentsDirectory stringByAppendingPathComponent:path];
        
       // NSError *error;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filepathToDelete])		//Does file exist?
        {
           // NSLog(@" Will be Removing file: %@ are you sure???", filepathToDelete);

            /*NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:filepathToDelete error:&error];
                        if (![[NSFileManager defaultManager] removeItemAtPath:filepathToDelete error:&error])	//Delete it
            {
                NSLog(@"Delete file error: %@", error);
            } 
             */
             
        }
        
        
        
        
        
        
        
      //  NSLog(@"ViewDidDissapper will delete video from file");
        
    }else{
         //do nothing
        
      //  NSLog(@"WE are NOT deleting the video");
    }
    
    
   // [self.navigationController popToRootViewControllerAnimated:YES];
    
}
 
#pragma mark delegate
- (void)receivedAudio:(NSMutableData *)data{
   // NSLog(@"delegate received data");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docsDir = [paths objectAtIndex:0];
    
    NSString *aPath = [docsDir stringByAppendingPathComponent:@"speech.mp3"];
    [data writeToFile:aPath atomically:YES];
    
    
    AVAudioPlayer *player;
    
    NSError *err;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:aPath]){
      //  NSLog(@"sound file path is%@", aPath);
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:aPath] error:&err];
        
        [player setVolume:0.40f];
        
        [player prepareToPlay];
        
        [player setNumberOfLoops:1];
        
        [player play];
    }

    
}
- (void)sentAudioRequest{
   // NSLog(@"sent Audio Request");


}
-(NSString*)shareAssessmentlink:(NSString *)anAPIcall{
    
    NSString *theLink;
    
    
    
    return theLink ;
}
/*
-(IBAction)shareReading:(id)sender{
    
#warning Need to Fix This
    
    NSString *sessionID=aSessionID;
   //NSString *senderName=assessedByString ;
    NSString *childName=studentNameLabel.text;
    NSString *cwpmString=cwpmLbl.text;
    
    NSString *accuracyString=accuracyLbl.text;
    NSString*aLinkString=[NSString stringWithFormat:@"http://readwithmeapp.com/api/v0/assessment/%@/link?apikey=c40b0c360f3d4959b53b103b25759542/", sessionID];
    
    NSString*okString=[self shareAssessmentlink:aLinkString];
    
    NSString *theMessage=[NSString  stringWithFormat:@"Hi, <br> This is %@. I just wanted to share my reading progress with you. I just took a reading assessment and here are the results:<ul> <li>Correct Words Per Minute: %@ </li><li>With an accuracy of: %@</li></ul> <br>  <a href=\"%@\">Click here if you want to see more!</a> <p>Bye!<p>%@",  childName,cwpmString,  accuracyString,okString, childName  ];
    
    
     NSString *theMessage=[NSString  stringWithFormat:@"Hello there,<br> This is %@. I'd like to inform you that Your child, %@ recently took a reading assessment to measure their fluency. <p> Here are the results:<ul> <li>Correct Words Per Minute:%@ </li><li>With an accuracy of:%@</li></ul> <br>  <a href=\"http://readwithmeapp.com/api/v0/assessment/%@/link?apikey=c40b0c360f3d4959b53b103b25759542/\">Click here to review this assessment in more detail</a>", senderName,childName,cwpmString,accuracyString,sessionID ]; 
    
    
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:[NSString stringWithFormat:@"Reading Assessment for %@", childName ]];
    [controller setMessageBody:theMessage isHTML:YES];
    
    if (controller) [self presentModalViewController:controller animated:YES];
    
    
    
}
*/

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
         
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)uploadToServer:(id)sender{
    
    
    isUploading=YES;
    uploadButton.enabled=NO;
    progressView.hidden=NO;
     
    NSString *fileAt =  afilePath;
    
    //  NSURL    *fileURL    =   [NSURL fileURLWithPath:fileAt];
    
    //  NSString *stringForURL = @"http://youtu.be/cFokLAhqaWQ";
    
    //  NSURL *youTubeURL = [NSURL URLWithString:stringForURL];
    
    // NSLog(@"fileURL reads: %@", fileURL);
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    NSString *filepath = [documentsDirectory stringByAppendingPathComponent:fileAt];
     
    
    NSURL *urlWithString = [NSURL fileURLWithPath:filepath];
    
    NSData *videodata = [NSData dataWithContentsOfURL:urlWithString];
    
    
    NSString *baseStringURL = @"https://readwithmeapp.com/api/v0/audioupload/";
    
    
    
    NSString *tokenAndKey=[NSString stringWithFormat:@"%@%@?apikey=%@&extras=html&track=uploadVid&v=3", baseStringURL, aSessionID, API_KEY];
    
    
    
    //NSString *baseStringWithSessionID=[baseStringURL stringByAppendingString:aSessionID];
    
  //  NSString *apiKey = API_KEY;
    
  //  NSString *serverURLForUploadWithKey = [baseStringWithSessionID stringByAppendingString:apiKey];
     //NSLog(@"the file will upload to url : %@", serverURLForUploadWithKey);
    
    
    NSURL *url = [NSURL URLWithString:tokenAndKey];//I added this
   //  NSLog(@"the NSURL upload to url : %@", url);
    
    
    
   AFHTTPClient * httpClient = [AFHTTPClient clientWithBaseURL:url];
    
    NSMutableURLRequest *afRequest = [httpClient multipartFormRequestWithMethod:@"POST" path:tokenAndKey parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData>formData) 
                                      {
                                          [formData appendPartWithFileData:videodata name:@"uploadfile" fileName:aSessionID mimeType:@".mp4"];
                                      }];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:afRequest];
    
    
    //lets try the NSINTEGER instead of long long
    [operation setUploadProgressBlock:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         
      //   NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
         
         float progress = totalBytesWritten / (float) totalBytesExpectedToWrite;
         [progressView setProgress:progress];
         
     }];
    
    [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {NSLog(@"Success");
    
        progressView.hidden=YES;
    
    
    
    }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {NSLog(@"error: %@",  operation.responseString);
                                      
                                      
                                          progressView.hidden=YES;
                                      
                                      
                                      }
     
     
     
     
     ];
    [operation start];
    
   // 
    
    
    
    /*
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
    
    
    
    */

    
}


-(IBAction)playMovie:(id)sender //need to add a check to see if one exists. 
{
   // NSLog(@"Play movie");
    
    isPlaying=YES;
    
    if (afilePath!=nil) {
         
    
    
    videoView.hidden=NO;
    
        NSString *fileAt =  afilePath;
   // NSLog(@"fileat reads: %@", fileAt);
 //  NSURL    *fileURL    =   [NSURL fileURLWithPath:fileAt];
    
  //  NSString *stringForURL = @"http://youtu.be/cFokLAhqaWQ";
    
  //  NSURL *youTubeURL = [NSURL URLWithString:stringForURL];
    
   // NSLog(@"fileURL reads: %@", fileURL);
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    NSString *filepath = [documentsDirectory stringByAppendingPathComponent:fileAt];
  //  NSLog(@"file path %@", filepath);
    
    NSURL *urlWithString = [NSURL fileURLWithPath:filepath];
    
   /* ALAssetsLibrary *assetLib =[[ALAssetsLibrary alloc] init];
   // [assetLib assetForURL:lastRecordingURL resultBlock:<#^(ALAsset *asset)resultBlock#> failureBlock:
    //<#^(NSError *error)failureBlock#>
    // 
    //NSURL    *fileURL    =    lastRecordingURL; 
    */
    
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:urlWithString];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
    
    
   // moviePlayerController.controlStyle = MPMovieControlStyleDefault;
    moviePlayer.shouldAutoplay = NO;
    
     [moviePlayer.view setFrame:CGRectMake(videoView.bounds.origin.x-15, videoView.bounds.origin.y, videoView.bounds.size.width, videoView.bounds.size.height)];
    
    [videoView addSubview:moviePlayer.view];
        
        //now add a view to show and hidethe controls
        
        videoControlDeck= [[UIView alloc] initWithFrame:CGRectMake(videoView.bounds.size.width-25, videoView.bounds.origin.y , 30,videoView.bounds.size.height)];
        
        [videoControlDeck setBackgroundColor:[UIColor grayColor]];
        
        [videoView addSubview:videoControlDeck];
        
    
        
        if (dismissVideoImage==nil) {
             
       
    dismissVideoImage =[UIImage imageNamed:@"minus-sign.png"];
            
            
     }
        
        if(playVideoImage==nil){
            
            playVideoImage=[UIImage imageNamed:@"button-play.png"];
        }
        
        
        if (pauseVideoImage==nil) {
             pauseVideoImage=[UIImage imageNamed:@"button-pause.png"];
        }
        
         
             
       
     dismissVidButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissVidButton setImage:dismissVideoImage forState:UIControlStateNormal];
    
    [dismissVidButton setFrame:CGRectMake(videoControlDeck.bounds.origin.x  , videoControlDeck.bounds.origin.y+5, 25, 25)];
     
    [dismissVidButton addTarget:self action:@selector(dismissVideo) forControlEvents:UIControlEventTouchUpInside];
            
            
    [videoControlDeck addSubview:dismissVidButton];
            
         
   
        playaVidButton2=[UIButton buttonWithType:UIButtonTypeCustom];
        [playaVidButton2 setImage:pauseVideoImage forState:UIControlStateNormal];
        
        pauseVidButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [pauseVidButton setImage:pauseVideoImage forState:UIControlStateNormal]; 
        [playaVidButton2 setFrame:CGRectMake(videoControlDeck.bounds.origin.x  , videoControlDeck.bounds.origin.y+45, 25, 25  )];
     
        [playaVidButton2 addTarget:self action:@selector(moviePlayerPlayPause:) forControlEvents:UIControlEventTouchUpInside];
        
    
        [moviePlayer setControlStyle:MPMovieControlStyleNone];
        [videoControlDeck addSubview:playaVidButton2];
        
   // [self.view addSubview:moviePlayer.view];
    moviePlayer.fullscreen = NO;
    [moviePlayer setUseApplicationAudioSession:NO];
    
    [moviePlayer play];
        
        
        
    }else {
        
        //should warn user that no video exists because none was taken
        
      //  NSLog(@"filePath for Video is nil");
    }
        
}

-(IBAction)moviePlayerPlayPause:(id)sender{
    
    if (isPlaying) {
        
        [moviePlayer pause];
        
         [playaVidButton2 setImage:playVideoImage forState:UIControlStateNormal];
        
        isPlaying=NO;
        
    } else {
        
        
        [moviePlayer play];
        
        [playaVidButton2 setImage:pauseVideoImage forState:UIControlStateNormal];
     //   NSLog(@"is puased, so let's play");
        isPlaying=YES;
        
    }
   
    
    
    
}

-(void) dismissVideo{
    dismissVidButton.hidden=YES;
    [dismissVidButton removeFromSuperview];
    videoView.hidden=YES;
    
    [moviePlayer stop];
    
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] 
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
   dismissVidButton.hidden=YES;
   videoView.hidden=YES;

}






- (void)viewDidUnload
{
    [self setLastRecordingURL:nil];
    [self setStudentNameLabel:nil];
    [self setDateLabel:nil];
    [self setFeedbackReadingLbl:nil];
    [self setFeedbackBenchmarkLbl:nil];
    [self setStatusImageView:nil];
    [self setWpmLabel:nil];
    [self setNumberErrorsLbl:nil];
    [self setCwpmLbl:nil];
    [self setAccuracyLbl:nil];
    [self setPassageTitleLbl:nil];
    [self setPassageTextLbl:nil];
    [self setJsonDataDict:nil];
    
    [self setReportWebView:nil];
    [self setErrorBoxTextView:nil];
    [self setVideoView:nil];
    [self setShareButton:nil];
    [self setUploadButton:nil];
    [self setPlayMovieBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
