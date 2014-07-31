//
//  RRGradeTableVC.h
//  RunningRecordTest
//
//  Created by Francisco Salazar on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRPassagesTableVC.h"

@protocol RRGradeTableVCDelegate <NSObject>

-(void) passageVCDidChooseWithTitle:(NSString*)aPassage  andGrade:(NSNumber*)aGrade;

@end


@interface RRGradeTableVC : UITableViewController <RRPassageTableVCDelegate>


@property (nonatomic, weak) id<RRGradeTableVCDelegate>delegate;
@property (nonatomic, strong) RRPassagesTableVC *passageTVC;
@end
