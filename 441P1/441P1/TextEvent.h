//
//  Event.h
//  441P1
//
//  Created by Josh Stern on 1/23/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextEvent : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSRange *range;

@end
