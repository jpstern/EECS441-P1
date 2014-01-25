//
//  CollabrifySession.h
//  Collabrify
//
//  Created by Brandon Knope on 11/18/13.
//  Copyright (c) 2013 Collabrify. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Represents a session on the Collabrify service.
 * Some of these properties may be nil when listing sessions
 */

@class CollabrifyParticipant;
@interface CollabrifySession : NSObject

/** The unique ID representing the session. (read-only) */
@property (readonly, assign, nonatomic) int64_t sessionID;

/** Specifies whether the session is password protected. (read-only) */
@property (readonly, assign, getter = isPasswordProtected, nonatomic) BOOL passwordProtected;

/** The name of the session. (read-only) */
@property (readonly, copy, nonatomic) NSString *sessionName;

/** The ID of the session owner. (read-only) */
@property (readonly, assign, nonatomic) int64_t ownerID;

/** An array of participant IDs who are in the session. (read-only) */
@property (readonly, copy, nonatomic) NSArray *participantIDs; //of NSNumber

/** The session's current order ID. (read-only) */
@property (readonly, assign, nonatomic) int64_t currentOrderID;

/** Specifies whether the session has a base file. (read-only) */
@property (readonly, assign, nonatomic) BOOL hasBaseFile;

/** Specifies the size of the base file. (read-only) */
@property (readonly, assign, nonatomic) int32_t baseFileSize;

/** Specifies whether the session has ended. (read-only) */
@property (readonly, assign, getter = hasEnded, nonatomic) BOOL ended;

/** Indicates the participant limit of the session. 0 indicates no limit. (read-only) */
@property (readonly, assign, nonatomic) NSInteger participantLimit;

/** Indicates the number of participants in the session. (read-only) */
@property (readonly, assign, nonatomic) NSUInteger participantCount;

/** The tags used when the session was created. (read-only) */
@property (readonly, copy, nonatomic) NSArray *tags; //of NSString

/** The owner of the session. Returns nil when listing sessions. (read-only) */
@property (readonly, strong, nonatomic) CollabrifyParticipant *owner;

/** The participants in a session. Returns nil when listing sessions. (read-only) */
@property (readonly, strong, nonatomic) NSArray *participants; //of CollabrifyParticipant

@end
