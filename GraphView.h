//
//  GraphView.h
//  MyGraph
//
//  Created by Francisco Salazar on 11/19/12.
//  Copyright (c) 2012 Francisco Salazar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelForGraphVC.h"

#define kGraphHeight 300
#define kDefaultGraphWidth 950
#define kOffsetX 20
#define kStepX 70
#define kGraphBottom 300
#define kGraphTop 0
#define kStepY 50
#define kOffsetY 15
#define kBarTop 10
#define kBarWidth 40
#define kCircleRadius 8
#define kNumberOfBars 12


@class LabelForGraphVC;

@interface GraphView : UIView <UIPopoverControllerDelegate>
 
 
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
