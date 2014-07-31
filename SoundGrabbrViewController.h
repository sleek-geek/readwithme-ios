//
//  SoundGrabbrViewController.h
//  SoundGrabbr
//
//  Created by Francisco Nieto on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "Visualizer.h"

@protocol SoundGrabbrViewControllerDelegate <NSObject>

-(void) recordingSessionHasBegun;
-(void)redordingSessionHasEnded;
-(void)requestPlaybackOfLastFile;
-(void) saveFile;


@end


@interface SoundGrabbrViewController : UIViewController
<AVAudioRecorderDelegate, AVAudioPlayerDelegate,  UITableViewDataSource, UITableViewDelegate> {
	
    
   // id <SoundGrabbrViewControllerDelegate> delegate;
    
	IBOutlet UIButton *playBtn;
	IBOutlet UIButton *recButton;
	IBOutlet UIButton *stopBtn;
	IBOutlet UILabel *textField;
	IBOutlet UITableView *table;
	//IBOutlet UISlider *progressSlider;
	IBOutlet UILabel *timerLabel;
	
	AVAudioRecorder *elRecorder;
	AVAudioPlayer *elPlayer;
	
	NSMutableArray *soundFilePaths;
	IBOutlet Visualizer *visualizer;
	NSTimer *timer;
}
@property (nonatomic, assign) id <SoundGrabbrViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIButton *playBtn;
@property (nonatomic, strong) IBOutlet UIButton *recButton;
@property (nonatomic, strong) IBOutlet UIButton *stopBtn;
@property (nonatomic, strong) IBOutlet UILabel *textField;
@property (nonatomic, strong) IBOutlet Visualizer *visualizer;
//@property (nonatomic, retain) IBOutlet UISlider *progressSlider;
@property (nonatomic, strong) IBOutlet UILabel *timerLabel;
@property (nonatomic, strong) NSString *studentRecording;


-(IBAction)recordNow;
-(IBAction) stopNow;
-(IBAction) playNow;
//-(IBAction) sliderMoved:sender;
-(void) invalidateTimer;
-(void)playFromList;


@end

