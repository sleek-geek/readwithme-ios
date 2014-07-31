//
//  RRPassageVC.h
//  RWM Fluency
//
//  Created by Francisco Salazar on 11/12/12.
//
//

#import <UIKit/UIKit.h>
 
#define MAX_FONT_SIZE 30
#define MIN_FONT_SIZE 14
#define DEFAULT_FONT_SIZE 20

@interface RRPassageVC : UIViewController{
    
    NSTimer *autoscrollTimer;
    float scrollFactor;
    CGPoint intialScrollPoint;
    int fontSize;
}

@property (nonatomic, strong)NSArray *passagesViewArray;
@property (strong, nonatomic) IBOutlet UILabel *q1Label;
@property (strong, nonatomic) IBOutlet UILabel *q2Label;
@property (strong, nonatomic) IBOutlet UILabel *q3Label;

@property (strong, nonatomic) IBOutlet UITextView *passageTxtView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lexileLbl;

@property (strong, nonatomic) IBOutlet UILabel *gradeLvl;

@property (strong, nonatomic) IBOutlet UISlider *scrollSlider;

@property (strong, nonatomic) NSTimer *autoscrollTimer;


@property (nonatomic, strong) NSString *titleOfText;

@property (strong, nonatomic) IBOutlet UIView *compView;
@property (strong, nonatomic) IBOutlet UIButton *showAndHideComprehension;
@property (strong, nonatomic) IBOutlet UIButton *scrollStartRestBtn;

- (IBAction)showComp:(id)sender;

-(IBAction)increaseTextSize:(id)sender;
-(IBAction)decreaseTextSize:(id)sender;
- (IBAction)scrollText:(id)sender;
- (IBAction)scrollingValueChanged:(id)sender;
@end
