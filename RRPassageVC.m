//
//  RRPassageVC.m
//  RWM Fluency
//
//  Created by Francisco Salazar on 11/12/12.
//
//

#import "RRPassageVC.h"

@interface RRPassageVC ()

@end

@implementation RRPassageVC
@synthesize passagesViewArray;
@synthesize titleOfText;
@synthesize titleLabel;
@synthesize passageTxtView;
@synthesize lexileLbl;
@synthesize q1Label, q2Label,  q3Label;
@synthesize gradeLvl, compView;
@synthesize scrollSlider, autoscrollTimer, scrollStartRestBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)increaseTextSize:(id)sender{
    
    
    int currentFontSize =fontSize;
    
    int newSize = currentFontSize+1;
    
    if (fontSize<=MAX_FONT_SIZE) {
        
         passageTxtView.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:newSize];
        
        fontSize=newSize;
    }
    
    
    
    
}
-(IBAction)decreaseTextSize:(id)sender{
    int currentFontSize =fontSize;
    
    int newSize = currentFontSize-1;
    
    if (fontSize>=MIN_FONT_SIZE) {
        
        passageTxtView.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:newSize];
        fontSize=newSize;
    }
    
    
}

- (IBAction)scrollText:(id)sender {
    
    if (autoscrollTimer == nil) {
        
        
        
        autoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:scrollFactor
                                                           target:self
                                                         selector:@selector(autoscrollTimerFired:)
                                                         userInfo:nil
                                                          repeats:YES];
        
        
        scrollStartRestBtn.titleLabel.text=@"Reset";
        
    } else {
        
        [autoscrollTimer invalidate];
        autoscrollTimer=nil;
        scrollStartRestBtn.titleLabel.text=@"Scroll ";
        [passageTxtView setContentOffset:intialScrollPoint animated:YES];
        
        
    }
    
    
    
    
}

- (void)autoscrollTimerFired:(NSTimer*)timer {
    CGPoint scrollPoint = passageTxtView.contentOffset;
    scrollPoint = CGPointMake(scrollPoint.x, scrollPoint.y + 1);
    [passageTxtView setContentOffset:scrollPoint animated:NO];
     
    
}
- (IBAction)scrollingValueChanged:(id)sender {
    
    [autoscrollTimer invalidate];
    autoscrollTimer=nil;
    scrollFactor= scrollSlider.value/10;
    
    if (autoscrollTimer == nil) {
        
         
        
    autoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:scrollFactor
                                                       target:self
                                                     selector:@selector(autoscrollTimerFired:)
                                                     userInfo:nil
                                                      repeats:YES];
        
     
    
    }
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    scrollSlider.hidden=YES;
    scrollStartRestBtn.hidden=YES;
    
    
    compView.hidden=YES;
    
    titleLabel.text=titleOfText;
    passageTxtView.userInteractionEnabled=YES;
    passageTxtView.editable=NO;
    
    intialScrollPoint=passageTxtView.contentOffset;
    
    scrollFactor=scrollSlider.value;
    
    NSString *sameTitleString=@"";
    
    
    for (NSArray *array in passagesViewArray) {
        
        for (NSDictionary *dict in array) {
            
            
            sameTitleString= [dict objectForKey:@"Title"];
            
            
            
            if ([titleOfText isEqualToString: sameTitleString]) {
                
                
                NSString *text =[dict objectForKey:@"Text"];
                
                
                passageTxtView.text=text;
                
                //need to set the font dynamically
                
                //get word count
             int wordCountINT=   [self wordCount:text];
            int fontSizeINT =0;
                
                if (wordCountINT>=0 && wordCountINT<=20) {
                    
                    fontSizeINT=45;
                    
                } else if (wordCountINT>=21 && wordCountINT<=50) {
                    
                    fontSizeINT=40;
                    
                    
                } else if (wordCountINT>=51 && wordCountINT<=80) {
                    
                    fontSizeINT=35;
                    
                    
                } else if(wordCountINT>=81 && wordCountINT<=120){
                    
                     fontSizeINT=30;
                    
                    
                }else if(wordCountINT>=121 && wordCountINT<=150){
                    
                    fontSizeINT=25;
                    
                    
                } else {
                    
                    fontSizeINT=DEFAULT_FONT_SIZE;
                }
                
                fontSize=fontSizeINT;
                passageTxtView.font=[UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSizeINT];
                
                
                int lexINT = [[dict objectForKey:@"Lexile"]intValue];
                
                int gradeINT=[[dict objectForKey:@"Grade"] intValue];
                
                lexileLbl.text=[NSString stringWithFormat:@"%i", lexINT];
                
                gradeLvl.text=[NSString stringWithFormat:@"%i", gradeINT];
                
                NSString *compQuestion1 =[dict objectForKey:@"Comp1"];
                q1Label.text=compQuestion1;
                
                
                NSString *compQuestion2 =[dict objectForKey:@"Comp2"];
                q2Label.text=compQuestion2;
                
                NSString *compQuestion3 =[dict objectForKey:@"Comp3"];
                q3Label.text=compQuestion3;
                
                
            } //end if
            
            
        }//endfor
        
        
        
    }//endfor
    
    
    
    
    
    
	// Do any additional setup after loading the view.
}
- (IBAction)showComp:(id)sender{
    
    if ([compView isHidden]) {
        
        compView.hidden=NO;
        passageTxtView.hidden=YES;
        
    }else {
        
        compView.hidden=YES;
        passageTxtView.hidden=NO;
    }
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)wordCount:(NSString *)str
{
    NSUInteger words = 0;
    
    NSScanner *scanner = [NSScanner scannerWithString: str];
    
    // Look for spaces, tabs and newlines
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    while ([scanner scanUpToCharactersFromSet:whiteSpace  intoString:nil])
        words++;
    
    return words;
}

- (void)viewDidUnload {
    [self setQ1Label:nil];
    [self setQ2Label:nil];
    [self setQ3Label:nil];
    [self setPassageTxtView:nil];
    [self setTitleLabel:nil];
    [self setLexileLbl:nil];
    [self setPassagesViewArray:nil];
    [self setGradeLvl:nil];
    [self setCompView:nil];
    [self setShowAndHideComprehension:nil];
    [self setScrollSlider:nil];
    [self setScrollStartRestBtn:nil];
    [super viewDidUnload];
}
 

@end
