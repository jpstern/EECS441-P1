//
//  CollabrifyError.h
//  Collabrify
//
//  Created by Brandon Knope on 11/13/13.
//  Copyright (c) 2013 Collabrify. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Collabrify/CollabrifyErrorTypes.h>

extern NSString * const CollabrifyClientSideErrorDomain;
extern NSString * const CollabrifyServerSideErrorDomain;

typedef NS_ENUM(NSInteger, CollabrifyClientSideErrorType)
{
    CollabrifyClientSideErrorTypeNotSet = -1,
    CollabrifyClientSideErrorAlreadyConnectedToASession,
    CollabrifyClientSideErrorAlreadyPendingSessionActivity,
    CollabrifyClientSideErrorNotConnectedToASession,
    CollabrifyClientSideErrorCannotConnectToCollabrify,
    CollabrifyClientSideErrorSessionHasEnded,
    CollabrifyClientSideErrorDataChunkTooLarge,
    CollabrifyClientSideErrorCurrentParticipantIsNotTheSessionOwner,
};

@interface CollabrifyError : NSObject

/** The error domain that this error is a part of. */
- (NSString *)domain;

/** A code that describes the error */
- (NSInteger)type;

/** A description of the error */
@property (readonly, copy, nonatomic) NSString *localizedDescription;

/**
 * Creates an error object in a domain with a specific type
 *
 * @param domain What domain the error occured in.
 * @param type The type of error that occurred.
 * @return An error object.
 */
- (instancetype)initWithDomain:(NSString *)domain type:(NSInteger)type;

@end

/**
 * Represents an error that the client can recover from successfully
 */
@interface CollabrifyRecoverableError : CollabrifyError

@end

/**
 * Represents an error that the client is not able to recover from.
 * Because it is unrecoverable, the client will reset and you should reflect this
 * in your interface appropriately
 */
@interface CollabrifyUnrecoverableError : CollabrifyError

@end
