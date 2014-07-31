//
//  EditStudentVC.h
//  elDcoderBeta
//
//  Created by Francisco Nieto on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Student;
@protocol EditStudentVCDelegate;

@interface EditStudentVC : UIViewController {
	
	id<EditStudentVCDelegate> delegate;
	UITextField *nameField;
	UISegmentedControl *lowerGrades;
	
	Student *studentEditing;
	
	UISegmentedControl *celdtLevel;
	
	UITextField *teacherField;
	
	UITextView *notesTextView;
	
	UIButton *cancel;
	UIButton *save;
    
    NSMutableArray *tempGroupArray;
	

}

@property (nonatomic, strong) id<EditStudentVCDelegate> delegate;

@property (nonatomic, strong) Student *studentEditing;

@property (nonatomic, strong) IBOutlet 	UITextField *nameField;
@property (nonatomic, strong) IBOutlet UITextField *lastNameField;

@property (nonatomic, strong) IBOutlet 	UITextField *teacherField;


@property (nonatomic, strong) IBOutlet 	 UISegmentedControl *lowerGrades;

@property (nonatomic, strong) IBOutlet 	 UITextField *readingLevel;

@property (nonatomic, strong) IBOutlet 	UITextView *notesTextView;


@property (nonatomic, strong) IBOutlet 	UIButton *cancel;

@property (nonatomic, strong) IBOutlet 	UIButton *save;

-(IBAction) cancelButtonClicked;

-(IBAction) saveStudent;

//-(id) initWithStudentName: (NSString *)nameToEdit   grade:(NSString *) gradeToEdit  teacher: (NSString *)teacherToEdit 
//					celdt: (NSString *) cldtToEdit  notes: (NSString *) notesToEdit

-(id) initWithStudent: (Student *) student;

@end


@protocol EditStudentVCDelegate <NSObject>

-(void) EditStudentVCDidFinish ; //well add arugments later...
//-(void) EditStudentDidFinishWithName: (NSString *)nm   grade:(NSString *) gr  teacher: (NSString *)tchr 
	//						  celdt: (NSString *) cldt  notes: (NSString *) nts;
-(void)EditStudentDidFinishWithStudent: (Student *) editedStudent;

@end

