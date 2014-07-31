    //
//  AddStudentVC.m
//  StudentManager1
//
//  Created by Francisco Nieto on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddStudentVC.h"
//#import "StudentManager1AppDelegate.h"
#import "Student.h"
 




@implementation AddStudentVC
@synthesize nameField, lowerGrades, teacherField, readingLevel, notesTextView, lastNameField;
@synthesize save, cancel, delegate, groupName;



-(IBAction) cancelButtonClicked
{
	if (delegate!=nil) {
		[self.delegate AddStudentVCDidFinish];
		
		
	}
	
	
}



-(IBAction) saveStudent 
{
	
    
    if ([nameField.text isEqualToString:@"<First Name>"]||[lastNameField.text isEqualToString:@"<Last Name>"] || [readingLevel.text isEqualToString: @"<reading level>" ] || [nameField.text isEqualToString:@""] || [lastNameField.text isEqualToString:@""]) {
        
        UIAlertView *noNameAlert=[[UIAlertView alloc] initWithTitle:@"No name?" message:@"Make sure you have entered a name and a a reading level" delegate:self cancelButtonTitle:@"Got it" otherButtonTitles:nil, nil];
        
        [noNameAlert show];
        return;
        
    }
    
   // NSLog(@"SAVE STUDENT invoked");
    
    NSString *studentToAddFirstName=[nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *studentToAddLastName=[lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

	NSString *selectedGrade = [lowerGrades titleForSegmentAtIndex:lowerGrades.selectedSegmentIndex];
	
	NSString *selectedLevel = readingLevel.text;
	
	//testing
	NSMutableArray *tempRecordArray =[[[NSMutableArray alloc] init] mutableCopy];
	
	NSString *newStudentNoTest=@"Not tested";
    
    
	NSDictionary *emptyRecordsDict =[[NSDictionary alloc] initWithObjectsAndKeys:newStudentNoTest, @"TestDate", [NSNumber numberWithInt:0], @"Benchmark", newStudentNoTest, @"SoundFilePath", newStudentNoTest, @"TextGrade",
                                     nil];
    
	NSMutableArray*testInstancesArray=[[NSMutableArray alloc]init];
    [testInstancesArray addObject:emptyRecordsDict];
	NSMutableArray *groupNameArray =[[NSMutableArray alloc]initWithObjects:groupName , nil];
   
    
    
    NSNumber*statusNumber = [NSNumber numberWithInt:0]; //number stores code for status of student
    
   // NSNumber *zeroNumber=[NSNumber numberWithInt:0]; //store a zero until delegate assigns it a real number for ID
    NSString *tempID=@"tempID"; 
	
	[tempRecordArray insertObject:testInstancesArray atIndex:0];
    [tempRecordArray insertObject:statusNumber atIndex:1];
	
     
       
    
	[self.delegate addStudentDidFinishWithName:studentToAddFirstName lastName:studentToAddLastName grade: selectedGrade teacher:teacherField.text level:selectedLevel notes:notesTextView.text testRecordArray:tempRecordArray andGroups:groupNameArray andID:tempID];
	
	emptyRecordsDict=nil;
    
	tempRecordArray=nil;
    
    groupNameArray=nil;
    testInstancesArray=nil;
    
    self.delegate=nil;
	 	
}



 
 /* The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
 */

 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//NSLog(@"Add Student VC called");
	
	
	
	nameField.text= @"";
	teacherField.text=@"";
	notesTextView.text=@"";
	readingLevel.selected=NO;
	
	self.contentSizeForViewInPopover=CGSizeMake(690, 480);
	
	 
	
	
}
 


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return  (interfaceOrientation ==UIInterfaceOrientationPortrait);;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setNameField:nil];
    [self setTeacherField:nil];
    [self setNotesTextView:nil];
    [self setReadingLevel:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.delegate=nil;
    // e.g. self.myOutlet = nil;
}

/*
- (void)dealloc {
	
	[save release];
	[cancel release];
	[nameField	 release];
	[lowerGrades	 release];
	[teacherField release];
	[celdtLevel release];
	[notesTextView release];
    [super dealloc];
}
*/

@end
