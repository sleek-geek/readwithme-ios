//
//  SoundGrabbrViewController.m
//  SoundGrabbr
//
//  Created by Francisco Nieto on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SoundGrabbrViewController.h"
#import "RRViewController.h"

@implementation SoundGrabbrViewController

@synthesize playBtn, recButton, stopBtn, visualizer, textField, timerLabel;

@synthesize studentRecording;
@synthesize  delegate;

int recordingNumber;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/
- (void)viewDidLoad {
	
	[[AVAudioSession sharedInstance] setActive:YES error:nil];
     
	 
	
	[super viewDidLoad];
	playBtn.enabled = NO;
	stopBtn.enabled = NO;
		
	
	
	if (!soundFilePaths) {
		soundFilePaths = [[NSMutableArray alloc] init];
		 
		
	}
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *dir = [paths objectAtIndex:0];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSArray *fileList = [fileManager contentsOfDirectoryAtPath:dir error:nil];
	
	for (  NSString*file in fileList ) {
		
		if ([[file pathExtension] isEqualToString:@"caf"]) {
			
			[soundFilePaths addObject:file];
             
		}
		
		
		
	}
	 
	
}

 	




-(IBAction)recordNow

{
    
    NSLog(@"Record now!!");
	
	if (!elRecorder.recording) {
		playBtn.enabled=NO;
		stopBtn.enabled=YES;
		elRecorder.meteringEnabled=YES;
	
		++recordingNumber;
		 		
		NSArray *dirPathsArray = NSSearchPathForDirectoriesInDomains(
															NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentDir = [dirPathsArray objectAtIndex:0];
		
		 NSString *fileNameFromTxt= studentRecording; //unecessary step, but well leave it for now. 
            
		
		NSString *fixedString=[fileNameFromTxt stringByReplacingOccurrencesOfString:@" " withString:@"_"];
		
		
		NSString*filenameWithDate= [NSString stringWithFormat: @"%@-%i.%@",fixedString ,recordingNumber
                            , @"caf"];
		
		NSString *soundFilePath = [documentDir stringByAppendingPathComponent:filenameWithDate];
		
		 
		
		//						   stringByAppendingPathComponent:@".caf"];
		
		NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
		
		
		
		
		
		NSDictionary *recordSettings = [NSDictionary 
										dictionaryWithObjectsAndKeys:
										[NSNumber numberWithInt:AVAudioQualityMin],
										AVEncoderAudioQualityKey,
										[NSNumber numberWithInt:16], 
										AVEncoderBitRateKey,
										[NSNumber numberWithInt: 2], 
										AVNumberOfChannelsKey,
										[NSNumber numberWithFloat:44100.0], 
										AVSampleRateKey,
										nil];
		
		NSError *error = nil;
		if (elRecorder) {
			//[elRecorder release];
			 
		}
		
		elRecorder = [[AVAudioRecorder alloc]
					  initWithURL:soundFileURL
					  settings:recordSettings
					  error:&error];
		elRecorder.meteringEnabled=YES;
		if (error)
		{
			 
			
		} else {
			[elRecorder prepareToRecord];
				[elRecorder record];
			 
			[visualizer clear];
            
            [delegate recordingSessionHasBegun];
             
            
            
			
		}
		
		
		timer	=[NSTimer scheduledTimerWithTimeInterval:0.05
												target: self
											  selector:@selector(timerFired:)
											  userInfo: nil repeats:YES];
		
	}
	
	
	
}
-(IBAction) stopNow


{ 
	stopBtn.enabled=NO;
	playBtn.enabled=YES;
	recButton.enabled=YES;
	if (elRecorder.recording) {
	
		[elRecorder stop];
        [delegate redordingSessionHasEnded];
			 
		
	}else if (elPlayer.playing) {
		
		[elPlayer stop];
		 
	}
	if ([timer isValid]) {
		[self invalidateTimer];
	}
	
}

-(IBAction) playNow


{
	
	
	
	stopBtn.enabled=YES;
	
	 
if (elRecorder.recording) {
	stopBtn.enabled=YES;
	recButton.enabled=NO;
}
	
	 if (elPlayer)  
		 
		//[elPlayer release];
		 
	elPlayer= [[AVAudioPlayer alloc] initWithContentsOfURL:elRecorder.url error:nil];
		elPlayer.delegate=self;
		
		
			 	
			[elPlayer prepareToPlay];
			[elPlayer play];
	
	
			
			timer	=[NSTimer scheduledTimerWithTimeInterval:0.1
											target: self
										  selector:@selector(timerFired:)
										  userInfo: nil repeats:YES];
	

	
}


-(void)playFromList


{
	if (elPlayer!=nil) {
		
				
		
		
		[elPlayer prepareToPlay];
		[elPlayer play];
		 
	}
	
}





-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag

{
	recButton.enabled=YES;
	stopBtn.enabled=NO;
	if (timer!=nil) {
		
		[self invalidateTimer];
	}
	
	
}

-(void) audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
	 
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
	playBtn.enabled=YES;
	stopBtn.enabled=NO;
    
}

-(void) audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
	 
	
	
}
 



-(void) timerFired: (NSTimer *)timer

{
	[elRecorder updateMeters];
	[visualizer setPower:[elRecorder averagePowerForChannel:0]];
	[visualizer setNeedsDisplay];
	
	
	if (elRecorder.recording) {
		double time = elRecorder.currentTime;
		
		//[progressSlider setValue:time ];
		timerLabel.text = [NSString stringWithFormat:@"%i:%.02i", (int)time/60, (int)time %60];
		
	}else if (elPlayer!=nil) {
		 
		double tiempo = elRecorder.currentTime;
		//[progressSlider setValue:tiempo ];
		
		
		
		timerLabel.text = [NSString stringWithFormat:@"%i:%.02i", (int)tiempo/60, (int)tiempo %60];
		  
	} 

	
	
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    
    return soundFilePaths.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
	
	 	
	NSString *text = [[soundFilePaths objectAtIndex:indexPath.row] lastPathComponent];
	cell.textLabel.text=text;
	
	
	//[arrayKeeper release];
	
	
	
	return cell;
}

-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle) 
editingStyle forRowAtIndexPath:(NSIndexPath*) indexPath
{
	
	if (editingStyle==UITableViewCellEditingStyleDelete)
	{
		
		
		NSFileManager *fileManager =[NSFileManager defaultManager];
		NSString *path = [soundFilePaths objectAtIndex:indexPath.row];
		
		if ([[elPlayer.url path] isEqualToString:path]) {
			
			[self stopNow];
			//[elPlayer release];
			elPlayer=nil;
			
		}
		NSArray *dirPathsArray;
		
		NSString *documentDir
		;
		
		dirPathsArray = NSSearchPathForDirectoriesInDomains(
															NSDocumentDirectory, NSUserDomainMask, YES);
		documentDir = [dirPathsArray objectAtIndex:0];
		
		
		
		
		NSString *filepth= [ documentDir stringByAppendingPathComponent:[soundFilePaths objectAtIndex:indexPath.row]];
		
		[fileManager removeItemAtPath:filepth error:nil];
		[soundFilePaths removeObjectAtIndex:indexPath.row];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
						 withRowAnimation:UITableViewRowAnimationRight];
		
		
	}
	
	
	
	
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
	
	NSArray *dirPathsArray;
	
	NSString *documentDir
	;
	
	dirPathsArray = NSSearchPathForDirectoriesInDomains(
														NSDocumentDirectory, NSUserDomainMask, YES);
	documentDir = [dirPathsArray objectAtIndex:0];
	
	
	
	
	NSString *filepth= [ documentDir stringByAppendingPathComponent:[soundFilePaths objectAtIndex:indexPath.row]];
	
	NSURL *url = [NSURL fileURLWithPath:filepth];
	//[elPlayer release];
	//NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
	
	elPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
 elPlayer.volume = .7;
	//progressSlider.maximumValue= player.duration;
	[elPlayer prepareToPlay];
	[elPlayer play];
	
	 
	playBtn.enabled= YES;
	
	if([timer isValid])
	{
		[timer invalidate];
		timer=nil;
		 	
	}
		
	stopBtn.enabled=YES;
	timer	=[NSTimer scheduledTimerWithTimeInterval:0.1
											target: self
										  selector:@selector(timerFired:)
										  userInfo: nil repeats:YES];
	
	
	
}

-(void) invalidateTimer


{
	[timer invalidate];
	timer=nil;
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}




- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	
	
	elPlayer=nil;
	elRecorder=nil;
	stopBtn=nil;
	playBtn=nil;
	recButton=nil;
	
}

/*
- (void)dealloc {
	
     [timerLabel release];
	[textField release];
	[visualizer release];
	[elPlayer release];
	[elRecorder release];
	[stopBtn release];
	[playBtn release];
	[recButton release];
     
    
	//[progressSlider release];
	//[ release];
   // [super dealloc];
}
*/
@end
