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

- (void)recievedEvent:(Event*)event;

@end

@interface CollabrifyManger : NSObject <CollabrifyClientDelegate>

@property (nonatomic, weak) id <CollabrifyProtocol> delegate;

@property (nonatomic, strong) CollabrifyParticipant *participant;
@property (nonatomic, strong) CollabrifyClient *client;

- (void)leaveSession;


- (void)sendEvent:(Event *)event;
- (NSData*)dataForEvent:(TextEvent*)event;
- (TextEvent*)eventFromData:(NSData*)data;

@end
