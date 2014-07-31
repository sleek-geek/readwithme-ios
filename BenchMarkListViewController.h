//
//  BenchMarkListViewController.h
//  RWM Fluency
//
//  Created by Francisco Salazar on 3/10/13.
//
//

#import <UIKit/UIKit.h>
@class IndividualStudentVC;
@class Student;

@protocol BenchmarkListVCDelegate;

 
 

@interface BenchMarkListViewController : UITableViewController
 
{
    
     
    IndividualStudentVC*individualProfileVC;
    Student *aStudent;
    NSMutableArray *studentsInThisGroupArr;
}
@property (nonatomic, strong)NSArray *becnharmkArrayList;
@property (nonatomic, readonly) id<BenchmarkListVCDelegate> delegate;
@end

@protocol BenchmarkListVCDelegate <NSObject>
-(void) pushIndividualStudentProfile:(NSString*)sID;



@end