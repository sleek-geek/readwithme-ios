//
//  Student.m
//  StudentManager1
//
//  Created by Francisco Nieto on 1/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Student.h"


@implementation Student
@synthesize nombre,apellido , grade, teacher, level, notes, studentID;

//testing
@synthesize testRecordArray, groupsArray;

/*
-(id) initWithName:(NSString *)nm grade:(NSString *)gr 
		   teacher:(NSString *)tchr celdt:(NSString *)cldt 
			 notes:(NSString *)nts

//testing this
-(id) initWithName: (NSString *)nm   grade:(NSString *) gr  teacher: (NSString *)tchr 
			 celdt: (NSString *) cldt  notes: (NSString *) nts testRecordArray :(NSMutableArray*)tstArr;

*/

-(id) initWithName: (NSString *)nm   lastName:(NSString*)lm grade:(NSString *) gr  teacher: (NSString *)tchr 
			 level: (NSString *) lv  notes: (NSString *) nts testRecordArray :(NSMutableArray*)tstArr andGroups:(NSMutableArray*)grpsArr andID:(NSString*)sID

{
	if (self= [super init]) {
		
	
	self.nombre=nm;
    self.apellido=lm;
	self.grade=gr;
	self.teacher = tchr;
	self.level = lv;
	self.notes = nts;
        self.studentID =sID;
      
		
	self.testRecordArray=tstArr;
    self.groupsArray=grpsArr;
		
	}
	
	return self;
}
 
 
-(id) initWithCoder: (NSCoder*) decoder
 {
 if (self = [super init])
 
 {
     self.nombre = [ decoder decodeObjectForKey:kFirstName];
     self.apellido =[decoder decodeObjectForKey:kLastName];
	 self.grade = [decoder decodeObjectForKey:kGrade];
	 self.teacher = [decoder decodeObjectForKey:kTeacher];
	 self.level = [decoder decodeObjectForKey:kLevel];
	 self.notes = [decoder decodeObjectForKey:kNotes];
     self.studentID = [decoder decodeObjectForKey:kID];
 //testing
	 self.testRecordArray = [decoder decodeObjectForKey:kArray];
     self.groupsArray = [decoder decodeObjectForKey:kGroupArray];
     
 
 }
 return self;
 }
 
 -(void) encodeWithCoder: (NSCoder *) encoder
 {
    [encoder encodeObject: self.nombre forKey: kFirstName];
     [encoder encodeObject:self.apellido forKey:kLastName];
	 [encoder encodeObject:self.grade  forKey: kGrade];
	 [encoder encodeObject:self.teacher forKey: kTeacher];
	 [encoder encodeObject:self.level forKey: kLevel];
	 [encoder encodeObject:self.notes forKey: kNotes];
     [encoder encodeObject:self.studentID forKey:kID];
 
	 //testing
	 [encoder encodeObject:self.testRecordArray forKey:kArray];
     [encoder encodeObject:self.groupsArray forKey:kGroupArray];
  
     
     
 
 }

/*not sure I need dealloc

-(void) dealloc


{
		
	
	[super dealloc];	
}
*/

@end
