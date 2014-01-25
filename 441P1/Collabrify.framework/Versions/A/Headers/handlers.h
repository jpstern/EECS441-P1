//
//  handlers.h
//  Collabrify
//
//  Created by Brandon Knope on 11/13/13.
//  Copyright (c) 2013 Collabrify. All rights reserved.
//

@class CollabrifyError;

typedef void (^CreateSessionCompletionHandler)(int64_t sessionID, CollabrifyError *error);
typedef void (^JoinSessionCompletionHandler)(int64_t maxOrderID, int32_t baseFileSize, CollabrifyError *error);
typedef void (^LeaveSessionCompletionHandler)(BOOL success, CollabrifyError *error);

typedef void (^ListSessionsCompletionHandler)(NSArray *sessions, CollabrifyError *error);
typedef void (^ListParticipantsCompletionHandler)(NSArray *participants, CollabrifyError *error);
