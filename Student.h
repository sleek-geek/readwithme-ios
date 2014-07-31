//
//  Student.h
//  StudentManager1
//
//  Created by Francisco Nieto on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define kFirstName @"FirstName"
#define kLastName @"LastName"
 #define kGrade @"Grade"
#define kTeacher @"Teacher"
#define kLevel @"Level"
#define kNotes @"Notes"
#define kID @"StudentID"
 

//testing
#define kArray @"Array"
#define kGroupArray @"GroupArray"

//conform to <NSCoding>

@interface Student : NSObject 
<NSCoding>
 {
     
    NSNumber *number;
	NSString *nombre;
    NSString *apellido;
	NSString *grade;
	NSString *teacher;
	NSString *level;
	NSString *notes;
     
	
	//testint the aarray!!
	NSMutableArray  *testRecordArray;
     NSMutableArray *groupsArray;

}


@property (nonatomic, copy) NSString *nombre;
@property (nonatomic, copy) NSString *apellido;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *teacher;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *notes;

@property (nonatomic, copy) NSString *studentID;


 
@property (nonatomic, readwrite) NSMutableArray *testRecordArray; //changed! f
@property (nonatomic, copy) NSMutableArray *groupsArray;

//-(id) initWithName: (NSString *)nm   grade:(NSString *) gr  teacher: (NSString *)tchr 
//				  celdt: (NSString *) cldt  notes: (NSString *) nts;

-(id) initWithName: (NSString *)nm   lastName:(NSString*)lm grade:(NSString *) gr  teacher: (NSString *)tchr level: (NSString *) lv  notes: (NSString *) nts testRecordArray :(NSMutableArray*)tstArr andGroups:(NSMutableArray*)grpsArr andID:(NSString*)sID  ;

@end
