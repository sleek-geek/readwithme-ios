//
//  RRViewController.h
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//???????????????????????????????????????????????????????????
/*
 
 rrrrrr     rr   rr     rrrr   rr     
 rr  rrr    rr   rr     rr rr  rr
 rr  rr     rr   rr     rr  rr rr
 rrrrr      rr   rr     rr   rrrr
 rr  rr     rrrrrrr     rr     rr
 rr   rr    rrrrrrr     rr     rr
 
 $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
*/

#import "IndividualStudentVC.h"
#import <UIKit/UIKit.h>
 #import "CustomLabel.h"
#import "CustomTextField.h"
//#import "SoundGrabbrViewController.h"
#import <AVFoundation/AVFoundation.h>
 
#import <CoreAudio/CoreAudioTypes.h>
#import "Visualizer.h"
#import "RRStudentTableVC.h"
#import "RRCurlPageVC.h"
#import "Test.h"
 

#define kBenchmark1 1  //Above BM
#define kBenchmark2 2  //BM
#define kBenchmark3 3  //Approaching BM
#define kBenchmark4 4  //Far Below BM
#define kBenchmark5 5  //Not available
//#import "MiscueTableVC.h"

@class CustomLabel;
//@class CustomTextField;
@class SoundGrabbrViewController;
@class RRCurlPageVC;
@class RWMOfflineReportVC;
@class Student;



@interface RRViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate,
AVAudioRecorderDelegate, AVAudioPlayerDelegate, RRStudentTableVCDelegate,  UIPopoverControllerDelegate, RRCurlPageVCDelegate, IndividualStudentVCDelegate, UIWebViewDelegate>




{
    int seconds;
    int minutes;
    
    int miscuesInt;
    int skippedWordsINT;
    int helpedWordsINT;
    int selfCorrectINT;
    int totalTimeINT;
    int wpmReadInt;
    int correctPerMinInt;
    int accuracyINT;
    
    int wordsReadTotal;
    
    int passageLvlINT;
    
    int elapsedTimeInt;
    
    BOOL isTestOn; //separate... this will 
    BOOL isTimerOn; //this keeps track of pausing/playing
    BOOL isVisualizerOn;
    BOOL isRecordRunning; //combine the other two under this bool!
    
    BOOL doesWantComprehension;
    BOOL comprehensionComplete;
    BOOL isComprehensionPassed;
    BOOL oneMinModeIsOn;
    BOOL isFluencyPassed;
    BOOL isHelpWanted;
    
    
    NSString *stringToLoad;
    
    NSArray *jSONArray;
   // NSDictionary *jsonResponse; //holds the JSON DATA from web view intercept
    NSNumber *selfCorrectNUM;
    NSNumber *gradeLevel; //used for passage! beguare! 
    
    NSNumber *benchmarkForPassageNUM;
    
    NSNumber *recNumbForBool;
    
    NSNumber *passageWordCount;
    
    NSNumber *accuracyNumber;
    
    NSNumber *wordsReadPerMinNUM;
    
    NSNumber *wordsReadCorrectPerMinNUM;
    
    NSNumber* comprehensionScore;
    
     NSNumber *thisTestFluencyBenchmark;
    
    NSString *studentIdNumber;
    
    NSNumber *benchmarkStatusNumber; //for student
    
    NSTimer *stopWatch;
    
    NSString *comparingString;
    
    NSURL *elRecorderURL;
    
    NSString *filePath;
    
    NSString *stringForMMM;
    
    NSString *textTitle;
    
    NSString *testStatusString;
    
    NSString *aGradeStringForPsg;
    
    CustomLabel* customLabel;
    
   // CustomTextField *customText;
    
     SoundGrabbrViewController *soundGrabber;
    RWMOfflineReportVC *offlineReportVC;
    
    RRStudentTableVC *studentTableViewController;
    RRCurlPageVC *compQuestionsVC;
    
    
    
    //use these if embedding soundGrabbr in this class
    AVAudioRecorder *elRecorder;
	AVAudioPlayer *elPlayer;
	
	NSMutableArray *soundFilePaths;
    
    NSMutableArray *fluencyNormsArray;
    
    NSDictionary* comprehensionDictionary;
    
    
	IBOutlet Visualizer *visualizer;
	NSTimer *timer;
    
}


@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *passageText;




@property (strong, nonatomic) IBOutlet UILabel *helpMSGLabel;

@property (strong, nonatomic) IBOutlet UIImageView *helpOverlayImg;


@property (strong, nonatomic)  NSString *studentIdNumber;
@property (strong, nonatomic) Student *student;

@property (strong, nonatomic) IBOutlet UISegmentedControl *stopWatchOptionSegment;
@property (nonatomic, strong) NSString *textTitle;
@property  (nonatomic, strong) NSString *studentReading;
@property (nonatomic, strong) UIPopoverController *compPopover;

@property (nonatomic, strong) SoundGrabbrViewController *soundGrabber;
@property (strong, nonatomic)     UIPopoverController *quickStartPopover;
@property (strong, nonatomic)     UIPopoverController *assmentInfoPopover;





@property (nonatomic, weak) NSString *miscueString;

@property (weak, nonatomic) IBOutlet UILabel *passageTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic   , strong) IBOutlet UILabel *mySelection;
@property (nonatomic, strong   ) UITextView *textSelection;

@property (weak, nonatomic) IBOutlet UILabel *wordCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *benchMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *passageLvlLabel;
@property (strong, nonatomic) IBOutlet UILabel *passageGrdLbl;
@property (strong, nonatomic) IBOutlet UIView *moreInfoView;


@property (weak, nonatomic) IBOutlet UIButton *showNotesButton;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic)IBOutlet UIButton* calculateButton;
@property (weak, nonatomic) IBOutlet UIButton *goBackButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton; //record Button
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIView *stopWatchView;


@property (weak, nonatomic) IBOutlet UITextView *notesTxtView;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (strong, nonatomic) IBOutlet UITableView *miscueTableView;

@property (copy, nonatomic) NSMutableArray *miscueArray;

//@property (strong, nonatomic) IBOutlet UIButton *plusTextSize;
 
//@property (strong, nonatomic) IBOutlet UIButton *minusTextSizeBtn;

@property (nonatomic, strong) IBOutlet UIButton *showCompButton;


@property (nonatomic, strong) IBOutlet Visualizer *visualizer;

@property (nonatomic, strong) NSNumber *  recNumbForBool;
@property (nonatomic, strong)  NSNumber *gradeLevel; //for passage grade, not student



@property (weak, nonatomic) IBOutlet UILabel *calcMiscueCountLBL;
@property (weak, nonatomic) IBOutlet UILabel *calcSkippedCountLBL;
@property (weak, nonatomic) IBOutlet UILabel *calcSelfCorrecLbl;
@property (weak, nonatomic) IBOutlet UILabel *calcWithHelpLbl;
@property (weak, nonatomic) IBOutlet UILabel *calcTotalTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *calcWPMlabel;
@property (weak, nonatomic) IBOutlet UILabel *calcCPMLabel;
@property (weak, nonatomic) IBOutlet UILabel *calcAccuracyLbl;

@property (strong, nonatomic) NSMutableArray *textArray;
@property (strong, nonatomic) NSMutableArray *tests;

@property (nonatomic, readwrite) NSMutableArray *studentsArray;

@property (weak, nonatomic) IBOutlet UILabel *timerCompOptionLBL;

-(NSString *) testArchivePath;
-(void) archiveTests;
-(NSString*) studentsArchivePath;
-(void) archiveStudents;


-(IBAction)requestPlaybackOfLastFile:(id)sender;
- (IBAction)useTimer:(id)sender;  //this starts test
-(IBAction)toggleNotesAndMiscues:(id)sender;

-(void) startRunning ;
-(void) visualizerTimerFired: (NSTimer*)aTimer;

-(void) recordingSessionHasBegun;
-(void) redordingSessionHasEnded;
-(void) redordingPaused;


-(IBAction)stopAndStart:(id)sender;
//-(IBAction)increaseTextSize:(id)sender;
//-(IBAction)decreaseTextSize:(id)sender;
-(void) invalidateTimer;

-(void)calculate;
-(IBAction)saveFile:(id)sender;
-(void) scoreTest:(Test*)aTest;

-(IBAction)setStudentForRecord:(id)sender;

-(IBAction)showCompQuestinos:(id)sender;

-(id)initWithPassageName:(NSString*)name andStudent:(NSString*)aStudent;


- (IBAction)showHelp:(id)sender;
-(IBAction)toggleTimerMode:(id)sender;

-(IBAction)goback:(id)sender;
- (IBAction)showHideMoreInfo:(id)sender;

//- (CGRect)rectFromOrigin:(CGPoint)origin inset:(int)inset;

@end
