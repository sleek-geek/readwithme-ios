//
//  RRGradeTableVC.m
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RRGradeTableVC.h"
 

@interface RRGradeTableVC ()

@end

@implementation RRGradeTableVC
@synthesize passageTVC;
@synthesize delegate;

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
    [super viewDidLoad];

    
    self.title=@"Grades";
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     // Return the number of rows in the section.
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    // Configure the cell...
    
    
    //if section 1 return ...
    if ([indexPath section]==0) {
         
    
    int indexpathINT = indexPath.row + 1;
    cell.textLabel.text = [NSString stringWithFormat:@"Grade %i", indexpathINT];
        
    } else if ([indexPath section]==1 && [indexPath row]==0){
        
        cell.textLabel.text=@"CustomPassages";
        
    } else {
        
        
        cell.textLabel.text=@"";
    }
    
    //else return "Custom Arrray"
    return cell;
}

-(void) passageVCDidChooseWithTitle:(NSString*)aPassage andGrade:(NSNumber*)aGrade{
    
    
    
    [self.delegate passageVCDidChooseWithTitle:aPassage andGrade:aGrade];
    
    
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
    
    
   //When the user touches row, an if/else will load the appropriate passages for the grade level 
    //if row =0 then load 1st grade plist and set the titles for the detail view controller, 
    //then push the detail view controller, which in this case is the new passages view controller, 
    //set property NSNumber on detail view. 
    
    
     passageTVC= [[RRPassagesTableVC alloc] init];
    
    NSNumber *rowIndexNUM;
    
    if ([indexPath section]==0) {
         
    
    
   rowIndexNUM= [NSNumber numberWithInt:indexPath.row+1];
  //  NSLog(@"rowINdexNUM ");
        
    } else {
         rowIndexNUM= [NSNumber numberWithInt:indexPath.row+9];
      //  NSLog(@"rowINdexNUM ");

        
        
    }
    
    passageTVC.gradesToDispaly=rowIndexNUM;
    passageTVC.delegate=self;
     
   // [passageTVC setDelegate:(id<RRPassageTableVCDelegate>) self ]; 
    
    [self.navigationController pushViewController:passageTVC animated:YES];
    
}

@end
