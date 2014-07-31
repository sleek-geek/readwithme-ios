//
//  Test.m
//  elDcoderBeta
//
//  Created by Francisco Nieto on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Test.h"


@implementation Test
@synthesize  passageLevel, studentName, passageTitle, passageBenchmark;
//testLevel,
@synthesize  testStatus, testDate,fluency, accuracy, time, testTypeArray , soundFilePath, compDict, wordsReadTotal, wordPositionArray, passageGrade;


-(id) initWithStudenttName: (NSString*)name passageTitle:(NSString*) psg passageLvl:(id) lvl benchMark:(NSNumber*)bm passageGrade:(NSNumber*)grd
                      date:(NSDate*)dt accuracy:(NSNumber*)acc  fluency:(NSNumber*)flu  timeInSec:(NSNumber*) sec  status:(NSString*)sts
miscuesArr:(NSArray*)arr soundfilePth:(NSString*)sndpth comprehensionDictionary:(NSDictionary*)compdict wordsRead:(NSNumber *)wrdsRd wordPositions:(NSArray*)wordPos;
 


{
	if (self= [super init])
	{
	 
        self.studentName=name;
        self.passageTitle=psg;
        self.passageLevel=lvl;
        self.passageGrade=grd;
        
        self.testDate =dt;
        self.passageBenchmark=bm;
        
        self.accuracy=acc;
        self.fluency=flu;
        
		self.time=sec;
        self.testTypeArray=arr; //as it turns out, this holds the miscues
		self.testStatus=sts;
		self.soundFilePath=sndpth;
        
        self.compDict=compdict;
        self.wordsReadTotal=wrdsRd;
        self.wordPositionArray=wordPos;
		
	}
	return self;
	
}



-(id) initWithCoder:(NSCoder *)decoder

{
	
	if (self = [super init])
	{	 
		
		self.studentName = [ decoder decodeObjectForKey:kStudentTestingName];
		self.passageTitle= [decoder decodeObjectForKey:kPassageTitle];
		 self.passageLevel=[decoder decodeObjectForKey:KPassageLevel];
        self.passageBenchmark=[decoder decodeObjectForKey:KBenchMark];
        self.passageGrade=[decoder decodeObjectForKey:kPassageGrade];
        
        self.accuracy=[decoder decodeObjectForKey:kAccuracyOnPassage];
        self.fluency=[decoder decodeObjectForKey:kFluency];
        
		self.time=[decoder decodeObjectForKey:kTimeOnPassage]; 		
		self.testDate=[decoder decodeObjectForKey:kTestDate];
		self.testTypeArray=[decoder decodeObjectForKey:kMiscuesArray];
		self.testStatus=[decoder decodeObjectForKey:kPassageStatus];
		self.soundFilePath=[decoder decodeObjectForKey:kSoundFile];
        self.compDict=[decoder decodeObjectForKey:kCompDict];
		self.wordsReadTotal=[decoder decodeObjectForKey:kWordsRead];
        self.wordPositionArray =[decoder decodeObjectForKey:kWordPositionArray];
		
	}
	return self;
}




-(void)encodeWithCoder:(NSCoder *)encoder 

{
	 
    
    [encoder encodeObject:self.studentName forKey:kStudentTestingName];
	[encoder encodeObject:self.passageTitle forKey: kPassageTitle];
	[encoder encodeObject:self.passageLevel forKey:KPassageLevel];
    [encoder encodeObject:self.passageBenchmark forKey:KBenchMark];
    [encoder encodeObject:self.passageGrade forKey:kPassageGrade];
    [encoder encodeObject:self.time forKey:kTimeOnPassage];
	[encoder encodeObject:self.testDate forKey:kTestDate];
	[encoder encodeObject:self.testStatus forKey:kPassageStatus];
	[encoder encodeObject:self.fluency forKey: kFluency];
    [encoder encodeObject:self.accuracy forKey: kAccuracyOnPassage];
    [encoder encodeObject:self.testTypeArray forKey:kMiscuesArray];
    [encoder encodeObject:self.soundFilePath forKey:kSoundFile];
    [encoder encodeObject:self.compDict forKey:kCompDict];
    [encoder encodeObject:self.wordsReadTotal forKey:kWordsRead];
    [encoder encodeObject:self.wordPositionArray forKey:kWordPositionArray];
    
	 
}

/*
-(void) dealloc

{
	
	[testDate release];
	//[testLevel release];
	[studentTesting release];
	[scoreOnTest release];
	[testType release];
	
	[super dealloc];
}
*/

@end
