//
//  Visualizer.m
//  VoiceRecorder
//
//  Created by Francisco Nieto on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Visualizer.h"


@implementation Visualizer


- (id)initWithCoder:(NSCoder *	)aDecoder {
    
    
    if ( self = [super initWithCoder:aDecoder]) {
        // Initialization code.
		
		
		powers = [[NSMutableArray alloc] initWithCapacity:self.frame.size.width/2];
		
		 
		
		
		
    }
    return self;
}


-(void)setPower:(float)p


{
	[powers addObject:[NSNumber numberWithFloat:p]];
	
	while (powers.count *2 > self.frame.size.width) 
		[powers removeObjectAtIndex:0];
	
	if (p<minPower) {
		minPower=p;//update min power with new power
	}
	
}
-(void) clear


{
	[powers removeAllObjects];
	//NSLog(@"clear!");
	
}
-(void) drawRect:(CGRect)rect
{
	
	 	CGContextRef context = UIGraphicsGetCurrentContext();
	CGSize size= self.frame.size;
	
	for (int i=0; i<powers.count; i++) {
		
		
		float	newPower = [[powers objectAtIndex:i]floatValue];
		float height = (1-newPower/minPower) * (size.height /2);
		
        
       // NSLog(@"drawRect called with %f", newPower);
		 		
		CGContextMoveToPoint(context, i *2, size.height/2 - height);
		
		CGContextAddLineToPoint(context, i*2, size.height/2 + height);
		CGContextSetRGBStrokeColor(context, 0, 0, 0, .8);//set color
		CGContextStrokePath(context);
		
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	//[powers release];
 //   [super dealloc];
}


@end
