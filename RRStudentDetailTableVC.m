//
//  RRStudentDetailTableVC.m
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RRStudentDetailTableVC.h"
 


@interface RRStudentDetailTableVC ()

@end

@implementation RRStudentDetailTableVC
@synthesize delegate, testsArray, aStudent;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.contentSizeForViewInPopover=CGSizeMake(600, 400);

   // NSMutableArray *array = [[NSMutableArray alloc] init];
     
    NSMutableArray *array = [NSKeyedUnarchiver
                  unarchiveObjectWithFile:  [self testsFilePath]];
    
  
    NSMutableArray *tempArray =[[NSMutableArray alloc] init];
    
   // NSLog(@"array count: %i", array.count);
    
    for (Test* someTests in  array) {
         
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", aStudent.nombre, aStudent.apellido];
        
        if ([someTests.studentName isEqualToString:fullName]) //if the names match, but we have to match them carefully
        {
            
            
            [tempArray addObject:someTests];
          //  NSLog(@"Match found between %@ and %@", someTests.studentName, fullName);
            
        }
        
      //  NSLog(@" NO MATCH FOUND between %@ and %@", someTests.studentName, aStudent.nombre);
        
           
    }
    
    
    testsArray=[[NSMutableArray alloc] init];
    
    [testsArray addObjectsFromArray:tempArray];
    array=nil;
    tempArray=nil;
    
    
    //self.testsArray=aStudent.testRecordArray;
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
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
    return testsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }

    // Configure the cell...
    Test *t =  (Test *)[testsArray objectAtIndex:indexPath.row]; 
    
    
    
   // NSString *stringWithDate =[NSString stringWithFormat:@"%@", t.testDate ];
    
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
   [dateFormatter setDateStyle:NSDateFormatterMediumStyle]; 
    //[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    
    
    NSString * tryThisDate =[dateFormatter stringFromDate:t.testDate];
    
     
    //set label like:        The Last Frontier:  -- Jan 25, 2012
    //and subtitle label:    accuracy: 95% 245 wpm
                               
    
    NSString *labelString=[NSString stringWithFormat:@"%@ -- %@ %@",t.passageTitle , t.passageLevel , tryThisDate];
    
    
    int accINT = [t.accuracy intValue];
    int fluINT = [t.fluency  intValue];
    
    
   // NSString *stringAcc =[t.accuracy stringValue];
    //NSString *stringFlu = [t.fluency stringValue];
     
    
    NSString *detailLblStrng =[NSString stringWithFormat:@"Accuracy: %i Fluency:%i", accINT, fluINT];
                              
                               
    cell.textLabel.text=labelString;
    cell.detailTextLabel.text=detailLblStrng;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


-(NSString *) testsFilePath {
    
    NSString *docDirect = 
	[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES	) objectAtIndex:0];
	return [docDirect stringByAppendingPathComponent:@"Tests.dat"];
    
    
}

@end
