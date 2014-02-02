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

@property (nonatomic, assign) BOOL canUndo;
@property (nonatomic, assign) BOOL canRedo;

@property (nonatomic, assign) NSInteger pendingUndo;

#pragma mark undo methods

- (void)addEventToUndoStack:(id)event;
- (id)undoEvent;
- (id)getNextUndo;

#pragma mark redo methods

- (id)getNextRedo;
- (id)redoEvent;

@end
