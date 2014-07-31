//
//  NewClassViewController.h
//  RWM Fluency
//
//  Created by Francisco Salazar on 11/12/12.
//
//

#import <UIKit/UIKit.h>
#import "AddStudentVC.h"
#import "Student.h"
#import "Teacher.h"
#import "RRStudentTableVC.h"

@class AddStudentVC;
@class RRStudentTableVC;


@protocol NewClassViewControllerDelegate;  

@interface NewClassViewController : UIViewController<AddStudentVCDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>{
    
    id<NewClassViewControllerDelegate> delegate;
    
    Teacher *newGroup;
    BOOL isGroupSaved;
    
    
}
@property (strong, nonatomic) IBOutlet UITextField *gradeField;

@property (strong, nonatomic) IBOutlet UITextView *notesField;

@property (nonatomic, strong) id<NewClassViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet 	UITextField *nameField;
@property (nonatomic, strong) IBOutlet 	UITextField *lastNameField;

@property (nonatomic, strong) IBOutlet 	UITextField *groupName;

@property (nonatomic, strong)  	NSMutableArray *addedStudentsArray; //holds all the students...

@property (nonatomic, strong) NSMutableArray *studentsInClassArray;// this holds all the students in a particular group
@property (nonatomic, strong) NSMutableArray *studentsForTable;

@property (nonatomic, strong) AddStudentVC *addStudent;

@property (nonatomic, strong) RRStudentTableVC *studentTableView;

@property (nonatomic, strong) UIPopoverController *addStudentPopover;

@property (strong, nonatomic) IBOutlet UITableView *studentListTableView;

@property (strong, nonatomic) IBOutlet UIButton *saveGroupBtn;

@property (strong, nonatomic) IBOutlet UIImageView *helpOverlayImg;



-(IBAction) cancelButtonClicked;

-(IBAction) saveClass;

-(IBAction)addStudent:(id)sender;

-(NSString *) archivePath;
 

- (IBAction)showHelp:(id)sender;


@end

@protocol NewClassViewControllerDelegate <NSObject>

-(void)newClassDidCreateClassWithName:(NSString *)className andTeacher:(NSString*)tchrNm andStudents:(NSArray*)studentsInClassArray andNotes:(NSString*)notes andGrade:(NSString*)theGrades;

-(void) addClassVCDidFinish;

@end