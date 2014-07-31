//
//  SetupVCViewController.h
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddStudentVC.h"
#import "Student.h"
#import "EditStudentVC.h"
#import "RRStudentTableVC.h"
#import "Teacher.h"

#import "AddAnotherStudentVC.h"
#import "IndividualStudentVC.h"
#import "GroupGraphView.h"
#import "XYPieChart.h"
#import "BenchMarkListViewController.h"


@class AddStudentVC;
@class AddAnotherStudentVC;
@class EditStudentVC;
@class RRStudentTableVC;
@class IndividualStudentVC;
@class GroupGraphView;



@interface SetupVCViewController : UIViewController<  AddAnotherStudentVCDelegate, RRStudentTableVCDelegate, EditStudentVCDelegate, UITableViewDataSource, UITableViewDelegate, XYPieChartDataSource, XYPieChartDelegate, BenchmarkListVCDelegate, UIPopoverControllerDelegate>

{
    EditStudentVC *editStudent;

    Student *editingStudent;
    
    Teacher *teacherOrGroup;
    
    IndividualStudentVC *individualProfileVC;
    
    NSString *gradeOfClass;
    
     NSMutableArray *studentsInThisGroupArr;
    
    
     }
@property (strong, nonatomic) IBOutlet UILabel *groupNameLabel;

@property (strong, nonatomic) IBOutlet UIView *pieChartBaseView;

@property (strong, nonatomic) IBOutlet XYPieChart *pieChartBenchmark;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;

@property (strong, nonatomic) IBOutlet GroupGraphView   *graph;
@property (nonatomic, strong) Teacher *teacherOrGroup;

@property (nonatomic, weak) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) IBOutlet UILabel *currentStudentName;
@property (nonatomic, strong) IBOutlet UILabel *currentStudentLastName;


@property (nonatomic, strong) IBOutlet 	UILabel *currentStudentTeacher;

@property (nonatomic, strong) IBOutlet 	UILabel *currentStudentLevel;

@property (nonatomic, strong) IBOutlet 	UILabel *currentStudentGrade;

@property (nonatomic, strong) IBOutlet 	UITextView *currentStudentNotes;

@property (weak, nonatomic) IBOutlet UIButton *addStudentsBtn;

@property (weak, nonatomic) IBOutlet UIButton *editStudentsBtn;

@property (weak, nonatomic) IBOutlet UIButton *viewStudentsBtn;

@property (nonatomic, strong) UIPopoverController *studentListPopover;

@property (nonatomic, strong) AddStudentVC *addStudent;
@property (nonatomic, strong) AddAnotherStudentVC *addAnotherStudent;

@property (nonatomic, strong) RRStudentTableVC *studentTableView;

@property (nonatomic, strong) UIPopoverController *addStudentPopover;

@property (nonatomic, assign) NSUInteger studentCounter;

//new property
@property (nonatomic, strong)  NSMutableArray *students;
@property (nonatomic, strong)  NSMutableArray *currentStudentTests;
//@property (nonatomic, strong)  NSMutableArray *studentsInThisGroupArr;
@property (nonatomic, strong) NSMutableArray *groupsArray;
 

@property (nonatomic, strong) IBOutlet UITableView *studentsInGroupTable;
@property (nonatomic, strong) NSString *groupNameStrng;

//for pie slices:

@property (nonatomic, strong) NSMutableArray*belowArr;
@property (nonatomic, strong) NSMutableArray*apprchArr;
@property (nonatomic, strong) NSMutableArray*benchArr;
@property (nonatomic, strong) NSMutableArray*advArr;
@property (nonatomic, strong) NSMutableArray*untstArr;


-(IBAction)addAnotherStudent :(id)sender;

-(IBAction)editStudent:(id)sender;

-(IBAction)viewStudents:(id)sender;
 

-(IBAction) done;


@end
