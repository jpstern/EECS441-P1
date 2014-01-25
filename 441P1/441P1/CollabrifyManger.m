//
//  CollabrifyManger.m
//  441P1
//
//  Created by Josh Stern on 1/25/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import "CollabrifyManger.h"

NSString *SESSION_NAME = @"89021390kldalksdjlsa";

@implementation CollabrifyManger

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        CollabrifyError *error = nil;
        CollabrifyClient *client = [[CollabrifyClient alloc] initWithGmail:@"jpstern@umich.edu"
                                                               displayName:@"Josh+Neil+Pauline"
                                                              accountGmail:@"441winter2014@umich.edu"
                                                               accessToken:@"338692774BBE"
                                                                     error:&error];
        [client setDelegate:self];

        [self setClient:client];
        
        [self findSession]; //joins session or creates session
    }
    
    return self;
}

- (void)createSession {
    
    [[self client] createSessionWithName:SESSION_NAME
                                password:nil tags:@[@"EECS441"]
                             startPaused:NO
                       completionHandler:^(int64_t sessionID, CollabrifyError *error) {
                           
                           if (!error) {
                               NSLog(@"Successful Create");
                           }
                           else {
                               NSLog(@"Error Creating Session = %@", error);
                            
                           }
                       }];
}

- (void)findSession {
    
    [[self client] listSessionsWithTags:@[@"EECS441"]
                      completionHandler:^(NSArray *sessions, CollabrifyError *error) {
                          
                          if (error) NSLog(@"Error = %@", error);
                          
                          BOOL sessionFound = NO;
                          
                          for (CollabrifySession *session in sessions) {
                              
                              if (session.sessionName == SESSION_NAME) {
                                  
                                  [self joinSession:session];
                                  sessionFound = YES;
                              }
                          }
                          
                          if (!sessionFound) {
                              
                              [self createSession];
                          }
                          
                      }];
}

- (void)joinSession:(CollabrifySession*)session {
    
    [[self client] joinSessionWithID:[session sessionID]
                            password:nil
                         startPaused:NO
                   completionHandler:^(int64_t maxOrderID, int32_t baseFileSize, CollabrifyError *error) {
                       
                       if (!error) {
                           //update your interface;
                       }
                   }];
}

- (void)leaveSession {
    
    [[self client] leaveAndEndSession:YES completionHandler:^(BOOL success, CollabrifyError *error) {
        
    }];
}

#pragma mark Collabrify Delegate Methods

- (void)client:(CollabrifyClient *)client encounteredError:(CollabrifyError *)error {
    
    NSLog(@"%@", error);
    
}

- (void)client:(CollabrifyClient *)client receivedEventWithOrderID:(int64_t)orderID submissionRegistrationID:(int32_t)submissionRegistrationID eventType:(NSString *)eventType data:(NSData *)data {
    
    NSString *chatMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", chatMessage);
    
}

- (void)client:(CollabrifyClient *)client receivedBaseFile:(NSData *)baseFile {
    
    
}

- (void)client:(CollabrifyClient *)client sessionEnded:(int64_t)sessionID {
    
    NSLog(@"ended");
    
}

- (void)client:(CollabrifyClient *)client participantLeft:(CollabrifyParticipant *)participant {
    
    [[self client] leaveAndEndSession:YES completionHandler:^(BOOL success, CollabrifyError *error) {
        
    }];
}


@end
