//
//  RJGoogleTTS.h
//  iGod
//
//  Created by Rishabh Jain on 11/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
Purpose of Class: This class is meant to be used to capitalize on the Google Translate Speech Services, by allowing a developer to use this as speech to text. This will eventually be ported to all different languages that Google supports!
*/

#import <Foundation/Foundation.h>

@protocol RJGoogleTTSDelegate <NSObject>

@required
- (void)receivedAudio:(NSMutableData *)data;
- (void)sentAudioRequest;

@end

@interface RJGoogleTTS : NSObject {
    id <RJGoogleTTSDelegate> delegate;
    NSMutableData *downloadedData;
}

@property (nonatomic, retain) id <RJGoogleTTSDelegate> delegate;
@property (nonatomic, retain) NSMutableData *downloadedData;

- (void)convertTextToSpeech:(NSString *)searchString;
-(id)initWithString:(NSString*)aString;

@end
