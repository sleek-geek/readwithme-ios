//
//  AddAnotherStudentVC.h
//  RWM Fluency
//
//  Created by Francisco Salazar on 11/18/12.
//
//

#import <UIKit/UIKit.h>

@protocol AddAnotherStudentVCDelegate;



@interface AddAnotherStudentVC : UIViewController {
	
	id<AddAnotherStudentVCDelegate> delegate;
	UITextField *nameField;
	UISegmentedControl *lowerGrades;
	
	
	NSNumber *studentNumber;
    
	
	UITextField *teacherField;
	
	UITextView *notesTextView;
    
	UIButton *cancel;
	UIButton *save;
    
    
    
    
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) id<AddAnotherStudentVCDelegate> delegate;

@property (nonatomic, strong) IBOutlet 	UITextField *nameField;
@property (nonatomic, strong) IBOutlet 	UITextField *lastNameField;

@property (nonatomic, strong) IBOutlet 	UITextField *teacherField;

@property (nonatomic, strong) IBOutlet 	UITextField *readingLevel;

@property (nonatomic, strong) NSString *groupName;


@property (nonatomic, strong) IBOutlet 	 UISegmentedControl *lowerGrades;



@property (nonatomic, strong) IBOutlet 	UITextView *notesTextView;


@property (nonatomic, strong) IBOutlet 	UIButton *cancel;

@property (nonatomic, strong) IBOutlet 	UIButton *save;

-(IBAction) cancelButtonClicked;

-(IBAction) saveStudent;


@end



@protocol AddAnotherStudentVCDelegate <NSObject>

//-(void) AddStudentVCDidFinish ; //well add arugments later...
 


-(void) addAnotherStudentDidFinishWithName: (NSString *)nm  lastName:(NSString*)lm grade:(NSString *) gr  teacher: (NSString *)tchr
							  level: (NSString *) lv  notes: (NSString *) nts
                    testRecordArray:(NSMutableArray*) tstArr andGroups:(NSMutableArray*)grpsArr andID:(NSString*)stID;
//test

-(void) addAnotherStudentVCDidFinish;


@end
