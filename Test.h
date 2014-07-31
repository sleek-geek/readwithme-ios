//
//  Test.h
//  elDcoderBeta
//
//  Created by Francisco Nieto on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Student.h"
#define kStudentTestingName  @"Name"
 
#define kPassageTitle @"Test"
#define KPassageLevel @"Level"
#define KBenchMark @"BenchMark"
#define kPassageGrade @"Grade"

#define kTestDate @"Date"
#define kAccuracyOnPassage @"Accuracy"
#define kFluency @"Fluency"
#define kPassageStatus @"Status"
#define kMiscuesArray @"Miscues"
#define kCompDict @"Comprehension"


#define kTimeOnPassage @"Time"

#define kSoundFile  @"Recording"

#define kWordsRead @"WordsRead"
#define kWordPositionArray @"WordPosition"


@interface Test : NSObject <NSCoding>{
	NSString *studentName;
   
     NSNumber *passageLevel;
    NSNumber *passageBenchmark;
    NSString *passageTitle;
    NSNumber *passageGrade;
    
	NSDate *testDate;
    NSNumber *accuracy;
	NSNumber *fluency;
    NSNumber *time;
    
    NSNumber *wordsRead;
   
	//NSNumber *testLevel;
	
	
	NSArray *miscuesArray; //
    
    NSArray *wordPositionArray;
	NSString *passageStatus;
	
    NSString *soundFilePath;
	
    
    NSDictionary *compDict;

}
@property (nonatomic, copy) NSString *studentName;
 
@property (nonatomic, copy) id passageLevel;
@property (nonatomic, copy) NSNumber *passageBenchmark;
@property (nonatomic, copy) NSString *passageTitle;

@property (nonatomic, copy) NSDate *testDate;
@property (nonatomic, copy) NSNumber *accuracy;
@property (nonatomic, copy) NSNumber *fluency;
@property (nonatomic, copy) NSNumber *time;
@property (nonatomic, copy) NSNumber *wordsReadTotal;
@property (nonatomic, copy) NSArray *wordPositionArray;
@property  (nonatomic, copy) NSNumber *passageGrade;;
 
@property (nonatomic, copy) NSDictionary *compDict;
@property (nonatomic, copy) NSArray *testTypeArray;
@property (nonatomic, copy)NSString *testStatus;

@property (nonatomic, copy) NSString *soundFilePath;

-(id) initWithStudenttName: (NSString*)name passageTitle:(NSString*) psg passageLvl:(id) lvl benchMark:(NSNumber*)bm passageGrade:(NSNumber*)grd
                      date:(NSDate*)dt accuracy:(NSNumber*)acc  fluency:(NSNumber*)flu  timeInSec:(NSNumber*) sec  status:(NSString*)sts
miscuesArr:(NSArray*)arr soundfilePth:(NSString*)sndpth comprehensionDictionary:(NSDictionary*)compdict wordsRead:(NSNumber*)wrdsRd wordPositions:(NSArray*)wordPos ;

 

@end
