//
//  RWMAddNewPassageVC.m
//  RWM Fluency
//
//  Created by Francisco Salazar on 12/16/12.
//
//

#import "RWMAddNewPassageVC.h"

@interface RWMAddNewPassageVC ()

@end

@implementation RWMAddNewPassageVC
@synthesize enterLevelField, enterTextView, enterTitleFiled, selectGradeSegment, question1Field, question2Field, question3Field, doneEnteringTxtBtn;
@synthesize wordCountLbl;
@synthesize helpOverlayImg;

BOOL isReadyToSave=NO;
BOOL doesHaveTitle=NO;
BOOL doesHaveText=NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)doneEnterText:(id)sender{
    
    
    if ([enterTextView isFirstResponder]) {
        [enterTextView resignFirstResponder];
        doneEnteringTxtBtn.enabled=NO;
        
        
        
        NSString *howManyWords=enterTextView.text;
        if (howManyWords) {
            
            int wordsINT=  [self wordCount:howManyWords];
            
            wordCountLbl.text=[NSString stringWithFormat:@"%i", wordsINT];
            
        }
        
    }
    
}

- (void)viewDidLoad

{
    helpOverlayImg.hidden=YES;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardDidShow:)
     name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardDidHide:)
     name:UIKeyboardDidHideNotification  object:nil];
    
    selectGradeSegment.selectedSegmentIndex=8;
    
    enterTitleFiled.delegate=self;
    enterLevelField.delegate=self;
    question1Field.delegate=self;
    question2Field.delegate=self;
    question3Field.delegate=self;
    
    doneEnteringTxtBtn.enabled=NO;
    doneEnteringTxtBtn.hidden=YES;
    
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
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

 

-(IBAction)reloadTextWithFormat:(id)sender{
    
   
    
    passageText=enterTextView.text;
    if (passageText) {
        
      //  int wordsINT=  [self wordCount:passageText];
          
        NSString *trimmedString = [passageText stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        
        //now remove all extra spaces...
        
        
        NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
        NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
        
        NSArray *parts = [trimmedString     componentsSeparatedByCharactersInSet:whitespaces];
        NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
        trimmedString = [filteredArray componentsJoinedByString:@" "];
        
        
        //remove potential "  . " lone periods and commas and apostrophes
        
        NSString *newString=[trimmedString stringByReplacingOccurrencesOfString:@" ." withString:@"."];
        
         NSString *newString2=[newString stringByReplacingOccurrencesOfString:@" ," withString:@","];
        
        
          NSString *newString3=[newString2 stringByReplacingOccurrencesOfString:@" '" withString:@"'"];
        
        
        //remove all the extra returns
        NSMutableString *mstring = [NSMutableString stringWithString:newString3];
        NSRange wholeShebang = NSMakeRange(0, [mstring length]);
        
        [mstring replaceOccurrencesOfString: @"\n\n"
                                 withString: @"\n"
                                    options: 0
                                      range: wholeShebang];
        
         
        
        //clear arrays
        parts=nil;
        filteredArray=nil;
        
        
        enterTextView.text=mstring;
        
     //  int   wordsINT=  [self wordCount:mstring];
         
        
        
    }
    
    
} 

-(IBAction)saveAndExitWithDict:(id)sender{
    
   
    
    [self  prepareTextForSaving];//lets start with a cool reformatting.
    
    isReadyToSave=NO;
    passageText=enterTextView.text;
    int wordsInTextINT= [self wordCount:passageText];
   
    
    if ([enterTextView.text isEqualToString:@""] || [enterTextView.text isEqualToString:@" " ]|| enterTextView.text==nil || [enterTextView.text isEqualToString:@" /n"] ) {
        
        isReadyToSave=NO;
        doesHaveText=NO;
         
       
      
    } else {
        if(wordsInTextINT>=5) {
            
            doesHaveText=YES;
            
        }else{
            
            UIAlertView *notEnoughWordsAlert=[[UIAlertView alloc] initWithTitle:@"Not enough text" message:@"Can't save a passage this short" delegate:self cancelButtonTitle:@"Got it" otherButtonTitles:nil, nil];
            
            [notEnoughWordsAlert show]  ;
             
            
            doesHaveText=NO;
            isReadyToSave=NO;
            
        }
        
       
    }
    
    textTitle=enterTitleFiled.text;
    if (enterTitleFiled.text==nil || [enterTitleFiled.text isEqualToString: @"<Enter title>"]|| [enterTitleFiled.text isEqualToString:@""] )
    {
        
        doesHaveTitle=NO;
        isReadyToSave=NO;
        
         
    } else {
         
         
        doesHaveTitle=YES;
        isReadyToSave=YES;
    }
    
    
    
       
    
    int segIndx= selectGradeSegment.selectedSegmentIndex+1;
    
    
    gradeOfPassage= [NSString stringWithFormat:@"%i", segIndx];
    
    question1Str=question1Field.text;
    question2Str=question2Field.text;
    question3Str=question3Field.text;
    
    
    
    
    textLevel=enterLevelField.text;
    
    
    
    
    
    if ([textLevel isEqualToString:@"<2.1 , 200L, H, etc. >"]) {
        
        
        textLevel=@"N/A";
        
    }
    
    if (doesHaveText==YES &&doesHaveTitle==YES  ) {
        

        
        
    
    newPassageDict =[[NSMutableDictionary alloc ] initWithObjectsAndKeys:passageText,@"Text", textTitle, @"Title", textLevel, @"Lexile", gradeOfPassage, @"Grade", question1Str, @"Comp1",question2Str, @"Comp2", question3Str, @"Comp3",      nil];
    
    
    
        
    
    [self.delegate addPassageDidFinishWithDict:newPassageDict];
    
    
    //make keys and values
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        UIAlertView*alertNoText=[[UIAlertView alloc]initWithTitle:@"No Text or title?" message:@"Please enter your text or title" delegate:self cancelButtonTitle:@"OK"  otherButtonTitles:nil];
        
        
        [alertNoText show]  ;
        
    }
    
}


-(void)prepareTextForSaving{
    
    
    
    passageText=enterTextView.text;
    if (passageText) {
        
       // int wordsINT=  [self wordCount:passageText];
         
        NSString *trimmedString = [passageText stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        
        //now remove all extra spaces...
        
        
        NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
        NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
        
        NSArray *parts = [trimmedString     componentsSeparatedByCharactersInSet:whitespaces];
        NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
        trimmedString = [filteredArray componentsJoinedByString:@" "];
        
        
        //remove potential "  . " lone periods and commas and apostrophes
        
        NSString *newString=[trimmedString stringByReplacingOccurrencesOfString:@" ." withString:@"."];
        
        NSString *newString2=[newString stringByReplacingOccurrencesOfString:@" ," withString:@","];
        
        
        NSString *newString3=[newString2 stringByReplacingOccurrencesOfString:@" '" withString:@"'"];
        
        
        /*remove all the extra returns
        NSMutableString *mstring = [NSMutableString stringWithString:newString3];
        NSRange wholeShebang = NSMakeRange(0, [mstring length]);
        
        [mstring replaceOccurrencesOfString: @"\n\n"
                                 withString: @"\n"
                                    options: 0
                                      range: wholeShebang];
        
        
        */
        //clear arrays
        parts=nil;
        filteredArray=nil;
        
        
        enterTextView.text=newString3;
        
     //   wordsINT=  [self wordCount:newString3];
        
        
        
    }
    
    
}



-(IBAction)cancel:(id)sender{
    
    
    [self.navigationController popViewControllerAnimated:YES ];
    
}

- (IBAction)showHelp:(id)sender {
    
    if (helpOverlayImg.hidden==YES) {
        helpOverlayImg.hidden=NO;
    } else {
        
        
        helpOverlayImg.hidden=YES;
    }
}

- (void)keyboardDidShow:(NSNotification *)note
{
    /* move your views here */
    
    if ([enterTextView isFirstResponder]) {
        
        doneEnteringTxtBtn.enabled=YES;
    }
    
    
    
    if ([question1Field isFirstResponder]||[question2Field isFirstResponder]|| [question3Field isFirstResponder] ) {
        
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.10];
    self.view.frame = CGRectMake(0,-200,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    }
    
    
    if ([enterTextView isFirstResponder]) {
        doneEnteringTxtBtn.enabled=YES;
        doneEnteringTxtBtn.hidden=NO;
    }
}
- (void)keyboardDidHide:(NSNotification *)note
{
    /* move your views here */
  
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.10];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    } else {
        NSLog(@"Putting back the Keayboard! iOS7");
        self.view.frame = CGRectMake(0,63,self.view.frame.size.width,self.view.frame.size.height);
    }
    
   // self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    
    doneEnteringTxtBtn.hidden=YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setEnterTextView:nil];
    [self setEnterLevelField:nil];
    [self setEnterTitleFiled:nil];
    [self setSelectGradeSegment:nil];
    [self setQuestion1Field:nil];
    [self setQuestion2Field:nil];
    [self setQuestion3Field:nil];
    [self setDoneEnteringTxtBtn:nil];
    [self setWordCountLbl:nil];
    [self setHelpOverlayImg:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
