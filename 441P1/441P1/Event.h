//
//  Event.h
//  441P1
//
//  Created by Josh Stern on 1/23/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject


@property (nonatomic) BOOL confirmed;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, strong) NSNumber *participantID;
@property (nonatomic, strong) NSNumber *submissionID;
@property (nonatomic, strong) NSNumber *orderID;

- (id)initWithLocation:(NSInteger)loc andText:(NSString*)text;

@end
