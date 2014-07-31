//
//  GroupGraphView.h
//  RWM Fluency
//
//  Created by Francisco Salazar on 12/31/12.
//
//

#import <UIKit/UIKit.h>
#import "LabelForGraphVC.h"

#define kGroupGraphHeight 385
#define kDefaultGraphWidth 950
#define kOffsetX 20
#define kStepX 70
#define kGroupGraphBottom 385
#define kGraphTop 0
#define kStepY 50
#define kOffsetY 15
#define kBarTop 10
#define kBarWidth 40
#define kCircleRadius 8
#define kNumberOfBars 12


@class LabelForGraphVC;

@interface GroupGraphView : UIView

{
    
    int stepXbaby;
    NSMutableArray *cwpmDataArr;
    NSMutableArray *testArray;
    NSMutableArray *differenceArray;
    NSMutableArray *stepsArray;
    NSMutableArray *datesArray;
    
    float eachStep;
    float difFloat;
    int touchAreasINT;
    LabelForGraphVC *aLabel;
    UIPopoverController *popover;
    
    
    
}

@property (nonatomic, strong) LabelForGraphVC *aLabel;
@property (nonatomic, strong) NSMutableArray *testArray; //for accuracy
@property (nonatomic, readwrite) NSMutableArray *fluencyArray;  //for fluency scores
@property (nonatomic, readwrite) NSMutableArray *levelsArray;
@property (nonatomic, readwrite) NSArray *datesArray;
@property (nonatomic, strong) NSNumber *boolNum;

-(void) setDataForGraph;

@end
