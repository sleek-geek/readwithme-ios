//
//  RWMOfflineReportVC.h
//  RWMStudent
//
//  Created by Francisco Salazar on 11/4/12.
//
//

#import <UIKit/UIKit.h>
#import "Test.h"
#import <AVFoundation/AVFoundation.h>
#import "Student.h"
#import <CoreAudio/CoreAudioTypes.h>

@interface RWMOfflineReportVC : UIViewController <AVAudioPlayerDelegate, UIWebViewDelegate>{
    
    
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
    
    AVAudioPlayer *elPlayer;
    
    
}
@property (strong, nonatomic) NSNumber *bnchNUM;
@property (strong, nonatomic) IBOutlet UILabel *benchmarkReachedLbl;
@property (strong, nonatomic) IBOutlet UILabel *studentNameLbl;
@property (strong, nonatomic) Student* studentInReport;
@property (strong, nonatomic) IBOutlet UILabel *passageTitleLbl;
@property (nonatomic, strong)Test *aTest;
@property (nonatomic, strong) NSString *passageText;
@property (nonatomic, strong) NSString *studentName;
@property (nonatomic, strong) NSString *passageTitle;
@property (nonatomic, strong) NSString *textForReport;
@property (nonatomic, strong) NSNumber *errorsNum;
@property (strong, nonatomic) IBOutlet UILabel *wordsReadLbl;

@property (nonatomic, strong) NSNumber *totalWordsNum;
@property (nonatomic, strong) NSNumber *studentGradeLevel;

@property (nonatomic, strong) id passageGradeLevel;
@property (strong, nonatomic) IBOutlet UIButton *launchNextBtn;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *feedbackReadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *feedbackBenchmarkLbl;


@property (weak, nonatomic) IBOutlet UILabel *calcMiscueCountLBL;
@property (weak, nonatomic) IBOutlet UILabel *calcSkippedCountLBL;
@property (weak, nonatomic) IBOutlet UILabel *calcSelfCorrecLbl;
@property (weak, nonatomic) IBOutlet UILabel *calcWithHelpLbl;
@property (weak, nonatomic) IBOutlet UILabel *calcTotalTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *calcWPMlabel;
@property (weak, nonatomic) IBOutlet UILabel *calcCPMLabel;
@property (weak, nonatomic) IBOutlet UILabel *calcAccuracyLbl;

@property (strong, nonatomic) IBOutlet UIWebView *aWebView;

@property (strong, nonatomic) IBOutlet UITextView *errorBoxTextView;

@property (strong, nonatomic) IBOutlet UILabel *levelLbl;
@property (strong, nonatomic) IBOutlet UIButton *showMiscuesBtn;

@property (strong, nonatomic) IBOutlet UIView *miscuesView;

@property (strong, nonatomic) NSMutableArray*wordPosArr;
@property (strong, nonatomic) NSMutableArray *textArray;
- (IBAction)showMiscues:(id)sender;

-(void)calculate:(id)sender;
 
-(void) scoreTest:(Test*)aTest;

-(IBAction)shareReport:(id)sender; //this will launch mail app 
- (IBAction)LaunchNextAssessment:(id)sender;

-(IBAction)playRecording:(id)sender;
@end
