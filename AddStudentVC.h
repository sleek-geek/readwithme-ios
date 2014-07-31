//
//  AddStudentVC.h
//  StudentManager1
//
//  Created by Francisco Nieto on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "StudentsListVC.h"

 



@protocol AddStudentVCDelegate;


@interface AddStudentVC : UIViewController {
	
	id<AddStudentVCDelegate> delegate;
	UITextField *nameField;
	UISegmentedControl *lowerGrades;
	
	NSNumber *studentNumber;
	
	 
	
	UITextField *teacherField;
	
	UITextView *notesTextView;

	UIButton *cancel;
	UIButton *save;
 


}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) id<AddStudentVCDelegate> delegate;

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


@protocol AddStudentVCDelegate <NSObject>

//-(void) AddStudentVCDidFinish ; //well add arugments later...

-(void) addStudentDidFinishWithName: (NSString *)nm  lastName:(NSString*)lm grade:(NSString *) gr  teacher: (NSString *)tchr
							  level: (NSString *) lv  notes: (NSString *) nts
                    testRecordArray:(NSMutableArray*) tstArr andGroups:(NSMutableArray*)grpsArr andID:(NSString*)stID;

//test

-(void) AddStudentVCDidFinish;


@end

