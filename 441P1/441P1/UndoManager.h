//
//  UndoManager.h
//  441P1
//
//  Created by Josh Stern on 1/23/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UndoManager : NSObject

@property (nonatomic, strong) NSMutableArray *undoStack;
@property (nonatomic, strong) NSMutableArray *redoStack;

#pragma mark undo methods

- (void)addEventToUndoStack:(id)event;
- (id)undoEvent;

#pragma mark redo methods

- (id)redoEvent;

@end
