//
//  AddAnotherStudentVC.m
//  RWM Fluency
//
//  Created by Francisco Salazar on 11/18/12.
//
//

#import "AddAnotherStudentVC.h"

@interface AddAnotherStudentVC ()

@end

@implementation AddAnotherStudentVC
@synthesize nameField, lowerGrades, teacherField, readingLevel, notesTextView, lastNameField;
@synthesize save, cancel, delegate, groupName;



-(IBAction) cancelButtonClicked
{
	if (delegate!=nil) {
		[self.delegate addAnotherStudentVCDidFinish];
		
		
	}
	
	
}



-(IBAction) saveStudent
{
	if ([nameField.text isEqualToString:@"<First Name>"] || [lastNameField.text isEqualToString:@"<Last Name>"]) {
        
        
        
         
             
        
        UIAlertView *noNameAlert =[[UIAlertView alloc] initWithTitle:@"No Name?" message:@"You can't save a student without a name" delegate:self cancelButtonTitle:@"Got it" otherButtonTitles:nil  , nil];
        
        [noNameAlert show]  ;
            
         
    } else {
        
     
	
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
    //NSLog(@"group name array contains: %@", groupNameArray);
    
    
    NSNumber*statusNumber = [NSNumber numberWithInt:0]; //number stores code for status of student
    
   // NSNumber *zeroNumber=[NSNumber numberWithInt:0]; //store a zero until delegate assigns it a real number for ID
    NSString *tempID=@"tempID";
	
	[tempRecordArray insertObject:testInstancesArray atIndex:0];
    [tempRecordArray insertObject:statusNumber atIndex:1];
	
        if ([selectedLevel isEqualToString:@"<Enter Level>"]) {
            selectedLevel=@"No Level Set";
        }
        
     //   NSLog(@"Group Name to save: %@", groupName);
        
        NSString *firstNameString =[nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *lasttNameString =[lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        

    
	[self.delegate addAnotherStudentDidFinishWithName:firstNameString lastName:lasttNameString grade: selectedGrade teacher:teacherField.text level:selectedLevel notes:notesTextView.text testRecordArray:tempRecordArray andGroups:groupNameArray andID:tempID];
	
	emptyRecordsDict=nil;
    
	tempRecordArray=nil;
    
    groupNameArray=nil;
    testInstancesArray=nil;
    
    self.delegate=nil;
    
    }
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
	notesTextView.text =@"";
	
	//NSLog(@"Add Another Student View did load with group: %@", groupName);
	
	
	 
	
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
