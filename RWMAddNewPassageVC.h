//
//  RWMAddNewPassageVC.h
//  RWM Fluency
//
//  Created by Francisco Salazar on 12/16/12.
//
//

#import <UIKit/UIKit.h>

 

@protocol RWMAddNewPassageVCDelegate;

@interface RWMAddNewPassageVC : UIViewController<UITextFieldDelegate>{
    
    
     
    NSString *textTitle;
    NSString* textLevel;
    NSString *passageText;
    
    NSString *question1Str;
    NSString *question2Str;
    NSString *question3Str;
    
    NSMutableDictionary *newPassageDict;
    NSString *gradeOfPassage;
    
    
    
    
    
    
    
}
@property (strong, nonatomic) IBOutlet UIButton *doneEnteringTxtBtn;

@property (nonatomic, strong) id<RWMAddNewPassageVCDelegate> delegate;


@property (strong, nonatomic) IBOutlet UITextField *enterLevelField;
@property (strong, nonatomic) IBOutlet UITextView *enterTextView;
@property (strong, nonatomic) IBOutlet UITextField *enterTitleFiled;
@property (strong, nonatomic) IBOutlet UILabel *wordCountLbl;

@property (strong, nonatomic) IBOutlet UISegmentedControl *selectGradeSegment;

@property (strong, nonatomic) IBOutlet UITextField *question1Field;

@property (strong, nonatomic) IBOutlet UITextField *question2Field;
@property (strong, nonatomic) IBOutlet UITextField *question3Field;

@property (strong, nonatomic) IBOutlet UIImageView *helpOverlayImg;


-(IBAction)saveAndExitWithDict:(id)sender;
-(IBAction)cancel:(id)sender;
- (IBAction)showHelp:(id)sender;
 
-(IBAction)reloadTextWithFormat:(id)sender;
- (IBAction)doneEnterText:(id)sender;
 
@end


@protocol RWMAddNewPassageVCDelegate <NSObject>

-(void) addPassageDidFinishWithDict:(NSDictionary*)newPassageDict;
 

@end
