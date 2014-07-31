//
//  SelfAssessViewController.m
//  RWMStudent
//
//  Created by Francisco Salazar on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelfAssessViewController.h"
 
@interface SelfAssessViewController ()
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation SelfAssessViewController
@synthesize responseData=_responseData;
@synthesize enterTokenField;
@synthesize contentTextView;
@synthesize titleLabel;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id) initWithToken:(NSString*)aToken{
    
    self = [super init];
    if (self) {
        // Custom initialization
        
        
        
        
    }
    
    return self;
    
}

- (void)viewDidLoad
{
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    enterTokenField.text=@"000";
    
     
    
    
   // NSURL* theURL= [NSURL URLWithString:@"http://readwithmeapp.com/student/connect"];
    
   // [self connectToUrl:theURL];
    
}

-(IBAction)setToken:(id)sender{
    
   // NSLog(@"setToken called");
    
    NSString *rwmGetContent= @"http://readwithmeapp.com/api/v0/getcontent/";
    
    //get the text in the field and concoctanate with rwm url
    
    NSString *stringForURL = [rwmGetContent stringByAppendingString:enterTokenField.text];
  //  NSLog(@"url + token = %@", stringForURL);
    
    //call connectToURL with new url
    
    NSURL* theURL= [NSURL URLWithString:stringForURL];
    
     [self connectToUrl:theURL];

    
}


-(void)setTokenFromSegue:(NSString*)aToken{
    
     
        
      //  NSLog(@"setToken called");
        
        NSString *rwmGetContent= @"http://readwithmeapp.com/api/v0/getcontent/";
        
        //get the text in the field and concoctanate with rwm url
        
        NSString *stringForURL = [rwmGetContent stringByAppendingString:aToken];
     //   NSLog(@"url + token = %@", stringForURL);
        
        //call connectToURL with new url
        
        NSURL* theURL= [NSURL URLWithString:stringForURL];
        
        [self connectToUrl:theURL];
        
        
}
-(void)connectToUrl:(NSURL*)url {
    
    self.responseData = [NSMutableData data];
     
   

    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
         self.responseData = [NSMutableData data];
        
        
    } else {
        // Inform the user that the connection failed.
      //  NSLog(@"Connection failed");
        UIAlertView *noConnectionAlert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"Make sure you are connected to the internet before you continue" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [noConnectionAlert show];
    }


}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  //  NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {        
    [self.responseData appendData:data]; 
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {    
  //  NSLog(@"didFailWithError");
   // NSString *errordesc= [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    
     
    
 //   NSLog(@"error is: %@", errordesc);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  //  NSLog(@"connectionDidFinishLoading");
   // NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    
  //  NSLog(@"JSON object includes: %@", res);
    
    
    
    NSString *content=[res objectForKey:@"content"];
    
    NSString *title= [res objectForKey:@"title"];
    
    [self setTextAndTitle:content andTitle:title];
    
    /* show all values
    for(id key in res) {
        
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }
    
    // extract specific value...
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *textTitle = [result objectForKey:@"title"];
        NSLog(@"icon: %@", textTitle);
    }
     */
    
}

-(void) setTextAndTitle:(NSString*) theContent andTitle:(NSString*)theTitle{
    
    titleLabel.text=theTitle;
    contentTextView.text=theContent;
    
    
    
    
}


 
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
