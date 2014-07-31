//
//  StudentOfflineHomeVC.m
//  RWM Fluency
//
//  Created by Francisco Salazar on 12/2/12.
//
//

#import "StudentOfflineHomeVC.h"

@interface StudentOfflineHomeVC ()

@end

@implementation StudentOfflineHomeVC
@synthesize passageTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        
        NSLog(@"Do nothting to view, we are in ios 6");
    } else {
        [self.view setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+20, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        NSLog(@"adjust the view for ios7");
    }
}


- (void)viewDidLoad
{
    
    
    
    NSArray *customTextsArray = [[NSMutableArray alloc]initWithContentsOfFile:[self filePathForCustomPsg]];
    
    
    
    if (customTitlesArray==nil) {
        customTitlesArray= [[NSMutableArray alloc]init];
        
        
        
        for (NSDictionary *dict in customTextsArray) {
            
            
            
            NSString *titleToSnatch = [dict objectForKey:@"Title"];
            
            
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
        
        
        
        if (customTextsArray!=nil) {
            
            
            [passagesArray addObject:customTextsArray];
            
            
            
            
        }
        
    }
    
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
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
        
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    
         return titlesArray.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    
    
        
        
        
        //Now to show off each passage on the right label:
        
        NSString *passageTitleForTable=[titlesArray objectAtIndex:indexPath.row];
        
        // passageTitleForTable=[[[passagesArray objectAtIndex:indexPath.row] objectAtIndex:0] objectForKey:@"Title"];
        
        //now sort by grade level
        
        cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        cell.backgroundColor=[UIColor clearColor    ];
        cell.textLabel.text=passageTitleForTable;
    //cell.textLabel.text=@"empty";
        
        NSString *sameTitleString=@"";
        
        
        for (NSArray *array in passagesArray) {
            
            for (NSDictionary *dict in array) {
                
                
                sameTitleString= [dict objectForKey:@"Title"];
                
                
                if ([passageTitleForTable isEqualToString: sameTitleString]) {
                    
                    
                    NSNumber *lexNum =[dict objectForKey:@"Lexile"];
                    
                    int lexINT = [lexNum intValue];
                    cell.detailTextLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:16];
                    
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"Level:%i", lexINT];
                    
                    
                }
                
                
            }//endfor
            
        }//endfor
        
        //cell.detailTextLabel.text=@"passage detail view";
    
    // cell.textLabel.text = [super.miscuesArray objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = [super.miscuesArray objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    
        
        passageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"passageViewController"];
        
        
        
        passageViewController.passagesViewArray= passagesArray;
        
        NSString *passageTitleForTable=[titlesArray objectAtIndex:indexPath.row];
        
        
        passageViewController.titleOfText=passageTitleForTable;
        
        
        [self.navigationController pushViewController:passageViewController animated:YES];
        
     
    
    
}

-(NSString*)filePathForCustomPsg {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"CustomPassages.plist"];
         
    return plistPath;
    
    
}

-(void)viewDidUnload{
    
    passageTableView=nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
