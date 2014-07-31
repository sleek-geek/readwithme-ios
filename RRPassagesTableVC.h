//
//  RRPassagesTableVC.h
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
 

@protocol RRPassageTableVCDelegate <NSObject>

-(void) passageVCDidChooseWithTitle:(NSString*)aPassage andGrade:(NSNumber*)aGrade;

@end


@interface RRPassagesTableVC : UITableViewController


{
    
    NSString *theChosenTitle;
    
}


@property (nonatomic, weak) id<RRPassageTableVCDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *passagesArray;

@property (nonatomic, strong) NSNumber  *gradesToDispaly;



@end
