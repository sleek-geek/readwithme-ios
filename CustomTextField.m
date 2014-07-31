//
//  CustomTextField.m
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTextField.h"
#import "MiscueTableVC.h"
#import "RRViewController.h"

@implementation CustomTextField

@synthesize miscueString, skippedString, selfCorrectString, gotHelpString;
@synthesize fontSize;
@synthesize wordsInPassage;
@synthesize selfCorrectNUM, skippedNUM, helpedNUM;
@synthesize textForView;
@synthesize wordPositionArray;
@synthesize isLastWord;
@synthesize wordPositionNum;
@synthesize menu;
@synthesize menuIndexNUM;

int getHelpINT;
int skippedWordINT;
int selfCorrINT;
int graphophonicINT;
int semanticINT;

BOOL wantsToCountHelpedAsMiscues;
BOOL wantsToCountSkippedAsMiscues;

int wordCountFromSelectedTextINT;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        isLastWord=NO;
        
        miscueString=@"!";
         
        
        self.editable=NO;
       // self.frame= CGRectMake(20, 160, 700, 500);   
        
        
        fontSize =[NSNumber numberWithInt:20];
        
        self.font=[UIFont fontWithName:@"Gill Sans" size:[fontSize intValue]];
        
        
        
        
        //self.text= sampleText;
        self.textColor =[UIColor blackColor];
         
          
        
        self.userInteractionEnabled=YES;
      
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapRecognized:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        int passageWordCount = [self returnWordCount:self.text];
        
        wordsInPassage=[NSNumber numberWithInt:passageWordCount];
        
        
        
        
      
        
    }
    
    //now init the array to hold the position of words
    
    if (self.wordPositionArray==nil) {
         
    
         self.wordPositionArray=[[NSMutableArray alloc] init];
        
        
    }
    
    
    
    //now set prefernces regarding miscues
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"CountHelpMiscues"] == YES) {
        
        wantsToCountHelpedAsMiscues=YES;
        
        
    }else{
        wantsToCountHelpedAsMiscues=NO;
        
    }
    
     if ([[NSUserDefaults standardUserDefaults] boolForKey:@"CountSkippedMiscues"] == YES) {
         
         
         wantsToCountSkippedAsMiscues=YES;
         
     } else {
         
         wantsToCountHelpedAsMiscues=NO;
         
         
         
     }
    
    
    
    
    
    return self;
}


-(void) doubleTapRecognized: (UITapGestureRecognizer*) gestureRecognizer {
    
   // NSLog(@"double tap");
    
   // [self placeMenuController];
    
    
}




- (void)singleTapRecognized:(UIGestureRecognizer *)gestureRecognizer {
   //  NSLog(@"single tap");
    // ...etc
     
  //  [self placeMenuController];
     
     
    
}

-(void)endInterface{
    
    skippedWordINT =0;
    selfCorrectNUM=0;
    
    semanticINT=0;
    
    skippedNUM =0;
    skippedWordINT=0;
    
    helpedNUM =0 ;
    getHelpINT=0;
    
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (BOOL)becomeFirstResponder {
    if([super becomeFirstResponder]) {
      //  self.highlighted = YES;
      
        return YES;
    }
    return NO;
}
- (id)aCopy:(id)sender {
    
    wordCountFromSelectedTextINT=0;
    
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    
    NSString *selectedText = [self.text substringWithRange:self.selectedRange];
    
    
    //this gets the word count
    
   // BOOL isSpaceCharacter = NO;

    NSUInteger cursorPosition =self.selectedRange.location;
    
    NSUInteger location = cursorPosition +1 ;
    
    //this gets the position of the word
    
     while ( location!=0) {
         
         if (location==-1) {
             break;
         }
         
         
         unichar prevChar = [self.text characterAtIndex:location];
          
         
         NSString *prevCharString = [NSString stringWithFormat:@"%C", prevChar];
          
         if ([prevCharString rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].location != NSNotFound) {
            // isSpaceCharacter = YES;
             
             wordCountFromSelectedTextINT++; //another space or line means another word
             
             location--;
             
             //break;
         }
         
     location--;
    
         
         
     } //end while
    
    //here we find the postition of the word
     
    
   
    
     //here we load the position into an array full of dictionaries
    
     wordPositionNum =[NSNumber numberWithInt:wordCountFromSelectedTextINT +1];
    
    
  //  NSLog(@"Word position= %i", [wordPositionNum intValue]);
    
    [wordPositionArray addObject:wordPositionNum];
   
    
    //get the type of miscue it is...
   // UIMenuItem *menuItem= [[menu menuItems] objectAtIndex:0];
    
   // NSString *menuTitle= menuItem.title;
    
  //  NSLog(@"the menuItem has: %@", menuTitle);
    
    
    [board setString:selectedText]; //its saving the whole text!
    //self.highlighted = NO;
    [self resignFirstResponder];
    return sender;
}
 
   
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    
     [self placeMenuController];
   
}
  



-(void) captureWord:(id)sender {
    
    
    //Basic Graphophonic error...
    
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    
    menuIndexNUM=[NSNumber numberWithInt:0];
    
    [self aCopy:sender];
    NSString *highlightedTextd = [[UIPasteboard generalPasteboard].string lowercaseString];
    
    [board setString:highlightedTextd];  
    
    
    //now we want to send a message to miscue table view to add this and update its view
    
  //  NSLog(@"capturing graphophonic word: %@", highlightedTextd );
     
    miscueString = highlightedTextd;
    
    
     
    
    
}
-(void) captureSemanticWord:(id)sender {
    
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [self aCopy:sender];
    NSString *highlightedTextd = [[UIPasteboard generalPasteboard].string lowercaseString];
    
    [board setString:highlightedTextd];
    
    
    //now we want to send a message to miscue table view to add this and update its view
    
    
    
    miscueString = highlightedTextd;
    
    menuIndexNUM=[NSNumber numberWithInt:1];
    
    ++semanticINT;
    
}



-(void)countWords:(id)sender{
    
    
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [self aCopy:sender];
    NSString *highlightedTextd = [UIPasteboard generalPasteboard].string;
    
    [board setString:highlightedTextd];
    
  // int howManyWords= [self returnWordCount:highlightedTextd];
    
     
    
}

-(int) returnWordPosition:(NSString*)aSelectedText {
    
    int positionINT=0;
    
    
    
    
    
    return positionINT;
}

-(int) returnWordCount:(NSString*)aText {
    //The following is beautiful code!!
   // NSString *texto = self.text;
    
    NSScanner *aScanner = [NSScanner scannerWithString:aText];
    
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSCharacterSet *nonWhitespace = [whiteSpace invertedSet];//wow, I have to say, what a cool method
    int wordcount = 0;
    
    while(![aScanner isAtEnd])
    {
        [aScanner scanUpToCharactersFromSet:nonWhitespace intoString:nil];
        [aScanner scanUpToCharactersFromSet:whiteSpace intoString:nil];
        wordcount++;
    }
    
    
  //  NSLog(@"Word count= %i", wordcount);
    
    return wordcount;
    
    
    
}

-(void) skippedWord:(id)sender {
    
    
    
    ++skippedWordINT;
    
    
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [self aCopy:sender];
    NSString *highlightedTextd = [[UIPasteboard generalPasteboard].string lowercaseString ];
    
    [board setString:highlightedTextd];  
     skippedString = highlightedTextd;
    
    //now we want to send a message to miscue table view to add this and update its view
    //if user wants to track this...set in settings
    miscueString=skippedString;
    
    menuIndexNUM=[NSNumber numberWithInt:2];
    
}
-(void) selfCorrected:(id)sender {
     
 
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [self aCopy:sender];
    NSString *highlightedTextd = [[UIPasteboard generalPasteboard].string lowercaseString];
    
    [board setString:highlightedTextd];
    
    selfCorrectString=highlightedTextd;
    miscueString=selfCorrectString;
    
    menuIndexNUM=[NSNumber  numberWithInt:3];
    //sticking this coude in here for now...
    
 //   int howManyWords= [self returnWordCount:highlightedTextd];
    
    
    
}


-(void)gotHelp:(id)sender {
    
    
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [self aCopy:sender];
    NSString *highlightedTextd = [[UIPasteboard generalPasteboard].string lowercaseString];
    
    [board setString:highlightedTextd];
    gotHelpString=highlightedTextd;
    miscueString=gotHelpString;
    menuIndexNUM=[NSNumber numberWithInt:4 ];
}


-(void) placeMenuController{
    
   // [self becomeFirstResponder];
    
   // NSLog(@"place Menu");
    
    
    
        
    if ([isLastWord boolValue]==NO) {
         
          
    UIMenuItem *graphophonic = [[UIMenuItem alloc] initWithTitle:@"Graphophonic" action:@selector(captureWord:)];
    UIMenuItem *selfCorrect = [[UIMenuItem alloc] initWithTitle:@"Self" action:@selector(selfCorrected:)];
        UIMenuItem *helped=[[UIMenuItem alloc]initWithTitle:@"Help" action:@selector(gotHelp:)];
    UIMenuItem *skipped = [[UIMenuItem alloc] initWithTitle:@"Skip" action:@selector(skippedWord:)];
    UIMenuItem *semantic = [[UIMenuItem alloc] initWithTitle:@"Semantic" action:@selector(captureSemanticWord:)];
    
     
    
    menu = [UIMenuController sharedMenuController];
    //menu.menuItems = [NSArray arrayWithObjects :captureMenu, repeat, nil];
    [menu setMenuItems:[NSArray arrayWithObjects :graphophonic, semantic, skipped,helped,  selfCorrect, nil]];
    [menu setTargetRect:self.frame inView:self];
    [menu setMenuVisible:NO animated:YES];

    
    
    } else {
        
        //else means it is a last word so load a new uimenucontroller
        
        
        UIMenuItem *lastWordMenuItem = [[UIMenuItem alloc] initWithTitle:@"Last Word" action:@selector(setLastWord:)];
         menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects :lastWordMenuItem, nil]];
        [menu setTargetRect:self.frame inView:self];
        [menu setMenuVisible:NO animated:YES];
    }
    
    /*
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    
    
    
    [menu setTargetRect:self.bounds inView:self];
    [menu setMenuVisible:YES animated:YES];
  */   
}



-(void) setLastWord:(NSNumber*)wordPosition{
    
    
    wordCountFromSelectedTextINT=0;
    
    NSUInteger cursorPosition =self.selectedRange.location;
    
    NSUInteger location = cursorPosition +1;
    
    //this gets the position of the word
    
    while ( location!=0) {
        
        
        if (location==-1) {
            break;
        }
        
        unichar prevChar = [self.text characterAtIndex:location];
        
        NSString *prevCharString = [NSString stringWithFormat:@"%C", prevChar];
        
        if ([prevCharString rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].location != NSNotFound) {
            // isSpaceCharacter = YES;
            
            wordCountFromSelectedTextINT++; //another space or line means another word
            
            location--;
            
            //break;
        }
        
        location--;
        
    }
    
    //here we find the postition of the word
    
    //here we load the position into an array full of dictionaries
    
     wordPositionNum =[NSNumber numberWithInt:wordCountFromSelectedTextINT +1 ];
    
    wordsInPassage=wordPositionNum; //This resets the original word count for calculation purposes..
    
    //Inform the RRViewController of Last word count here...
    
    
    
    
}

-(BOOL) canPerformAction:(SEL)action withSender:(id)sender{
    
    
    if (action==@selector(captureWord: )) {
        return YES;
    }
    
    if (action==@selector(selfCorrected: )) {
        return YES;
    }
    if (action==@selector(skippedWord: )) {
        return YES;
    } if (action==@selector(gotHelp: )) {
        return  YES;
    } if (action==@selector(captureSemanticWord: )) {
        return  YES;
    } if (action==@selector(setLastWord: )) {
        return  YES;
    }
    return NO;
    
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
