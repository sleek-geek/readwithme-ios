//
//  RWMReportVCViewController.h
//  RWMStudent
//
//  Created by Francisco Salazar on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MediaPlayer/MediaPlayer.h> 
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
//#define API_KEY @"?apikey=c40b0c360f3d4959b53b103b25759542"
#define API_KEY @"c40b0c360f3d4959b53b103b25759542"
 #import <AVFoundation/AVFoundation.h>
#import "RJGoogleTTS.h"
#import <MessageUI/MFMailComposeViewController.h>
 

@class RJGoogleTTS;
@interface RWMReportVCViewController : UIViewController <NSURLConnectionDelegate,RJGoogleTTSDelegate, MFMailComposeViewControllerDelegate>  

{
    
    BOOL isAssessmentGraded;
    NSString *stringForBox;
    MPMoviePlayerController *moviePlayer;
    NSString *assessedByString;
    NSString *textLevelForEmailString;
    UIImage *dismissVideoImage;
    UIImage *playVideoImage;
    UIView *videoControlDeck;
    UIImage *pauseVideoImage;
   

}

//test with uiwebview...
@property (strong, nonatomic) RJGoogleTTS *rJGoogleTTS;
@property (strong, nonatomic) IBOutlet UIWebView *reportWebView;
@property (strong, nonatomic) IBOutlet UIButton *playMovieBtn;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic, copy) NSDictionary *jsonDataDict;

@property (strong, nonatomic) NSString *studentName;
@property (strong, nonatomic)  NSString *assessmentText;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) NSString *aSessionID;
@property (strong, nonatomic) NSString *afilePath;
@property (strong, nonatomic) IBOutlet UILabel *studentNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *feedbackReadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *feedbackBenchmarkLbl;
@property (strong, nonatomic) IBOutlet UIImageView *statusImageView;
@property (strong, nonatomic) IBOutlet UILabel *wpmLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberErrorsLbl;
@property (strong, nonatomic) IBOutlet UILabel *cwpmLbl;
@property (strong, nonatomic) IBOutlet UILabel *accuracyLbl;
@property (strong, nonatomic) IBOutlet UILabel *passageTitleLbl;
@property (strong, nonatomic) IBOutlet UITextView *passageTextLbl;
@property (strong, readwrite) IBOutlet NSDictionary *responseDataDict;
@property (strong, nonatomic) IBOutlet UIView *videoView;

@property (strong, nonatomic) NSURL *lastRecordingURL;
@property (strong, nonatomic) IBOutlet UITextView *errorBoxTextView;

@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *uploadButton;
@property (strong, nonatomic) UIButton *dismissVidButton;
@property (strong, nonatomic) UIButton *playaVidButton2;
@property (strong, nonatomic) UIButton *pauseVidButton;

@property (nonatomic, retain) NSMutableData *downloadedData;

//-(IBAction)shareReading:(id)sender;
-(IBAction)uploadToServer:(id)sender;
-(IBAction)readToMe:(id)sender;
-(IBAction)playMovie:(id)sender;
-(void) dismissVideo;
-(IBAction)moviePlayerPlayPause:(id)sender;

-(void) setText:(NSString*) theContent andResults:(NSDictionary*)theResults;        
    
@end
