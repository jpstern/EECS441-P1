//
//  Event.m
//  441P1
//
//  Created by Josh Stern on 1/23/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import "TextEvent.h"

@implementation TextEvent

- (id)init {
    
    self = [super init];
    
    _text = [[NSMutableString alloc] init];
    
    return self;
}

@end
