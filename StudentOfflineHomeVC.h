//
//  StudentOfflineHomeVC.h
//  RWM Fluency
//
//  Created by Francisco Salazar on 12/2/12.
//
//

#import <UIKit/UIKit.h>
#import "StudentOffLinePassgeVC.h"


@class StudentOffLinePassgeVC;

@interface StudentOfflineHomeVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

{
    
    NSMutableArray *titlesArray;
    NSMutableArray *passagesArray;
    NSMutableArray *customTitlesArray;
    StudentOffLinePassgeVC *passageViewController;
    

}

@property (strong, nonatomic) IBOutlet UITableView *passageTableView;

@end
