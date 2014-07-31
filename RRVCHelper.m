//
//  RRVCHelper.m
//  RWM Fluency
//
//  Created by Francisco Salazar on 4/12/13.
//
//

#import "RRVCHelper.h"

@interface RRVCHelper ()

@end

@implementation RRVCHelper
@synthesize helperWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    
    NSString *htmlPath=[[NSBundle mainBundle ] pathForResource:@"offlinevchelper" ofType:@"html"];
    
    
    
    
    
    
    NSURL *webURL = [NSURL fileURLWithPath:htmlPath];
	[helperWebView loadRequest:[NSURLRequest requestWithURL:webURL]];
    
}
- (void)viewDidLoad
{
    
    
     self.contentSizeForViewInPopover=CGSizeMake(740, 1000);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload{
    
    [self setHelperWebView:nil];
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
