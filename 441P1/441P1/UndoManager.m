//
//  UndoManager.m
//  441P1
//
//  Created by Josh Stern on 1/23/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import "UndoManager.h"

@implementation UndoManager

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        _undoStack = [[NSMutableArray alloc] init];
        _redoStack = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (BOOL)canUndo {
    
    return _undoStack.count > 0;
}

- (BOOL)canRedo {
    
    return _redoStack.count > 0;
}

- (void)addEventToUndoStack:(id)event {
    
    //lifo
    [_undoStack addObject:event];
}

- (id)getNextUndo {
    
    id event = _undoStack[_undoStack.count - 1 - _pendingUndo];
    
    _pendingUndo ++;
    
    return event;
    
//    return [_undoStack lastObject];
}

- (id)getNextRedo {
    
    return [_redoStack lastObject];
}

- (id)undoEvent {
    
    _pendingUndo --;
    
    id event = [_undoStack lastObject];
    [_redoStack addObject:event];
    [_undoStack removeLastObject];
    
    return event;
}

- (id)redoEvent {
    
    id event = [_redoStack lastObject];
    [_undoStack addObject:event];
    [_redoStack removeLastObject];
    
    return event;
    
}


@end
