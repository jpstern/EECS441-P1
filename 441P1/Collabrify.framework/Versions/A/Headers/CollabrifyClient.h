//
//  CollabrifyClient.h
//  Collabrify
//
//  Created by Brandon Knope on 11/4/13.
//  Copyright (c) 2013 Collabrify. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Collabrify/handlers.h>

typedef NS_ENUM(NSInteger, CollabrifyClientNetworkStatus)
{
    CollabrifyClientNetworkStatusUnknown,
    CollabrifyClientNetworkNotReachable,
    CollabrifyClientNetworkReachableViaWiFi,
    CollabrifyClientNetworkReachableViaWWAN
};

/** 
 * This notification is posted when the network status changes for the client. Inspect the new state with the status key 
 * You can also check the current status by calling currentNetorkStatus
 */
extern NSString *const CollabrifyClientNetworkStatusChangedNotification;
extern NSString *const CollabrifyClientNetworkStatusKey;

@class CollabrifyError;
@class CollabrifyClient;
@class CollabrifySession;
@class CollabrifyParticipant;

@protocol CollabrifyClientDelegate <NSObject>

@required
/**
 * Informs the delegate that the client has encountered an error. If the error is of type
 * CollabrifyUnrecoverableError, the client will be reset to its defaults. You should reflect this
 * in your UI.
 *
 * @param client The client informing the delegate of the error.
 * @param error A CollabrifyError object that is either CollabrifyRecoverableError or CollabrifyUnrecoverableError.
 * @see CollabrifyError
 */
- (void)client:(CollabrifyClient *)client encounteredError:(CollabrifyError *)error;

/**
 * Informs the delegate that the client has received an event
 *
 * @param client The client informing the delegate of the new event.
 * @param orderID The global orderID of the received event.
 * @param submissionRegistrationID The submission ID if the event originated from this client, otherwise -1.
 * @param eventType An optional string that represents the type of the new event.
 * @param data The event as represented by NSData
 * @warning This method is never called on the main thread. If you need to update your UI, make sure to do it on the main thread
 */
- (void)client:(CollabrifyClient *)client receivedEventWithOrderID:(int64_t)orderID submissionRegistrationID:(int32_t)submissionRegistrationID eventType:(NSString *)eventType data:(NSData *)data;

/**
 * Informs the delegate that the client has received a base file
 *
 * @param client The client informing the delegate that it has received a base file
 * @param baseFile The base file data
 */
- (void)client:(CollabrifyClient *)client receivedBaseFile:(NSData *)baseFile;

/**
 * Informs the delegate that the session has ended.
 *
 * @param client The client where the session has ended.
 * @param sessionID The session ID of the session that has ended.
 */
- (void)client:(CollabrifyClient *)client sessionEnded:(int64_t)sessionID;

@optional

/**
 * Informs the delegate that a participant has left the current session.
 *
 * @param client The client object containing the session that participant has joined.
 * @param participant The participant that has just joined the session.
 * @see CollabrifyParticipant
 */
- (void)client:(CollabrifyClient *)client participantJoined:(CollabrifyParticipant *)participant;

/**
 * Informs the delegate that a participant has left the current session.
 *
 * @param client The client object containing the session that the participant has left
 * @param participant The participant has just left the session
 * @see CollabrifyParticipant
 */
- (void)client:(CollabrifyClient *)client participantLeft:(CollabrifyParticipant *)participant;

/**
 * Informs the delegate that a base file has been uploaded
 *
 * @param client The client object that has successfully uploaded a base file
 * @param baseFileSize The size of the completed base file
 */
- (void)client:(CollabrifyClient *)client uploadedBaseFileWithSize:(NSUInteger)baseFileSize;

/**
 * Informs the delegate that the session owner has prevented further participants from joining the current session.
 *
 * @param client The client object that participants can no longer join.
 */
- (void)ownerHasPreventedFurtherJoinsForClient:(CollabrifyClient *)client;

@end

/**
 * Your main interface with the Collabrify.it service
 */
@interface CollabrifyClient : NSObject

/** The object that will receive important information from the client */
@property (weak, nonatomic) id <CollabrifyClientDelegate> delegate;

/** This user's display name. (read-only) */
@property (readonly, copy, nonatomic) NSString *displayName;

/** This user's gmail. (read-only) */
@property (readonly, copy, nonatomic) NSString *gmail;

/** The account gmail this client registers with. (read-only) */
@property (readonly, copy, nonatomic) NSString *accountGmail;

/** This user's participantID. If the user is not in a session, this is -1. (read-only) */
@property (readonly, assign, nonatomic) int64_t participantID;

/** Returns the current network status of the client */
+ (CollabrifyClientNetworkStatus)currentNetworkStatus;

/**
 * Instantiates a client to be used with the Collabrify service.
 *
 * @param displayName A non-unique display name for the user.
 * @param gmail The user's gmail address.
 * @param accountGmail Your account gmail used for authentication with Collabrify.
 * @param accessToken Your access token used for authentication with Collabrify.
 * @param error An error object that is populated if an error occurs during instantiation
 * @see CollabrifyError
 * @return Returns a client object that can be used with the Collabrify service or nil if an error occurs
 */
- (instancetype)initWithGmail:(NSString *)gmail
                  displayName:(NSString *)displayName
                 accountGmail:(NSString *)accountGmail
                  accessToken:(NSString *)accessToken
                        error:(CollabrifyError **)error;

/**
 * Retrieves a list of sessions that contain the specified tags.
 *
 * @param tags An array of NSStrings representing descriptions of a session.
 * @param completionHandler The completion handler that is called after retrieving the sessions.
 * @discussion The completion handler is called on the main thread.
 */
- (void)listSessionsWithTags:(NSArray *)tags
           completionHandler:(ListSessionsCompletionHandler)completionHandler;

/**
 * Creates a session with a given name under the specified tags
 *
 * @param sessionName The name of the session. The name is not unique.
 * @param password A password for the session (optional).
 * @param tags An array of NSString objects describing the session.
 * @param startPaused Specifies whether the session should pause all incoming events upon creation.
 * @param completionHandler The handler that is called when the session is created.
 * @discussion The completionHandler is called on the main thread
 */
- (void)createSessionWithName:(NSString *)sessionName
                     password:(NSString *)password
                         tags:(NSArray *)tags
                  startPaused:(BOOL)startPaused
            completionHandler:(CreateSessionCompletionHandler)completionHandler;

/**
 * Creates a session with a base file
 *
 * @param sessionName The name of the session. The name is not unique.
 * @param password A password for the session (optional).
 * @param tags An array of NSString objects describing the session.
 * @param baseFile NSData that represents the base file to be downloaded by all participants in a session (optional).
 * @param startPaused Specifies whether the session should pause all incoming events upon creation.
 * @param completionHandler The handler that is called when the session is created.
 * @discussion The completionHandler is called on the main thread.
 */
- (void)createSessionWithName:(NSString *)sessionName
                     password:(NSString *)password
                         tags:(NSArray *)tags
                     baseFile:(NSData *)baseFile
                  startPaused:(BOOL)startPaused
            completionHandler:(CreateSessionCompletionHandler)completionHandler;

/**
 * Creates a session with a base file
 *
 * @param sessionName The name of the session. The name is not unique.
 * @param password A password for the session (optional).
 * @param tags An array of NSString objects describing the session.
 * @param participantLimit Specifies the max number of participants allowed. Pass 0 for no limit.
 * @param baseFile NSData that represents the base file to be downloaded by all participants in a session (optional).
 * @param startPaused Specifies whether the session should pause all incoming events upon creation.
 * @param completionHandler The handler that is called when the session is created.
 * @discussion The completionHandler is called on the main thread.
 */
- (void)createSessionWithName:(NSString *)sessionName
                     password:(NSString *)password
                         tags:(NSArray *)tags
             participantLimit:(NSInteger)participantLimit
                     baseFile:(NSData *)baseFile
                  startPaused:(BOOL)startPaused
            completionHandler:(CreateSessionCompletionHandler)completionHandler;

/**
 * Join a session with the specified sessionID and a password (if required)
 *
 * @param sessionID A unique ID identifying a specific session.
 * @param password The password for the session if required.
 * @param startPaused Pauses the client from receiving events when joining a session.
 * @param completionHandler The completion handler called upon joining a session.
 * @discussion The completion is called on the main thread.
 */
- (void)joinSessionWithID:(int64_t)sessionID
                 password:(NSString *)password
              startPaused:(BOOL)startPaused
        completionHandler:(JoinSessionCompletionHandler)completionHandler;

/**
 * Leave and specify whether the session should end for others if you are the session owner
 *
 * @param endSession Specifies whether the session should be ended for others. This is ignored if you are not the session owner
 * @param completionHandler The completion handler called upon leaving a session.
 * @discussion The completion handler is called on the main thread.
 */
- (void)leaveAndEndSession:(BOOL)endSession
         completionHandler:(LeaveSessionCompletionHandler)completionHandler;

/**
 * Broadcast's data to all participants in the session (including this participant).
 *
 * @param payload The data to broadcast.
 * @param eventType The type of event. This is optional.
 * @return A submissionID, allowing you to apply changes immediately. When the event is finally received,
 * you will receive this value in the delegate
 */
- (int32_t)broadcast:(NSData *)payload eventType:(NSString *)eventType;

/**
 * Prevents participants from joining once received by the backend. Only applies if you are the session owner.
 * Participants who are joining before this is called will still join.
 */
- (void)preventFurtherJoins;

/**
 * Returns whether the client has paused sending the client new events
 * @return A BOOL that returns YES if events are paused. Default is NO.
 */
- (BOOL)eventsArePaused;

/**
 * Pauses the client from receiving new events. The client cannot pause an event if it is already being processed.
 *
 * @discussion The client will still retrieve events up to a certain a limit but will not inform the delegate if paused. This
 * means when you resume the client, you will quickly retrieve any pending events as they are essentially cached.
 */
- (void)pauseEvents;

/**
 * Resumes incoming events for the client.
 *
 * @discussion Because the client still retrieves events while paused, resuming the client will allow you to quickly retrieve events
 * that were sent while paused.
 */
- (void)resumeEvents;

/** Returns whether the client is in a session */
- (BOOL)isInSession;

/** Returns the current session ID or -1 if not in a session */
- (int64_t)currentSessionID;

/** Returns the current session order ID or -1 if not in a session */
- (int64_t)currentSessionOrderID;

/** Returns whether the current session is password protected */
- (BOOL)currentSessionIsPasswordProtected;

/** Returns the name of the current session */
- (NSString *)currentSessionName;

/** Returns an array of NSStrings representing the tags of the current session */
- (NSArray *)currentSessionTags;

/** Returns the owner of the current session */
- (CollabrifyParticipant *)currentSessionOwner;

/** Returns whether the current session has ended */
- (BOOL)currentSessionHasEnded;

/** Returns whether the current session has a base file */
- (BOOL)currentSessionHasBaseFile;

/** Returns the number of participants in the current session */
- (NSUInteger)currentSessionParticipantCount;

/** Returns an array containing CollabrifyParticipant objects, representing the participants in the current session */
- (NSArray *)currentSessionParticipants;

@end
