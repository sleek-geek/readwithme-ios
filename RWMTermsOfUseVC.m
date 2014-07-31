//
//  RWMTermsOfUseVC.m
//  RWM Fluency
//
//  Created by Francisco Salazar on 3/27/13.
//
//

#import "RWMTermsOfUseVC.h"

@interface RWMTermsOfUseVC ()

@end


@implementation RWMTermsOfUseVC
@synthesize webview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    
    
    NSString *htmlPath=[[NSBundle mainBundle ] pathForResource:@"scoringGuidelines" ofType:@"html"];
    
    
    
    
    
    
    NSURL *webURL = [NSURL fileURLWithPath:htmlPath];
	[webview loadRequest:[NSURLRequest requestWithURL:webURL]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
