//
//  SetupVCViewController.m
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
/*
 
 This class will also load the pie chart, which will take all the students, sort through their latest benchmark status, and lay them out
 
 
 
 */

#import "SetupVCViewController.h"
#import "EditStudentVC.h"
#import "BenchMarkListViewController.h" 

@interface SetupVCViewController ()

@end


@implementation SetupVCViewController
@synthesize addStudentsBtn;
@synthesize editStudentsBtn;
@synthesize viewStudentsBtn;
@synthesize currentStudentName, currentStudentGrade, currentStudentLevel;
@synthesize currentStudentNotes, currentStudentTests, currentStudentTeacher;
@synthesize currentStudentLastName;
@synthesize students, studentCounter, addStudent, addAnotherStudent;
@synthesize doneButton, addStudentPopover, studentListPopover;
@synthesize studentTableView;
@synthesize teacherOrGroup;
//@synthesize studentsInThisGroupArr;
@synthesize studentsInGroupTable;
@synthesize groupsArray;
@synthesize groupNameStrng, groupNameLabel;
@synthesize graph;
@synthesize pieChartBenchmark;
@synthesize  sliceColors=_sliceColors;
@synthesize slices = _slices;
@synthesize pieChartBaseView;
@synthesize belowArr, apprchArr,benchArr, advArr, untstArr;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)viewWillAppear:(BOOL)animated    {
    
    
    
}

- (void)viewDidLoad

{
    
    //need to modify this now. Only for the selected class....
    
     
    self.students = [NSKeyedUnarchiver
					 unarchiveObjectWithFile:  [self archivePath]];
    
    if (self.students==nil) {
        
        
        
		 
		self.students =[[NSMutableArray alloc] init];
		
	}
    
    
    
    //$$$$$ Debugging $$$$$$$$$$
    
    for (Student *stndt in self.students) {
                 
    }
	
	 
    
    self.groupsArray=[NSKeyedUnarchiver
                                 unarchiveObjectWithFile:  [self archiveGroupPath]];
    
    if (self.groupsArray==nil) {
		 
		self.groupsArray =[[NSMutableArray alloc] init];
		
	}
    
    
    NSMutableArray*tempStudentIDArray=[[NSMutableArray alloc] init];
  
    for (Teacher*t in groupsArray) {
        
        
        if ( [t.firstName isEqualToString:groupNameStrng]){
            
            
            //we have a match...
             gradeOfClass= t.grades;
            
            teacherOrGroup=t;//assing the group as THIS group;
                        
            groupNameLabel.text= groupNameStrng;
           // studentsInThisGroupArr=t.studentsArray;
            
            //need to pluck out the Student IDs and buld an array with them
            for (NSString *sIDs in  t.studentsArray) {
                
                [tempStudentIDArray addObject:sIDs];
                
               // NSLog(@"Temp Student ID ARRAYS: %@", tempStudentIDArray);
                                 
            } //end for
            
            
            
            
        }// end if
        
    } //end for, so now we are ready to go to use our tempstudentIDarray to find those students
    
    //go through self.students and get all matching IDs
    
    
    NSMutableArray *studentsToSort=[[NSMutableArray alloc]init];
   /* if (studentsInThisGroupArr==nil) {
         
    
    studentsInThisGroupArr=[[NSMutableArray alloc] init ];
    }
    */
    for (Student*aStudent in self.students) {
        
        if ([tempStudentIDArray containsObject:aStudent.studentID ]){
            
           // [studentsInThisGroupArr addObject:aStudent];
            [studentsToSort addObject:aStudent];
        }
        
        
    }
    
    
    //now lets sort the studetns in alpha order...
    
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nombre" ascending:YES];
    NSArray  *sortDescriptors = @[nameDescriptor];
   
    NSArray *sortedStudents = [studentsToSort sortedArrayUsingDescriptors:sortDescriptors];
    
    studentsInThisGroupArr=[[NSMutableArray alloc] init ];
    for (Student*stud in sortedStudents) {
        [studentsInThisGroupArr addObject:stud];
        
        
        
    }
    //NSLog(@"Students in this group: %@", [studentsInThisGroupArr]);
    
    
    self.slices = [NSMutableArray arrayWithCapacity:5];
    /*
    [self.slices addObject:[NSNumber numberWithInt:1]]; //advanced Index:0
    [self.slices addObject:[NSNumber numberWithInt:2]];//at benchmark :1
    [self.slices addObject:[NSNumber numberWithInt:3]]; //approaching benchmark:2
    [self.slices addObject:[NSNumber numberWithInt:4]];//below benchmark :3
    [self.slices addObject:[NSNumber numberWithInt:5]]; //untested, index: 4
    
    
    */
    int belowINT=0;
    int approachingINT=0;
    int atBenchmartINT=0;
    int aboveBenchmarkINT=0;
    int untestedINT=0;
    
    //let's make 5 quick arrays to handle all the kids names, so they can be displayed in the pie chart...
    advArr=[[NSMutableArray alloc]init];
    benchArr=[[NSMutableArray alloc]init];
    apprchArr=[[NSMutableArray alloc]init];
    belowArr=[[NSMutableArray alloc]init];
    untstArr=[[NSMutableArray alloc]init];
    
    for (Student *stndt in studentsInThisGroupArr) {
         
        
        if ([[stndt.testRecordArray objectAtIndex:1] intValue]==0 || [[stndt.testRecordArray objectAtIndex:1] intValue]==5 ) {
           
            
            NSString *firstAndLatName=[NSString stringWithFormat:@"%@ %@", stndt.nombre, stndt.apellido];
            
            
            
            [untstArr addObject:firstAndLatName];
         //   NSLog(@"Untested");
           untestedINT ++;
            
        } else if([[stndt.testRecordArray objectAtIndex:1] intValue]==1) {
              
            
             NSString *firstAndLatName=[NSString stringWithFormat:@"%@ %@", stndt.nombre, stndt.apellido];
          //   NSLog(@" aboveBenchmarkINT++;");
            [advArr addObject:firstAndLatName];
            
            aboveBenchmarkINT++;
        } else if ([[stndt.testRecordArray objectAtIndex:1] intValue]==2){
             
            atBenchmartINT++;
             NSString *firstAndLatName=[NSString stringWithFormat:@"%@ %@", stndt.nombre, stndt.apellido];
          // NSLog(@" atBenchmartINT++");
            [benchArr addObject:firstAndLatName];
            
        } else if ([[stndt.testRecordArray objectAtIndex:1] intValue]==3){
              
             NSString *firstAndLatName=[NSString stringWithFormat:@"%@ %@", stndt.nombre, stndt.apellido];
            approachingINT++;
            
           //  NSLog(@" approachingINT++");
            [apprchArr addObject:firstAndLatName];
            
        } else if ([[stndt.testRecordArray objectAtIndex:1] intValue]==4) {
             
            belowINT++;
            
             NSString *firstAndLatName=[NSString stringWithFormat:@"%@ %@", stndt.nombre, stndt.apellido];
          //    NSLog(@" Below INT++");//
            [belowArr addObject:firstAndLatName];
            
        } else
        {
          //do nothing
            
            
           // NSLog(@" Do Nothing");
        }
        
    }
    
    NSArray *arrayForArray=[[NSArray alloc] initWithObjects:advArr,benchArr,  apprchArr, belowArr    , untstArr,  nil];
    
    //now add the ints to the pieChart array
    
    [self.slices addObject:[NSNumber numberWithInt:aboveBenchmarkINT]]; //advanced Index:0
    [self.slices addObject:[NSNumber numberWithInt:atBenchmartINT]];//at benchmark :1
    [self.slices addObject:[NSNumber numberWithInt:approachingINT]]; //approaching benchmark:2
    [self.slices addObject:[NSNumber numberWithInt:belowINT]];//below benchmark :3
    [self.slices addObject:[NSNumber numberWithInt:untestedINT]]; //untested, index: 4
    
      [super viewDidLoad];
 //   currentStudentNotes.text=@"Add a student or edit an existing enttry";
    // Do any additional setup after loading the view from its nib.
    //XYPiechart
   
    /*
    for(int i = 0; i < 5; i ++)
    {
        NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
        
        
        [_slices addObject:one];
    }
     */
    
    self.pieChartBenchmark.arrayOfBencharkArrays=arrayForArray;
    [self.pieChartBenchmark setDelegate:self];
    [self.pieChartBenchmark setDataSource:self];
    [self.pieChartBenchmark setPieCenter:CGPointMake(157, 157)];
    [self.pieChartBenchmark setShowPercentage:NO];
    [self.pieChartBenchmark setLabelColor:[UIColor blackColor]];
    
     //change the array to display
    
    
    
    
   
    
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:119.0/255.0 green:79.0/255.0 blue:240.0/255.0 alpha:1], //Advanced? Purple
                       [UIColor colorWithRed:75.0/255.0 green:195.0/255.0 blue:255.0/255.0 alpha:1], //2? AT Benchmark?
                       [UIColor colorWithRed:255.0/255.0 green:155.0/255.0 blue:37.0/255.0 alpha:1],   /*approaching benchmark*/
                       [UIColor colorWithRed:123.0/255.0 green:12.0/255.0 blue:0.0 alpha:1], //below benchmark
                       [UIColor colorWithRed:31.0/255.0 green:52.0/255.0 blue:167.0/255.0 alpha:1],nil]; //untested
    
    
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.pieChartBenchmark reloadData];
        
    
}


-(IBAction)addAnotherStudent :(id)sender{
     
    
     
    addAnotherStudent = [self.storyboard instantiateViewControllerWithIdentifier:@"addAnotherStudent"];
     
    
    
    
   // NSLog(@"Teacher group is: %@", teacherOrGroup.lastName);
    
    
   addAnotherStudent.delegate=self;
    
    int gradeINT=[gradeOfClass intValue];
    
    NSString *groupFirstAndLastName=[NSString stringWithFormat:@"%@ %@", teacherOrGroup.firstName, teacherOrGroup.lastName];
    
     
     
    addAnotherStudent.lowerGrades.selectedSegmentIndex=gradeINT;
    addAnotherStudent.groupName=groupFirstAndLastName;
    addAnotherStudent.groupName=teacherOrGroup.firstName;
    
 
	addStudentPopover = [[UIPopoverController alloc] initWithContentViewController:addAnotherStudent];
	
	
	 addAnotherStudent.teacherField.text=teacherOrGroup.lastName;
    addAnotherStudent.lowerGrades.selectedSegmentIndex=[teacherOrGroup.grades integerValue];
	
	[addStudentPopover presentPopoverFromRect:[sender frame] inView:self.view 
					 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
    
}

-(IBAction)editStudent:(id)sender{
     
    
	NSString *currentStudentToEdit = currentStudentName.text;
 	
	for (Student* student in students)
	{
        
		
		if ([student.nombre isEqualToString:currentStudentToEdit]) {
			
			//Student *s =  (Student *)[students objectAtIndex:indexPath.row];
            
			 
			editStudent= [[EditStudentVC alloc] initWithStudent:student];
			
			addStudentPopover = [[UIPopoverController alloc] initWithContentViewController:editStudent];
			
			editStudent.delegate=self;
			
			
			[addStudentPopover presentPopoverFromRect:[sender frame] inView:self.view 
							 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
			 
			 
			
		} //end if
		
	}//end for
	 

    
}

-(IBAction)viewStudents:(id)sender{
    
    
    if (studentListPopover) {
      //  NSLog(@"studentpopover exits, lets kill it before loading");
        [studentListPopover dismissPopoverAnimated:YES];
        studentListPopover=nil;
        studentTableView = [[RRStudentTableVC alloc] initWithStyle:UITableViewStylePlain];
        
        studentListPopover=[[UIPopoverController alloc] initWithContentViewController:studentTableView  ];
        studentListPopover.delegate=self;
        studentTableView.delegate=self;
        
        [studentListPopover presentPopoverFromRect:[sender frame] inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
        
       //  NSLog(@"NO studentpopover exits, lets load one");
     studentTableView = [[RRStudentTableVC alloc] initWithStyle:UITableViewStylePlain];
    
    studentListPopover=[[UIPopoverController alloc] initWithContentViewController:studentTableView  ];
    studentListPopover.delegate=self;
     studentTableView.delegate=self;
    
    [studentListPopover presentPopoverFromRect:[sender frame] inView:self.view
                      permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    }
}

-(void) StudentsListVCDidFinishWithStudent:(NSString *)nm lastName:(NSString*)lm  grade:(NSString *) gr  teacher: (NSString *)tchr  level: (NSString *) lv  notes: (NSString *) nts array: (NSMutableArray*)tstArr andGroups:(NSMutableArray*)grpsAr{
    
    currentStudentName.text=nm;
    currentStudentLastName.text=lm;
	currentStudentTeacher.text=tchr;
	currentStudentGrade.text=gr;
	
	currentStudentLevel.text=lv;
	currentStudentNotes.text=nts;
	
	
	
	[self.studentListPopover dismissPopoverAnimated:YES];
    
   

}

 
-(void)AddStudentVCDidFinish
{
 
	
	[self.addStudentPopover dismissPopoverAnimated:YES];
	
}

-(void)EditStudentVCDidFinish{
    
    [self.addStudentPopover dismissPopoverAnimated:YES];
    
}
-(void) EditStudentDidFinishWithStudent:(Student *)editedStudent{
    
    
	 	[self.addStudentPopover dismissPopoverAnimated:YES];
	
	editingStudent=editedStudent;
	
	int indexOfStudent=0;
	
    
	NSString *changedStudent = currentStudentName.text;
 	  
	for (Student* student in students)
	{
		
		
		if ([student.nombre isEqualToString:changedStudent]) 		
		{
			
            
			
			indexOfStudent	=	[self.students indexOfObject:student];	
            
			 
		} 
		
		
	}
	
	
    [self.students replaceObjectAtIndex:indexOfStudent withObject:editedStudent];
	[self archiveStudents];
	
	currentStudentName.text=editedStudent.nombre;
	currentStudentTeacher.text=editedStudent.teacher;
	currentStudentNotes.text=editedStudent.notes;
    currentStudentLastName.text=editedStudent.apellido;
    currentStudentGrade.text=editedStudent.grade;
    currentStudentLevel.text=editedStudent.level;
    
    
}

-(IBAction) done{
    
    [self.view removeFromSuperview];
    
}

 
-(NSString *) archivePath{
    
    NSString *docDirect = 
	[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES	) objectAtIndex:0];
	return [docDirect stringByAppendingPathComponent:@"Students.dat"];
}
-(void) archiveStudents{
    
    
    [NSKeyedArchiver archiveRootObject:students toFile:[self archivePath]];
    
}


-(NSString *) archiveGroupPath{
    
    NSString *docDirect =
	[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES	) objectAtIndex:0];
	return [docDirect stringByAppendingPathComponent:@"Groups.dat"];
}

-(void)archiveGroup {
    
    
     [NSKeyedArchiver archiveRootObject: groupsArray toFile:[self archiveGroupPath]];
    
}


#pragma mark delegate method

-(void) addStudentDidFinishWithName: (NSString *)nm  lastName:(NSString*)lm grade:(NSString *) gr  teacher: (NSString *)tchr
							  level: (NSString *) lv  notes: (NSString *) nts
                    testRecordArray:(NSMutableArray*) tstArr andGroups:(NSMutableArray*)grpsArr andNumber:(NSNumber*)num{
    
    /*
    NSLog(@"Delegate Method: addeddStudentDidFinishWithName");
    
   
    NSNumber *newNumber =[NSNumber numberWithInt:students.count+1];
    NSLog(@"Added new student to this class with number: %i", students.count+1);
    
    Student *newStudent =[[Student alloc] initWithName:(NSString *)nm lastName:(NSString*)lm grade:(NSString *) gr teacher: (NSString *)tchr  level: (NSString *) lv notes: (NSString *) nts testRecordArray:(NSMutableArray*) tstArr andGroups:(NSMutableArray*)grpsArr andNumber:newNumber];
    
    
   // [teacherOrGroup.studentsArray addObject:newStudent];
    
    [studentsInThisGroupArr addObject:newStudent]; //add it to this particular class
    
    
    
    [self.students addObject:newStudent]; //add to the whole body of students...
    
    
    
    NSLog(@"There are now: %i students in the array", self.students.count);
    
    currentStudentName.text=nm;
	currentStudentTeacher.text=tchr;
	currentStudentGrade.text=gr;
	currentStudentLastName.text=lm;
	currentStudentLevel.text=lv;
	currentStudentNotes.text=nts;
    
    [self.addStudentPopover dismissPopoverAnimated:YES];
	
	
	
	
	[self archiveStudents];
    */
    
}

#pragma mark Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return studentsInThisGroupArr.count;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    
    
    
    Student *s =  (Student *)[studentsInThisGroupArr objectAtIndex:indexPath.row];
    
    
    
    
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", s.nombre, s.apellido];
    cell.textLabel.text=fullName;
    
    NSString *info = [NSString stringWithFormat:@"%@ -- %@", s.grade, s.teacher];
    
    cell.detailTextLabel.text=info;
    cell.textLabel.font = [UIFont fontWithName:@"Futura" size:18];

    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int indexToDelete=0;
    //need to change these
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		 
		[tableView beginUpdates];
        
        
            Student *aStudent=(Student*)[studentsInThisGroupArr objectAtIndex:indexPath.row];
        NSString *studToDelete=@"";
        
        
        
        for (Student *stdt in students ) {
            if ([stdt.studentID  isEqualToString:aStudent.studentID]) {
                
             //   NSLog(@"We have a student to delete! with id: %@", aStudent.studentID);
                 
                studToDelete=aStudent.studentID;
                indexToDelete=[students indexOfObject:stdt];
                
            }
        }
        //this removes it from master array
		 [students removeObjectAtIndex:indexToDelete];
        
          [studentsInThisGroupArr removeObjectAtIndex:indexPath.row];
        
        //now remove this student from students
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
        
        
        [tableView endUpdates];
        
		[NSKeyedArchiver archiveRootObject:students toFile:[self archivePath]];
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //push the next view controller to edit student, view details, etc. 
    individualProfileVC= [self.storyboard instantiateViewControllerWithIdentifier:@"IndividualStudentID"];
    
    Student *aStudent=(Student*)[studentsInThisGroupArr objectAtIndex:indexPath.row];
    
    //  setUpViewController.studentsInThisGroupArr=group.studentsArray;
    
    individualProfileVC.thisStudent=aStudent;
    
     
    
    aStudent=nil;
    
    [self.navigationController pushViewController:individualProfileVC animated:YES];
    
    
}
- (NSString *)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
   // return (__bridge NSString *)uuidStringRef;
    return  CFBridgingRelease(uuidStringRef); //this fixes potential memory leak
}

#pragma mark addAnotherStudent delegate methods
//-(void) AddStudentVCDidFinish ; //well add arugments later...

-(void) pushIndividualStudentProfile:(NSString*)sID{
    
    
    
}


-(void) addAnotherStudentDidFinishWithName: (NSString *)nm  lastName:(NSString*)lm grade:(NSString *) gr  teacher: (NSString *)tchr
                                     level: (NSString *) lv  notes: (NSString *) nts
                           testRecordArray:(NSMutableArray*) tstArr andGroups:(NSMutableArray*)grpsArr andID:(NSString *)stID {
    
    
    
    NSString  *anId=[self uuid];
         
    Student *newStudent =[[Student alloc] initWithName:(NSString *)nm lastName:(NSString*)lm grade:(NSString *) gr teacher: (NSString *) tchr  level: (NSString *) lv notes: (NSString *) nts testRecordArray:(NSMutableArray*) tstArr andGroups:(NSMutableArray*)grpsArr andID:(NSString*)anId];
    
   
    
    
    
    
     
     [studentsInThisGroupArr addObject:newStudent]; //add it to this particular class
    
         
    if (self.teacherOrGroup.studentsArray !=nil) {
        
    
   [ self.teacherOrGroup.studentsArray addObject:newStudent.studentID];
        
        
    }
    int indexOfGroup=0;
	
	
	NSString *changedGroup = teacherOrGroup.firstName;
    
    for (Teacher *grp in groupsArray) {
        
        if ([grp.firstName isEqualToString:changedGroup]) {
            
            //we have a match so let's get the index
            indexOfGroup	=	[self.groupsArray indexOfObject:grp];
             
            
        }
        
    }
    
    
    
    [self.groupsArray replaceObjectAtIndex:indexOfGroup withObject:teacherOrGroup];
	 
    //now look in the groups array and replace the old group with the updated group
    
    
    
    
    [self.students addObject:newStudent]; //add to the whole body of students...
    
     
    
    currentStudentName.text=nm;
	currentStudentTeacher.text=tchr;
	currentStudentGrade.text=gr;
	currentStudentLastName.text=lm;
	currentStudentLevel.text=lv;
	currentStudentNotes.text=nts;
    
    [self.addStudentPopover dismissPopoverAnimated:YES];
	
	
	
	
	[self archiveStudents];
    [self archiveGroup];
    
    [studentsInGroupTable reloadData];
    
}
 

-(void) addAnotherStudentVCDidFinish{
    
    [self.addStudentPopover dismissPopoverAnimated:YES];
    
    
    
}




#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return 5;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    //if(pieChart == self.pieChartBenchmark) return nil;
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
     
}
-(void) setStudentForRunningRecord:(Student*)studentForTest{
    
    //do nothing for now
}

- (void)viewDidUnload
{
    
    currentStudentTests=nil;
    
    [self setPieChartBenchmark:nil ];
    [self setViewStudentsBtn:nil];
    [self setEditStudentsBtn:nil];
    [self setAddStudentsBtn:nil];
    studentsInThisGroupArr=nil;
    
    [self setPieChartBaseView:nil];
    [self setGroupNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation ==UIInterfaceOrientationPortrait);
}

@end
