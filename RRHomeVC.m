//
//  RRHomeVC.m
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RRHomeVC.h"
#import "RRPassageVC.h"
#import "Student.h"

@interface RRHomeVC ()

@end

@implementation RRHomeVC
@synthesize setupButton;
@synthesize passageButton;
@synthesize reportsButton;
@synthesize quickStartButton;
@synthesize settingsButton;
@synthesize aboutButton;
@synthesize guideButton;
@synthesize quickStartPopover;
@synthesize passagesPopover;
@synthesize rrviewController, setUpViewController;
@synthesize classTableView, passageTableView;
@synthesize passageViewController;
@synthesize classesArray;
@synthesize helpMeBtn;
@synthesize helpOverlayImg;
 

 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    
    
     [self.navigationController setNavigationBarHidden:NO animated:animated];
    
if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
    // Load resources for iOS 6.1 or earlier
    
  //  NSLog(@"Do nothting to view, we are in ios 6");
} else {
     
    
  //  NSLog(@"adjust the view for ios7");
}
}

- (void)viewDidLoad




{
    
    helpMeBtn.enabled=YES;
    
    helpOverlayImg.hidden=YES;
    
    [super viewDidLoad];
    
    self.passageTableView.rowHeight=60;
    chosenStudent=@"nil";
    
     customTextsArray = [[NSMutableArray alloc]initWithContentsOfFile:[self filePathForCustomPsg]];
    
    
     
    if (customTitlesArray==nil) {
        customTitlesArray= [[NSMutableArray alloc]init];
        
        
        
        for (NSDictionary *dict in customTextsArray) {
            
          //  NSLog(@"dict has: %@" , dict);
            
            NSString *titleToSnatch = [dict objectForKey:@"Title"];
            
         //   NSLog(@"snatching title: %@", titleToSnatch);
            [customTitlesArray addObject:titleToSnatch];
            
            
            
            
        }
        
    }
    
    
    if (passagesArray==nil){
        
        //if no classes array, init one
        
        passagesArray=[[NSMutableArray alloc] init];
        
        NSString *gradeString=@"";
        
        for (int i=0; i<=7; i++) {
            
            
            //do this 8 times
            
            if (i==0) {
               gradeString=@"1stGradePassages";
            } else if (i==1){
                
                gradeString=@"2ndGradePassages";
            }else if (i==2){
                
                gradeString=@"3rdGradePassages";
            }else if (i==3){
                
                gradeString=@"4thGradePassages";
            }else if (i==4){
                
                gradeString=@"5thGradePassages";
            } else if (i==5){
                
                gradeString=@"6thGradePassages";
            } else if (i==6){
                
                gradeString=@"7thGradePassages";
            } else if (i==7){
                
                gradeString=@"8thGradePassages";
            
            }
            
            NSString *pathForPlist = [[NSBundle mainBundle]pathForResource:gradeString ofType:@"plist"];
            
            NSArray* tempArr = [[NSArray alloc] initWithContentsOfFile:pathForPlist];
            
           // NSLog(@"tempArrContents: %@", tempArr);
            
            [ passagesArray addObject:tempArr];
            
            
            
            tempArr=nil;
            
        }
        //now add the custom passages to the passages array!
   
    if (customTextsArray!=nil) {
        
    
    [passagesArray addObject:customTextsArray];
    
        
        
    
    }
    
    }


   // NSLog(@"passages array has the following passage: %@", passagesArray);
    
    
    //now go through passages array to take out tiles and put them in newTitlesArray
    if (titlesArray==nil) {
        
        titlesArray = [[NSMutableArray alloc]init];
        
        for (NSArray *array in passagesArray) {
            
            for (NSDictionary *dict in array) {
                
                
                NSString *titleToSnatch = [dict objectForKey:@"Title"];
                
             //   NSLog(@"snatching title: %@", titleToSnatch);
                [titlesArray addObject:titleToSnatch];
                
                
            }
            
        }
    
    }
    
    //Now find the custom passages and put them into the customarray
    
    
    
    
    
   // customTitlesArray=[[NSMutableArray alloc]initWithContentsOfFile:[self filePathForCustomPsg]]; //here are the custom titles
    
    allTextsArray=[[NSMutableArray alloc] initWithObjects:titlesArray , customTitlesArray   , nil];
    
    
    
    
    
    
    //Now for the groups...
    
    self.classesArray =[NSKeyedUnarchiver
                        unarchiveObjectWithFile:  [self archivePath]];
    
    if (self.classesArray==nil) {
        
        self.classesArray=[[NSMutableArray alloc]init];
        
      //  NSLog(@"classes Array init");
    }
    
    if (classesArray.count==0) {
        quickStartButton.enabled=NO;
    }
    
    
   // NSLog(@"classesArray: %@", classesArray);
    // Do any additional setup after loading the view from its nib.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"Scoring"]) {
        
      
        [segue.destinationViewController setGradeLevel:gradeLevelForChosenPassage];
      //  NSLog(@"Grade level for chosen passage: %i", [gradeLevelForChosenPassage intValue]);
        
        [segue.destinationViewController setStudentReading:chosenStudent];
        [segue.destinationViewController setTextTitle:titleOfChosenPassage];
        
    } else if ([segue.identifier isEqualToString:@"AddClass"]){
        
       // NSLog(@"prepare for Segue: AddClass");
        [segue.destinationViewController setDelegate:self];
        
        
    } else if ([segue.identifier isEqualToString:@"AddPassage"]){
        
      //  NSLog(@"prepare for Segue: AddClass");
        [segue.destinationViewController setDelegate:self];
        
        
    }
    
}


-(IBAction)showPassages:(id)sender{
    
  //  NSLog(@"showPassagest Launched");
    
    
    
   // UITableViewController *aTableViewContoller= [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    
    //UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:passageTableViewController];
    
   // passageTableViewController=[[RRPassagesTableVC alloc] init];
    
    gradesTableVC =[[RRGradeTableVC alloc] init];
    
    gradesTableVC.delegate=self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:gradesTableVC];
     
    
     
    passagesPopover = [[UIPopoverController alloc] initWithContentViewController:navController];
    
    passagesPopover.delegate=self;
    
    passagesPopover.popoverContentSize = CGSizeMake(230, 350);
    
    [ passagesPopover presentPopoverFromRect:CGRectMake(340, 125, 230, 350) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
  //  passageTableViewController.delegate=self;
    
    
    
}

-(IBAction)quickStart:(id)sender{
    
    
    studentTableViewController =[[RRStudentTableVC alloc] init];
    
    
     
    
    
    UITableViewController *tableViewContoller= [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
     
    
    
    studentTableViewController.useForStudentList=@"HomeScreen";
    tableViewContoller.contentSizeForViewInPopover=CGSizeMake(230, 400);
    tableViewContoller=studentTableViewController;
     
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tableViewContoller];
    quickStartPopover = [[UIPopoverController alloc] initWithContentViewController:navController];
    [quickStartPopover presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
    
    
    
}

 
-(IBAction)showSetup:(id)sender{
    
  //  NSLog(@"showSetupt Launched");
    
    setUpViewController=[[SetupVCViewController alloc] initWithNibName:@"SetupVCViewController" bundle:[NSBundle mainBundle]];
    
    [self.view addSubview:setUpViewController.view];
    
    
    
}

-(IBAction)showReports:(id)sender{
    
    
  //  NSLog(@"showReports Launched");
}
-(IBAction)showGuide:(id)sender{
    
    if (helpOverlayImg.hidden==YES) {
        helpOverlayImg.hidden=NO;
    }else{
        helpOverlayImg.hidden=YES;
    }
    
    
  //  NSLog(@"showGuide Launched");
}
-(IBAction)showAbout:(id)sender{
    
    
    
  //  NSLog(@"showAbout Launched");
    
}

- (IBAction)showHelperView:(id)sender {
    
    
   oLHelperView= [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineHelper"];
    
    
    
    /*
   popover=[[UIPopoverController alloc]initWithContentViewController:oLHelperView];
    
    [popover presentPopoverFromRect:self.view.frame inView:self.view    permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
     
     */
    
    [self.navigationController pushViewController:oLHelperView animated:YES];
  //  NSLog(@"Showing helper view");
    
    
}




#pragma mark delegate methods

-(void) passageVCDidChooseWithTitle:(NSString*)aPassage andGrade:(NSNumber*)aGrade{
    
    [self.passagesPopover dismissPopoverAnimated:YES];
    
    titleOfChosenPassage = aPassage;
   // NSLog(@"title of chosen passage %@ AND GRADE %i", titleOfChosenPassage, [aGrade intValue] );
    gradeLevelForChosenPassage=aGrade;
    
    
    if ([chosenStudent isEqualToString:@"nil"]) {
        
        chosenStudent=@"Touch to Choose Student";
    }
    
   /*
    rrviewController = [[RRViewController alloc] initWithPassageName:nextPassageString andStudent:@"Touch to choose student"];
    */
    [self performSegueWithIdentifier:@"Scoring" sender:self];
    
    
    //[self.view addSubview:rrviewController.view];
   // NSLog(@"RRHome recieved delegatemethod and added subview");
    
    
    
}

-(void) StudentsListVCDidFinishWithStudent:(NSString *)nm lastName:(NSString*)lm  grade:(NSString *) gr  teacher: (NSString *)tchr  level: (NSString *) lv  notes: (NSString *) nts array: (NSMutableArray*)tstArr andGroups:(NSMutableArray*)grpsAr{
    
    
    //NSLog(@"studentListDidFinishWithStudent");
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView==classTableView) {
        return 1;
    } else
        
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if (tableView==classTableView) {
        return classesArray.count;
    } else {
        
        NSArray *sectionContents = [allTextsArray objectAtIndex:section];
       NSInteger rows = [sectionContents count];
        
         return rows;
         
        
        
      //  return allTextsArray.count;
    }
    
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
     if (tableView==classTableView) {
         
         groupToDeleteIndexPath= indexPath;
      //   NSLog(@"groupToDeleteIndexPath.row=%i", groupToDeleteIndexPath.row);
         UIAlertView *deleteAlert=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Deleting this group will erase all of its data, including students and assessmetns" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete Group", nil];
         
         [deleteAlert show];
         
         
         
         
      //   NSLog(@"the classes array has %@", classesArray);
         [tableView beginUpdates];
         
         
         
         //now go through the group and delete them from all the students
         
         
         //look at the index of the group in array
        // [classesArray removeObjectAtIndex:indexPath.row];
         
       //  [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
         
         
         //get index of group being deleted
         
         
         
         
         //iterate through the students and find matches of ids to remove
         
         
         
         //iterate through assessments and remove all the assessmetns linked through each student, if any
         
         
         
         
         
         //update tableview
         
         
        
         
         
         //archimve groups
         
         [tableView endUpdates];
         
         
         
         
     }else{
         
          
              
             
         
         
         [tableView beginUpdates];
         //find matches for custom passages
         
         int indexToDelete=0;
          
         
         NSArray *sectionContents = [allTextsArray objectAtIndex:[indexPath section]];
         NSString *contentForThisRow = [sectionContents objectAtIndex:[indexPath row]];
                 
         //lets get it out of custom texts array
         BOOL canDelete=NO;
         for (NSDictionary *dicts in customTextsArray) {
             if ([contentForThisRow isEqualToString:[dicts objectForKey:@"Title"]]){
                
                 canDelete=YES;
               //  NSLog(@"Found an item to delete from customTextsArray");
                 indexToDelete=[customTextsArray indexOfObject:dicts];
             }
         }
         
         if (customTextsArray.count> 0 &&canDelete==YES) {
              //have to make sure this only works when section is 1
            // NSLog(@"CAn delete!");
         [customTextsArray removeObjectAtIndex:indexToDelete];
             
         }else{
             
           //  NSLog(@"Not authorized to delete") ;
         }
         //return this value to zero
         //   NSLog(@"POST Removal: customTextsArray: %@", customTextsArray);
         
          indexToDelete=0;
         
         
        
         
        // [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:YES];
         if (canDelete==YES) {
              
         
         [[allTextsArray objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
        
         
          [customTextsArray writeToFile:[self filePathForCustomPsg] atomically:YES];
         //update tableview
          [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
         }
         
         [tableView endUpdates];
          
         
           
         
     }
    
     
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    
    if (tableView==classTableView) {
        
        Teacher *group=(Teacher*)[classesArray objectAtIndex:indexPath.row];
        
        
        cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        cell.detailTextLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:16];

      cell.textLabel.text=group.firstName; //actually this is group name
        cell.detailTextLabel.text=group.lastName;
    
    } else{
        
         NSArray *sectionContents = [allTextsArray objectAtIndex:[indexPath section]];
         NSString *contentForThisRow = [sectionContents objectAtIndex:[indexPath row]];
        
       
        
        //Now to show off each passage on the right label:
        
      // NSString *passageTitleForTable=[allTextsArray objectAtIndex:indexPath.row];
        NSString *passageTitleForTable=contentForThisRow;
        
       //  passageTitleForTable=[[[allTextsArray objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"Title"];
        
        //now sort by grade level
        
        cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        cell.backgroundColor=[UIColor clearColor];
        
        if (passageTitleForTable!=nil) {
      
            
            
        cell.textLabel.text=passageTitleForTable;
            
        }else {
            
            cell.textLabel.text=@"Untitled";
        }
        
        NSString *sameTitleString=@"";
        
        //now for subtitle, lets look into all texts array, object at index
        
        
        
        
        for (NSArray *array in passagesArray) {
            
            for (NSDictionary *dict in array) {
                
                sameTitleString= [dict objectForKey:@"Title"];
     
                
                if ([passageTitleForTable isEqualToString: sameTitleString]) {
                    
                    NSString *gradeString =[dict objectForKey:@"Grade"];
                    
                    if ([[dict objectForKey:@"Lexile"] isKindOfClass:[NSNumber class]]) {
                         
                   
                    
                    NSNumber *lexNum =[dict objectForKey:@"Lexile"];
                    
                    
                    
                    int lexINT = [lexNum intValue];
                     cell.detailTextLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:16];
                        
                    
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"Gr.%@ - Lexile:%iL     ",gradeString, lexINT ];
                 } else if ([[dict objectForKey:@"Lexile"] isKindOfClass:[NSString class]]) {
                     
                     
                     NSString* stringLvl=[dict objectForKey:@"Lexile"];
                     cell.detailTextLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:16];
                     
                     cell.detailTextLabel.text = stringLvl;
                     
                 }
                
                }//end if
                
                
            }//endfor
            
        }//endfor
        
        
        
        
        
        
        //cell.detailTextLabel.text=@"passage detail view";
    }
    // cell.textLabel.text = [super.miscuesArray objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = [super.miscuesArray objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView==classTableView) {
         
         setUpViewController= [self.storyboard instantiateViewControllerWithIdentifier:@"classViewID"];
         
        Teacher *group=(Teacher*)[classesArray objectAtIndex:indexPath.row];
         
       //  setUpViewController.studentsInThisGroupArr=group.studentsArray;
         
         setUpViewController.teacherOrGroup=group;
         
         setUpViewController.groupNameStrng=group.firstName;
         
         group=nil;
         
         [self.navigationController pushViewController:setUpViewController animated:YES];
         
     } else {
    
    passageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"passageViewController"];
    
    
    passageViewController.passagesViewArray= passagesArray;
     
    NSString *passageTitleForTable=[titlesArray objectAtIndex:indexPath.row];
         
    
    passageViewController.titleOfText=passageTitleForTable;
    
    
    [self.navigationController pushViewController:passageViewController animated:YES];
    
     }
      
     
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)//OK button pressed
    {
        
      //  NSLog(@"groupToDeleteIndexPath.row=%i", groupToDeleteIndexPath.row);
        
        
        Teacher *group=(Teacher*)[classesArray objectAtIndex:groupToDeleteIndexPath.row];
        
        NSArray *studentsToDelete=group.studentsArray;
        
        
        [classesArray removeObjectAtIndex:groupToDeleteIndexPath.row];
        
        
        [ classTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:groupToDeleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        
        
        
        
         
        
        //unarchive all the students
        NSMutableArray *students = [NSKeyedUnarchiver
                                   
                                   unarchiveObjectWithFile:  [self studentArchivePath]];
        
        //iterate through them all and find the matches to the students in the students to delete array
        NSMutableArray *disposalArray=[[NSMutableArray alloc]initWithCapacity:students.count];
        
        for (Student*stds in students ) {
             
            
           // NSLog(@"stds SID: %@", stds.studentID);
            
            if ([studentsToDelete containsObject:stds.studentID] ) {
                
             //   NSLog(@"Aha!!!! we found some students to delete: %@", stds.studentID);
                
               // [students indexOfObject:stds];
                
                [disposalArray addObject:stds];
                //
                
                
            }
            
        }
        
        [students removeObjectsInArray:disposalArray];
        
     //   NSLog(@"Studnets has been updated, now it has these students:%@", students );
        
        //remove them from the array
        
        
        
        //archive the students
        
        [NSKeyedArchiver archiveRootObject:students toFile:[self studentArchivePath]];
        
        
        [self archiveGroups];
        
    }
}
-(NSString *) studentArchivePath{
    
    
    NSString *docDirect =
	[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES	) objectAtIndex:0];
	return [docDirect stringByAppendingPathComponent:@"Students.dat"];
    
    
    
}




#pragma mark new class delegate methods

 


-(void)newClassDidCreateClassWithName:(NSString *)className andTeacher:(NSString*)tchrNm andStudents:(NSMutableArray*)stntArrstudentsInClassArray andNotes:(NSString*)notes andGrade:(NSString*)theGrades {
    
    
   // NSLog(@"New class: %@", className);
    
    
    Teacher *newGroup =[[Teacher alloc] initWithName:className lastName:tchrNm email:nil array:stntArrstudentsInClassArray notes:notes grades:theGrades groupName:nil]; //this object has classname already defined a initWithName
    
    
    
    [self.classesArray addObject:newGroup];
    
  //  NSLog(@"New Class has these students in its array: %@", stntArrstudentsInClassArray);
    
    [self archiveGroups];
    
        
}
-(NSString*)archivePath{
    
    NSString *docDirect =
	[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES	) objectAtIndex:0];
	return [docDirect stringByAppendingPathComponent:@"Groups.dat"];
    
}
-(void)archiveGroups{
    
    [NSKeyedArchiver archiveRootObject:classesArray toFile:[self archivePath]];
    
    [classTableView reloadData];
    
    
    
}
-(void) addClassVCDidFinish{
    
   // NSLog(@"AddClassVCDidFinish called");
    
}

- (void)viewDidUnload
{
    [self setSetupButton:nil];
    [self setPassageButton:nil];
    [self setReportsButton:nil];
    [self setQuickStartButton:nil];
    [self setSettingsButton:nil];
    [self setAboutButton:nil];
    [self setGuideButton:nil];
    [self setClassTableView:nil];
    [self setPassageTableView:nil];
    [self setHelpMeBtn:nil];
    [self setHelpOverlayImg:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation ==UIInterfaceOrientationPortrait);
}

-(void) setStudentForRunningRecord:(NSString*)studentForTest{
    
    
   // NSLog(@"never implement here");
}


#pragma mark delegate
-(void) addPassageDidFinishWithDict:(NSDictionary*)newPassageDict{
    
  //  NSLog(@"addPassageDidFinish");
    
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:[self filePathForCustomPsg]]) {
       // NSLog(@"custom passage plist DID NOT EXIST");
        
        // create one
        NSMutableArray*arrayWithPlist =[[NSMutableArray alloc]init];
        
         [arrayWithPlist addObject:newPassageDict];
      
        [arrayWithPlist writeToFile:[self filePathForCustomPsg] atomically:YES ];
       //  NSLog(@"arrayWithPlistNOW: %@", arrayWithPlist);
        arrayWithPlist=nil;
        newPassageDict=nil;
        
        
    } else {
       // NSLog(@"custom passage plist existed, so add to it");
        //alredy exists so lets open it
          NSMutableArray*arrayWithPlist =[[NSMutableArray alloc]initWithContentsOfFile:[self filePathForCustomPsg]];
        
         [arrayWithPlist addObject:newPassageDict];
        
        
         [arrayWithPlist writeToFile:[self filePathForCustomPsg] atomically:YES];
        
       // NSLog(@"arrayWithPlistNOW: %@", arrayWithPlist);
        
        arrayWithPlist=nil;
        newPassageDict=nil;
    }
   
      
   
    
    
}
-(NSString*)filePathForCustomPsg {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"CustomPassages.plist"];
       // NSLog(@"plistFilePath %@", plistPath   );
    
    return plistPath;
    
    
}



@end
