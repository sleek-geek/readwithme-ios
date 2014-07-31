//
//  StudentOffLinePassgeVC.m
//  RWM Fluency
//
//  Created by Francisco Salazar on 12/2/12.
//
//

#import "StudentOffLinePassgeVC.h"

@interface StudentOffLinePassgeVC ()

@end

@implementation StudentOffLinePassgeVC
@synthesize passagesViewArray;
@synthesize titleOfText;
@synthesize titleLabel;
@synthesize passageTxtView;
@synthesize lexileLbl;
@synthesize q1Label, q2Label,  q3Label;
@synthesize gradeLvl;

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
        [self.view setFrame:CGRectMake(self.view.bounds.origin.x, 100, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        NSLog(@"adjust the view for ios7");
    }
}

- (void)viewDidLoad
{
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        
        NSLog(@"Do nothting to view, we are in ios 6");
    } else {
        [self.view setFrame:CGRectMake(self.view.bounds.origin.x, 100, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        NSLog(@"adjust the view for ios7");
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
