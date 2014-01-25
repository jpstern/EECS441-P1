//
//  CollabrifyParticipant.h
//  Collabrify
//
//  Created by Brandon Knope on 11/18/13.
//  Copyright (c) 2013 Collabrify. All rights reserved.
//

#import <Foundation/Foundation.h>

/** A string that populates the NSString properties if a participant is joining but their information has not been received */
extern NSString * const CollabrifyParticipantJoiningMessage;

/**
 * Represents a single user in a session
 */

@interface CollabrifyParticipant : NSObject < NSCopying >

/** A unique ID within a session to represent a participant. (read-only) */
@property (readonly, assign, nonatomic) int64_t participantID;

/** The display name chosen by the participant. (read-only) */
@property (readonly, copy, nonatomic) NSString *displayName;

/** The participant's gmail account. (read-only) */
@property (readonly, copy, nonatomic) NSString *gmail;

/** The date the participant joined the session in the device's current calendar. (read-only) */
@property (readonly, copy, nonatomic) NSDate *dateJoined;

@end
