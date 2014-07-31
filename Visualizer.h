//
//  Visualizer.h
//  VoiceRecorder
//
//  Created by Francisco Nieto on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Visualizer : UIView {
	
	
	NSMutableArray *powers;
	float	minPower;
	
	
	

}
-(void)setPower:(float)p;
-(void) clear;

@end
