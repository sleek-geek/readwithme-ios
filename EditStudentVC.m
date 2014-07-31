    //
//  EditStudentVC.m
//  elDcoderBeta
//
//  Created by Francisco Nieto on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditStudentVC.h"
 
#import	"Student.h"

@implementation EditStudentVC

@synthesize nameField, lastNameField, lowerGrades, teacherField, notesTextView, readingLevel;
@synthesize save, cancel, delegate, studentEditing ;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
-(id) initWithStudentName: (NSString *)nameToEdit   grade:(NSString *) gradeToEdit  teacher: (NSString *)teacherToEdit 
					celdt: (NSString *) cldtToEdit  notes: (NSString *) notesToEdit

{
	
	
}
 
 */
 
-(IBAction) cancelButtonClicked
{
	
	if (delegate!=nil) {
		[self.delegate EditStudentVCDidFinish];
		
	}
		
}
-(IBAction) saveStudent

{
	 
	
	
	
	studentEditing.nombre=nameField.text;
    studentEditing.apellido=lastNameField.text;
	studentEditing.teacher=teacherField.text;
	studentEditing.notes=notesTextView.text;
	NSString *selectedGrade;
    
    
	
    
    
	selectedGrade = [lowerGrades titleForSegmentAtIndex:lowerGrades.selectedSegmentIndex];
	
	NSString *selectedLevel;
	
	selectedLevel = readingLevel.text;
	
	studentEditing.level=selectedLevel;
	studentEditing.grade=selectedGrade;
	
   
    if ([studentEditing.nombre isEqualToString:@""] || [studentEditing.apellido isEqualToString:@""]|| [studentEditing.nombre isEqualToString:@" "] || [studentEditing.apellido isEqualToString:@" "]){
        
        //throw error
        
        UIAlertView *noBlankFieldsAlert =[[UIAlertView alloc]initWithTitle:@"No name?" message:@"A student must have a valid first and last name in order to save" delegate:self cancelButtonTitle:@"Got it" otherButtonTitles:nil, nil];
        
        [noBlankFieldsAlert show];
        return;
        
        
        
    } else{
        
    
        
	[self.delegate EditStudentDidFinishWithStudent:studentEditing ];
    
    
    [self dismissModalViewControllerAnimated:YES];
        
        
    }
	
}

-(id) initWithStudent:(Student*)student

{
	
	self = [super init];
	
    if (self) {
         
	
	 									 
   // tempGroupArray =[[NSMutableArray alloc] init]; //place holder for now!!!!
    
    self.studentEditing= [[Student alloc] initWithName:student.nombre lastName:student.apellido grade:student.grade teacher:student.teacher level:student.level notes:student.notes testRecordArray:student.testRecordArray andGroups:student.groupsArray andID:(NSString*)student.studentID]; 
        
        //need to make sure it's the same one by ID

    }
	return self;
	
}

- (void)viewDidLoad {
	
	self.contentSizeForViewInPopover=CGSizeMake(690.0, 480.0);

	nameField.text=studentEditing.nombre;
    
    
    lastNameField.text=studentEditing.apellido;
	
   // [celdtLevel setTitle:studentEditing.celdt forSegmentAtIndex:celdtLevel.selectedSegmentIndex];
	//were not setting the title, were hightlingting the index number...
    
    
    int gradeToEditINT =  [studentEditing.grade  intValue];
    
	lowerGrades.selectedSegmentIndex= gradeToEditINT;
	
    readingLevel.text=studentEditing.level;
	
	//lowerGrades.text= studentEditing.grade;
	
	teacherField.text= studentEditing.teacher;
	
	
	notesTextView.text= studentEditing.notes;
    
    
   //  NSLog(@"StudentEditing.nombre has %@ ",studentEditing.testRecordArray );
	
    [super viewDidLoad];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*

- (void)dealloc {
	
	[save release];
	[cancel release];
	[nameField	 release];
	[studentEditing release];
	[lowerGrades	 release];
	[teacherField release];
	[celdtLevel release];
	[notesTextView release];
    [super dealloc];
}
*/

@end
