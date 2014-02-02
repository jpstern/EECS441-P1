//
//  CollabrifyManger.h
//  441P1
//
//  Created by Josh Stern on 1/25/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Collabrify/Collabrify.h>

#include "TextEvent.pb.h"
#import "Event.h"

#include <iostream>

using namespace std;

@protocol CollabrifyProtocol <NSObject>

- (void)receivedEvent:(Event*)event;
- (void)applyEvent:(Event *)event;
- (void)redoEvent:(Event *)event;
- (void)undoEvent:(Event*)event andRemoveFromStack:(BOOL)flag;
- (BOOL)isTimerValid;

- (void)clearText;

@end

@interface CollabrifyManger : NSObject <CollabrifyClientDelegate>

@property (nonatomic, weak) id <CollabrifyProtocol> delegate;

@property (nonatomic, strong) CollabrifyParticipant *participant;
@property (nonatomic, strong) CollabrifyClient *client;

@property (nonatomic, strong) NSMutableArray *eventOrdering;

- (void)leaveSession;

- (void)unwindEvents;
- (void)sendEvent:(Event *)event;
- (NSData*)dataForEvent:(TextEvent*)event;
- (TextEvent*)eventFromData:(NSData*)data;

- (void)timerBecameInvalid;



@end
