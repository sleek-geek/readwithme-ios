//
//  ViewController.m
//  webViewTest
//
//  Created by Francisco Salazar on 2/6/13.
//  Copyright (c) 2013 Francisco Salazar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize webView;



-(void)viewWillAppear:(BOOL)animated{
    
   /*
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    */
    NSString *htmlPath=[[NSBundle mainBundle ] pathForResource:@"rwmWebTest1" ofType:@"html"];
    
     
    
    
    
    
    NSURL *webURL = [NSURL fileURLWithPath:htmlPath];
	[webView loadRequest:[NSURLRequest requestWithURL:webURL]];
    
    
   // [webView loadHTMLString:htmlString baseURL:baseURL];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
