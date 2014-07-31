//
//  RJGoogleTTS.m
//  iGod
//
//  Created by Rishabh Jain on 11/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RJGoogleTTS.h"

@implementation RJGoogleTTS
@synthesize delegate, downloadedData;

- (id)initWithString:(NSString *)aString
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    [self convertTextToSpeech:aString];
    return self;
}

- (void)convertTextToSpeech:(NSString *)searchString {
    //NSString *search = [NSString stringWithFormat:@"http://translate.google.com/translate_tts?tl=en&q=%@", searchString];
    NSString *search = @"http://translate.google.com/translate_tts?tl=en&q=Pam%20and%20Tad%20sat%20and%20ate%20ice%20cream";
   // search = [search stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
   // NSLog(@"Search: %@", search);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:search]];
    [request setValue:@"Mozilla/5.0" forHTTPHeaderField:@"User-Agent"];
    ///5.0
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (theConnection) {
        [delegate sentAudioRequest];
        downloadedData = [[NSMutableData alloc] initWithLength:0];
    } else {
        
       // NSLog(@"connection failed");
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.downloadedData setLength:0];
  //  NSLog(@"Connection Did Recieve response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.downloadedData appendData:data];
  //  NSLog(@"Connection did receive data");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  //  NSLog(@"Failure: %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [delegate receivedAudio:self.downloadedData];
   // NSLog(@"ConnectionDidFinishLoading");
}

@end
