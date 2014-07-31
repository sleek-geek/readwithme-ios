//
//  NewClassViewController.m
//  RWM Fluency
//
//  Created by Francisco Salazar on 11/12/12.
//
//

#import "NewClassViewController.h"

@interface NewClassViewController ()

@end

@implementation NewClassViewController
@synthesize nameField, lastNameField, groupName, notesField;
@synthesize delegate;
@synthesize gradeField;
@synthesize addedStudentsArray;
@synthesize addStudent, addStudentPopover, studentTableView;
@synthesize studentListTableView;
@synthesize studentsInClassArray;
@synthesize saveGroupBtn;
@synthesize studentsForTable;
@synthesize helpOverlayImg;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 
- (void)viewDidLoad
{
    
	// Do any additional setup after loading the view.
    
        helpOverlayImg.hidden=YES;
    
        
        studentsInClassArray=[[NSMutableArray alloc]init];
        
    isGroupSaved=NO;
    
    if(studentsForTable==nil)
    studentsForTable=[[NSMutableArray alloc]init];
    
    [super viewDidLoad];
}



-(IBAction) cancelButtonClicked{
    
    if (delegate!=nil) {
        
        
        
        if (addedStudentsArray.count >0){
            
            //if we have studetns added, we should warn that they won't be saved.
            UIAlertView *areUsure=[[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"It looks like you have added a student. Cancelling will not save their information" delegate:self  cancelButtonTitle:@"Go back" otherButtonTitles:@"Cancel anyway", nil];
            
            [areUsure show];
            
            return;
            
        }
        
        
        [addedStudentsArray removeAllObjects];
        addedStudentsArray=nil;
        
        
        
		[self.delegate addClassVCDidFinish];
        [self.navigationController popViewControllerAnimated:YES];
		
		
	}
}

-(IBAction) saveClass{
    
    
    
    if (studentsInClassArray.count==0) {
        UIAlertView *nokidsAlert =[[UIAlertView alloc] initWithTitle:@"No Students?" message:@"Add at least one student before you save this group" delegate:self cancelButtonTitle:@"Got it" otherButtonTitles:nil, nil];
        
        [nokidsAlert show];
    
    
    } else  {
        
        
    if ([groupName.text isEqualToString:@""] || groupName.text==nil || [groupName.text isEqualToString:@" "]) {
     //   NSLog(@"No group Name, can't save");
        UIAlertView *noGrpNmAlert =[[UIAlertView alloc] initWithTitle:@"No Group Name?" message:@"You can't create a group without a name" delegate:self cancelButtonTitle:@"Got it" otherButtonTitles:nil, nil];
        
        [noGrpNmAlert show];
        
        
    } else {
    
     //   NSLog(@"found the error! it is here!");
    
    NSString *frstNmStrng= nameField.text;
    
    NSString *lstNmStrng = lastNameField.text;
    
    NSString *grpNmStrng = groupName.text;
    
    NSString *notesStrng =notesField.text;
    
    NSString *gradesStrng=gradeField.text;
    
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", frstNmStrng, lstNmStrng];
    
    if (addedStudentsArray==nil) {
       
         
        
        
        addedStudentsArray=[[NSMutableArray alloc] init];
        
    }
    
        [self archiveStudents]; //Moved method here to avoid students being added until they were confirmed. 

    //can then proceed. Class can still save if there are no students add yet. Just pass empty array
        
      //  NSLog(@"delegae newClassDidCreateClass"  );
        
            [self.delegate newClassDidCreateClassWithName:grpNmStrng andTeacher:fullName andStudents:studentsInClassArray andNotes:notesStrng andGrade:gradesStrng ];

//[self.navigationController popToRootViewControllerAnimated:YES];

            [self.navigationController popViewControllerAnimated:YES];
            isGroupSaved=YES;
            
             
    }
        
        
        
    }
         
}

-(IBAction)addStudent:(id)sender{
    
    
   
    if (addedStudentsArray==nil) {
         
     //   NSLog(@"addStudent: addedStudentArray ==nil");
     self.addedStudentsArray = [NSKeyedUnarchiver
    
                            unarchiveObjectWithFile:  [self archivePath]];
    
     
    } else{
       // NSLog(@"addStudent: addedStudentArray already exists!");
    }
    
    if (addedStudentsArray.count==0) {
      //  NSLog(@"This is the first student to exist!, lets build an array!");
        
          
         
          
        
         addedStudentsArray=[[NSMutableArray alloc] init];
        
        
    }
     
    
  //  NSLog(@"ADDED StudentArray count=%i", addedStudentsArray.count);
    
    
    if ([groupName.text isEqualToString:@""]) {
        UIAlertView *noGroupAlert = [[UIAlertView alloc] initWithTitle:@"No Group Name?" message:@"You must give the group a name before you add students" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [noGroupAlert show];
        return;
        
    }  
        
    //    NSLog(@"Group name present, so lets add popover");
    
    addStudent = [self.storyboard instantiateViewControllerWithIdentifier:@"addStudent"];
    
    
	
	addStudentPopover = [[UIPopoverController alloc] initWithContentViewController:addStudent];
    

    
    addStudent.teacherField.text= [NSString stringWithFormat:@"%@ %@", nameField.text, lastNameField.text];
    
    addStudent.groupName=self.groupName.text;
        
        int gradeINT = [gradeField.text intValue];
        
        addStudent.lowerGrades.selectedSegmentIndex=gradeINT;
	
	addStudent.delegate=self;
	
	
	[addStudentPopover presentPopoverFromRect:[sender frame] inView:self.view
					 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    
    
    
}


-(void) addStudentDidFinishWithName: (NSString *)nm  lastName:(NSString*)lm grade:(NSString *) gr  teacher: (NSString *)tchr
							  level: (NSString *) lv  notes: (NSString *) nts
                    testRecordArray:(NSMutableArray*) tstArr andGroups:(NSMutableArray*)grpsArr andID:(NSString*)stID{
    
    
    
  //  NSLog(@"add Student Did Finish with %@ %@", nm, lm);
    
    
    NSString  *anId=[self uuid];
    
  //  NSLog(@"UNIQUE ID ASSIGNED %@", anId);
    
   // NSNumber *newNumber= [NSNumber numberWithInt:addedStudentsArray.count+1];
    
    
    
     
    
    
    Student *newStudent =[[Student alloc] initWithName:(NSString *)nm lastName:(NSString*)lm grade:(NSString *) gr teacher: (NSString *)tchr  level: (NSString *) lv notes: (NSString *) nts testRecordArray:(NSMutableArray*) tstArr andGroups:(NSMutableArray*)grpsArr andID:(NSString*)anId];
    
    
    
    
    [ studentsForTable addObject:newStudent];
    
  //  NSLog(@"Students For Table %@", studentsForTable );
    //this will only survive until this view is unloaded
    
    
    [self.addedStudentsArray addObject:newStudent]; 
        
         
        
        [self.addStudentPopover dismissPopoverAnimated:YES];
        
        
        
        
     //   [self archiveStudents]; //Don't archive them until you press SAVE. likewise, in Cancel, empty addedStudentArray, but prompt you to be sure if you have already added one. 
        
   
    
     [studentsInClassArray removeAllObjects];
    //now go through the array and pluck out the students that match this class
    
       
    for (Student *s in self.addedStudentsArray) {
        
         
        
        if ([s.groupsArray containsObject:groupName.text]) {
            
          //  NSLog(@"%@ is in %@ group", s.nombre, s.teacher);
            
            //add to array for this class...
            
            [studentsInClassArray addObject:s.studentID]; //Major change HERE: Adding just reference to student! ID
            
            
        } else{
            
         //   NSLog(@"s.groupsArray: %@", s.groupsArray);
            
        }
        
    
        
        
    }
    
    
   
    
 //   NSLog(@"students in class array contains: %@", studentsInClassArray);

    [studentListTableView reloadData];
}
- (NSString *)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
   // return (__bridge NSString *)uuidStringRef;
    return CFBridgingRelease(uuidStringRef);// prevents memory leaks
}
//test

-(void) AddStudentVCDidFinish{
    
    [self.addStudentPopover dismissPopoverAnimated:YES];
    
 //   NSLog(@"user didn't add any students");
}


-(NSString *) archivePath{
    
    
    NSString *docDirect =
	[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES	) objectAtIndex:0];
	return [docDirect stringByAppendingPathComponent:@"Students.dat"];
    
     
    
}

- (IBAction)showHelp:(id)sender {
    
    
    
    
     
    
    if (helpOverlayImg.hidden==YES) {
        helpOverlayImg.hidden=NO;
        
       // NSLog(@"Show help");
    }else {
        helpOverlayImg.hidden=YES;
      //  NSLog(@"hide help");
    }
}



-(void) archiveStudents{
    
     [NSKeyedArchiver archiveRootObject:addedStudentsArray toFile:[self archivePath]];
    
}


#pragma mark table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     
        
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    
    if (studentsInClassArray.count>0){
        
        return studentsInClassArray.count;
    } else
    
        return 1;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    
    if (studentsInClassArray.count>0) {
        
        
        
        
    
    
    Student *student=(Student*)[studentsForTable objectAtIndex:indexPath.row];
     
    
     //cell.textLabel.text= [[ self.studentsInClassArray objectAtIndex:indexPath.row];
        int indexRowINT = indexPath.row ;
        NSString *nameToDisplay=student.nombre;
        NSString *lastNameToDispaly=student.apellido;
        NSString *readingLvlToDisplay =student.level;
        //NSDate *dateAdded = [NSDate date];
        
        
        
    cell.textLabel.text=[NSString stringWithFormat:@"%i) %@ %@ -- Reading Level: %@", indexRowINT+1, nameToDisplay, lastNameToDispaly, readingLvlToDisplay ];
        
        
        NSString *groupToDispaly = groupName.text;
        NSString *teacherToDispaly=student.teacher;
        //NSString *addedOnToDisplay=dateAdded;
        
        cell.detailTextLabel.font=[UIFont fontWithName:@"Helvetica_Neue_Light" size:12];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"group:%@ Teacher: %@", groupToDispaly, teacherToDispaly];
        
    } else {
        cell.textLabel.text=@"No students" ;

        
        
    }
    return cell;
}

-(void)viewWillDisappear:(BOOL)animated {
    
  //  NSLog(@"View Will Dissappear");
    if (studentsInClassArray.count>=1 && isGroupSaved==NO) {
        
       /*
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Warning!" message:@"You didn't save this group" delegate:self cancelButtonTitle:@"That's Ok" otherButtonTitles:@"Save Now", nil];
        [alert show];
        
         */
        
      //  NSLog(@"not saved!");
     
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *buttonTitleOfAlert = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitleOfAlert isEqualToString:@"That's Ok"]) {
        
        return;
        
    } else if ([buttonTitleOfAlert isEqualToString:@"Save Now"]){
        
        [self performSelector:@selector(saveClass)];
    } else if ([buttonTitleOfAlert isEqualToString:@"Cancel anyway"]){
        
        //cancel then,
        
        [addedStudentsArray removeAllObjects];
        addedStudentsArray=nil;
        
        
        
		[self.delegate addClassVCDidFinish];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNotesField:nil];
    [self setGradeField:nil];
    [self setStudentListTableView:nil];
    studentsInClassArray=nil;
    addedStudentsArray=nil;
    [self setSaveGroupBtn:nil];
    [self setStudentsForTable:nil];
    [self setHelpOverlayImg:nil];
    [super viewDidUnload];
  //  NSLog(@"VIEW DID UNLOAD");
}
@end
