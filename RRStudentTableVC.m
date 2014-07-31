//
//  RRStudentTableVC.m
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RRStudentTableVC.h"

#import "RRStudentDetailTableVC.h"

@interface RRStudentTableVC ()

@end

@implementation RRStudentTableVC
@synthesize delegate, students, studentsSorted;
@synthesize useForStudentList;


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
    if (students==nil) {
        students=[[NSMutableArray alloc] init ];
    }
    
    //NSLog(@"use is: %@", self.useForStudentList);
    
    self.students =[NSKeyedUnarchiver
                    unarchiveObjectWithFile:  [self archivePath]];
    
         self.clearsSelectionOnViewWillAppear = NO;

    
    [self.tableView setRowHeight:80];
    [super viewDidLoad];
    
   // NSLog(@"RRStudentTableVC studentsArray has: %i items", [students count]);
    
     self.contentSizeForViewInPopover=CGSizeMake(600, 400);
    
    
 
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nombre" ascending:YES];
    NSArray *sortDescriptors = @[nameDescriptor];
    studentsSorted = [students sortedArrayUsingDescriptors:sortDescriptors];
    
}



-(NSString *) archivePath{
    
    NSString *docDirect = 
	[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES	) objectAtIndex:0];
	return [docDirect stringByAppendingPathComponent:@"Students.dat"];
    
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
    return [students count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    
    Student *s =  (Student *)[studentsSorted objectAtIndex:indexPath.row];
    
    
     
    
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", s.nombre, s.apellido];
     
    
    cell.textLabel.text=fullName;
    
    NSString *info = [NSString stringWithFormat:@"%@ -- %@", s.grade, s.teacher];
    
    cell.detailTextLabel.text=info;
    cell.textLabel.font = [UIFont fontWithName:@"Futura" size:18];
    
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

 
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		//NSLog(@" editingstyle Delete");
		
		[students removeObjectAtIndex:indexPath.row];
	//	NSLog(@"tempArrayStudent lost an object at indexpath.row!");
		
		
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
		//NSLog(@"row deleted from data Source");
        
		[NSKeyedArchiver archiveRootObject:students toFile:[self archivePath]];
        
    }   
   
}
 

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
     
 
    
    Student *s =  (Student *)[studentsSorted objectAtIndex:indexPath.row];
   // NSString *fullName = [NSString stringWithFormat:@"%@ %@", s.nombre, s.apellido];
    
    if ([useForStudentList isEqualToString:@"RunningRecordView"]) {
        //in case its for the running record view this method will call a different delegate method. 
    
        [self.delegate  setStudentForRunningRecord:s];
        
        
        
    }else{
    
        RRStudentDetailTableVC *detailViewController =[[RRStudentDetailTableVC alloc] initWithStyle:UITableViewStylePlain];
        
        
        detailViewController.aStudent = s;
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        
     
        [self.delegate StudentsListVCDidFinishWithStudent:s.nombre lastName:s.apellido grade:s.grade teacher:s.teacher level:s.level notes:s.notes array:s.testRecordArray andGroups:s.groupsArray];
        
        
     
	}

    
    
}

@end
