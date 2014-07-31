//
//  LabelForGraphVC.m
//  MyGraph
//
//  Created by Francisco Salazar on 12/5/12.
//  Copyright (c) 2012 Francisco Salazar. All rights reserved.
//

#import "LabelForGraphVC.h"

@interface LabelForGraphVC ()

@end

@implementation LabelForGraphVC
@synthesize levelLBL, accuracyLBL, cwpmLBL, dateLBL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    self.contentSizeForViewInPopover=CGSizeMake(100, 100);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
