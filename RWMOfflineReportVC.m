   //
//  RWMOfflineReportVC.m
//  RWMStudent
//
//  Created by Francisco Salazar on 11/4/12.
//
// 
//A passageText will be nil in View did load if the report is loaded from the individual student screen
//if (passageText==nil) then we search for title-- in Custom texts from unarchived array.



#import "RWMOfflineReportVC.h"

@interface RWMOfflineReportVC ()

@end

@implementation RWMOfflineReportVC
@synthesize passageText;
@synthesize  passageTitle, studentName;
@synthesize dateLabel;
@synthesize feedbackBenchmarkLbl, feedbackReadingLbl;
@synthesize calcAccuracyLbl, calcCPMLabel, calcMiscueCountLBL, calcSelfCorrecLbl, calcSkippedCountLBL, calcTotalTimeLbl, calcWithHelpLbl, calcWPMlabel;
@synthesize aWebView;

@synthesize aTest;
@synthesize textForReport;
@synthesize studentNameLbl, passageTitleLbl;
@synthesize errorsNum, totalWordsNum;
@synthesize studentGradeLevel, passageGradeLevel;
@synthesize errorBoxTextView;
@synthesize textArray;
@synthesize studentInReport=_studentInReport;
@synthesize levelLbl;
@synthesize miscuesView,showMiscuesBtn, launchNextBtn;
@synthesize benchmarkReachedLbl, bnchNUM;
@synthesize wordsReadLbl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad


{
    miscuesView.hidden=YES;
    
    aWebView.delegate=self;
    launchNextBtn.hidden=YES;//will activate in update
    
     self.navigationController.title=@"Individual Student Record";
    passageTitleLbl.text=aTest.passageTitle;
    
   // NSLog(@"Loading View with passageTitle=%@", aTest.passageTitle);
    
    
    int benchmrkINT = [[self.studentInReport.testRecordArray objectAtIndex:1]  intValue];
   // NSLog(@"benchmarkINT = %i", benchmrkINT);
    
    NSString *benchmarkString =@"";
    
    if (benchmrkINT==0 || benchmrkINT==5) {
        benchmarkString =@"Benchmark: Unvailable";
    } else if (benchmrkINT==1){
        
        benchmarkString =@"Benchmark: ADVANCED";
        
    } else if (benchmrkINT==2){
        
         benchmarkString =@"Benchmark: AT BENCHMARK";
    } else if (benchmrkINT==3){
        
        benchmarkString =@"Benchmark: APPROACHING";
    } else if (benchmrkINT==4) {
         benchmarkString =@"Benchmark: BELOW";
        
    }
    
    
    studentNameLbl.text=[NSString stringWithFormat:@"%@ -- %@", studentName, benchmarkString];
    //studentNameLbl.text=studentName;
    wordsReadLbl.text=[NSString stringWithFormat:@"%i", [aTest.wordsReadTotal intValue]];
    
    
    
    
  //  [self unarchiveTests];
    
  //  passageTitleLbl.text=passageTitle;
    
  //  NSString *textToDisplay =passageText;
    
    
  //  NSString *path =[[NSBundle mainBundle] pathForResource:@"taggedText" ofType:@"js"];
    //NSString *path =[[NSBundle mainBundle] pathForResource:@"formatForText" ofType:@"html"];
    NSString *path =[[NSBundle mainBundle] pathForResource:@"formatForText" ofType:@"html"];
    
    
    NSURL *instructionsURL = [NSURL fileURLWithPath:path];
	[aWebView loadRequest:[NSURLRequest requestWithURL:instructionsURL]];
    
    
    
    
     float accuracyFloat= [self.aTest.accuracy floatValue];
    
     
    calcAccuracyLbl.text =[NSString stringWithFormat:@"%.0f ", accuracyFloat];
    
  //  (wordsCorrectDbl/totalTimeINT)*60;
    
    
    double correctPerMinuteRead = [self.aTest.fluency floatValue];
    
    calcCPMLabel.text=[NSString stringWithFormat:@"%.0f ", correctPerMinuteRead];
    
    int timeINT =[self.aTest.time intValue];
    
    
    minutes = (timeINT % 3600) / 60;
    seconds= (timeINT %3600) % 60;
    
    
    // NSLog(@"timerFired %i", newCount);
    calcTotalTimeLbl.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    
    
    
    
    calcMiscueCountLBL.text=[errorsNum stringValue];
    
    
    
    calcWPMlabel.text=[totalWordsNum stringValue]; //this is currently returning zero
    
     
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
     NSString *dateToDisplay=[formatter stringFromDate:self.aTest.testDate];
    
    dateLabel.text=dateToDisplay;
     NSString *stringLevel=@"N/A";
    
    
    //Change level depending if level is string or number
    if ([aTest.passageLevel isKindOfClass:[NSNumber class]]) {
        
        stringLevel=[NSString stringWithFormat:@"%i", [aTest.passageLevel intValue]];
        
        
        
    } else if ([aTest.passageLevel isKindOfClass:[NSString class]]){
         stringLevel=aTest.passageLevel;
        
    }
    
    
    if ([stringLevel isEqualToString:@"0"]) {
        stringLevel=@"N/A";
    }
    
    
    levelLbl.text=stringLevel;
    
    int wrdsRD=[aTest.wordsReadTotal intValue];
    calcWPMlabel.text=[NSString stringWithFormat:@"%i", wrdsRD];
    
    
    
	// Do any additional setup after loading the view.
    
    
    
    
    [self scoreTest:aTest];
    passageText=  [self passageFromIndividualStudentFromGrade:aTest.passageGrade];
    
   // NSLog(@"What is the text? %@", passageText);
    
    if (passageText==nil || [passageText isEqualToString:@""]){
        
        calcMiscueCountLBL.text=[NSString stringWithFormat:@"%i", aTest.testTypeArray.count];
                //then go find the freking text
        
        
        
        NSMutableArray*customPsgsArr=[[NSMutableArray alloc ] initWithContentsOfFile:[self filePathForCustomPsg]];
        
       // NSLog(@"CUSTOMPSGARR: %@", customPsgsArr)  ;
        
        if (customPsgsArr.count !=0) {
             
            
        for (NSDictionary* dicts in customPsgsArr){
            
         //   NSLog(@"aTest.passgeTitle=%@", aTest.passageTitle);
            
            if ([[dicts objectForKey:@"Title"] isEqualToString:aTest.passageTitle]) {
        
        //if it's not there, then it has to be a regular passage, so let's find it by grade
                 
                
             //  NSLog(@"WTF");

                //let's get the text
                self.passageText=[dicts objectForKey:@"Text"];
              //  NSLog(@"passgaText: %@", passageText);
                
        
            } //end if
            
            else {
                
             //   NSLog(@"Custom passge not found");
                
                
                
            } //end else 
              
                
                
                
            } //end for
            
            
            // passageText=  [self passageFromIndividualStudentFromGrade:aTest.passageGrade];
        }//end if
        
       // passageText=  [self passageFromIndividualStudentFromGrade:aTest.passageGrade];
    }//end if
    
    
    
    
    
    
    
    

    [super viewDidLoad];
    
}




-(NSString*)passageFromIndividualStudentFromGrade:(NSNumber*)gradeToFind {
    
    NSString*gradeLevelToUnarchiveString=@"";
    NSString*path=@"";
     NSString *stringToReturn=@"";
    
    int grd = [gradeToFind intValue]; //this number comes fromt the indexPath.row in the superview.
    
   // NSLog(@"int Grd:%i", grd)   ;
    
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
        
                 
        stringToReturn=@"Error: Text not found!";
    }
    
     
    
   NSMutableArray *regularTextArray=[[NSMutableArray alloc] initWithContentsOfFile:path];
    
    
    
    //now go through the regular text array and find the title...
    
    
    for (NSDictionary *dict in regularTextArray) {
        
        
        if ([[dict objectForKey:@"Title"] isEqualToString:aTest.passageTitle]) {
            
            
           
            
            stringToReturn=[dict objectForKey:@"Text"];
        
           

            
        } else{
            
       //     NSLog(@"Text not found in reg. text array");
        }
        
        
        
        
    }
    regularTextArray=nil;
    
    return  stringToReturn;
}


-(void) textForPassage:(NSString*)aGrade{
    
   
    if ([aGrade isEqualToString:@"n/a"]) {
        
        
         
        
        for (NSDictionary* dicts in textArray){
            
                        if ([[dicts objectForKey:@"Title"] isEqualToString:aTest.passageTitle]) {
                
                passageText=[dicts objectForKey:@"Text"];
                
                 
                
                
                
            }
            
        }
        
    }
    
    else{
    NSString *path = [[NSBundle mainBundle] pathForResource:aGrade ofType:@"plist"];
    if (!textArray) {
        
        
        textArray=[[NSMutableArray alloc] initWithContentsOfFile:path];
        
        
        
    }
    
    
        
    
     }
    
    
    
     
    
    
}

-(NSString*)filePathForCustomPsg {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"CustomPassages.plist"];
    //NSLog(@"Looking for a Custom passage");
    
    return plistPath;
    
    
}

-(void) unarchiveTests{
   
    NSString * gradeLevelToUnarchiveString=@"";
     
    int value = [passageGradeLevel intValue];
    
    
    
    
    switch (value)
    {
        case 1:
            gradeLevelToUnarchiveString=@"1stGradePassages";
        break;
        case 2:
            gradeLevelToUnarchiveString=@"2ndGradePassages";
        break;
        case 3:
            gradeLevelToUnarchiveString=@"3rdGradePassages";
        break;
        case 4:
            gradeLevelToUnarchiveString=@"4thGradePassages";
        break;
        case 5:
            gradeLevelToUnarchiveString=@"5thGradePassages";
        break;
        case 6:
            gradeLevelToUnarchiveString=@"6thGradePassages";
        break;
        case 7:
             gradeLevelToUnarchiveString=@"7thGradePassages";
            
            break;
            
        case 8:
             gradeLevelToUnarchiveString=@"8thGradePassages";
            break;
            
    default:
            
            gradeLevelToUnarchiveString=@"n/a";
         
        break;
    }
    
    
            
        [self textForPassage:gradeLevelToUnarchiveString];
        
    
         
    
    
}

#pragma mark delegate web view
-(void)webViewDidFinishLoad:(UIWebView *)webView   {
    
   NSString *newTestString= [passageText stringByReplacingOccurrencesOfString:@"\'" withString:@",,q,,"];

   // NSLog(@"PassageText: %@", passageText);
    //  NSScanner *aScanner = [NSScanner scannerWithString:passageText];
    
    NSMutableString *mutatedString = [[NSMutableString alloc]initWithString:newTestString];//instead of passage text
    
    
    
    NSCharacterSet *newLinesBrakes =[NSCharacterSet newlineCharacterSet];
    
    
    
    
    NSString *reformattedString =[[mutatedString componentsSeparatedByCharactersInSet:newLinesBrakes] componentsJoinedByString:@",,n,,"];
    
    
    
    //trying out this new code!
    
    
  //  [reformattedString stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
    
    
    /*
    
    int subtractedValue=1;
    NSMutableArray *tempArray=[[NSMutableArray alloc]initWithCapacity:_wordPosArr.count];
    
    for (int i=0; i <_wordPosArr.count ; i++) {
        
        subtractedValue=[[_wordPosArr objectAtIndex:i]  intValue]-1;
        
        [tempArray addObject:[NSNumber numberWithInt:subtractedValue]];
        
        
    }
    
     
     */
    NSMutableArray *aTempArr=[[NSMutableArray alloc]initWithCapacity:_wordPosArr.count];
    for (NSDictionary *aDict in _wordPosArr) {
        
        
        if ([aDict objectForKey:@"id"]) {
            
            if ([[aDict objectForKey:@"type"] isEqualToString:@"l"]) {
                
           //     NSLog(@"OOPS, its the last word");
                
            }else{
            
       //     NSLog(@"A word in array: %@", [aDict objectForKey:@"id"]);
            
            NSString *miscueToFormat=[aDict objectForKey:@"id"];
            
          NSString *miscueStringNoUnderscore=  [miscueToFormat stringByReplacingOccurrencesOfString:@"word_" withString:@""];
            
            [aTempArr addObject:miscueStringNoUnderscore];
                
            }
            
        }
        
        
    }
    
  //  NSString *mystring = [[aTempArr valueForKey:@"description"] componentsSeparatedByString:@"," ];
    
     NSString* mystring = [[aTempArr valueForKey:@"description"] componentsJoinedByString:@","];
    
  //  NSLog(@"My string: %@", mystring);
    
    
    NSString *jsCommand=[NSString stringWithFormat:@"formatText('passagetext', '%@', [%@]);" , reformattedString, mystring];
    
    
    
    [aWebView stringByEvaluatingJavaScriptFromString: jsCommand];
    
    
     
    
    
}




- (IBAction)showMiscues:(id)sender {
    showMiscuesBtn.titleLabel.text=@"Hide Miscues";
     
   
    
    if (miscuesView.hidden==YES) {
         
     
    miscuesView.hidden=NO;
        showMiscuesBtn.titleLabel.text=@"Hide Miscues";
    
    } else {
        miscuesView.hidden=YES;
        showMiscuesBtn.titleLabel.text=@"Hide Miscues";
        
    }
    
}

-(void)calculate:(id)sender{
    
    
}

-(void) scoreTest:(Test*)thisTest{
    
    
        
      //  NSString *comprehensionAssessmentString=@"";
        
        NSString *fluencyAssessmentString=@"";
        
      //  NSString *accuracyAssessmentString=@"";
        NSNumber *thisTestFluencyBenchmark=[NSNumber numberWithInt:0];
        
        //In this method we are going to score the test.
        /*
         This method takes in a aTest, then checks to see if its accuracy meets the benchmark for the passage.
         if it meets the benchmark AND it has comprehension Questions Set as correct it will set the string to passed
         else if it meets the benchmark and  both Comp NOT passed, it will set string to "Fluency with limited Comprehension"
         else if it meets benchmark nad on Comp Not passed it will set statusSTring to "Fluency with some Comprehension"
         else if it meets benchmark and has both Comp Questions set to passed, then set to "Fluency with Strong Comprehension"
         
         */
        
        
        //get the passage benchmark form plist
        NSString *path  = [[NSBundle mainBundle] pathForResource:@"FluencyNorms" ofType:@"plist"];
        
        
        NSMutableArray *fluencyNormsArray =[[NSMutableArray alloc] initWithContentsOfFile:path];
         
    
        
        for (NSDictionary *dicts in fluencyNormsArray) {
             
            if ([[dicts objectForKey:@"Grade"] isEqualToNumber: studentGradeLevel] )              
            {
                
                //if the passage is from the same grade level...
                //get the date and see what month...
                //need date to format
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                
                [dateFormatter setDateFormat:@"MMM"];
                
                NSString *myMonthString = [NSString stringWithFormat:@"%@",
                                           [dateFormatter stringFromDate:aTest.testDate]];
                
                 //from aug. to  nov. set to Fall
                
                
                if ([myMonthString isEqualToString:@"Aug"] ||
                    [myMonthString isEqualToString:@"Sep"] ||
                    [myMonthString isEqualToString:@"Oct"]||
                    [myMonthString isEqualToString:@"Nov"])
                {
                    //
                    thisTestFluencyBenchmark=[dicts objectForKey:@"Fall"];
                    
                    
                    
                } else if ([myMonthString isEqualToString:@"Dec"] ||
                           [myMonthString isEqualToString:@"Jan"] ||
                           [myMonthString isEqualToString:@"Feb"]||
                           [myMonthString isEqualToString:@"Mar"])
                    
                {
                    
                    thisTestFluencyBenchmark=[dicts objectForKey:@"Winter"];
                    
                    
                    
                } else if
                    ([myMonthString isEqualToString:@"Apr"] ||
                     [myMonthString isEqualToString:@"May"] ||
                     [myMonthString isEqualToString:@"Jun"]||
                     [myMonthString isEqualToString:@"Jul"])
                    
                {
                    
                    thisTestFluencyBenchmark=[dicts objectForKey:@"Spring"];
                    
                    
                    
                }
                
                //compare date month benchmark with actual date to determine actual mastery...
                
                
                //
                
            }//end if
            
        }//end for
    
    
    
    
        
        //EVALUTATE FLUENCY...
        //compare date month benchmark with actual date to determine actual  mastery...
    
    int roundedBenchmark= [thisTestFluencyBenchmark intValue];
    
    int aTestFluencyINT = [aTest.fluency intValue];
    
        if (roundedBenchmark > aTestFluencyINT) {
            
            //if the benchmark is greater than student's achived score, then they have not met accuracy goal...
           // NSLog(@"ATestFluencyINT: %i, roundedBenchmark-- float: %i", aTestFluencyINT, roundedBenchmark);
            
            NSString *compString =[NSString stringWithFormat:
                                   @"Sorry, Student got %.0f CWPM, but needed %.0f to meet benchmark for fluency.",
                                   [aTest.fluency floatValue], [thisTestFluencyBenchmark floatValue]];
            
            fluencyAssessmentString=compString;
            [aTest.fluency floatValue], [thisTestFluencyBenchmark floatValue];
            
            feedbackBenchmarkLbl.text=fluencyAssessmentString;
            
            
        } else {
            NSString *compString =[NSString stringWithFormat:
                                   @"Good Job! Student got %.0f CWPM, and met %.0f to meet benchmark for fluency",
                                   [aTest.fluency floatValue], [thisTestFluencyBenchmark floatValue]];
            fluencyAssessmentString=compString;
            
            
            
             
            feedbackBenchmarkLbl.text=fluencyAssessmentString;
        }
        
        
        //EVALUATE ACCURACY...
        
        double studentAccuracyDouble=[aTest.accuracy doubleValue]; //what the student got on the test for Accuracy %
        
        
        if (studentAccuracyDouble >= 95){
            
            
            
         //   accuracyAssessmentString=@"Independent";
            feedbackReadingLbl.text=@"Student reading at Independent Level, try a higher passage to find instructional level";
            
            
        }else if (studentAccuracyDouble <= 95 && studentAccuracyDouble>= 90)
        {
            
             
        //    accuracyAssessmentString=@"Instructional";
            feedbackReadingLbl.text=@"Student read the passage at their instructional level";
            
        } else {
            
            
            
    //        accuracyAssessmentString=@"Frustration";
            feedbackReadingLbl.text=@"The student read this at a frustration level. Try a grade level below";
        }
        
        
        
        //EVALUATE COMPREHENSION
        
        //Populate the miscue box
    NSMutableArray *arrayOfErrors =[[NSMutableArray alloc]init];
    NSString * stringForBox=@"Miscues:";
    NSString *anError=@"";
    NSString *anErrorCode=@"";
     
    int valueOfNum=0;
    
    for (NSDictionary*dict in aTest.testTypeArray) {
        
        
        //find all the miscues and put them into Array of errors
        
       anError=   [dict objectForKey:@"Miscue"];
      valueOfNum=[[dict objectForKey:@"MiscueTypeNumber"] intValue];
       
       
        if (valueOfNum==0) {
            
            //gp
            anErrorCode=@"gp";
             
        } else if (valueOfNum==1) {
            
            //sm
            anErrorCode=@"sm";
            
            
        }else if (valueOfNum==2) {
            
            //sk
            anErrorCode=@"sk";
            
        }else if (valueOfNum==3) {
            //sc
            anErrorCode=@"sc";
            
        }else if (valueOfNum==4) {
            //th
            anErrorCode=@"th";
            
        }
        
        
         stringForBox = [NSString stringWithFormat:@"%@       %@ (%@)", stringForBox, anError, anErrorCode];
        
    }
    
     
    
        
    
    
    
    
    for (NSString *error in arrayOfErrors) {
        
        stringForBox = [NSString stringWithFormat:@"%@       %@", stringForBox, error];
        
    }
    
    
    errorBoxTextView.text=stringForBox;

    arrayOfErrors=nil;
    
    
    //_wordPosArr= [NSMutableArray arrayWithArray:thisTest.wordPositionArray];
    
    //here we also take the opportunity to check to see if the wordsMatch...
   // NSLog(@"word pos arr.: %@", _wordPosArr);
    
}


- (IBAction)LaunchNextAssessment:(id)sender {
    
    //NSLog(@"Launch next assessment called");
    
    //see if the test was too easy or too hard or just about right
    //depending on benchmark number, recommend the next assessment
    //if 
    
    //find right passage.
    
    
    //go back to RRViewController, with another test [super]
    
    
    
    
    
    
    
}

-(IBAction)playRecording:(id)sender{
    //need to play/pause
   
    if ([elPlayer isPlaying]) {
        [elPlayer pause];
        
         
        
    } else {
    
    NSString *soundFilePath= aTest.soundFilePath;
     
        
        if  (aTest.soundFilePath!=nil){
            
       
    
            NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
           // NSLog(@"playing from URL: %@", [NSString stringWithContentsOfURL:soundFileURL encoding:1 error:nil]);
            if (elPlayer)
                elPlayer=nil;
    
    
            elPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
            elPlayer.delegate=self;
    
    
            [elPlayer prepareToPlay];
            [elPlayer play];
        }
    }     
}

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag

{
	
    
   
    
    
    
}

-(void) audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
	 
}


-(IBAction)shareReport:(id)sender{
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"WantsToSaveAudio"] == NO) {
        
       //erase the recording
        
         
        
         NSError *error;
        if ([[NSFileManager defaultManager] fileExistsAtPath:aTest.soundFilePath])		//Does file exist?
        {
           // NSLog(@" Will be Removing file: %@ are you sure???", aTest.soundFilePath);
            
             NSFileManager *fileManager = [NSFileManager defaultManager];
             [fileManager removeItemAtPath:aTest.soundFilePath error:&error];
             if (![[NSFileManager defaultManager] removeItemAtPath:aTest.soundFilePath error:&error])	//Delete it
             {
            // NSLog(@"Delete file error: %@", error);
             }
             
            
        }
        
    }
    
    
    
    
    
    
   // [self.navigationController popToRootViewControllerAnimated:YES];
    
   
    
    
    
    
   // int count = [self.navigationController.viewControllers count];
    
      
    
     } 

- (void)viewDidUnload {
    [self setPassageTitleLbl:nil];
    [self setStudentNameLbl:nil];
    [self setErrorsNum:nil];
    [self setTotalWordsNum:nil];
    self.studentInReport=nil;
    [self setLevelLbl:nil];
    [self setLaunchNextBtn:nil];
    [self setShowMiscuesBtn:nil];
    [self setMiscuesView:nil];
    [self setWordsReadLbl:nil];
    [super viewDidUnload];
}

         
  @end        

