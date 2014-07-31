//
//  Teacher.m
//  RWM Fluency
//
//  Created by Francisco Salazar on 11/11/12.
//
//

#import "Teacher.h"

@implementation Teacher
@synthesize firstName, lastName, email, studentsArray, notes, grades, groupName;

-(id) initWithName: (NSString *)nm   lastName:(NSString*)lm email:(NSString*)em array:(NSMutableArray*)stntArr notes:(NSString*)nts grades:(NSString*)grds groupName:(NSString*)grp{
    
    
    if (self= [super init]) {
		
        self.firstName=nm;
        self.lastName=lm;
        self.email=em;
        self.studentsArray=stntArr;
        self.notes=nts;
        self.grades=grds;
        self.groupName=grp;
         		
        
		
	}
	
	return self;
    
}
-(id) initWithCoder: (NSCoder*) decoder
{
    if (self = [super init])
        
    {
        self.firstName = [ decoder decodeObjectForKey:kFirstName];
        self.lastName =[decoder decodeObjectForKey:kLastName];
        self.email = [decoder decodeObjectForKey:kEmail];
        self.notes=[decoder decodeObjectForKey:kNotes];
        self.grades=[decoder decodeObjectForKey:kGrades];
        self.studentsArray = [decoder decodeObjectForKey:kSTArray];
        self.groupName=[decoder decodeObjectForKey:kGroupName];
        
    }
    return self;
}

-(void) encodeWithCoder: (NSCoder *) encoder
{
    [encoder encodeObject: self.firstName forKey: kFirstName];
    [encoder encodeObject:self.lastName forKey:kLastName];
    [encoder encodeObject:self.email  forKey: kEmail];
    [encoder encodeObject:self.notes forKey:kNotes];
    [encoder encodeObject:self.grades forKey:kGrades];
    [encoder encodeObject:self.studentsArray forKey:kSTArray];
    [encoder encodeObject:self.groupName forKey:kGroupName];
    
    
    
    
}

@end
