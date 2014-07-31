//
//  OfflineSettings.m
//  RWM Fluency
//
//  Created by Francisco Salazar on 3/3/13.
//
//

#import "OfflineSettings.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface OfflineSettings ()

@end

@implementation OfflineSettings
@synthesize saveVideoSwitch, wantsComprehensionSwitch, wantsSkippedMiscuesSwitch, wantsHelpMiscuesSwitch, wantsStudentsToEmailSwitch, saveAudioSwitch;


bool deviceRecordsVideo;

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
    
    
    if ([UIImagePickerController isSourceTypeAvailable:SOURCETYPE]) {
        // if so, does that camera support video?
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:SOURCETYPE];
        deviceRecordsVideo = [mediaTypes containsObject:(NSString*)kUTTypeMovie];
    }
    if (deviceRecordsVideo==NO) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WantsToSaveVideo"];
      //  NSLog(@"Doeasn't record video anyway");
        saveVideoSwitch.enabled=NO;
        
    }
    
    
    
    //Online settings...
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"WantsToSaveVideo"] == YES) {
        _wantsToSaveVideo=YES;
        [saveVideoSwitch setOn:YES];
                 
    }else{
        _wantsToSaveVideo=NO;
        [saveVideoSwitch setOn:NO];
              }
    
    
    //Now for Offline settings...
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"WantsComprension"] == YES) {
        _wantsComprension=YES;
        [wantsComprehensionSwitch setOn:YES];
        
        
    }else{
        _wantsComprension=NO;
        [wantsComprehensionSwitch  setOn:NO];
         
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"WantsToSaveAudio"] == YES) {
        _wantsToSaveAudio=YES;
        [saveAudioSwitch setOn:YES];
         
        
    }else{
        _wantsToSaveAudio=NO;
        [saveAudioSwitch  setOn:NO];
         
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"CountHelpMiscues"] == YES) {
        _countHelpAsMiscues=YES;
        [ wantsHelpMiscuesSwitch setOn:YES];
         
        
    }else{
        _countHelpAsMiscues=NO;
        [wantsHelpMiscuesSwitch  setOn:NO];
         
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"CountSkippedMiscues"] == YES) {
        _countSkippedAsMiscues=YES;
        [wantsSkippedMiscuesSwitch setOn:YES];
         
        
    }else{
        _countSkippedAsMiscues=NO;
        [wantsSkippedMiscuesSwitch  setOn:NO];
        
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}




-(IBAction)helpMiscuesChanged:(id)sender{
    
    
    
    
    if (_countHelpAsMiscues==YES) {
        _countHelpAsMiscues=NO;
    }else{
        
        _countHelpAsMiscues=YES;
    }
    
    [self savePreferences];
}
-(IBAction)skippedMiscuesChanged:(id)sender{
    
    if (_countSkippedAsMiscues==YES) {
        _countSkippedAsMiscues=NO;
    }else {
        _countSkippedAsMiscues=YES;
    }
    [self savePreferences];
}
-(IBAction)videoSavingChanged:(id)sender{
    
    if (_wantsToSaveVideo==YES) {
        _wantsToSaveVideo=NO;
        
          
    } else{
        
        _wantsToSaveVideo=YES;
          
    }
    [self savePreferences];
}
-(IBAction)auidoSavingChanged:(id)sender{
    if (_wantsToSaveAudio==YES) {
        _wantsToSaveAudio=NO;
    } else{
        
        _wantsToSaveAudio=YES;
    }
    [self savePreferences];
    
}
-(IBAction)includeComprehensionChanged:(id)sender{
    if (_wantsComprension==YES) {
        _wantsComprension=NO;
    }else{
        
        _wantsComprension=YES;
    }
    
    [self savePreferences];
    
}
/*
-(IBAction)allowEmailChanged:(id)sender{
    
    
    if (_wantsStudentsToSendEmail==YES) {
        _wantsStudentsToSendEmail=NO;
    } else{
        
        _wantsStudentsToSendEmail=YES;
    }
    [self savePreferences];
    
}
*/


-(void)savePreferences {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //online settings
    [prefs setBool:_wantsToSaveVideo forKey:@"WantsToSaveVideo"];
    
   // [prefs setBool:_wantsStudentsToSendEmail forKey:@"WantsStudentsToSendEmail"];
    
    
    //offline settings
    [prefs setBool:_wantsComprension forKey:@"WantsComprension"];
    
    [prefs setBool:_wantsToSaveAudio forKey:@"WantsToSaveAudio"];
    
    
    
    [prefs setBool:_countHelpAsMiscues forKey:@"CountHelpMiscues"];
    
    [prefs setBool:_countSkippedAsMiscues forKey:@"CountSkippedMiscues"];
    if (_wantsToSaveVideo==YES) {
         
   //  NSLog(@"Saving: Wants to save Video-YES");
    }else {
    //     NSLog(@"Saving: Wants to save Video-NO");
        
    }
     [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    //[self setSaveVideoSwitch:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
