//
//  RRViewController.m
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
/*
 This class is the main running record interface
 it accomplishes the following:
    > starts a recording session via the Start button
    > loads the text to be used based on the grade and text selection of the previous view controller
    > allows for changing students to be assessed
    > keeps time and saves miscues that are passed from the CustomTextView
    > loads comprehension questions
    > saves files, inlcuding test instances, updates student archives, and sound files. 
    
 
 
 */

#import "RRViewController.h"
#import "Student.h"
#import "RWMOfflineReportVC.h"

  



#define MAX_FONT_SIZE 40
#define MIN_FONT_SIZE 20

@interface RRViewController ()

@end

@implementation RRViewController
@synthesize passageTitleLabel;
@synthesize nameLabel;
@synthesize mySelection;
@synthesize textSelection;
@synthesize wordCountLabel;
@synthesize benchMarkLabel;
@synthesize passageLvlLabel;
@synthesize showNotesButton;
@synthesize startButton;
@synthesize resetButton;
@synthesize saveButton;
@synthesize stopWatchView;
@synthesize notesTxtView;
@synthesize timerLabel;
@synthesize miscueTableView;
@synthesize  miscueString;
@synthesize miscueArray;
//@synthesize plusTextSize;
//@synthesize minusTextSizeBtn;
@synthesize soundGrabber;
@synthesize visualizer;
@synthesize  playButton, calculateButton, goBackButton, settingsButton;
@synthesize recNumbForBool;
@synthesize calcMiscueCountLBL;
@synthesize calcSkippedCountLBL;
@synthesize calcSelfCorrecLbl;
@synthesize calcWithHelpLbl;
@synthesize calcTotalTimeLbl;
@synthesize calcWPMlabel;
@synthesize calcCPMLabel;
@synthesize calcAccuracyLbl;
@synthesize textArray;
@synthesize quickStartPopover;
@synthesize tests;
@synthesize showCompButton;
@synthesize compPopover;
@synthesize gradeLevel;
@synthesize studentReading;
@synthesize textTitle;
@synthesize stopWatchOptionSegment;
@synthesize student= _student;
@synthesize studentsArray=_studentsArray;
@synthesize studentIdNumber;
@synthesize helpMSGLabel;
@synthesize passageGrdLbl;
@synthesize timerCompOptionLBL;
@synthesize helpOverlayImg;

int recordingNumber;

BOOL moreInfoisHiding;
BOOL isRecordingAllowed;


-(id)initWithPassageName:(NSString*)name andStudent:(NSString*)aStudent{
    
    //unarchive the passages and load the proper one
    
    self =[super init];
    
    if (self){
     
        
      NSString *path = [[NSBundle mainBundle] pathForResource:@"6thGradePassages" ofType:@"plist"];
        
        if (!textArray) {
            
        
        textArray=[[NSMutableArray alloc] initWithContentsOfFile:path];
            
        }
    
        textTitle=name;
        studentReading=aStudent;
    
        
        self.tests = [NSKeyedUnarchiver
                         unarchiveObjectWithFile:  [self testArchivePath]];
        
        if (self.tests==nil) {
            
            self.tests =[[NSMutableArray alloc] init];
            
        }
        
    }
   
    return self;  
    
}

- (IBAction)showHelp:(id)sender {
    
    
    if (helpOverlayImg.hidden==YES) {
        
       // NSLog(@"showing help");
        helpOverlayImg.hidden=NO;
        [self.view bringSubviewToFront:helpOverlayImg];
        
    } else {
        helpOverlayImg.hidden=YES;
        //NSLog(@"hiding help");
    }
}

-(IBAction)toggleTimerMode:(id)sender{
    
   // NSLog(@"toggle timer mode");
    
    if ( !isTimerOn) {
         
    
    
    if (stopWatchOptionSegment.selectedSegmentIndex==0){
       // NSLog(@"wants one min.mode");
        //wants one min. mode
        oneMinModeIsOn=YES;
        timerCompOptionLBL.hidden=NO;
        
        // NSNumber *numberForStopwatchOption = [NSNumber numberWithBool:oneMinModeIsOn ];
        
        int timerTypeInt=0;
        
        
        NSString *formatJs=  [NSString stringWithFormat: @"setTimerOption('%i')",  timerTypeInt];
        
        
        
        [_webView stringByEvaluatingJavaScriptFromString:formatJs];
        
    }else {
        //wants stopwatch
       // NSLog(@"wants stopwatch mode");
        oneMinModeIsOn=NO;
        timerCompOptionLBL.hidden=YES;
        
        
     //   NSNumber *numberForStopwatchOption = [NSNumber numberWithBool:oneMinModeIsOn ];
        
        int timerTypeInt=1;
        
        
        NSString *formatJs=  [NSString stringWithFormat: @"setTimerOption('%i')",  timerTypeInt];
        
        
        
        [_webView stringByEvaluatingJavaScriptFromString:formatJs];
        
        
    }
        
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch ;
    touch = [[event allTouches] anyObject];
    
    
    if ([touch view] == _moreInfoView && moreInfoisHiding==NO)
    {
        //Do what ever you want
        [self performSelector:@selector(showHideMoreInfo:) withObject:nil afterDelay:0.0];
    }
    
    
    
}

#pragma mark webview delegate methdos

-(void)webViewDidFinishLoad:(UIWebView *)webView   {
    
    if ([[webView stringByEvaluatingJavaScriptFromString:@"document.readyState"] isEqualToString:@"complete"]) {
        // UIWebView object has fully loaded.
      
        NSString *formattedString =[_passageText stringByReplacingOccurrencesOfString:@"\"" withString:@",,q,,"];
        
        //NSString *formattedStringNoDoubleSpaces=[ stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        
        NSString *formattedStringNoSingleQuotes=[formattedString stringByReplacingOccurrencesOfString:@"'" withString:@",,s,,"];
        
        NSMutableString *mutatedString = [[NSMutableString alloc]initWithString:formattedStringNoSingleQuotes];//instead of passage text
        
        
        
        NSCharacterSet *newLinesBrakes =[NSCharacterSet newlineCharacterSet];
        
        
        
        
        NSString *reformattedString =[[mutatedString componentsSeparatedByCharactersInSet:newLinesBrakes] componentsJoinedByString:@",,n,,"];
        
        NSString *addBreaks=[reformattedString stringByReplacingOccurrencesOfString:@",,n,," withString:@" <br><br>" ];
        
        reformattedString=addBreaks;
        
        
        
       //Let's move this to the array building function.
       //  NSString *noNewLinesFormattedSTring = [formattedStringNoSingleQuotes stringByReplacingOccurrencesOfString:@"\n" withString:@"</span><br><span>"];
        // NSString *noNewLinesFormattedSTring = [formattedStringNoSingleQuotes stringByReplacingOccurrencesOfString:@"\n" withString:@",,n,,"];
      
        NSMutableArray *formattedArray=[[NSMutableArray alloc]init];
 
        //separate text into array (replacing noNewLinesFormattedSTring with formattedSTringNoSingleQuotes)
        NSArray *words = [reformattedString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
       // NSMutableArray *wordsFromWords=[NSMutableArray arrayWithArray:words];
        
        //tag each word
       // NSLog(@"Words: %@", words);
        int wordCount=0;
        for (int i=0; i<words.count; i++) {
            
           // NSLog(@"Word #: %@", [words objectAtIndex:i]);
            
             //if hte word equals /n, then we replace it before wrapping it.
            
            NSString *wordToCheck=[words objectAtIndex:i];
            
            if (![wordToCheck isEqual:@""]) {
                
                
                NSString *spanPrefix=[NSString  stringWithFormat:@"<span id=\"word_%i\">", wordCount];
                
                NSString* wordWithPrefix= [spanPrefix stringByAppendingString:[words objectAtIndex:wordCount]];
                
                
                
                
                NSString *formattedWord =[wordWithPrefix stringByAppendingString:@" </span>"];
                
              // NSLog(@"formatted word: %@", formattedWord);
                
                //put into array
                [formattedArray addObject:formattedWord];
                
                
                
                wordCount++;
                
                
            }
                    
           
            
            
        }
        
      //  NSLog(@"formatted array has: %@", formattedArray);
        
        stringToLoad=@"";
        
        
        for (NSString *aWord in formattedArray) {
         //   NSLog(@"AWord: %@", aWord);
            stringToLoad= [stringToLoad stringByAppendingString:aWord];
            
            
            
        }
        //clear the arrays
        
        formattedArray=nil;
        words=nil;
        
        
        
        
      //   NSLog(@"Our final product: %@", stringToLoad);
        
        //NSString *js=[NSString  stringWithFormat:@"document.getElementById('displaytext').innerHTML =  '%@';", stringToLoad];
        
        NSString *setContentString=[NSString stringWithFormat:@"setContent('%@')", stringToLoad];
        
        
        [_webView stringByEvaluatingJavaScriptFromString:setContentString];
        
       // oneMinModeIsOn
        
      //  NSNumber *numberForStopwatchOption = [NSNumber numberWithBool:oneMinModeIsOn ];
        
       // int timerTypeInt=[numberForStopwatchOption intValue ];
        
        int timerTypeInt=stopWatchOptionSegment.selectedSegmentIndex;
        
     //   NSLog(@"timerMode is: %i", timerTypeInt);
        
        NSString *setTheTimerOptionStrng= [NSString stringWithFormat:@"setTimerOption('%i')", timerTypeInt];
        
        [_webView stringByEvaluatingJavaScriptFromString:setTheTimerOptionStrng];
        
        
      //  NSString *formatJs=  [NSString stringWithFormat: @"formatText('%@', '%i')", stringToLoad, timerTypeInt];
        
        
        
       // [_webView stringByEvaluatingJavaScriptFromString:formatJs];
        
         
        
        
        
        
    }
    
    
    
    
    
    
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
  //  NSLog(@"shouldStartLoadWithRequest");
    
    
    NSString *myAppScheme = @"testrwm";
    
    
   // NSLog(@"requets.URL.scheme : %@", request.URL.scheme);
    
    if (![request.URL.scheme isEqualToString:myAppScheme]) {
        
      //  NSLog(@"request.url.scheme %@ is not equal to %@", request.URL.scheme,  myAppScheme);
        
        
        if ([request.URL.scheme isEqualToString:@"startclock"]) {
            
            
         //   NSLog(@"Starting Running Record");
            
            [self startRunningRecord];
            
        } else if ([request.URL.scheme isEqualToString:@"stoppinglclock"]){
            
            
         //   NSLog(@"Stopping Running Record");
            
            [self stopRunningRecord];
            
        }else{
            
            return YES;
        }
        
        
        
        
        
        return YES;
    }
    else if ([request.URL.scheme isEqualToString:@"startclock"]){
        
        
      //  NSLog(@"start/stop");
        
        
        
    }
    //getting action from path:
    
    
    
//    NSString* actionType = request.URL.path;
    
    //and now deserialize the JSON
    
    NSString *jsonDictString=[request.URL.fragment stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    
  //  NSLog(@"YES! %@ is equal to my appscheme: %@",  actionType, myAppScheme);
    
    
    
    
    
    
    NSData *data = [jsonDictString dataUsingEncoding:NSUTF8StringEncoding];
    
   // NSLog(@"JSON DICT  = %@", jsonResponse);
    
    NSError *e;
    jSONArray=[NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    
 //   NSLog(@"JSON ARRAY: %@", jSONArray);
    
  // NSLog(@"My Action type from reqeust.URL.path: %@", actionType);
    
    if (jSONArray!=nil) {
        
        
   //     NSLog(@"JSON DATA is not equal to nil");
        [self saveJsonFile:jSONArray];
        
    }
    
    return NO;
    

}




#pragma mark View Did Load

- (void)viewDidLoad

{
    
    miscueTableView.hidden=YES;
    
    miscueTableView.hidden=YES;
     moreInfoisHiding=YES;
    _webView.delegate=self;
    isHelpWanted=YES;
    
    if (isHelpWanted) {
         
  
    helpMSGLabel.hidden=NO;
    helpMSGLabel.text=@"Press 'START' when ready"; 
      }
    
    
    helpOverlayImg.hidden=YES;
    
    
    
    isTimerOn=NO;
    oneMinModeIsOn=YES;
    
    // set the minute mode here...
    if (oneMinModeIsOn==YES){
        
        stopWatchOptionSegment.selectedSegmentIndex=0;
    }
        
    comparingString =@"!";
    timerLabel.text=@"00:00";
    
    
   // customText= [[CustomTextField alloc] initWithFrame:CGRectMake(25, 160, 550 , 730)];
    
    notesTxtView.hidden=YES;
    miscueTableView.hidden=NO;
    
    saveButton.enabled=NO;
    
     
    
    [self unarchiveTests];
    
    
    [self unarchiveStudents];
    
    //here we will check against user settings....
    
    

  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"WantsComprension"] == YES) {
      
      doesWantComprehension=YES;
  } else {
    doesWantComprehension=NO;
  }
    
    for (NSDictionary* dicts in textArray){
        
        
        
        
        if ([[dicts objectForKey:@"Title"] isEqualToString:textTitle]) {
            
           // customText= [[CustomTextField alloc] initWithFrame:CGRectMake(25, 160, 550 , 750)];
            
            
            
            
            
           // customText.textForView=[dicts objectForKey:@"Text"];
           
            passageGrdLbl.text=[NSString stringWithFormat:@"%i", [[dicts objectForKey:@"Grade"] intValue ]];
            
            
            
            
 
            
          _passageText=[dicts objectForKey:@"Text"]; //here is where the text is set!!!
            
          //  NSLog (@"PassageText is: %@", _passageText);
            
            NSString *passgeTextNoDoubleSpaces = [_passageText stringByReplacingOccurrencesOfString:@"  " withString:@" "];
            
            
            _passageText=passgeTextNoDoubleSpaces;
            
          //  NSLog(@"PassageTEXT NO Dobule Spaces: %@", _passageText);
                       
            if ([[dicts objectForKey:@"Lexile"] isKindOfClass:[NSString class]] ) {
                
                
                
                NSString *strng= [dicts objectForKey:@"Lexile"];
                
                passageLvlLabel.text=strng;
            } else if ([[dicts objectForKey:@"Lexile"] isKindOfClass:[NSNumber class]]){
            
                NSNumber *psgLvl=[dicts objectForKey:@"Lexile"];
                
                
           passageLvlLabel.text= [NSString stringWithFormat:@"%@L",[psgLvl stringValue]];
           passageLvlINT= [psgLvl intValue]; //this will be used when the test is saved...
                
            }
          
        }
        
    }
    
    
   // [self.view addSubview:customText];
  //  [customText becomeFirstResponder];
    
    passageTitleLabel.text=textTitle;
    
    nameLabel.text=studentReading;
    
   //int words=[customText.wordsInPassage intValue];
//#warning return count called here..
   // int words =[self returnWordCount];
    
  //  passageWordCount=[NSNumber numberWithInt:words];
    
  //  wordCountLabel.text=[NSString stringWithFormat:@"%i", words];
    
    if (miscueArray==nil){
    miscueArray = [[NSMutableArray alloc] initWithCapacity:100]; //lets try and set  it to one hudred. 
    }
    //set up button title states
    UIImage *pauseButtonImage = [UIImage imageNamed:@"Pausa2.png"];
    [startButton setImage:pauseButtonImage forState:UIControlStateSelected];
  
    
    //The following code is for the embedded SoundGrabber
    recNumbForBool= [NSNumber numberWithInt:1]; //ONE returns YES
    
    BOOL recordingEnabled =[recNumbForBool boolValue];
    
    if (recordingEnabled==YES) { 
        
        //set up embedded soundgrabber if user has set this option to YES
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        
        if (!soundFilePaths) {
            soundFilePaths = [[NSMutableArray alloc] init];
             
            
        }
        
    }
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self selector:@selector(keyboardDidShow:)
     name:UIKeyboardDidShowNotification object:nil]; 
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self selector:@selector(keyboardDidHide:)
     name:UIKeyboardDidHideNotification  object:nil]; 
    
    
    
     [super viewDidLoad];
    
    
    
    
    if ([nameLabel.text isEqualToString:@"Touch to set student..."]) {
         
        
        settingsButton.enabled=NO; //if a student is already loaded, the student cannot be reset 
        
        
        
    }
   // NSNumber *thisTestFluencyBenchmark;
    
    //Now add benchmark to label
    if ([gradeLevel intValue ]!=9) {
        
        
       thisTestFluencyBenchmark= [self getBenchmarkForDate:[NSDate date]];
    } else {
        
          //we are dealing with a custom passage.
        
        thisTestFluencyBenchmark=[self getBenchmarkForDate:[NSDate date]];
    }
    
    
    benchMarkLabel.text=[thisTestFluencyBenchmark stringValue];
    
   
    
    
    //now load the web view
    
    
    NSString *filepath =[[NSBundle mainBundle] pathForResource:@"rwmoffline" ofType:@"html"];
//    NSLog(@"FILE PATH FOR url: %@", filepath);
    
    NSURL *aURL = [NSURL fileURLWithPath:filepath];
    
    [_webView  loadRequest:[NSURLRequest requestWithURL:aURL]];
    
    
     
     //now prompt the user to set student if not set
    
    
    
    isTestOn=NO;
}


-(void) unarchiveStudents {
    
    if (self.studentsArray==nil) {
        
        self.studentsArray=[NSKeyedUnarchiver
                            unarchiveObjectWithFile:[self studentsArchivePath]];
        
    }
    
}


-(void) unarchiveTests{
    
    NSString *gradeLevelToUnarchiveString=@"";
    NSString *path = @"";
    
    int grd = [gradeLevel intValue]; //this number comes fromt the indexPath.row in the superview.
    
    if (grd==1) {
        
        gradeLevelToUnarchiveString=@"1stGradePassages";
        path = [[NSBundle mainBundle] pathForResource:gradeLevelToUnarchiveString ofType:@"plist"];
        
        
    } else if (grd==2){
        
        gradeLevelToUnarchiveString=@"2ndGradePassages";
        path = [[NSBundle mainBundle] pathForResource:gradeLevelToUnarchiveString ofType:@"plist"];
        
    }else if (grd==3){
        
        gradeLevelToUnarchiveString=@"3rdGradePassages";
        path = [[NSBundle mainBundle] pathForResource:gradeLevelToUnarchiveString ofType:@"plist"];
        
    }else if (grd==4){
        
        gradeLevelToUnarchiveString=@"4thGradePassages";
        path = [[NSBundle mainBundle] pathForResource:gradeLevelToUnarchiveString ofType:@"plist"];
        
    }else if (grd==5){
        
        gradeLevelToUnarchiveString=@"5thGradePassages";
        path = [[NSBundle mainBundle] pathForResource:gradeLevelToUnarchiveString ofType:@"plist"];
        
    }else if (grd==6){
        
        gradeLevelToUnarchiveString=@"6thGradePassages";
        path = [[NSBundle mainBundle] pathForResource:gradeLevelToUnarchiveString ofType:@"plist"];
        
    }else if (grd==7){
        
        gradeLevelToUnarchiveString=@"7thGradePassages";
        path = [[NSBundle mainBundle] pathForResource:gradeLevelToUnarchiveString ofType:@"plist"];
        
    }else if (grd==8){
        
        gradeLevelToUnarchiveString=@"8thGradePassages";
        path = [[NSBundle mainBundle] pathForResource:gradeLevelToUnarchiveString ofType:@"plist"];
        
    } else {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        path = [documentsDirectory stringByAppendingPathComponent:@"CustomPassages.plist"];
        
        
    }
    
    
    if (!textArray) {
        
        textArray=[[NSMutableArray alloc] initWithContentsOfFile:path];
        
    }
    
    
  //  studentReading=studentReading;
    
    
    self.tests = [NSKeyedUnarchiver
                  unarchiveObjectWithFile:  [self testArchivePath]];
    
    if (self.tests==nil) {
        
        self.tests =[[NSMutableArray alloc] init];
        
    }
    
    
}


-(void)viewDidAppear:(BOOL)animated{

 
    
    
    if ([nameLabel.text isEqualToString:@"Touch to Choose Student"] )
    
    {
        
        studentTableViewController =[[RRStudentTableVC alloc] init];
        
        
        studentTableViewController.useForStudentList=@"RunningRecordView";
        
        UITableViewController *tableViewContoller= [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        
        studentTableViewController.delegate=self;
        studentTableViewController.title=@"Choose Student";
        tableViewContoller.contentSizeForViewInPopover=CGSizeMake(230, 400);
        
        tableViewContoller=studentTableViewController;
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tableViewContoller];
        quickStartPopover = [[UIPopoverController alloc] initWithContentViewController:navController];
        [quickStartPopover presentPopoverFromRect:[settingsButton  frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

        
    }
    
}


 


 

-(IBAction)setStudentForRecord:(id)sender{
    
   
    studentTableViewController =[[RRStudentTableVC alloc] init];
    

    studentTableViewController.useForStudentList=@"RunningRecordView";
    
    UITableViewController *tableViewContoller= [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    studentTableViewController.delegate=self;
    
    tableViewContoller.contentSizeForViewInPopover=CGSizeMake(230, 400);
    
    tableViewContoller=studentTableViewController;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tableViewContoller];
    quickStartPopover = [[UIPopoverController alloc] initWithContentViewController:navController];
    [quickStartPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}

-(void) setStudentForRunningRecord:(Student*)studentForTest{
    
    
    self.student= studentForTest;
    studentIdNumber=studentForTest.studentID;
    
     NSString *fullName = [NSString stringWithFormat:@"%@ %@", studentForTest.nombre, studentForTest.apellido];
       nameLabel.text=fullName;
    studentReading=fullName;
  
    [quickStartPopover dismissPopoverAnimated:YES];
}
/*
-(int) returnWordCount {
    //The following is beautiful code!! IT returns the word count for a loaded passage form custom text class
    NSString *texto =  customText.text;
    
    NSScanner *aScanner = [NSScanner scannerWithString:texto];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSCharacterSet *nonWhitespace = [whiteSpace invertedSet];//wow, I have to say, what a cool method
    int wordcount = 0;
    
    while(![aScanner isAtEnd])
    {
        [aScanner scanUpToCharactersFromSet:nonWhitespace intoString:nil];
        [aScanner scanUpToCharactersFromSet:whiteSpace intoString:nil];
        wordcount++;
    }
    
    return wordcount;
    
    
}
 */

/*the 
 
 
 
 following method is activated when user presses play/start*/
-(void)startRunningRecord{
    
    
    
    
    
    [self performSelector:@selector(useTimer:) withObject:nil afterDelay:0.0 ]; //this starts a new recording to a new URL...
    //[self fireUpTimers];
        
         
        
        
   
    
    
    
    
    
}
-(void)stopRunningRecord{
    
    
    [self performSelector:@selector(useTimer:) withObject:nil afterDelay:0.0];
    
    
    
    
}




- (IBAction)useTimer:(id)sender //This method is to pause and play the test AND to pause record if option is set
{ 
    
    
    if (isHelpWanted) {
        
        
        helpMSGLabel.hidden=NO;
        helpMSGLabel.text=@"Timer running, select miscues";
    }

    
    //set the timer option here:
    if (stopWatchOptionSegment.selectedSegmentIndex==0) {
        //one min. mode set
        oneMinModeIsOn=YES;
        doesWantComprehension=NO;
        
        
//#warning disable comprehension button here...
        
        timerCompOptionLBL.text=@"Comprehension Disabled";
        showCompButton.enabled=NO;
        
    }else{
        showCompButton.enabled=YES;
        oneMinModeIsOn=NO;
        doesWantComprehension=YES;
        timerCompOptionLBL.text=@"1 Enabled";
    }
    
    
    
    isRecordingAllowed=[recNumbForBool boolValue];
    
     
    if (isTimerOn && isTestOn) //the first time it wont meet this condition, but second time it will. 
    { 
         
        startButton.selected=NO;
        
                
        if (isRecordingAllowed==YES) {
            isVisualizerOn=NO;//this will flag the visualizer to stop firing
            
             [self toggleRecordingOnOff]; //if its already recording, it will pause at this time
            
                    }
        
         
        isTimerOn=NO; //this refers to the stopwatch, not the timer associated with the visualizer, sorry. 
        
    }
    else //it will ignore this call the first time, but be true the third time. 
    
    {     
        startButton.selected=YES;
       
       // [self startRunning];
        
        if (isRecordingAllowed==YES && isTestOn==YES) {
           // [self redordingPaused]; //IT should not be recording, so calling this method will cause it to continue recording
                
            [self toggleRecordingOnOff]; //timer is not on so this will resume or start recording
            
                isVisualizerOn=YES;
                //initiate a recording session
              
        }  
        
         isTimerOn=YES; //timer can keep updating stopwatch
  }    //end else...
    if (!isTestOn) {
        
        //when it returns from this state the timers will be running and the recording will have begun
        // but test wont be on until this method goes thorugh at least once
             [self startRunning];
        
    }
    isTestOn=YES; //test wont really start until it goes through this method once, in order to avoid fooling the toggle pause 
   
}
-(void) startRunning{
    
    if (isTestOn==NO){
        
        //isTestOn=YES;
        
        if (miscueArray) {
            [miscueArray removeAllObjects];
        }
        
        
        //22222
        [self startNewRecording];  
        
        
        [self fireUpTimers]; //...
        
        playButton.enabled =NO;
    } else {
        playButton.enabled=YES;
    }
    
    
    startButton.selected=YES;
    
    
    
}

#pragma mark timer functions

//This method takes care of firing up the timers at the beginning only 
-(void) fireUpTimers{
    
    elapsedTimeInt=0;
    
    recNumbForBool= [NSNumber numberWithInt:1]; //ONE returns YES
    
    BOOL recordingEnabled =[recNumbForBool boolValue]; //gets whether the user wants to record or not
    
    if (recordingEnabled) {
        
        
        timer	=[NSTimer scheduledTimerWithTimeInterval:0.05
                                                target: self
                                              selector:@selector(visualizerTimerFired:)
                                              userInfo: nil repeats:YES];
        
        
        isVisualizerOn=YES;   
        
        
    }
    
    if (!stopWatch ) {
         
    
    stopWatch = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:stopWatch forMode:NSRunLoopCommonModes];
     
    
    isTimerOn=YES;
        }
    
    
}


- (void)timerFired:(NSTimer *)timer //timer fired is associated with stopWatch, not visualizer
{
    // update label
    if (isTimerOn) {
         
    
   // NSLog(@"stopWatch --    TimerFired");
    elapsedTimeInt++;
  
    
     minutes = (elapsedTimeInt % 3600) / 60;
      seconds= (elapsedTimeInt %3600) % 60;
    
    
  // NSLog(@"timerFired %i", newCount);
     timerLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds]; //set new incremented value to label
     
 //   NSString * newCompareString  =[customText  miscueString]; //get the last miscue and assign it to the comparestring
     
    //******is this the same as the one I still have set?
   // if ([newCompareString isEqualToString:comparingString]){
        
        // if its the same, do nothing but keep firing the timer
        
    }
    
    //******if it's not the same, then grab it and put it in the array
    
            //update the table view with this new word
     
    else {
       // NSInteger *miscuePos= customText.wordPositionNum;
         
        //now adding miscue type as third entry in dict.
        
        
        
      //  NSDictionary*newMiscueDict=[[NSDictionary alloc] initWithObjectsAndKeys:newCompareString,@"Miscue",customText.wordPositionNum  ,@"Position", customText.menuIndexNUM, @"MiscueTypeNumber",  nil];
        
        
        
        
        // [ miscueArray addObject:newMiscueDict]; //need to add a dictionary, with teh string, and the wordposition.
        
        [miscueTableView reloadData];
        
      //  comparingString =newCompareString;
    } 
     
    
    if (oneMinModeIsOn==YES && elapsedTimeInt==60 ) {
        //minute is up..so invalidate timer, isTestOn=NO and set isLastWord=YES
                  
        isTimerOn=NO;
        
       // customText.isLastWord= [NSNumber numberWithBool:YES];
        
        
       // [self performSelector:@selector(stopAndStart:)];
        
        [self invalidateStopWatch];
        
        [self toggleRecordingOnOff];
        [self redordingSessionHasEnded];
        
        saveButton.enabled=YES;
        
      //  UIAlertView *endAlert =[[UIAlertView alloc] initWithTitle:@"Time is Up" message:@"Double Tap on last word read" delegate:@"self" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
       // [endAlert show];
        
        isTestOn=NO;
        
    }
    
    
  }
     



-(void) visualizerTimerFired: (NSTimer*)aTimer{
    
    if (isVisualizerOn) {
         
   // NSLog(@"visualizerTimerFired");
   [elRecorder updateMeters];
	[visualizer setPower:[elRecorder averagePowerForChannel:0]];
	[visualizer setNeedsDisplay];
	 }
	 
}

-(void) invalidateTimer{ //this invalidates the visualizer timer
     
	[timer invalidate];
	timer=nil;
    
}
-(void) invalidateStopWatch{//only at the end of the test do we invalidagte, or if we want to quit
    [stopWatch invalidate];
    stopWatch =nil;
    
}
//code for tableview follows

#pragma mark recorder methods

-(void) startNewRecording {
    
    //33333
   // customText.isLastWord= [NSNumber numberWithBool:NO];
    
    
        
    NSArray *dirPathsArray = NSSearchPathForDirectoriesInDomains(
                                                                 NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [dirPathsArray objectAtIndex:0];
    
    NSString *fileNameFromTxt= nameLabel.text; //unecessary step, but well leave it for now. 
    
    
    NSString *fixedString=[fileNameFromTxt stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    NSDate *todaysDate=[NSDate date];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    NSString *stringFromDate=[dateFormatter stringFromDate:todaysDate];
    
     
    
    NSString*filenameWithDate= [NSString stringWithFormat: @"%@-%@.%@",fixedString ,stringFromDate
                                , @"caf"];
    
    NSString *soundFilePath = [documentDir stringByAppendingPathComponent:filenameWithDate];
    
    filePath= soundFilePath; //set the new filePath
    
   
    
    //						   stringByAppendingPathComponent:@".caf"];
    
    elRecorderURL = [NSURL fileURLWithPath:soundFilePath];
    
    
    
    NSDictionary *recordSettings = [NSDictionary 
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16], 
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2], 
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0], 
                                    AVSampleRateKey,
                                    nil];
    
    
    NSError *error = nil;
    
    if (elRecorder) {
        
        elRecorder=nil;
        //[elRecorder release];
             }  
		
		elRecorder = [[AVAudioRecorder alloc] //start a new elRecorder
					  initWithURL:elRecorderURL
					  settings:recordSettings
					  error:&error];
		elRecorder.meteringEnabled=YES;
          
    

    if (error)
    {
      //  NSLog(@"%@", error);
        
    } else { //else no error, then proceed
        
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
        
        
        
        [elRecorder prepareToRecord];
        [elRecorder setDelegate:self]; //is this necessary?
        [elRecorder record]; //recording
        
        [visualizer clear];
        
        
    }

    recordingNumber++;
    
    //end condition here..
    
    
    if (doesWantComprehension) {
         
    
    comprehensionComplete=NO; //set the comprehension as not complete
    }
    
   // NSLog(@"starting new recording")    ;
}

-(void) recordingSessionHasBegun{
    
    if (isVisualizerOn)  //only gets called if the visualizer has been turned on. OTherwise just pause it. 
    
    { 
    if (!elRecorder.recording) { //if elRecorder is not recording...
	 
		elRecorder.meteringEnabled=YES;
        
		++recordingNumber; //this needs to be loaded initially with saved value
		
		NSArray *dirPathsArray = NSSearchPathForDirectoriesInDomains(
                                                                      NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentDir = [dirPathsArray objectAtIndex:0];
		
        NSString *fileNameFromTxt= @"Testing"; //unecessary step, but well leave it for now. 
        
		
		NSString *fixedString=[fileNameFromTxt stringByReplacingOccurrencesOfString:@" " withString:@"_"];
		
		
		NSString*filenameWithDate= [NSString stringWithFormat: @"%@-%i.%@",fixedString ,recordingNumber
                                    , @"caf"];
		
		NSString *soundFilePath = [documentDir stringByAppendingPathComponent:filenameWithDate];
		
		//NSLog(@"soundfilePath is %@", soundFilePath);
		
		//						   stringByAppendingPathComponent:@".caf"];
		
		NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
		
		
      //  NSLog(@"elRecorder URL is %@", soundFilePath);
		
		NSDictionary *recordSettings = [NSDictionary 
										dictionaryWithObjectsAndKeys:
										[NSNumber numberWithInt:AVAudioQualityMin],
										AVEncoderAudioQualityKey,
										[NSNumber numberWithInt:16], 
										AVEncoderBitRateKey,
										[NSNumber numberWithInt: 2], 
										AVNumberOfChannelsKey,
										[NSNumber numberWithFloat:44100.0], 
										AVSampleRateKey,
										nil];
		
		NSError *error = nil;
		if (elRecorder) {
            
            elRecorder=nil;
			//[elRecorder release];
			 
		} else {
		
		elRecorder = [[AVAudioRecorder alloc] //start a new elRecorder
					  initWithURL:soundFileURL
					  settings:recordSettings
					  error:&error];
		elRecorder.meteringEnabled=YES;
            
        }
		if (error)
		{
		//	NSLog(@"error: %@", [error localizedDescription]);
			
		} else { //else no error, then proceed
            
			[elRecorder prepareToRecord];
            
           
            [elRecorder record]; //recording
             
			[visualizer clear];
            
			
		}
		
		
		timer	=[NSTimer scheduledTimerWithTimeInterval:0.05
												target: self
											  selector:@selector(visualizerTimerFired:)
											  userInfo: nil repeats:YES];
        	}
	

    } else {
        [self redordingPaused]; //this gets called to avoid setting up a whole new recording session
        
    }
    
}
-(void) toggleRecordingOnOff{
    
    if (elRecorder.recording ) {
         
        [self enableButtonsIfNotRecordingOrPlaying];
        
        //startButton.titleLabel.text=@"Pause";
        [elRecorder pause];
        
    }
    else {
        
        [elRecorder record];
       // startButton.titleLabel.text=@"Start";
        [self disableButtonsWhileRecordingORPlaying ];
         
    }
    
    
    
    
}

-(void) redordingPaused{
    
     
         
   //just toggles the recorder on or off
    
    if (elRecorder.recording ) {
         
        [elRecorder pause];
         
    }
    else {
         
        [elRecorder record];
        
    }
    
     
}

-(IBAction)stopAndStart:(id)sender{
    
    helpMSGLabel.hidden=NO;
    helpMSGLabel.text=@"Tap on the Last Word";
    
    int recNum =[ recNumbForBool boolValue];
    
    
    if (oneMinModeIsOn==YES) {
        //set custom text to last word
        
       // customText.isLastWord= [NSNumber numberWithBool:YES];
        
    }
    
    
    
    //this method will stop recording or playback dpending on what is going on
    
    if (elPlayer) {
         
    
        
        [elPlayer stop];
        [self invalidateStopWatch];
        
        if (recNum==1) {
            [self invalidateTimer];
        }
        
            }
     
    if (elRecorder) {
         
        [elRecorder stop];
        [self invalidateStopWatch];
        
        if (recNum==1) {
             
            [self invalidateTimer];
         
      }  
        
    }
     
   isTestOn=NO;
    
    
    
}
-(void)redordingSessionHasEnded{
    
   
	//stopBtn.enabled=NO;
	//playBtn.enabled=YES;
	//recButton.enabled=YES;
	if (elRecorder.recording) {
        
		[elRecorder stop];
        //[delegate redordingSessionHasEnded];
        
		
	}else if (elPlayer.playing) {
		
		[elPlayer stop];
        
	}
	if ([timer isValid]) {
		[self invalidateTimer];
	}
    
    [self useTimer:nil];
    
}


#pragma mark playback methods

-(IBAction)requestPlaybackOfLastFile:(id)sender

{
        //stopBtn.enabled=YES;
         
        if (elRecorder.recording) {
           resetButton.enabled=YES;
           startButton.enabled=NO;
            
        }
        
        if (elPlayer)  
            elPlayer=nil;
    
    
        elPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:elRecorderURL error:nil];
		elPlayer.delegate=self;
		
		 		
        [elPlayer prepareToPlay];
        [elPlayer play];
        
        
    if (timer) {
        [timer invalidate];
        timer=nil;
        
    }
        
}
-(void)disableButtonsWhileRecordingORPlaying{
   
    if (playButton.selected) {
         
    
    playButton.enabled=YES;
    }
    
    if (startButton.selected) {
      
    startButton.enabled=YES;
    startButton.titleLabel.text=@"Record";
    }
    //re enable the recording button
	saveButton.enabled=NO; //re enable the saving button
    resetButton.enabled=NO;
    calculateButton.enabled=NO;
    settingsButton.enabled=NO;
    showNotesButton.enabled=NO; 
    startButton.titleLabel.text=@"Pause";
    
}

-(void) enableButtonsIfNotRecordingOrPlaying{
    
    if (!elPlayer.playing ) {
     
        
    playButton.enabled=YES;
    startButton.enabled=YES; //re enable the recording button
	saveButton.enabled=YES; //re enable the saving button
    resetButton.enabled=YES;
    calculateButton.enabled=YES;
    settingsButton.enabled=YES;
    showNotesButton.enabled=YES;
        
    }
    
}


-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag

{
	
    
	if (timer!=nil) {
		
		[self invalidateTimer];
	}
	
	[self enableButtonsIfNotRecordingOrPlaying];
    
    
    
}

-(void) audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
	//NSLog(@"Decode Error occured");
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    [self enableButtonsIfNotRecordingOrPlaying];
    startButton.selected=NO;
     
   // customText.isLastWord=[NSNumber numberWithBool:YES];
    
}

-(void) audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
	//NSLog(@"encode error occured");
	
	
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
     return miscueArray.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
     
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    NSString *wordForCell=[[miscueArray objectAtIndex:indexPath.row] objectForKey:@"Miscue"];
    
                                                         ;
    
    NSNumber *miscueTypeNum=[[miscueArray objectAtIndex:indexPath.row]objectForKey:@"MiscueTypeNumber"];
    NSString *miscueTypeString=@"";
    
    if ([miscueTypeNum intValue]==0){
        //gp
        miscueTypeString=@"gp";
        
        
    } else if ([miscueTypeNum intValue]==1){
        //sm
        miscueTypeString=@"sm";
        
        
    }else if ([miscueTypeNum intValue]==2){
        //sk
        miscueTypeString=@"sk";
        
    }else if ([miscueTypeNum intValue]==3){
        miscueTypeString=@"sc";
        //sc
    }else if ([miscueTypeNum intValue]==4){
        
        //th
        miscueTypeString=@"th";
    }
    
    
    
    
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", wordForCell, miscueTypeString];
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    /* statements here */
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //need to change these
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		//NSLog(@" editingstyle Delete");
		
		[miscueArray removeObjectAtIndex:indexPath.row];
	//	NSLog(@"tempArrayStudent lost an object at indexpath.row!");
		
		//[customText.wordPositionArray removeObjectAtIndex:indexPath.row];//lets test this!!
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
		//NSLog(@"row deleted from data Source");
        
		//[NSKeyedArchiver archiveRootObject:miscueArray toFile:[self archivePath]];
        
    }
    
}


#pragma mark TEXT size +/-
/*
-(IBAction)increaseTextSize:(id)sender{
    
    int currentFontSize = [customText.fontSize intValue];
    
    if (currentFontSize<=MAX_FONT_SIZE) {
        
        //
               int newFontSize=  currentFontSize +4;
        
        NSNumber *numberForFont = [NSNumber numberWithInt:newFontSize];
        
        customText.fontSize = numberForFont;
        
        customText.font = [UIFont fontWithName:@"Gill Sans" size:newFontSize];
        
        
    } else{
                
    }
    
}
-(IBAction)decreaseTextSize:(id)sender{
    
    int currentFontSize = [customText.fontSize intValue];
    
    if (currentFontSize >= MIN_FONT_SIZE) {
        
        int newFontSize=  currentFontSize -4;
        
        NSNumber *numberForFont = [NSNumber numberWithInt:newFontSize];
        
        customText.fontSize = numberForFont;
        
        customText.font = [UIFont fontWithName:@"Gill Sans" size:newFontSize];
                
    } else {
      }
    
}
 
 */
#pragma mark notebook-misuces

-(IBAction)toggleNotesAndMiscues:(id)sender;
{
        //this method will switch views by hiding or showing the miscues table view
    
    if (notesTxtView.hidden==YES) {
       // miscueTableView.hidden=NO;
        NSLog(@"It's hidden,so lets show");
        notesTxtView.hidden=NO;
        [showNotesButton setTitle:@"Hide Notes" forState:UIControlStateNormal];
        showNotesButton.titleLabel.text=@"Show Notes";
    } else {
        NSLog(@"It's shwoing,so lets hide");
        miscueTableView.hidden=YES;
        notesTxtView.hidden=YES;
  [showNotesButton setTitle:@"Show Notes" forState:UIControlStateNormal];
    }
     
}

- (void)keyboardDidShow:(NSNotification *)note 
{
    /* move your views here */
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0,-240,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
        
       // NSLog(@"Do nothting to view, we are in ios 6");
    } else {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0,-200,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
        
       // NSLog(@"adjust the view for ios7");
    }
    
    
    
    
}
- (void)keyboardDidHide:(NSNotification *)note 
{
    /* move your views here */
    
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    
        }else{
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            self.view.frame = CGRectMake(0,60,self.view.frame.size.width,self.view.frame.size.height);
            [UIView commitAnimations];
            
        }
}
 
#pragma mark Get benchmarkForDate

-(NSNumber*) getBenchmarkForDate:(NSDate*)today{
    
      // NSString *path  = [[NSBundle mainBundle] pathForResource:@"FluencyNorms" ofType:@"plist"];
    
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"Benchmarks" ofType:@"plist"];
    
    
    fluencyNormsArray =[[NSMutableArray alloc] initWithContentsOfFile:path];
    
    //get the right grade (item in the array)
    
    
    int value= [gradeLevel intValue]-1;
     
   stringForMMM=@"";
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MMM"];
    
    NSString *myMonthString = [NSString stringWithFormat:@"%@",
                               [dateFormatter stringFromDate:[NSDate date]]];
    
     
    //$$$$$$$$$$$$$$$   Pick   months here $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    
    if ([myMonthString isEqualToString:@"Aug"] ||
        [myMonthString isEqualToString:@"Sep"] ||
        [myMonthString isEqualToString:@"Oct"]||
        [myMonthString isEqualToString:@"Nov"])
    {
        //
        stringForMMM=@"Fall";
       
        
        
    } else if ([myMonthString isEqualToString:@"Dec"] ||
               [myMonthString isEqualToString:@"Jan"] ||
               [myMonthString isEqualToString:@"Feb"]||
               [myMonthString isEqualToString:@"Mar"])
        
    {
        
        stringForMMM=@"Winter";
         
        
        
    } else if
        ([myMonthString isEqualToString:@"Apr"] ||
         [myMonthString isEqualToString:@"May"] ||
         [myMonthString isEqualToString:@"Jun"]||
         [myMonthString isEqualToString:@"Jul"])
        
    {
        
        stringForMMM=@"Spring";
         
        
        
    }
    
    
    if (value!=8) {
        //its not a custom passage         
    
    [ fluencyNormsArray objectAtIndex:value];
    
    
   
    
    //got the season now lets get the right bencmark dict
    
        //$$$$$$$$$$$$$$$$$$$$$$$ Responsible for returning actual Benchmark NUmber $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        
    NSString *benchmarkNumberString=  [[[[fluencyNormsArray objectAtIndex:value] objectForKey:stringForMMM] objectAtIndex:0] objectForKey:@"Benchmark"];
    
    int benchINT= [benchmarkNumberString intValue];
  
   benchmarkForPassageNUM = [NSNumber numberWithInt:benchINT];
        
        aGradeStringForPsg=[NSString stringWithFormat:@"%i", [ gradeLevel intValue]] ;
        
        
                 
    } else {
        
        //what is the grade level of the custom passage?
        for (NSDictionary* dicts in textArray){
            
                        //****** This code is not firing ************
           
            
            if ([[dicts objectForKey:@"Title"] isEqualToString:textTitle]) {
                
                
                  //if so, then what is it?
                 aGradeStringForPsg=[dicts objectForKey:@"Grade"];
                //we get a string, so make int
                int value =[aGradeStringForPsg intValue]; //why is this a string?
                
                
               
                NSString *benchmarkNumberString=  [[[[fluencyNormsArray objectAtIndex:value-1] objectForKey:stringForMMM] objectAtIndex:0] objectForKey:@"Benchmark"];
                
                 
                
                int benchINT= [benchmarkNumberString intValue];
                
                benchmarkForPassageNUM = [NSNumber numberWithInt:benchINT];
                
                return benchmarkForPassageNUM;
        }

      
        
        //if not, pass a neutral value.
        
        benchmarkForPassageNUM = [NSNumber numberWithInt:0];
            
            NSLog (@"No bemcnmark. returning zero");
        
        
      }
    
    }
    
    
    
    return benchmarkForPassageNUM;
    
   
}

#pragma mark Save/Score 


-(void)saveJsonFile:(NSArray*)assmtData{
    
    if ( studentIdNumber!=nil) //need to change value here,
        
    {
        if (doesWantComprehension==YES && comprehensionComplete==NO) {
            
            
            UIAlertView *noComprehensionYetAlertView =[[UIAlertView alloc]
                                                       initWithTitle:@"NO Comprehension?" message:@"You forgot to administer comprehension questions for this record. Do you want to administer now?" delegate:self cancelButtonTitle:@"It's Ok" otherButtonTitles:@"Administer Now",  nil];
            
            [noComprehensionYetAlertView show];
            
            return;
        }
        
        
         [ soundFilePaths addObject:filePath];
        
        
        
        isTestOn=NO;
        
        NSDate *dateNow=[NSDate date];
        
        
        
        id timeTaken =[[assmtData objectAtIndex:assmtData.count-1] objectForKey:@"timetaken"];
        
        totalTimeINT=[timeTaken intValue];
        
        NSNumber *timeRead =[NSNumber numberWithInt:[timeTaken integerValue]];
        
        NSLog(@"timetaken: %i", totalTimeINT);
        
        
        
        NSString *howManyWordsRead= @"";
        
        
        if (miscueArray.count>0) {
            
        
        
        [miscueArray removeAllObjects];
        }
        
       // int selfCorrect=0;
        
        
        for (NSDictionary* aDict in assmtData) {
            
            
            if ([aDict objectForKey:@"word"]) {
                
                if ([[aDict objectForKey:@"type"] isEqualToString:@"l"]) {
                    
                    
                    
                    NSLog(@" value for key 'l' is %@", [aDict objectForKey:@"id"] );
                    
                    howManyWordsRead=[aDict objectForKey:@"id"]  ;
                    
                    
                } else {
                
                NSString*miscString = [aDict objectForKey:@"word"];
                NSString *miscType=[aDict objectForKey:@"type"];
                
                NSDictionary *miscDict =[[NSDictionary alloc]initWithObjectsAndKeys:miscString, @"Miscue", miscType, @"MiscueTypeNumber", nil];
                
                NSLog(@"adding miscue dict: %@", miscDict);
                
                [miscueArray addObject:miscDict];
                    
                }
            }
            
            
         
            
            
            
        } //end for
        
        
        
        
        /*
        for (int m=1;  assmtData.count-3; m++) {
            
            
            if ([[assmtData objectAtIndex:m]objectForKey:@"word"]) {
                //there is a miscue here
                NSLog(@"there is a miscue here to add");
            NSString *miscString = [[assmtData objectAtIndex:m]objectForKey:@"word"];
                
                
            NSString *miscType=[[assmtData objectAtIndex:m]objectForKey:@"type"];
                
                NSDictionary *miscDict =[[NSDictionary alloc]initWithObjectsAndKeys:miscString, @"Miscue", miscType, @"iscueTypeNumber", nil];
                
                [miscueArray addObject:miscDict];
            
            }else {
                NSLog(@"There is no miscue word, so lets create a type");
                
#warning LETS handle these differently;
                
                selfCorrect++;
                
                
                
            }
        
            
            
        }//end for
        
        */
        NSArray *micuesToSave =[[NSArray alloc] initWithArray:miscueArray copyItems:YES ];
        
        
    
    
    if (!comprehensionScore) {
        
        comprehensionScore = [NSNumber numberWithInt:2];
        
        
    }
    
    if (!comprehensionDictionary) {
        
        
        comprehensionDictionary=[[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"This Question is not answered", @"Question1",
                                 @"This Question is not answered", @"Question2",
                                 comprehensionScore, @"Comprehension Score", nil];
        
        
    }
    
    
    
    //lets find how many words they read:
        
    
    
    
    NSString *numberOFwordsNoUnderscore =[howManyWordsRead stringByReplacingOccurrencesOfString:@"word_" withString:@""];
    
   // NSLog(@"New STring without underscore is: %@", numberOFwordsNoUnderscore);
    
    
    wordsReadTotal=[numberOFwordsNoUnderscore intValue];
    
     NSNumber *wordsTotalToSave =[NSNumber numberWithInt:wordsReadTotal+1];
        
        wordsReadTotal++;;
        
    //    NSLog(@"words READ TOTAL: %i", [wordsTotalToSave intValue]);
    
     NSNumber *passageGrdNum=[NSNumber numberWithInt:[aGradeStringForPsg intValue]];
    
    
        
        NSArray *posArray =[[NSArray alloc] init];//empty for now
        
         NSMutableArray*jsonArray= [[NSMutableArray alloc]initWithArray:assmtData];
        
        
        
        [self calculateWithJson];
        
        
        Test *newTest =[[Test alloc] initWithStudenttName:studentReading
                                             passageTitle:textTitle
                                               passageLvl:[NSNumber numberWithInt:passageLvlINT]
                                                benchMark: benchmarkForPassageNUM
                                             passageGrade:passageGrdNum
                                                     date:dateNow
                                                 accuracy:accuracyNumber
                                                  fluency:wordsReadCorrectPerMinNUM
                                                timeInSec:timeRead
                                                   status:testStatusString
                                               miscuesArr:micuesToSave
                                             soundfilePth:filePath
                                  comprehensionDictionary:comprehensionDictionary
                                                wordsRead:wordsTotalToSave
                                            wordPositions:posArray];
        
        
        
 
        [self scoreTest:newTest];
        
        
        if ( doesWantComprehension && isComprehensionPassed && isFluencyPassed ) {
            
            //  testStatusString=@"Benchmark Fluency and Comprehension Passed";
            testStatusString=@"Passed fluency and comprehension";
            
            
        } else if ( doesWantComprehension && !isComprehensionPassed && isFluencyPassed ) {
            
            testStatusString=@"Fluency  Passed; Comprehension Not passed";
            
            
            
        } else if ( doesWantComprehension && isComprehensionPassed && !isFluencyPassed ) {
            
            //  testStatusString=@"Fluency not Passed; Comprehension passed";
            testStatusString=@"Not Passed with Comprehension";
            
            
            
        } else if ( doesWantComprehension && !isComprehensionPassed && !isFluencyPassed ) {
            
            // testStatusString=@"Fluency  Passed; Comprehension not passed";
            testStatusString=@"Fluency  Not Passed; Comprehension not passed";
            
            
            
        }  else if ( !doesWantComprehension && !isFluencyPassed ) {
            
            testStatusString=@"Not passed";
            
            
        } else if ( !doesWantComprehension && isFluencyPassed ) {
            
            testStatusString=@"Passed";
            
            
        } else {
            testStatusString=@"N/A";
            
            
            
        }
        
        
        newTest.testStatus=testStatusString;
        newTest.passageBenchmark=benchmarkForPassageNUM; //update test obj. before archiving
        
        
        
        
        [tests addObject:newTest];
        
        //NSLog(@"TEst have: %@", tests);
        
    
        [self archiveTests];
        
        int indexToReplace =0;
        //find the student by number
        
        for (int i=0; i<self.studentsArray.count; ++i  ) {
            
            
            
            
            NSString *stringToCompare= [[self.studentsArray objectAtIndex:i] studentID] ;
            
            
            
            if ([stringToCompare isEqualToString:studentIdNumber] ) {
                
                //we have a match
                
                //get the index of this student
                indexToReplace=i;
                
            }
            
        }//end for

        
        NSDictionary *assessmentDict= [[NSDictionary alloc]initWithObjectsAndKeys:dateNow, @"TestDate", benchmarkStatusNumber, @"Benchmark", filePath, @"SoundFilePath",   gradeLevel, @"TextGrade", nil ];
        
        
        
        
        //change the status
        
        [self.student.testRecordArray  replaceObjectAtIndex:1 withObject:benchmarkStatusNumber];//put the test status
        
        
      //  NSLog(@"student.testrecord- bnchmrk sts:%i", [[self.student.testRecordArray objectAtIndex:1] intValue]);
        
        
        [[self.student.testRecordArray objectAtIndex:0] addObject:assessmentDict]; //add the dictonary to index 0, which
     //   NSLog(@"Assmt Dict:%@", assessmentDict);
        
        //replace index of student with new student
        
        [self.studentsArray replaceObjectAtIndex:indexToReplace withObject:self.student];
        //archive the whole studentsArray again
        
        
        [self archiveStudents];
        //BAM!! we archive!
        
        
        
        
        
        offlineReportVC= [ self.storyboard instantiateViewControllerWithIdentifier:@"OfflineReport"];
        offlineReportVC.studentInReport=self.student;
        offlineReportVC.studentName=studentReading;
        offlineReportVC.passageTitle=textTitle;
        
        
        
 
        // offlineReportVC.passageText=customText.text;
        offlineReportVC.totalWordsNum=[NSNumber numberWithInt:wordsReadTotal];
        offlineReportVC.errorsNum=[NSNumber numberWithInt:miscuesInt];
        offlineReportVC.aTest=newTest;
        offlineReportVC.studentGradeLevel=gradeLevel;
        offlineReportVC.wordPosArr= jsonArray;
        
        [self.navigationController pushViewController:offlineReportVC animated:YES];
        
        
        
        
    }else {
        
        //  NSLog(@"Test is still on, or student is not set");
    }
    if ([nameLabel.text isEqualToString:@"Touch to Choose Student"]){
        UIAlertView *noStudentSetAlert=[[UIAlertView alloc]initWithTitle:@"No Student is set" message:@"You must choose a student before you save this test, then try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
        
        [noStudentSetAlert show] ;
        
    }
    
 //   NSLog(@"Save JSON FILE");
    
}

-(IBAction)saveFile:(id)sender{
    
    
   //  wordsReadTotal =[customText.wordsInPassage intValue];
    
    
     
    if (isTestOn==NO && studentIdNumber!=nil) //need to change value here,
    
    {
         
        //prompt user to add comprehension if not yet set.... with NSAlert
        if (doesWantComprehension==YES && comprehensionComplete==NO) {
             
            
            UIAlertView *noComprehensionYetAlertView =[[UIAlertView alloc]
                                                       initWithTitle:@"NO Comprehension?" message:@"You forgot to administer comprehension questions for this record. Do you want to administer now?" delegate:self cancelButtonTitle:@"It's Ok" otherButtonTitles:@"Administer Now",  nil];
            
            [noComprehensionYetAlertView show];
            
            return;
        }
         
        if (wordsReadTotal==0 ) {
             
            
            UIAlertView *setLastWordAlert =[[UIAlertView alloc]
                                       initWithTitle:@"Last Word?" message:@"Double tap on the last word read and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:  nil];
            
            [setLastWordAlert show];
            
            
            return;
        }
     
        
         
    [self calculate]; //first we calculate the stuff
        
        
    //saveFile will put the current filePath into the Array
    [ soundFilePaths addObject:filePath];
   ///  NSLog(@" soundFilePaths Array has %i items:", soundFilePaths.count);
      //  NSLog(@"soundfile: %@", filePath   );
    
    //Then it will Archive it into the NSMUtable array that opened at the init
    
    //create a testobject
        //int bnchmrkINT = [benchMarkLabel.text intValue];
      //  NSNumber *benchmarkNUM = [NSNumber numberWithInt:bnchmrkINT]; //Need to change this to grade, to include it in the assessment results
        NSDate *dateNow=[NSDate date];
        
        NSNumber *timeRead =[NSNumber numberWithInt:totalTimeINT];
        NSArray *micuesToSave =[[NSArray alloc] initWithArray:miscueArray copyItems:YES ];
        
        
        if (!comprehensionScore) {
           
            comprehensionScore = [NSNumber numberWithInt:2];
            
            
    }
        //This dict has the compscores already written and set too null
        
        if (!comprehensionDictionary) {
             
        
        comprehensionDictionary=[[NSDictionary alloc] initWithObjectsAndKeys:
                                              @"This Question is not answered", @"Question1",
                                              @"This Question is not answered", @"Question2", 
                                              comprehensionScore, @"Comprehension Score", nil];
        
        
        }
        
        
        NSNumber *wordsTotalToSave =[NSNumber numberWithInt:wordsReadTotal];
        
        NSNumber *passageGrdNum=[NSNumber numberWithInt:[aGradeStringForPsg intValue]];
        
        
        
        //here is how you make the sausage!!
      
        
 
        
        NSArray *posArray =[[NSArray alloc] init];//empty for now
        
                 
        Test *newTest =[[Test alloc] initWithStudenttName:studentReading
                                             passageTitle:textTitle
                                               passageLvl:[NSNumber numberWithInt:passageLvlINT]
                                                benchMark: benchmarkForPassageNUM
                                                passageGrade:passageGrdNum  
                                                     date:dateNow
                                                 accuracy:accuracyNumber
                                                  fluency:wordsReadCorrectPerMinNUM
                                                timeInSec:timeRead
                                                   status:testStatusString
                                               miscuesArr:micuesToSave
                                             soundfilePth:filePath
                                  comprehensionDictionary:comprehensionDictionary
                                                wordsRead:wordsTotalToSave
                                            wordPositions:posArray];
        
      
       
        
        [self scoreTest:newTest];
        
      //  NSLog(@"Sound File Path: %@", filePath);
        
        
        
        //here we build status
        if ( doesWantComprehension && isComprehensionPassed && isFluencyPassed ) {
            
          //  testStatusString=@"Benchmark Fluency and Comprehension Passed";
            testStatusString=@"Passed fluency and comprehension";
             
            
        } else if ( doesWantComprehension && !isComprehensionPassed && isFluencyPassed ) {
            
            testStatusString=@"Fluency  Passed; Comprehension Not passed";
             
             
                         
        } else if ( doesWantComprehension && isComprehensionPassed && !isFluencyPassed ) {
            
          //  testStatusString=@"Fluency not Passed; Comprehension passed";
            testStatusString=@"Not Passed with Comprehension";
            
            
            
        } else if ( doesWantComprehension && !isComprehensionPassed && !isFluencyPassed ) {
            
           // testStatusString=@"Fluency  Passed; Comprehension not passed";
            testStatusString=@"Fluency  Not Passed; Comprehension not passed";
             
             
            
        }  else if ( !doesWantComprehension && !isFluencyPassed ) {
            
            testStatusString=@"Not passed";
             
             
        } else if ( !doesWantComprehension && isFluencyPassed ) {
            
            testStatusString=@"Passed";
             
            
        } else {
            testStatusString=@"N/A";
            
            
            
        }
        
        newTest.testStatus=testStatusString;
        newTest.passageBenchmark=benchmarkForPassageNUM; //update test obj. before archiving

                 
        
        
        [tests addObject:newTest];
        
        //this array holds the positions of all the miscues
        
        
        if (comprehensionComplete==YES || comprehensionComplete==NO) {
             
         
         
            [self archiveTests];
            
            
            int indexToReplace =0;
            //find the student by number
            
            for (int i=0; i<self.studentsArray.count; ++i  ) {
                
                
                
                   
                NSString *stringToCompare= [[self.studentsArray objectAtIndex:i] studentID] ;
                
                
                
                if ([stringToCompare isEqualToString:studentIdNumber] ) {
                    
                    //we have a match
                    
                    //get the index of this student
                    indexToReplace=i;
                     
                }
                
            }
            
            
            
            //add date, benchmark, and sound file path to a dict. 
            NSDictionary *assessmentDict= [[NSDictionary alloc]initWithObjectsAndKeys:dateNow, @"TestDate", benchmarkStatusNumber, @"Benchmark", filePath, @"SoundFilePath",   gradeLevel, @"TextGrade", nil ];
            
             
            
            
            //change the status
             
           [self.student.testRecordArray  replaceObjectAtIndex:1 withObject:benchmarkStatusNumber];//put the test status
            
            
             
             
            [[self.student.testRecordArray objectAtIndex:0] addObject:assessmentDict]; //add the dictonary to index 0, which
            
            
            //replace index of student with new student
             
            [self.studentsArray replaceObjectAtIndex:indexToReplace withObject:self.student];
            //archive the whole studentsArray again
            
           
            
            
            [self archiveStudents];
            //BAM!! we archive!
            
        //now push the Report view...
        
            offlineReportVC= [ self.storyboard instantiateViewControllerWithIdentifier:@"OfflineReport"];
            offlineReportVC.studentInReport=self.student;
            offlineReportVC.studentName=studentReading;
            offlineReportVC.passageTitle=textTitle;
            
            
 
           // offlineReportVC.passageText=customText.text;
            offlineReportVC.totalWordsNum=[NSNumber numberWithInt:wordsReadTotal];
            offlineReportVC.errorsNum=[NSNumber numberWithInt:miscuesInt];
            offlineReportVC.aTest=newTest;
            offlineReportVC.studentGradeLevel=gradeLevel;
            
            [self.navigationController pushViewController:offlineReportVC animated:YES];
            
         //and set the values...
            
            
            
            
     }
    /*then it will prompt you to move to the next level, either lower or higher depending on results  of calc. 
    */
    
   
    
    } else {
        
      //  NSLog(@"Test is still on, or student is not set");
    }
    if ([nameLabel.text isEqualToString:@"Touch to Choose Student"]){
        UIAlertView *noStudentSetAlert=[[UIAlertView alloc]initWithTitle:@"No Student is set" message:@"You must choose a student before you save this test, then try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
        
        [noStudentSetAlert show] ;
        
    }
    
}


-(void)calculateWithJson{
    
    if (!isTestOn) //can only calc. if the test is not running
        
    {
        
        
        miscuesInt= [miscueArray count];
        
       // NSLog(@"MISC Array has: %@", miscueArray);
        
        
         double wordsCorrectDbl = (wordsReadTotal-miscuesInt );
        
      //  NSLog(@"Miscue INT:%i", miscuesInt);
        
        
        double wordsPerMinRead = (wordsReadTotal / totalTimeINT)*60;
        
        
        
     //   NSLog(@"WordsReadTotal: %i, totalTime: %i, Words Per MInute: %f", wordsReadTotal,totalTimeINT, wordsPerMinRead);
        
        
        calcWPMlabel.text= [NSString stringWithFormat:@"%.1lf", wordsPerMinRead];
        double correctPerMinuteRead = (wordsCorrectDbl/totalTimeINT)*60;
         wordsReadCorrectPerMinNUM=[NSNumber numberWithDouble:correctPerMinuteRead];
        
        NSLog(@"Correct WPM %f", correctPerMinuteRead);
        
         double accuracyFloat =( wordsCorrectDbl /wordsReadTotal )*100;
        
        accuracyNumber=[NSNumber numberWithFloat:accuracyFloat];
    }else{
      //  NSLog(@"isTestOn==yes");
    }
    
}


-(void)calculate{
    
//#warning This is where the calculations happen
    
    
    if (!isTestOn) //can only calc. if the test is not running
        
    {
         
        //this method will count miscues
        miscuesInt= [miscueArray count];
        
        
        
        
        double wordsCorrectDbl = (wordsReadTotal-(miscuesInt + skippedWordsINT));
        
        
        //words per minute
        
        //words per minute = (number of words in passage ÷ reading time (in seconds)) x 60
        
        if (minutes>=1) {
            totalTimeINT=  (minutes*60)+seconds;
        } else {
            totalTimeINT=seconds;
        }
        
        //replacing the words count read
        double wordsPerMinRead = (wordsReadTotal / totalTimeINT)*60;
        
        calcWPMlabel.text= [NSString stringWithFormat:@"%.1lf", wordsPerMinRead];
        
        
        // float wordsPerMinRead = (wordCountINT / seconds)*60;
        
        
        double correctPerMinuteRead = (wordsCorrectDbl/totalTimeINT)*60;
                 
        calcCPMLabel.text=[NSString stringWithFormat:@"%.1lf", correctPerMinuteRead];
        wordsReadCorrectPerMinNUM=[NSNumber numberWithDouble:correctPerMinuteRead];
        
        
        double accuracyFloat =( (wordsCorrectDbl-skippedWordsINT) /wordsReadTotal )*100; //replaced wordsCountINT
        
      
        
        
        calcTotalTimeLbl.text=[NSString stringWithFormat:@"%i minutes: %i seconds", minutes, seconds];
        // totalTimeINT=seconds;
        
        calcAccuracyLbl.text = [NSString stringWithFormat:@"%.1lf ", accuracyFloat];
        
        accuracyNumber=[NSNumber numberWithFloat:accuracyFloat];
        
         
        
    }
    
    
    
    
}
-(void) scoreTest:(Test *)aTest{
    NSLog(@"ScoreTest****************ScoreTest**************");
    /*
     
     This method   sets the Benchmark number if the passage is custom or not
     
     It takes in a Test object and evaluates based on the passage fluency benchmarks and determenes whether the studdent is advanced, benchmark, etc. 
      It need an update so it takes into account student's current grade level to see if they are Benchamrk FOR THEIR GRADE LEVEL. 
     
     >> So method should only set the Benchmark NUmber when a test is given at their grade LEVEL OR, if a fluency benchmark is NOT met for a passage below their particular grade level, OR if a passage is read AT or ABOVE the BENCHMRK for a passage ABOVE their grade level. 
     
       It should not SET the BENCHMARK NUM if the student meets benchmark on a test below their current grade level, or fails to meet Benchmark on a test above their grade level. 
    
     Workflow: 
     
     >> get the test object
     
     >> find thisTestFluencyBenchark (whcih actually means this PASSAGE Fluency)
     >> Evaluate Fluency regardless of Grade, and set Benchmark Number ( later we will reset it depending on conditions outlined above.
     >> detemrine whether this test is from their grade level
        >> if yes, then leave benchmark number alone
        >> if no, then look for other conditions
            >> if student is taking below grade level test
                >>if student is below bm on below level test, still below, so status 4
                >> if student is approaching bm on below grade test, still below, status 4
                >> if student is  is above bm on below grade level, set as undertermined...( can this be an option?)
                >> if student is at benchmark on below grade level : set as reading level..but leave bm number as below
            >> if student is taking above grade level test:
                >> if student is advanced or AT bm, set bm as advanced
                >> if student is below bm or approaching, set as undetermined ( can this be a setting?)
     
     */
    //  NSString *comprehensionAssessmentString=@"";
    
   // NSString *fluencyAssessmentString=@"";
    
   // NSString *accuracyAssessmentString=@"";
    
    
    // >> find thisTestFluencyBenchark (whcih actually means this PASSAGE Fluency)
     thisTestFluencyBenchmark= [self getBenchmarkForDate:[NSDate date]];
    
    
    // set isFluencyPassed BOOL to NO intially
    
    isFluencyPassed=NO;
    
    //EVALUTATE FLUENCY...
    //compare date month benchmark with actual date to determine actual  mastery...
    
    
    
    float fluencyFloat = [aTest.fluency floatValue]; //benchmark float
    
    NSLog(@"FLUENCY FLOAT: %f", fluencyFloat);
    
    //got the season now lets get the right bencmark dict
    
     if ([gradeLevel intValue] !=9) // if not a custom passage
     {
        
        
        // NSLog(@"Scoring a REgular passage");
        NSString *advString=  [[[[fluencyNormsArray objectAtIndex:[gradeLevel intValue]-1] objectForKey:stringForMMM] objectAtIndex:0] objectForKey:@"Above"];
        
        float advancedFloat = [advString floatValue];
        
        
        NSString *apprString=  [[[[fluencyNormsArray objectAtIndex:[gradeLevel intValue]-1] objectForKey:stringForMMM] objectAtIndex:0] objectForKey:@"Approaching"];
        float approachingFloat = [apprString floatValue];
        
        
        
        
        if (fluencyFloat>=advancedFloat){
            benchmarkStatusNumber=[NSNumber numberWithInt:1];
            
        } else if (fluencyFloat < advancedFloat && fluencyFloat>= [thisTestFluencyBenchmark floatValue]){
             
            benchmarkStatusNumber=[NSNumber numberWithInt:2];
            
        } else if   (fluencyFloat<[thisTestFluencyBenchmark floatValue]&& fluencyFloat>= approachingFloat){
            
             
            benchmarkStatusNumber=[NSNumber numberWithInt:3];
            
        } else if   ( fluencyFloat< approachingFloat && fluencyFloat >=0.0f) {
            
            
            benchmarkStatusNumber=[NSNumber numberWithInt:4];
        } else{
            
            
            
            benchmarkStatusNumber=[NSNumber numberWithInt:5];
        }
         
          
        
    } else {
        
       //benchmarkStatusNumber=[NSNumber numberWithInt:5];
        
        //use the grade of the passage to determine the benchmark, can't use gradeLevel like in non-custom passgs, so we try again. 
        
        
        NSNumber *passageGrdNum=[NSNumber numberWithInt:[aGradeStringForPsg intValue]];
        
        NSString *advString=  [[[[fluencyNormsArray objectAtIndex:[passageGrdNum intValue]-1] objectForKey:stringForMMM] objectAtIndex:0] objectForKey:@"Above"];
        
        float advancedFloat = [advString floatValue];
        
        
        NSString *apprString=  [[[[fluencyNormsArray objectAtIndex:[passageGrdNum intValue]-1] objectForKey:stringForMMM] objectAtIndex:0] objectForKey:@"Approaching"];
        float approachingFloat = [apprString floatValue];
        
        
       // NSLog(@"FLUENCY FLOAT: %f", fluencyFloat);
        
        if (fluencyFloat>=advancedFloat){
            benchmarkStatusNumber=[NSNumber numberWithInt:1];
            
        } else if (fluencyFloat < advancedFloat && fluencyFloat>= [thisTestFluencyBenchmark floatValue]){
            
            benchmarkStatusNumber=[NSNumber numberWithInt:2];
            
        } else if   (fluencyFloat<[thisTestFluencyBenchmark floatValue]&& fluencyFloat>= approachingFloat){
            
            
            benchmarkStatusNumber=[NSNumber numberWithInt:3];
            
        } else if   ( fluencyFloat< approachingFloat && fluencyFloat >=0.0f) {
             
            
            benchmarkStatusNumber=[NSNumber numberWithInt:4];
        } else{
            
            
           //Benchmark Unavailable");
            benchmarkStatusNumber=[NSNumber numberWithInt:5];
        }
        
        
    }//end  else
    
    //>> detemrine whether this test is from their grade level
    if ([gradeLevel intValue]!=[[self.student grade] intValue]) {
         
        
         // >> if student is taking below grade level test
        if ([gradeLevel intValue]< [[self.student grade] intValue]) {
            
             
            if ([benchmarkStatusNumber intValue] ==4 || [benchmarkStatusNumber intValue]==3 ) {
                
                
                benchmarkStatusNumber=[NSNumber numberWithInt:4];//set to below
                
            } else if ([benchmarkStatusNumber intValue] ==1  ){
                
                benchmarkStatusNumber=[NSNumber numberWithInt:5];
                
            }else if ([benchmarkStatusNumber intValue] ==2  ){
                
                
                benchmarkStatusNumber=[NSNumber numberWithInt:4];
                
            } else {
                  benchmarkStatusNumber=[NSNumber numberWithInt:5];
                 
                
            }
            
            
            /* if student is taking above grade level test:
             
             >> if student is below bm or approaching, set as undetermined ( can this be a setting?)
             */
        } else if ([gradeLevel intValue]> [[self.student grade] intValue]   ){
             
            
            //>> if student is advanced or AT bm, set bm as advanced
            if ([benchmarkStatusNumber intValue] ==1 || [benchmarkStatusNumber intValue]==2 ) {
                benchmarkStatusNumber=[NSNumber numberWithInt:1];
                 
                
            }else if ([benchmarkStatusNumber intValue] ==3 || [benchmarkStatusNumber intValue] ==4  ){
                
                 
                benchmarkStatusNumber=[NSNumber numberWithInt:5];
                
            }
            
        }
        
        
        
        
    }
    
     
      
    
      
       
    /*
    
    int value2=[benchmarkStatusNumber intValue];
    NSString *compString =@"";
    
    
    switch (value2) {
        case 1:
            compString =[NSString stringWithFormat:
                         @"Sorry, Student got %f CWPM, but needed %f to meet benchmark for fluency",
                         [aTest.fluency floatValue], [thisTestFluencyBenchmark floatValue]];
            
            fluencyAssessmentString=compString;
            
            // [aTest.fluency floatValue], [thisTestFluencyBenchmark floatValue];
             
            
            isFluencyPassed=NO;
            break;
        case 2:
            compString =[NSString stringWithFormat:
                         @"Sorry, Student got %f CWPM, but needed %f to meet benchmark for fluency",
                         [aTest.fluency floatValue], [thisTestFluencyBenchmark floatValue]];
            
            fluencyAssessmentString=compString;
            
            // [aTest.fluency floatValue], [thisTestFluencyBenchmark floatValue];
            
            
            isFluencyPassed=NO;
            break;
            
        case 3:
            compString =[NSString stringWithFormat:
                         @"Sorry, Student got %f CWPM, but needed %f to meet benchmark for fluency",
                         [aTest.fluency floatValue], [thisTestFluencyBenchmark floatValue]];
            
            fluencyAssessmentString=compString;
            
            // [aTest.fluency floatValue], [thisTestFluencyBenchmark floatValue];
             
            
            isFluencyPassed=NO;
            
            break;
        case 4:
            compString =[NSString stringWithFormat:
                         @"Sorry, Student got %f CWPM, but needed %f to meet benchmark for fluency",
                         [aTest.fluency floatValue], [thisTestFluencyBenchmark floatValue]];
            
            fluencyAssessmentString=compString;
            
            // [aTest.fluency floatValue], [thisTestFluencyBenchmark floatValue];
            
            
            isFluencyPassed=NO;
            break;
            
        case 5:
            compString =[NSString stringWithFormat:
                         @"The Benchmark for this passage has not be set"],
            
            
            fluencyAssessmentString=compString;
            
            // [aTest.fluency floatValue], [thisTestFluencyBenchmark floatValue];
            
            
            isFluencyPassed=NO;
            break;
        default:
            break;
    }
    
    
    
    if ([thisTestFluencyBenchmark floatValue] >= fluencyFloat) {
        
        //if the benchmark is greater than student's achived score, then they have not met accuracy goal...
        
        
        NSString *compString =[NSString stringWithFormat:
                               @"Sorry, Student got %f CWPM, but needed %f to meet benchmark for fluency",
                               [aTest.fluency floatValue], [thisTestFluencyBenchmark floatValue]];
        
        fluencyAssessmentString=compString;
        
        // [aTest.fluency floatValue], [thisTestFluencyBenchmark floatValue];
         
        
        isFluencyPassed=NO;
        
        
    } else {
        NSString *compString =[NSString stringWithFormat:
                               @"Good Job! Student got %f CWPM, and met %f to meet benchmark for fluency",
                               [aTest.fluency floatValue], [thisTestFluencyBenchmark floatValue]];
        fluencyAssessmentString=compString;
        
        isFluencyPassed=YES;
        
         
    }
    
    
    //EVALUATE ACCURACY...
    
    
    
    
    double studentAccuracyDouble=[aTest.accuracy doubleValue]; //what the student got on the test for Accuracy %
    
    
    if (studentAccuracyDouble >= 95){
        
         
        
        accuracyAssessmentString=@"Independent";
        
        
        
    }else if (studentAccuracyDouble <= 95 && studentAccuracyDouble>= 90)
    {
        
        
        accuracyAssessmentString=@"Instructional";
        
        
        
        
    } else {
        
        
         
        accuracyAssessmentString=@"Frustration";
    }
    
    
    */
        
    NSLog(@"BENCHMARK STATuS ####: %i", [benchmarkStatusNumber intValue]);
    
    saveButton.enabled=YES;   
    
}

-(IBAction)showCompQuestinos:(id)sender{
    
    
    if (doesWantComprehension==YES) {
        
         
        /*
         
         compQuestionsVC=[[RRCurlPageVC   alloc] initWithNibName:@"RRCurlPageVC" bundle:[NSBundle mainBundle ]];
         
         */
        
        
        
        for (NSDictionary* dicts in textArray){
            
            
            if ([[dicts objectForKey:@"Title"] isEqualToString:textTitle]) {
                //compQuestionsVC.question1Label.text=[dicts objectForKey:@"Comp1"];
                // compQuestionsVC.question2Label.text=[dicts objectForKey:@"Comp2"];
                compQuestionsVC=[self.storyboard instantiateViewControllerWithIdentifier:@"comprehension"];
                
                compQuestionsVC.delegate=self;
                
                //
                
                
                
                
                compQuestionsVC.question1 =[dicts objectForKey:@"Comp1"];
                compQuestionsVC.question2 =[dicts objectForKey:@"Comp2"];
                compQuestionsVC.question3 =[dicts objectForKey:@"Comp3"];
                
                
                
                compPopover=[[UIPopoverController alloc] initWithContentViewController:compQuestionsVC];
                
                compPopover.delegate=self;
                [compPopover presentPopoverFromRect:[showCompButton frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                
            }
            
        }//end for
        
        
        
    }
}




#pragma mark archive Paths

-(NSString *) testArchivePath{
    
    NSString *docDirect = 
	[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES	) objectAtIndex:0];
	return [docDirect stringByAppendingPathComponent:@"Tests.dat"];
    
}
-(void) archiveTests{
    
    [NSKeyedArchiver archiveRootObject:tests toFile:[self testArchivePath]];
     
    NSLog(@"Archiving Tests");
}

-(NSString *) studentsArchivePath{
     
    NSString *docDirect =
	[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES	) objectAtIndex:0];
	return [docDirect stringByAppendingPathComponent:@"Students.dat"];
    
}
-(void) archiveStudents{
    
         
    [NSKeyedArchiver archiveRootObject:self.studentsArray toFile:[self studentsArchivePath]];
    
     
    
}
 

#pragma  mark prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    
    if ([segue.identifier isEqualToString:@"Comprehension"]) {
        
        
        for (NSDictionary* dicts in textArray){
            
            
            if ([[dicts objectForKey:@"Title"] isEqualToString:textTitle]) {
                /*
                compQuestionsVC.question1Label.text=[dicts objectForKey:@"Comp1"];
                compQuestionsVC.question2Label.text=[dicts objectForKey:@"Comp2"];
                */
               
                [segue.destinationViewController setQuestion1:[dicts objectForKey:@"Comp1"]];
                [segue.destinationViewController setQuestion1:[dicts objectForKey:@"Comp2"]];
            }
            
        }//end for
        
        
        
        
    } else if ([segue.identifier isEqualToString:@"OfflineReport"]) {
        
        //first perform selector to calculate
        
        [self performSelector:@selector(calculate:)];
        
        
        //set the report
        //[segue.destinationViewController setTeacher:passageTitleLabel.text ];
        
        [segue.destinationViewController setStudentName:studentReading];
        
        [segue.destinationViewController setPassageTitle:textTitle];
        
        
        
 
        
        NSString*textForOfflineReport = @"text" ;
        [segue.destinationViewController setPassageText:textForOfflineReport];
        
        
       // [segue.destinationViewController setStudentInReport:self.student];
        
        [segue.destinationViewController setTotalWordsNum:[NSNumber numberWithInt:wordsReadTotal]];
        
        
        [segue.destinationViewController setBnchNUM:benchmarkForPassageNUM];
        
        [segue.destinationViewController setErrorsNum:[NSNumber numberWithInt:miscuesInt] ];
        
        
        if (isTestOn==NO) {
            
            
            
            
            /*prompt user to add comprehension if not yet set.... with NSAlert
            if (doesWantComprehension==YES && comprehensionComplete==NO) {
                
                
                UIAlertView *noComprehensionYetAlertView =[[UIAlertView alloc]
                                                           initWithTitle:@"NO Comprehension?" message:@"You forgot to administer comprehension questions for this record. Do you want to administer now?" delegate:self cancelButtonTitle:@"It's Ok" otherButtonTitles:@"Administer Now",  nil];
                
                [noComprehensionYetAlertView show];
                
               // return;
            }
            
            */
            /*
            //saveFile will put the current filePath into the Array
            [ soundFilePaths addObject:filePath];
            NSLog(@" soundFilePaths Array has %i items:", soundFilePaths.count);
            
            //Then it will Archive it into the NSMUtable array that opened at the init
            
            //create a testobject
            int bnchmrkINT = [benchMarkLabel.text intValue];
            NSNumber *benchmarkNUM = [NSNumber numberWithInt:bnchmrkINT];
            NSDate *dateNow=[NSDate date];
            NSLog(@"date %@", dateNow);
            NSNumber *timeRead =[NSNumber numberWithInt:totalTimeINT];
            NSArray *micuesToSave =[[NSArray alloc] initWithArray:miscueArray copyItems:YES ];
            
            
            if (!comprehensionScore) {
                
                
                
                comprehensionScore = [NSNumber numberWithInt:2];
                
                
            }
            //This dict has the compscores already written and set too null
            
            if (!comprehensionDictionary) {
                
                
                comprehensionDictionary=[[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"This Question is not answered", @"Question1",
                                         @"This Question is not answered", @"Question2",
                                         comprehensionScore, @"Comprehension Score", nil];
                
                
            }
            
            //here is how you make the sausage!!
            NSLog(@"Creating new Test object");
            
             Test *newTest =[[Test alloc] initWithStudenttName:studentReading passageTitle:textTitle passageLvl:[NSNumber numberWithInt:passageLvlINT] benchMark: benchmarkNUM date:dateNow accuracy:accuracyNumber fluency:wordsReadCorrectPerMinNUM timeInSec:timeRead status:testStatusString miscuesArr:micuesToSave soundfilePth:filePath comprehensionDictionary:comprehensionDictionary ];
            
            
            NSLog(@"add object to testArray done");
            
            
            [self scoreTest:newTest]; //This needs to be done elsewhere, probably...unless we want to save it...
            
            NSLog(@"will add object to testArray...");
            [tests addObject:newTest];
             
            [segue.destinationViewController setATest:newTest ];
            
            */
           // NSArray *posArray =customText.wordPositionArray;//this array holds the positions of all the miscues
            
            
            
          //  [self archiveTests];
            
            if (comprehensionComplete==YES) {
                
                
                
                //[self archiveTests]; //BAM!! we archive!
            }
            /*then it will prompt you to move to the next level, either lower or higher depending on results  of calc. 
             */
            
            
            
        }

          
        
        
    }
    
    
    
}




- (void)viewDidUnload
{
    elPlayer=nil;
	elRecorder=nil;
    [self setStudentsArray:nil];
    [self setNameLabel:nil];
    [self setPassageTitleLabel:nil];
    [self setWordCountLabel:nil];
    [self setBenchMarkLabel:nil];
    [self setPassageLvlLabel:nil];
    [self setStartButton:nil];
    [self setResetButton:nil];
    [self setSaveButton:nil];
    [self setStopWatchView:nil];
    [self setMiscueTableView:nil];
    [self setNotesTxtView:nil];
    [self setTimerLabel:nil];
     
    //[self miscueArray:nil];
   // [self setPlusTextSize:nil];
  //  [self setMinusTextSizeBtn:nil];
    [self setShowNotesButton:nil];
    [self setCalcMiscueCountLBL:nil];
    [self setCalcSkippedCountLBL:nil];
    [self setCalcSelfCorrecLbl:nil];
    [self setCalcWithHelpLbl:nil];
    [self setCalcTotalTimeLbl:nil];
    [self setCalcWPMlabel:nil];
    [self setCalcCPMLabel:nil];
    [self setCalcAccuracyLbl:nil];
    [self setStopWatchOptionSegment:nil];
    [self setStudentIdNumber:nil];
    [self setHelpMSGLabel:nil];
    
    [self setStudent:nil];
    
     
    [self setHelpMSGLabel:nil];
    [self setPassageGrdLbl:nil];
    [self setTimerCompOptionLBL:nil];
    [self setHelpOverlayImg:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void) StudentsListVCDidFinishWithStudent:(NSString *)nm lastName:(NSString*)lm  grade:(NSString *) gr  teacher: (NSString *)tchr  level: (NSString *) lv  notes: (NSString *) nts array: (NSMutableArray*)tstArr andGroups:(NSMutableArray *)grpsArr{
    
    
}
-(void) compQuestionsDidFinishWithQuestions:(NSNumber*)score q1Text:(NSString*) question1Text q2text:(NSString*) question2Text q3text:(NSString*)question3Text{
    
    
    
    comprehensionDictionary=[[NSDictionary alloc] initWithObjectsAndKeys:score, @"TotalScore",
                             question1Text, @"Question1Text",
                             question2Text, @"Question2Text",
                             question3Text, @"Question3Text", nil];
    
     
    [self.compPopover dismissPopoverAnimated:YES];
    
    comprehensionComplete=YES;
    
    
    
    if ([score intValue]>=2) {
        isComprehensionPassed=YES;
        
    }else {
        
        isComprehensionPassed=NO;
         
    }
    
    
    
    
    
}
-(void) compQuestionsDidCancel{
    
    [self.compPopover dismissPopoverAnimated:YES];

    
}



-(IBAction)goback:(id)sender{
    
    
    
    
    if (isTestOn==YES) { //if test is on then prompt user if they are sure...
        
         
        UIAlertView *goBackAlert =[[UIAlertView alloc] initWithTitle:@"Go Back" message:@"Are you sure? This session will not be saved" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Return Home", nil];
        
        [goBackAlert show];
        
        
        
        isTestOn=NO;
    } else {
        //set all things to zero before leaving...
        
        
        
        
        [self.view removeFromSuperview];
    }
    
    
}



- (IBAction)showHideMoreInfo:(id)sender {
    
    
    if (moreInfoisHiding) {
        
    
        
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void) {
                             [_moreInfoView setFrame:CGRectMake(_moreInfoView.frame.origin.x, _moreInfoView.frame.origin.y+60, _moreInfoView.frame.size.width, _moreInfoView.frame.size.height)];
                         }
                         completion:^(BOOL finished){
                         }];
        moreInfoisHiding=NO;
    
    
    } else{
        
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void) {
                             [_moreInfoView setFrame:CGRectMake(_moreInfoView.frame.origin.x, _moreInfoView.frame.origin.y-60, _moreInfoView.frame.size.width, _moreInfoView.frame.size.height)];
                         }
                         completion:^(BOOL finished){
                         }];
        moreInfoisHiding=YES;
        
    }
    
    
    
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex
{
	
	NSString *buttonTitleOfAlert = [alertView buttonTitleAtIndex:buttonIndex];
	if ([buttonTitleOfAlert isEqualToString:@"Return Home"]) 
	{
        //run all the code to end the test and not leave any loose ends...
        
        if (timer) {
            [timer invalidate];
            timer=nil;
        }
        if (stopWatch) {
            [stopWatch invalidate];
            stopWatch=nil;
        }
        
        isTestOn=NO;
        
		[self.view removeFromSuperview];
		
	} else if ([buttonTitleOfAlert isEqualToString:@"Administer Now"]){
        
        
        [self showCompQuestinos:nil];
         
        
        
        
    } else if([buttonTitleOfAlert isEqualToString:@"Ignore"])
    {
        
        comprehensionComplete=YES;
        
    }
	  
	
    
    else {
        
        return;   
    }
	
}



@end 