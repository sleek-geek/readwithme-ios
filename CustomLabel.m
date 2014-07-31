//
//  CustomLabel.m
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomLabel.h"
#import "RRViewController.h"
#define NUMBER_OF_LINES 40;

@implementation CustomLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.frame= CGRectMake(40, 10, 728, 1004);   
        
        self.numberOfLines= NUMBER_OF_LINES;
        self.font=[UIFont fontWithName:@"Gill Sans" size:20];
        
        NSString *sampleText = @"It’s rare to come across an engaging, all-inclusive digital learning portal like I did this week when I came upon the BBC’s Bitesize education websites. I was actually looking at an old site, Skillwise, which is still good and recommended, but its nothing like what the blokes at the BBC have been working on lately. Here in the United States you would expect to pay a few hundred bucks, or at least a good thousand bucks for access to this kind of learning (think BrainPOP and IXL Math), but the folks in the UK still believe in the government’s role in funding public education, and they are doing a much better job of bringing technology to their students for free. ";
        
        
        self.text= sampleText;
        self.textColor =[UIColor redColor];
        
        self.userInteractionEnabled=YES;
        
        
        
        
    }
    return self;
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (BOOL)becomeFirstResponder {
    if([super becomeFirstResponder]) {
        self.highlighted = YES;
        return YES;
    }
    return NO;
}
- (void)copy:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    
    
    [board setString:self.text];
     
    
    
    //its saving the whole text!
    self.highlighted = NO;
    [self resignFirstResponder];
    
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if([self isFirstResponder]) {
        self.highlighted = NO;
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuVisible:NO animated:YES];
        [menu update];
        
        
        
        
        
        [self resignFirstResponder];
    }
    else if([self becomeFirstResponder]) {
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.bounds inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
