//
//  Teacher.h
//  RWM Fluency
//
//  Created by Francisco Salazar on 11/11/12.
//
//These will actually handle groups, or classes, not teachers, but oh well, we can use the class

#import <Foundation/Foundation.h>
#define kFirstName @"FirstName"
#define kLastName @"LastName"
#define kEmail @"Email"
#define kGrades @"Grades"
#define kSTArray @"ArrayOfStudents"
#define kGroupName @"GroupName"

#define kNotes @"Notes"
 

@interface Teacher : NSObject <NSCoding>{
    
    NSString *groupName;
    
    NSString *firstName;
    NSString *lastName;
    NSString *email;
    NSString *notes;
    
    NSString *grades;
    
    NSMutableArray *studentsArray;
    
    
}

@property (nonatomic, copy)  NSString *firstName;
@property (nonatomic, copy)  NSString *lastName;
@property (nonatomic, copy)  NSString *email;
@property (nonatomic, copy)  NSString *notes;
@property (nonatomic, copy)  NSString *grades;
@property (nonatomic, readwrite)  NSMutableArray *studentsArray;
@property (nonatomic, copy)  NSString *groupName;


-(id) initWithName: (NSString *)nm   lastName:(NSString*)lm email:(NSString*)em array:(NSMutableArray*)stntArr notes:(NSString*)nts grades:(NSString*)grds groupName:(NSString*)grp;


@end
