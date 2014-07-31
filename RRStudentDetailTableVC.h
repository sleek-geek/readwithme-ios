//
//  RRStudentDetailTableVC.h
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRStudentTableVC.h"
#import "Student.h"
#import "Test.h"


@protocol RRStudentDetailTableVCDelegate <NSObject>

-(void) studentDetailTableViewDidFinishWithTestAndStudent;

-(void) studentDetailTableViewDidCancel;

@end


@interface RRStudentDetailTableVC : UITableViewController
{
    
    
    Student *aStudent;
    Test *aTest;
    
}


@property (nonatomic, weak) id<RRStudentDetailTableVCDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *testsArray; 
@property (nonatomic, strong) Student *aStudent;
-(NSString *) testsFilePath;

@end
