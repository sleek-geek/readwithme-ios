//
//  RWMAboutPageVC.m
//  RWM Fluency
//
//  Created by Francisco Salazar on 2/6/13.
//
//

#import "RWMAboutPageVC.h"

@interface RWMAboutPageVC ()
 

@end

@implementation RWMAboutPageVC
@synthesize aboutWebView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    /*
     NSString *path = [[NSBundle mainBundle] bundlePath];
     NSURL *baseURL = [NSURL fileURLWithPath:path];
     */
    NSString *htmlPath=[[NSBundle mainBundle ] pathForResource:@"rwmWebTest1" ofType:@"html"];
    
    
    
    
    
    
    NSURL *webURL = [NSURL fileURLWithPath:htmlPath];
	[aboutWebView loadRequest:[NSURLRequest requestWithURL:webURL]];
    
    
    // [webView loadHTMLString:htmlString baseURL:baseURL];
    
    
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

- (void)viewDidUnload {
    [self setAboutWebView:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
