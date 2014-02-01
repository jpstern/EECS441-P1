//
//  Event.h
//  441P1
//
//  Created by Josh Stern on 1/23/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EventType) {
    
    INSERT = 0,
    DELETE = 1,
    UNDO = 2,
    REDO = 3
};

@interface Event : NSObject


@property (nonatomic) BOOL confirmed;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, strong) NSNumber *participantID;
@property (nonatomic, strong) NSNumber *submissionID;
@property (nonatomic, strong) NSNumber *orderID;
@property (nonatomic, assign) EventType type;

- (id)initWithLocation:(NSInteger)loc andText:(NSString*)text;

@end
