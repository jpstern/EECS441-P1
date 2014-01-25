//
//  CollabrifyManger.h
//  441P1
//
//  Created by Josh Stern on 1/25/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Collabrify/Collabrify.h>


@interface CollabrifyManger : NSObject <CollabrifyClientDelegate>

@property (nonatomic, strong) CollabrifyParticipant *participant;
@property (nonatomic, strong) CollabrifyClient *client;

- (void)leaveSession;

@end
