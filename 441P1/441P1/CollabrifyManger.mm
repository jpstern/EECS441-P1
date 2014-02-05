//
//  CollabrifyManger.m
//  441P1
//
//  Created by Josh Stern on 1/25/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import "CollabrifyManger.h"



NSString *SESSION_NAME = @"g0000000000000000000004";

@interface CollabrifyManger ()

@property (nonatomic, strong) NSMutableArray *pendingEvents;

@end

@implementation CollabrifyManger

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        _pendingEvents = [[NSMutableArray alloc] init];
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
    
    NSArray *array = [_eventOrdering valueForKey:@"text"];
    NSArray *array3 = [_eventOrdering valueForKey:@"orderID"];
    
    _eventOrdering = [[_eventOrdering sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        if ([obj1 orderID] == nil) return NSOrderedDescending;
        if ([obj2 orderID] == nil) return NSOrderedAscending;
        
        return [[obj1 orderID] compare:[obj2 orderID]];        
        
    }] mutableCopy];
    
    NSArray *array2 = [_eventOrdering valueForKey:@"text"];
    
    for (Event *event in _eventOrdering) {
        
        if (event.type == INSERT || event.type == DELETE) {
            
            [_delegate applyEvent:event];
        }
        else if (event.type == REDO && event.orderID) {
            
            [_delegate redoEvent:event andRemove:[event.submissionID intValue] != -1];
        }
        else if (event.type == UNDO && event.orderID) {
            
            [_delegate undoEvent:event andRemoveFromStack:[event.submissionID intValue] != -1];
            
            
        }

    }
    
    NSInteger index = [_eventOrdering indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        if (![obj confirmed]) {
            
            return YES;
        }
        
        return NO;
        
    }];
    
    if (index != NSNotFound) {
        _eventOrdering = [[_eventOrdering subarrayWithRange:NSMakeRange(index, _eventOrdering.count - index)] mutableCopy];
    }
    else {
        
        [_eventOrdering removeAllObjects];
    }
    

//    [_delegate setCursorLocation:_cursorPosition];
}

- (void)unwindEvents {
    
//    [_delegate clearText];
    
    NSInteger index = [_eventOrdering indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
       
        if (![obj confirmed]) {
            
            return YES;
        }
        
        return NO;
        
    }];
   
    if (index != NSNotFound) {
        _eventOrdering = [[_eventOrdering subarrayWithRange:NSMakeRange(index, _eventOrdering.count - index)] mutableCopy];
    }
    else {
        
        [_eventOrdering removeAllObjects];
    }

    for (Event *event in [_eventOrdering reverseObjectEnumerator]) {
        
        if (event.type == INSERT || event.type == DELETE) {
            [_delegate undoEvent:event andRemoveFromStack:NO];
            
            [self fixEventOrderingForEvent:event];
        }
    
        if (event.orderID)
            event.confirmed = YES;
    }

    [self reapplyEvents];
}

#pragma sending data

- (void)sendEvent:(Event *)event {
    
    event.confirmed = NO;

    [_eventOrdering addObject:event];
    
    TextEvent *textEvent = new TextEvent();
    textEvent->set_text([event.text cStringUsingEncoding:NSUTF8StringEncoding]);
    textEvent->set_user_id(self.client.participantID);
    textEvent->set_location((int32_t)event.range.location);
    textEvent->set_type((EventType)event.type);
    
    std::string x = textEvent->DebugString();
    NSData *rawEvent = [self dataForEvent:textEvent];
    
    int32_t submissionID = [self.client broadcast:rawEvent eventType:nil];
    
    event.submissionID = @(submissionID);
    
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

- (void)timerBecameInvalid {
    
    for (Event *event in _pendingEvents) {
        
        NSLog(@"processing pending event %ld %@", event.type, event.text);
        
        [self processRecievedEvent:event];
    }
    
    [_pendingEvents removeAllObjects];
}

#pragma mark Collabrify Delegate Methods

- (void)client:(CollabrifyClient *)client encounteredError:(CollabrifyError *)error {
    
    NSLog(@"%@", error);
    
}

- (void)client:(CollabrifyClient *)client receivedEventWithOrderID:(int64_t)orderID submissionRegistrationID:(int32_t)submissionRegistrationID eventType:(NSString *)eventType data:(NSData *)data {
    
    TextEvent *textEvent = [self eventFromData:data];
    
    int64_t participant = textEvent->user_id();
    
    NSString *text = [NSString stringWithCString:textEvent->text().c_str() encoding:NSUTF8StringEncoding];
    Event *event = [[Event alloc] init];
    event.text = text;
    event.participantID = @(participant);
    event.range = NSMakeRange(textEvent->location(), text.length);
    event.orderID = @(orderID);
    event.submissionID = @(submissionRegistrationID);
    event.type = textEvent->type();
    event.del = textEvent->delete_();
    
    cout << orderID << " receiving : " << textEvent->text().c_str() << endl;
    
    if (submissionRegistrationID != -1) {
        for (Event *event in _eventOrdering) {
            
            if ([event.submissionID intValue] == submissionRegistrationID) {
                
                event.orderID = @(orderID);
            }
        }
    }
    
    if (![_delegate isTimerValid]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self processRecievedEvent:event];
        });
    }
    else {
        
        NSLog(@"timer is valid, adding %ld %@ to pending event", event.type, event.text);
        
        [_pendingEvents addObject:event];
    }
    //call received
    
}

- (void)processRecievedEvent:(Event*)event {
    
    if ([event.participantID intValue] == self.client.participantID) {
        //need to confirm my event
        
        NSLog(@"confirming event mode %ld text %@", (long)event.type, event.text);
        
        [self unwindEvents];
    }
    else {
        
        event.confirmed = YES;
        
        [_eventOrdering addObject:event];
        
//        [self fixEventOrderingForEvent:event];
        
        [_delegate receivedEvent:event];
    }

}

- (void)fixEventOrderingForEvent:(Event*)e {
    
    Event *changedEvent = [e copy];
    
    for (Event *event in _eventOrdering) {
        
        if (!e.del && NSLocationInRange(changedEvent.range.location, event.range)) {
            
            event.range = NSMakeRange(event.range.location + changedEvent.range.length, event.range.length);
            changedEvent = event;
        }
        else if (e.del) {
            
            event.range = NSMakeRange(event.range.location - changedEvent.range.length, event.range.length);
            changedEvent = event;
        }
    }
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
