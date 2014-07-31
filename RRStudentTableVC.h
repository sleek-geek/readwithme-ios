//
//  RRStudentTableVC.h
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddStudentVC.h"
#import "Student.h"

@protocol RRStudentTableVCDelegate;

@interface RRStudentTableVC : UITableViewController

 



@property (nonatomic, weak) id<RRStudentTableVCDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *students;
@property (nonatomic, strong) NSArray *studentsSorted;
@property (nonatomic, strong) NSString *useForStudentList;

-(NSString *) archivePath;

@end


@protocol RRStudentTableVCDelegate

//-(void) StudentsListVCDidFinish: (StudentsListVC *) studentList;
-(void) StudentsListVCDidFinishWithStudent:(NSString *)nm lastName:(NSString*)lm  grade:(NSString *) gr  teacher: (NSString *)tchr  level: (NSString *) lv  notes: (NSString *) nts array: (NSMutableArray*)tstArr andGroups:(NSMutableArray*)grpsArr;

-(void) setStudentForRunningRecord:(Student*)studentForTest;
@end

@interface NSDictionary (sorting)
-(NSComparisonResult) compareSudentNames: (NSDictionary *)student; //this might have to change

@end