//
//  RWMAppDelegate.m
//  RWMStudent
//
//  Created by Francisco Salazar on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RWMAppDelegate.h"
#import <MobileCoreServices/MobileCoreServices.h>



@implementation RWMAppDelegate

@synthesize window = _window;


bool deviceRecordsVideo;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        
        NSLog(@"Do nothting to view, we are in ios 6");
    } else {
        
         
        
        NSLog(@"adjust the view for ios7");
    }

    
    
    // Override point for customization after application launch.
    
    if ([UIImagePickerController isSourceTypeAvailable:SOURCETYPE]) {
        // if so, does that camera support video?
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:SOURCETYPE];
        deviceRecordsVideo = [mediaTypes containsObject:(NSString*)kUTTypeMovie];
    }
    //check to see if any userdefaults exist, if not set defaults here;
    NSString *settingsHelpMiscues = [[NSUserDefaults standardUserDefaults] stringForKey:@"CountHelpMiscues"];
    if (!settingsHelpMiscues) {
        // since no default values have been set, create them here
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CountHelpMiscues"];
         
        
        
    }  
    
    
    NSString *settignsSkippedMiscues = [[NSUserDefaults standardUserDefaults] stringForKey:@"CountSkippedMiscues"];
    if (!settignsSkippedMiscues) {
        // since no default values have been set, create them here
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CountSkippedMiscues"];
         
        
         
    } else {
        
         
        
    }
    
    NSString *settingsComprehension = [[NSUserDefaults standardUserDefaults] stringForKey:@"WantsComprension"];
    if (!settingsComprehension) {
        // since no default values have been set, create them here
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WantsComprension"];
        
        
         
    } else {
        
         
        
    }
    
    NSString *settingsVideSave = [[NSUserDefaults standardUserDefaults] stringForKey:@"WantsToSaveVideo"];
    if (!settingsVideSave) {
        // since no default values have been set, create them here
        
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WantsToSaveVideo"];
        
        if (deviceRecordsVideo==NO) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WantsToSaveVideo"];
            
        }
        
         
    } else {
        
         
        
    }
    
    NSString *settingsAudioSave = [[NSUserDefaults standardUserDefaults] stringForKey:@"WantsToSaveAudio"];
    if (!settingsAudioSave) {
        // since no default values have been set, create them here
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WantsToSaveAudio"];
        
        
         
    } else {
        
         
        
    }
    
    
    
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage
                                          sharedHTTPCookieStorage];
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    
    return YES;
}



//iRate method

+ (void)initialize{
    
     [iRate sharedInstance].previewMode = NO;
    
    
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
