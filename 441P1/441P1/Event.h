//
//  Event.h
//  441P1
//
//  Created by Josh Stern on 1/23/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSUInteger, EventType) {
//    
//    INSERT = 0,
//    DELETE = 1,
//    UNDO = 2,
//    REDO = 3
//};

//#include "TextEvent.pb.h"

@interface Event : NSObject <NSCopying>


@property (nonatomic) BOOL confirmed;

@property (nonatomic, assign) NSInteger startCursor;
@property (nonatomic, assign) NSInteger endCursor;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, strong) NSNumber *participantID;
@property (nonatomic, strong) NSNumber *submissionID;
@property (nonatomic, strong) NSNumber *orderID;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL del;

- (id)initWithLocation:(NSInteger)loc andText:(NSString*)text;

@end
