//
//  CollabrifyManger.m
//  441P1
//
//  Created by Josh Stern on 1/25/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import "CollabrifyManger.h"


NSString *SESSION_NAME = @"4ggggddddfff";

@implementation CollabrifyManger

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        _eventOrdering = [[NSMutableArray alloc] init];
        
        CollabrifyError *error = nil;
        CollabrifyClient *client = [[CollabrifyClient alloc] initWithGmail:@"jpstern@umich.edu"
                                                               displayName:@"Josh+Neil+Pauline"
                                                              accountGmail:@"441winter2014@umich.edu"
                                                               accessToken:@"338692774BBE"
                                                                     error:&error];
        [client setDelegate:self];

        [self setClient:client];
        
//        SESSION_NAME = [NSString stringWithFormat:@"%@%@", SESSION_NAME, [@(rand() % 1231232) stringValue]];
        
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
                              
                              if ([session.sessionName isEqualToString:SESSION_NAME] && !session.hasEnded) {
                                  
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
                           
                           NSLog(@"%d", baseFileSize);
                       }
                   }];
}

- (void)leaveSession {
    
    [[self client] leaveAndEndSession:YES completionHandler:^(BOOL success, CollabrifyError *error) {
        
    }];
}

#pragma mark confirming events/global ordering

- (void)reapplyEvents {
    
    [_eventOrdering sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        if ([obj1 orderID] > [obj2 orderID]) return NSOrderedDescending;
        
        return NSOrderedAscending;
        
    }];

    for (Event *event in _eventOrdering) {
        
        [_delegate applyEvent:event];
    }
    
    NSUInteger index = [_eventOrdering indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
     
        if ([obj confirmed] == NO) return YES;
        
        return NO;
    }];
    
    if (index == NSNotFound) {
        
        [_eventOrdering removeAllObjects];
    }
    else {
        _eventOrdering = [[_eventOrdering subarrayWithRange:NSMakeRange(index, _eventOrdering.count - index)] mutableCopy];
        
    }
    
}

- (void)unwindEvents {
    
    for (Event *event in [[_eventOrdering copy] reverseObjectEnumerator]) {
    
        [_delegate undoEvent:event];
        
    }
    
    [self reapplyEvents];
}

#pragma sending data

- (void)sendEvent:(Event *)event {
    
    event.confirmed=NO;

    [_eventOrdering addObject:event];
    
    TextEvent *textEvent = new TextEvent();
    textEvent->set_text([event.text cStringUsingEncoding:NSUTF8StringEncoding]);
    textEvent->set_user_id(self.client.participantID);
    textEvent->set_location((int32_t)event.range.location);
    
    std::string x = textEvent->DebugString();
    NSData *rawEvent = [self dataForEvent:textEvent];
    
    int32_t orderID = [self.client broadcast:rawEvent eventType:nil];
    
    event.orderID = orderID;
    
}

- (TextEvent *)eventFromData:(NSData *)data {
    
    int len = (int)[data length];
    char raw[len];
    TextEvent *event = new TextEvent();
    [data getBytes:raw length:len];
    event->ParseFromArray(raw, len);
    return event;
}

- (NSData *)dataForEvent:(TextEvent *)event {
    
    std::string ps = event->SerializeAsString();
    return [NSData dataWithBytes:ps.c_str() length:ps.size()];
}

#pragma mark Collabrify Delegate Methods

- (void)client:(CollabrifyClient *)client encounteredError:(CollabrifyError *)error {
    
    NSLog(@"%@", error);
    
}

- (void)client:(CollabrifyClient *)client receivedEventWithOrderID:(int64_t)orderID submissionRegistrationID:(int32_t)submissionRegistrationID eventType:(NSString *)eventType data:(NSData *)data {
    
    TextEvent *textEvent = [self eventFromData:data];
    
    cout << orderID << " receiving : " << textEvent->text().c_str() << endl;
    
    NSString *text = [NSString stringWithCString:textEvent->text().c_str() encoding:NSUTF8StringEncoding];
    Event *event = [[Event alloc] init];
    event.text = text;
    event.participantID = textEvent->user_id();
    event.range = NSMakeRange(textEvent->location(), text.length);
    
    dispatch_async(dispatch_get_main_queue(), ^{
     
        event.confirmed=YES;
        
        [_eventOrdering addObject:event];
        
        [_delegate recievedEvent:event];
    });
    //call received
    
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
