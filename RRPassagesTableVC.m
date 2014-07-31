//
//  RRPassagesTableVC.m
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RRPassagesTableVC.h"
#import "RRViewController.h"

@interface RRPassagesTableVC ()

@end

@implementation RRPassagesTableVC
@synthesize  passagesArray;
@synthesize delegate;
@synthesize gradesToDispaly;

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

    
    self.title=@"Passages";
    
    
    //Need to set up if/else or switch to handle NSNUMBER for levelsToDispaly or GradesToDisplay
    
     
    
    int intFromNumber = [gradesToDispaly intValue];
    
    NSString *path=@" "; //declare it blank
    
    if (intFromNumber==6) {
         
    
     path = [[NSBundle mainBundle] pathForResource:@"6thGradePassages" ofType:@"plist"];
     
    
    } else if (intFromNumber==7){
        
        
        path = [[NSBundle mainBundle] pathForResource:@"7thGradePassages" ofType:@"plist"];
      
        
        
    }else if (intFromNumber==8){
        
        
        path = [[NSBundle mainBundle] pathForResource:@"8thGradePassages" ofType:@"plist"];
      
        
        
    }
    else if (intFromNumber==5){
        
        
        path = [[NSBundle mainBundle] pathForResource:@"5thGradePassages" ofType:@"plist"];
        
        
        
    }else if (intFromNumber==4){
        
        
        path = [[NSBundle mainBundle] pathForResource:@"4thGradePassages" ofType:@"plist"];
        
        
        
    }else if (intFromNumber==3){
        
        
        path = [[NSBundle mainBundle] pathForResource:@"3rdGradePassages" ofType:@"plist"];
        
        
        
    }
    else if (intFromNumber==2){
        
        
        path = [[NSBundle mainBundle] pathForResource:@"2ndGradePassages" ofType:@"plist"];
     
        
        
    }else if (intFromNumber==1){
        
        
        path = [[NSBundle mainBundle] pathForResource:@"1stGradePassages" ofType:@"plist"];
         
        
        
    } else {
        
        path = [self filePathForCustomPsg];
        
    }
    
    
    
    if (passagesArray==nil) {
        passagesArray =[[NSMutableArray alloc] initWithContentsOfFile:path];;
    }
    
    [self.tableView setRowHeight:80];
    
     self.contentSizeForViewInPopover=CGSizeMake(200, 350);
    
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

-(NSString*)filePathForCustomPsg {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"CustomPassages.plist"];
   
    
    return plistPath;
    
    
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
    return [ passagesArray count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    
   // cell.accessoryType=UITableViewCellAccessoryCheckmark;
    
    cell.textLabel.font=[UIFont fontWithName:@"Futura" size:12];
    
    cell.textLabel.text = [[passagesArray objectAtIndex: indexPath.row] objectForKey:@"Title"];
    
    
    if( [[[passagesArray objectAtIndex:indexPath.row]objectForKey:@"Lexile"] isKindOfClass:[NSNumber class]]){
         int lex=[[[passagesArray objectAtIndex:indexPath.row]objectForKey:@"Lexile"]  intValue];
        
         NSString *lexileString = [NSString stringWithFormat:@"%iL", lex];
        cell.detailTextLabel.text=lexileString;
    } else if ([[[passagesArray objectAtIndex:indexPath.row]objectForKey:@"Lexile"] isKindOfClass:[NSString class]]) {
        
         NSString *lexileString =  [[passagesArray objectAtIndex:indexPath.row]objectForKey:@"Lexile"];
         cell.detailTextLabel.text=lexileString;
        
    }
    
        
    
    
    
    //cell.detailTextLabel.text =[[passagesArray objectAtIndex:indexPath.row]objectForKey:@"Benchmark"];
    
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
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
     
    
    theChosenTitle=cell.textLabel.text;
    
     
          [self.delegate passageVCDidChooseWithTitle:theChosenTitle andGrade:gradesToDispaly]; //if custom, it will return 8 index
    
    
    
    
    
}

@end
