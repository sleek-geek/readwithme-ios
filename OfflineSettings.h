//
//  OfflineSettings.h
//  RWM Fluency
//
//  Created by Francisco Salazar on 3/3/13.
//
//

#import <UIKit/UIKit.h>
#define SOURCETYPE UIImagePickerControllerSourceTypeCamera

@interface OfflineSettings : UIViewController

@property (strong, nonatomic) IBOutlet UISwitch *saveVideoSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *saveAudioSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *wantsComprehensionSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *wantsHelpMiscuesSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *wantsSkippedMiscuesSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *wantsStudentsToEmailSwitch;

@property (nonatomic, assign)BOOL countHelpAsMiscues;
@property (nonatomic, assign)BOOL countSkippedAsMiscues;
@property (nonatomic, assign)BOOL wantsComprension;
@property (nonatomic, assign)BOOL wantsToSaveVideo;
@property (nonatomic, assign)BOOL wantsToSaveAudio;
//@property (nonatomic, assign)BOOL wantsStudentsToSendEmail;

-(IBAction)helpMiscuesChanged:(id)sender;
-(IBAction)skippedMiscuesChanged:(id)sender;
-(IBAction)videoSavingChanged:(id)sender;
-(IBAction)auidoSavingChanged:(id)sender;
-(IBAction)includeComprehensionChanged:(id)sender;
//-(IBAction)allowEmailChanged:(id)sender;

-(void)savePreferences ;
@end
