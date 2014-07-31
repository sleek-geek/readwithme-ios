//
//  RRHomeVC.h
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRStudentTableVC.h"
#import "RRPassagesTableVC.h"
#import "RRViewController.h"
#import "SetupVCViewController.h"
#import "RRGradeTableVC.h"
#import "NewClassViewController.h"
#import "RWMAddNewPassageVC.h"
#import "RRVCHelper.h"

#define kFont = "Helvetica Neue_Light"
@class RRPassageVC;

@interface RRHomeVC : UIViewController <UIPopoverControllerDelegate, RRPassageTableVCDelegate, RRGradeTableVCDelegate, RRStudentTableVCDelegate, NewClassViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, RWMAddNewPassageVCDelegate, UIAlertViewDelegate>


{
    
    
    UIPopoverController *popover;
   // UIPopoverController *quickStartPopover;
    //UIPopoverController *passagesPopover;
    RRVCHelper *oLHelperView;
    
    RRPassageVC *passageViewController;
    RRPassagesTableVC *passageTableViewController;
    RRStudentTableVC *studentTableViewController;
    RRGradeTableVC *gradesTableVC;
    
    NSMutableArray *passagesArray;
    NSArray *studentsArray;
    
    NSMutableArray *titlesArray;
    NSMutableArray *customTitlesArray;
    NSMutableArray *allTextsArray;
    NSMutableArray *customTextsArray;
    
    NSNumber *gradeLevelForChosenPassage;
    NSString *titleOfChosenPassage;
    
    NSString *chosenStudent;
    NSIndexPath *groupToDeleteIndexPath;
    
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *helpMeBtn;
@property (strong, nonatomic) NSMutableArray *classesArray;

@property (strong, nonatomic) IBOutlet UITableView *classTableView;
@property (strong, nonatomic) IBOutlet UITableView *passageTableView;

@property   (strong, nonatomic) RRViewController *rrviewController;
@property   (strong, nonatomic) SetupVCViewController *setUpViewController;
@property   (strong, nonatomic) RRPassageVC *passageViewController;

@property (strong, nonatomic)     UIPopoverController *passagesPopover;
@property (strong, nonatomic)     UIPopoverController *quickStartPopover;

@property (weak, nonatomic) IBOutlet UIButton *setupButton;
@property (weak, nonatomic) IBOutlet UIButton *passageButton;
@property (weak, nonatomic) IBOutlet UIButton *reportsButton;
@property (weak, nonatomic) IBOutlet UIButton *quickStartButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *guideButton;

@property (strong, nonatomic) IBOutlet UIImageView *helpOverlayImg;




-(IBAction)quickStart:(id)sender;

-(IBAction)showGuide:(id)sender;

 

-(IBAction)showSetup:(id)sender;

-(IBAction)showPassages:(id)sender;

-(IBAction)showReports:(id)sender;

-(IBAction)showAbout:(id)sender;


- (IBAction)showHelperView:(id)sender;

-(NSString*)archivePath;
-(void)archiveGroups;


@end
