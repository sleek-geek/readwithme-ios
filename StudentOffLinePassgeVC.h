//
//  StudentOffLinePassgeVC.h
//  RWM Fluency
//
//  Created by Francisco Salazar on 12/2/12.
//
//

#import <UIKit/UIKit.h>

@interface StudentOffLinePassgeVC : UIViewController


@property (nonatomic, strong)NSArray *passagesViewArray;
@property (strong, nonatomic) IBOutlet UILabel *q1Label;
@property (strong, nonatomic) IBOutlet UILabel *q2Label;
@property (strong, nonatomic) IBOutlet UILabel *q3Label;

@property (strong, nonatomic) IBOutlet UITextView *passageTxtView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lexileLbl;

@property (strong, nonatomic) IBOutlet UILabel *gradeLvl;

@property (nonatomic, strong) NSString *titleOfText;

@end
