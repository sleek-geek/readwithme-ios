//
//  IndividualStudentVC.m
//  RWM Fluency
//
//  Created by Francisco Salazar on 11/19/12.
//
//

#import "IndividualStudentVC.h"
#import "PlayerCell.h"
#import "RRViewController.h"

@interface IndividualStudentVC ()

@end

@implementation IndividualStudentVC
@synthesize passagesPopover;
@synthesize accuracyLabel,launchAssessmentBtn, nameLabel, teacherLabel, gradeLabel, groupsLabel, readingLevelLable, frustrationLevelLabel, cwpmLabel, instructionalLabel, IndependentLabel;
@synthesize graph;
@synthesize thisStudent, lastTestedLabel, notesTextView, studentsArray, classesArray, thisStudentGroup;
@synthesize testHistoryTable;
@synthesize graphChoiceSegment;
@synthesize delegate;
@synthesize graphYAxis, lastTestedView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




-(IBAction)launchAssessment:(id)sender{
    
     
    
    gradesTableVC =[[RRGradeTableVC alloc] init];
    
    gradesTableVC.delegate=self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:gradesTableVC];
    
    passagesPopover = [[UIPopoverController alloc] initWithContentViewController:navController];
    
    passagesPopover.delegate=self;
    
    passagesPopover.popoverContentSize = CGSizeMake(230, 500);
    
    [ passagesPopover presentPopoverFromRect:CGRectMake(340, 125, 230, 500) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
    
}
-(void)viewWillAppear:(BOOL)animated    {
         
    if (testHistoryTable!=nil) {
        
    }
     
    
}

- (void)viewDidLoad
{
    
    
  //lets flip the YaxisLabel
    graphYAxis.transform =  CGAffineTransformMakeRotation(- M_PI/2 );
    
    //label.transform = CGAffineTransformMakeRotation( M_PI/4 )
    
    graphChoiceSegment.selectedSegmentIndex=0; //default set to accuracy!
    
    
    self.testHistoryTable.rowHeight=100;
    
    self.classesArray=[NSKeyedUnarchiver
                        unarchiveObjectWithFile:  [self archiveGroupPath]];
    
    if ( self.classesArray==nil) {
		 
        classesArray =[[NSMutableArray alloc] init];
		
	}
    
    
     self.studentsArray = [NSKeyedUnarchiver
					 unarchiveObjectWithFile:  [self archiveStudentsPath]];
    
    if ( self.studentsArray==nil) {
		 
		 studentsArray =[[NSMutableArray alloc] init];
		
	}
    
    //lets unarchive all the tests...THESE ARE THE SYSTEM TESTS, NOT CUSTOM
    assessmentsArray = [NSKeyedUnarchiver
                                      unarchiveObjectWithFile:  [self archivePath]];
    
    if (assessmentsArray==nil) {
		 
		assessmentsArray =[[NSMutableArray alloc] init];
		
	}
    
    if (studentAssessmentsArray==nil) {
		 
		studentAssessmentsArray =[[NSMutableArray alloc] init];
         
        
		
	} else {
        
         
        
         [studentAssessmentsArray removeAllObjects];
    }
    
    
    NSString *studentFullName =[NSString stringWithFormat:@"%@ %@", thisStudent.nombre, thisStudent.apellido];
     
    
    
    for (Test *t in assessmentsArray) {
        
        
       // NSLog(@"Comparing %@ to %@", t.studentName, studentFullName);
        
        if ([t.studentName isEqualToString:studentFullName]) {
            
            //we have match
            
          //  NSLog(@"Tests found for %@", t.studentName);
             
            
            [studentAssessmentsArray addObject:t];
            
        }
        
         
        
    }
    
    //******* The  code  below is not necessary, only for debugging purpos******
    
    
    //let's see what is actually in the studentAssessmentArray:
            //******* This code above is not necessary, only for debugging purpos******
    
    if (studentAssessmentsArray.count==0){
        
        
        //no assessments, so lets hide hte views
        
        graph.hidden=YES;
        lastTestedView.hidden=YES; 
        
    
    }
    
    
    Test *lastTest=[studentAssessmentsArray lastObject] ; //assuming it's the last object
    NSDate *lastTestedDate =lastTest.testDate;
         float accFloat= [lastTest.accuracy floatValue];
    
    accuracyLabel.text=[NSString stringWithFormat:@"%.0f", accFloat];
   
    
    nameLabel.text=studentFullName;
    teacherLabel.text=thisStudent.teacher;
    gradeLabel.text=thisStudent.grade;
    
    
    
    
    if ([lastTest.testStatus isEqualToString:@"Passed"]) {
        
        readingLevelLable.text=[NSString stringWithFormat:@"%i", [lastTest.passageLevel intValue]];
    } else {
        
        
         readingLevelLable.text=[NSString stringWithFormat:@"%i", [thisStudent.level intValue]];
    }
    
    
    
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *dateToDisplay=[formatter stringFromDate:lastTestedDate];
    
    
    
    
    
    lastTestedLabel.text = dateToDisplay;
     
    
    NSString *  groupsString=@"";
    
    //go trough groups array to find groups this student belongs to.
    for (NSString *grps in thisStudent.groupsArray) {
        
         
        
    groupsString  = [NSString stringWithFormat:@"%@       ", grps];
        
        
        
    }
    
    groupsLabel.text=groupsString;
    
    //find 
    accuracyLabel.text=[NSString stringWithFormat:@"%i", [lastTest.accuracy intValue]];
    
    
    cwpmLabel.text=[NSString stringWithFormat:@"%i", [lastTest.fluency intValue]];;
    
    notesTextView.text=thisStudent.notes;
    
    //Now find instructional level based on studentArrays
    
    
    //go through studenttestArray and get all the testaccuracys between 90 and 95, and so on
    NSMutableArray *instructionalArray=[[NSMutableArray alloc] init];
    NSMutableArray *frustrationArray=[[NSMutableArray alloc]init];
    NSMutableArray *independentArray=[[NSMutableArray alloc]init];
    
    for (Test*t in studentAssessmentsArray) {
        
        if ([t.accuracy floatValue] >=90 && [t.accuracy floatValue] <96) {
            //we have ourselves a test in the instructional range
            
            [instructionalArray addObject:t];
            
            
            
        } else if ([t.accuracy floatValue] < 90 ) {
            //we have ourselves a test in the frustration range
            
            [frustrationArray addObject:t];
            
            
            
        } else {
            
            [independentArray addObject:t];
            
        }
        
    }
    
    
    //then  go through each array and find the test that has the greatest fluency
    NSNumber *greatestFluency=[NSNumber numberWithInt:0];
    NSNumber *readLevl=[NSNumber numberWithInt:0];
    
    for (Test* u in instructionalArray) {
        
        //find the greatest fluency
         
        
        if  ([u.fluency floatValue] > [greatestFluency floatValue] && [u.testStatus isEqualToString:@"Passed"]){
            
                        
            greatestFluency=u.fluency;
             

            
        }
        if  ([u.passageLevel intValue] > [readLevl intValue]){
            
                         
            readLevl=u.passageLevel;
            
            
        }
        
        
        
    }
    
    instructionalLabel.text =[NSString stringWithFormat:@"%.0f", [readLevl floatValue]];
    
    
    greatestFluency=[NSNumber numberWithInt:0];
    readLevl=[NSNumber numberWithInt:0];
    
    
    for (Test* v  in independentArray) {
        
        //find the greatest fluency
        
        
        if  ([v.fluency floatValue] > [greatestFluency floatValue] && [v.testStatus isEqualToString:@"Passed"]){
            
            greatestFluency=v.fluency;
            
                         
        }
        
        if  ([v.passageLevel intValue] > [readLevl intValue]){
            
            
            
            readLevl=v.passageLevel;
            
            
        }
        
    }
    IndependentLabel.text =[NSString stringWithFormat:@"%.0f", [readLevl floatValue]];
    
    
    greatestFluency=[NSNumber numberWithInt:0];
    readLevl=[NSNumber numberWithInt:0];
    
    for (Test* w  in frustrationArray) {
        
        //find the greatest fluency
        
        
        if  ([w.fluency floatValue] >[greatestFluency floatValue]){
            
            greatestFluency=w.fluency;
            
            
        }
        
        if  ([w.passageLevel intValue] > [readLevl intValue]){
                         
            readLevl=w.passageLevel;
            
             
        }
    }
    
    frustrationLevelLabel.text =[NSString stringWithFormat:@"%.0f", [readLevl floatValue]];
    
    
    instructionalArray=nil;
    frustrationArray=nil;
    independentArray=nil;
    
    
    
    [self calculateProgress];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editStudent:)] ;
    self.navigationController.navigationItem.rightBarButtonItem=editButton;
    
    
    
    
    
}
-(NSString*)archiveGroupPath{
    
    NSString *docDirect =
	[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES	) objectAtIndex:0];
	return [docDirect stringByAppendingPathComponent:@"Groups.dat"];
    
}




-(IBAction)changeGraphOption:(id)sender{
    
     
    if ([self.graph.boolNum intValue]==1 ) {
         
    
     
    self.graph.boolNum=[NSNumber numberWithInt:0];
    
    } else if ([self.graph.boolNum intValue]==0 ){
        
    
        
        self.graph.boolNum=[NSNumber numberWithInt:1];
    }
    
    
    [self.graph setNeedsDisplay];
}


-(void)archiveGroups{
    
    [NSKeyedArchiver archiveRootObject:classesArray toFile:[self archiveGroupPath]];
    
    
    
    
    
}
-(NSString *) archiveStudentsPath{
    
    NSString *docDirect =
	[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES	) objectAtIndex:0];
	return [docDirect stringByAppendingPathComponent:@"Students.dat"];
}
-(void) archiveStudents{
    
     
    [NSKeyedArchiver archiveRootObject:self.studentsArray toFile:[self archiveStudentsPath]];
    
    
    
    for (Student *s in self.studentsArray) {
        
        
        
    }
    
}


-(NSString *) archivePath{
    
    NSString *docDirect =
	[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES	) objectAtIndex:0];
	return [docDirect stringByAppendingPathComponent:@"Tests.dat"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) calculateProgress{
    
    NSMutableArray*tempFluencyArray =[[NSMutableArray alloc]initWithCapacity:studentAssessmentsArray.count];
    NSMutableArray*tempAccuracyArray =[[NSMutableArray alloc]initWithCapacity:studentAssessmentsArray.count];
    NSMutableArray*tempLevelsArray =[[NSMutableArray alloc]initWithCapacity:studentAssessmentsArray.count];
    NSMutableArray*tempDatesArray =[[NSMutableArray alloc]initWithCapacity:studentAssessmentsArray.count];
    
    for (Test *t in studentAssessmentsArray){
    //    NSLog(@"t.Fluency: %i", [t.fluency intValue]);
        
        //get the test and fluency, accuracy, date make a dictionary
        if (t.fluency ) {
            
        
        [ tempFluencyArray addObject:t.fluency];
        
            
            }
       //  NSLog(@"Accuracy: %i", [t.accuracy intValue]);
        
        if(t.accuracy){
        
        [tempAccuracyArray addObject:t.accuracy];
            
            
        }
        
        
        [tempLevelsArray   addObject:t.passageLevel];
        
        
        [tempDatesArray addObject:t.testDate];
        
        
        
        
    }
    
    self.graph.testArray=tempAccuracyArray;
    self.graph.fluencyArray=tempFluencyArray;
    self.graph.levelsArray=tempLevelsArray;
    self.graph.datesArray=tempDatesArray;
    //[self.graph setNeedsDisplay];
    
    tempFluencyArray=nil;
    tempLevelsArray=nil;
    tempAccuracyArray=nil;
    
}
-(void) playRecording{
    
    
    
    
}


 


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     
    
    // Return the number of rows in the section.
    return studentAssessmentsArray.count;
   
    
} 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
      
    
     static NSString *CellIdentifier = @"Cell";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    
    //  Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
        
        
    }
        cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.textColor=[UIColor purpleColor];
       
        
        
        cell.detailTextLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        
         Test *testForCell=(Test*)[studentAssessmentsArray objectAtIndex:indexPath.row];

    
       
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        
        NSString *dateToDisplay=[formatter stringFromDate:testForCell.testDate];
        
        
        
        NSString *cellTextString =[NSString stringWithFormat:@"%@  Title: %@   Level: %i   Grade: %i ", dateToDisplay,
                               testForCell.passageTitle, [testForCell.passageLevel intValue], [testForCell.passageGrade intValue]];
        
          
        
        
        cell.textLabel.text=cellTextString  ;
        
        NSString *cellDetailString=[NSString stringWithFormat:@"Accuracy: %.1f || Fluency: %.0f cwpm || No. errors: %i " ,
                                    [testForCell.accuracy floatValue], [testForCell.fluency floatValue], testForCell.testTypeArray.count ];
        
        cell.detailTextLabel.text=cellDetailString;
        
     
    
    return cell;
}

 
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
	  		
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
		//NSLog(@"row deleted from data Source");
             }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
 
        //load the offline report from storyboard
      offlineReportVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineReport"];
        
        Test *someTest=(Test*)[studentAssessmentsArray objectAtIndex:indexPath.row];
    
        offlineReportVC.aTest=someTest;
    
    
        
        //  setUpViewController.studentsInThisGroupArr=group.studentsArray;
    
   
    //have to find the grade level of the passage
    gradeLevelForChosenPassage=someTest.passageGrade;
    
        
    offlineReportVC.aTest=someTest;
    offlineReportVC.studentName=thisStudent.nombre;
    offlineReportVC.passageTitle=aTest.passageTitle;
    
   // need to work on getting passage text set in next view
    
   // offlineReportVC.passageText=
    
    offlineReportVC.passageGradeLevel=gradeLevelForChosenPassage;
    
    int studGradINT = [ thisStudent.grade intValue];
    
    offlineReportVC.studentGradeLevel=[NSNumber numberWithInt:studGradINT];
    
    
        
        someTest=nil;
        
        [self.navigationController pushViewController:offlineReportVC animated:YES];
    
    
     
}



-(void) passageVCDidChooseWithTitle:(NSString*)aPassage andGrade:(NSNumber*)aGrade{
    
    
     
    [self.passagesPopover dismissPopoverAnimated:YES];
    
    titleOfChosenPassage = aPassage;
    gradeLevelForChosenPassage=aGrade;
    
    
    if ([thisStudent.nombre isEqualToString:@"nil"]) {
        
        thisStudent.nombre=@"Touch to Choose Student";
    }
    
    /*
     rrviewController = [[RRViewController alloc] initWithPassageName:nextPassageString andStudent:@"Touch to choose student"];
     */
  ///  [self performSegueWithIdentifier:@"Evaluate" sender:self];
    evaluationVC=[self.storyboard instantiateViewControllerWithIdentifier:@"EvalViewController" ];
    //we don't want to add the grade of the student, but grade of selected text...
    
    
    
    
    
    NSString *stringForName =[NSString stringWithFormat:@"%@ %@", thisStudent.nombre, thisStudent.apellido];

     
    evaluationVC.studentReading=stringForName;
    evaluationVC.studentIdNumber=thisStudent.studentID;
    
    //need to add this student here for eval screen
    evaluationVC.student=thisStudent;
    evaluationVC.gradeLevel=gradeLevelForChosenPassage; //not student grade, but passage grade
    
    evaluationVC.textTitle=titleOfChosenPassage;
    
    
    [self.navigationController pushViewController:evaluationVC animated:YES ];
    //[self.view addSubview:rrviewController.view];
    
    
    
    
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
      if ([segue.identifier isEqualToString:@"Evaluate"]) {
    
      } else if ([segue.identifier isEqualToString:@"EditStudent"]) {
          
                     
          [segue.destinationViewController setStudentEditing:thisStudent];
          [segue.destinationViewController setDelegate:self];
      }

}
-(IBAction)editStudent:(id)sender{
    
    
   editStudentVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"EditStudent"];
         
    editStudentVC.studentEditing=thisStudent;
     editStudentVC.delegate=self;
	editStudentPopover = [[UIPopoverController alloc] initWithContentViewController:editStudentVC];
    
    [editStudentPopover presentPopoverFromRect:[sender frame] inView:self.view
					 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
	
}


-(void) EditStudentVCDidFinish {
    
    
        [editStudentPopover dismissPopoverAnimated:YES];
}

-(void)EditStudentDidFinishWithStudent: (Student *) editedStudent{
    
    
	
	int indexOfStudent=0;
       
	for (Student* student in self.studentsArray)
	{
		 
     
        
		if ([editedStudent.studentID isEqualToString:student.studentID])
		{
			
			indexOfStudent	=	[self.studentsArray indexOfObject:student];
            
			  
		}
		
		
	}
	
	
    [self.studentsArray replaceObjectAtIndex:indexOfStudent withObject:editedStudent];
    
    
    
   // NSLog(@"student new name: %@", [[self.studentsArray objectAtIndex:indexOfStudent] nombre]);
	[self archiveStudents];
    [editStudentPopover dismissPopoverAnimated:YES];
    
    //Actually, dont need to update group student info ID.
     
    
    notesTextView.text=editedStudent.notes;
    nameLabel.text=[NSString stringWithFormat:@"%@ %@", editedStudent.nombre, editedStudent.apellido];
    gradeLabel.text=editedStudent.grade;
    
    for (NSString *groups in editedStudent.groupsArray) {
        
        groupsLabel.text=[NSString stringWithFormat:@"     %@", groups];
        
    }
    
   // [self archiveGroups];
    
}

- (void)viewDidUnload {
    [self setTeacherLabel:nil];
    [self setGradeLabel:nil];
    [self setGroupsLabel:nil];
    [self setReadingLevelLable:nil];
    [self setFrustrationLevelLabel:nil];
    [self setIndependentLabel:nil];
    [self setInstructionalLabel:nil];
    [self setBenchmarkLabel:nil];
    [self setLastTestedLabel:nil];
    [self setTestHistoryTable:nil];
    [self setCwpmLabel:nil];
    [self setAccuracyLabel:nil];
    [self setLaunchAssessmentBtn:nil];
    [self setNotesTextView:nil];
    [self setGraphChoiceSegment:nil];
    [self setGraphYAxis:nil];
    [self setLastTestedView:nil];
    [super viewDidUnload];
}
@end
