//
//  Event.m
//  441P1
//
//  Created by Josh Stern on 1/23/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import "Event.h"

@implementation Event

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
