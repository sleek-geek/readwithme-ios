//
//  IndividualStudentVC.h
//  RWM Fluency
//
//  Created by Francisco Salazar on 11/19/12.
//
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "Test.h"
#import "RRPassagesTableVC.h"
#import "RRGradeTableVC.h"
#import "RWMOfflineReportVC.h"

#import "GraphView.h"
#import "EditStudentVC.h"
#import "Teacher.h"
 

@protocol IndividualStudentVCDelegate;

@class Student;
@class Test;
@class Teacher;
@class RWMOfflineReportVC;
@class RRViewController;
@class EditStudentVC;



@interface IndividualStudentVC : UIViewController <RRPassageTableVCDelegate, RRGradeTableVCDelegate, UIPopoverControllerDelegate, EditStudentVCDelegate, UITableViewDataSource, UITableViewDelegate>
{
    
    Student *editingStudent;
    
    Teacher *thisStudentGroup;
    RRGradeTableVC *gradesTableVC;
    RRPassagesTableVC *passageTableViewController;
    
    RWMOfflineReportVC *offlineReportVC;
    RRViewController *evaluationVC;
    EditStudentVC *editStudentVC;
    
    UIPopoverController *editStudentPopover;
    
    
    NSMutableArray *passagesArray;
    
    
    NSMutableArray *titlesArray;
    
    NSMutableArray *assessmentsArray;
    
    NSMutableArray  *studentAssessmentsArray;
    
    NSNumber *gradeLevelForChosenPassage;
    NSString *titleOfChosenPassage;
    
    Test *aTest;
    
}

@property (nonatomic, weak) id<IndividualStudentVCDelegate> delegate;
@property  (readwrite, nonatomic) NSMutableArray *studentsArray;
@property (readwrite, nonatomic) NSMutableArray *classesArray;
@property (strong, nonatomic) IBOutlet GraphView   *graph;
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;
@property (strong, nonatomic) IBOutlet UIButton *launchAssessmentBtn;
@property  (strong, nonatomic) Student *thisStudent;
@property (strong, nonatomic) Teacher *thisStudentGroup;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *teacherLabel;
@property (strong, nonatomic) IBOutlet UILabel *gradeLabel;
@property (strong, nonatomic) IBOutlet UILabel *groupsLabel;
@property (strong, nonatomic) IBOutlet UILabel *readingLevelLable;

@property (strong, nonatomic) IBOutlet UILabel *frustrationLevelLabel;
@property (strong, nonatomic) IBOutlet UILabel *IndependentLabel;

@property (strong, nonatomic) IBOutlet UILabel *instructionalLabel;

@property (strong, nonatomic) IBOutlet UISegmentedControl *graphChoiceSegment;
@property (strong, nonatomic) IBOutlet UILabel *benchmarkLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastTestedLabel;

@property (strong, nonatomic) IBOutlet UITableView *testHistoryTable;

@property (strong, nonatomic) IBOutlet UILabel *cwpmLabel;
@property (strong, nonatomic) IBOutlet UILabel *accuracyLabel;

@property (strong, nonatomic)     UIPopoverController *passagesPopover;
@property (strong, nonatomic) IBOutlet UILabel *graphYAxis;

 
@property (strong, nonatomic) IBOutlet UITableView *passageTableView;

@property (strong, nonatomic) IBOutlet UIView *lastTestedView;

-(IBAction)editStudent:(id)sender;


-(IBAction)launchAssessment:(id)sender;

-(IBAction)changeGraphOption:(id)sender;


-(void) calculateProgress;
-(void) playRecording;


@end

@protocol IndividualStudentVCDelegate 

//-(void) setStudentForRunningRecord:(Student*)studentForTest;

@end
