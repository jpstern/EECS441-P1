//
//  Event.m
//  441P1
//
//  Created by Josh Stern on 1/23/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import "Event.h"

@implementation Event

/*
 @property (nonatomic) BOOL confirmed;
 @property (nonatomic, strong) NSString *text;
 @property (nonatomic, assign) NSRange range;
 @property (nonatomic, strong) NSNumber *participantID;
 @property (nonatomic, strong) NSNumber *submissionID;
 @property (nonatomic, strong) NSNumber *orderID;
 @property (nonatomic, assign) NSInteger type;
 */

- (id)copyWithZone:(NSZone *)zone {
    
    Event *copy = [[Event alloc] init];
    
    if (copy) {
        
        [copy setText:[self.text copyWithZone:zone]];
        [copy setParticipantID:[self.participantID copyWithZone:zone]];
        [copy setSubmissionID:[self.submissionID copyWithZone:zone]];
        [copy setOrderID:[self.orderID copyWithZone:zone]];
        
        [copy setRange:self.range];
        [copy setType:self.type];
        [copy setConfirmed:self.confirmed];
    }
    
    return copy;
    
}

- (id)initWithLocation:(NSInteger)loc andText:(NSString*)text {
    
    self = [super init];
    
    _range = NSMakeRange(loc, text.length);
    _text = [[NSString alloc] initWithString:text];
    
    return self;
}

- (void)setText:(NSString *)text {
    
    _range = NSMakeRange(_range.location, text.length);
    
    _text = [[NSString alloc] initWithString:text];
}

@end
