//
//  ViewController.m
//  441P1
//
//  Created by Josh Stern on 1/23/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import "ViewController.h"

using namespace std;

@interface ViewController ()

@property (nonatomic, strong) NSTimer *eventTimer;
@property (nonatomic, strong) Event *currentEvent;

@property (nonatomic, strong) NSString *activeText;

@property (nonatomic, strong) NSMutableArray *events;

@property (nonatomic, strong) NSString *textBeforeEvent;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

    _textView.text = @"";
    _activeText = @"";
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;
    _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [_textView becomeFirstResponder];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Undo" style:UIBarButtonItemStylePlain target:self action:@selector(undoPressed:)];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStylePlain target:self action:@selector(exitSession:)], [[UIBarButtonItem alloc] initWithTitle:@"Redo" style:UIBarButtonItemStylePlain target:self action:@selector(redoPressed:)]];
    
    _manager = [[UndoManager alloc] init];
    _collabrifyManager = [[CollabrifyManger alloc] init];
    _collabrifyManager.delegate = self;
    
    _events = [[NSMutableArray alloc] init];

}

- (void)createTimer {
    
    _eventTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(prepareEvent) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_eventTimer forMode:NSDefaultRunLoopMode];
    
}

- (void)clearText {
    
    _textView.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCursorLocation:(NSInteger)pos {
    
    _textView.selectedRange = NSMakeRange(pos, 0);
}

- (void)prepareEvent {
    
    NSRange cursorPosition = [_textView selectedRange];
    
    _collabrifyManager.cursorPosition = cursorPosition.location;
    
    _currentEvent.endCursor = cursorPosition.location;
    
    if (_textBeforeEvent.length != _activeText.length) {
        
        if (_textBeforeEvent.length < _activeText.length) {
            
            _currentEvent.type = INSERT;
            _currentEvent.range = NSMakeRange(_currentEvent.startCursor, _currentEvent.endCursor - _currentEvent.startCursor);
            //NSMakeRange(_textBeforeEvent.length, _activeText.length - _textBeforeEvent.length);
            _currentEvent.text = [_activeText substringWithRange:_currentEvent.range];
        }
        else if (_textBeforeEvent.length > _activeText.length) {
            
            _currentEvent.type = DELETE;
            _currentEvent.range = NSMakeRange(_currentEvent.endCursor, _currentEvent.startCursor - _currentEvent.endCursor);
            //NSMakeRange(_activeText.length, _textBeforeEvent.length - _activeText.length);
            _currentEvent.text = [_textBeforeEvent substringWithRange:_currentEvent.range];
        }
        
        
        [_manager addEventToUndoStack:_currentEvent];
        
        NSLog(@"sending text %@", _currentEvent.text);
        
        //add event to global ordering array
        
        [_collabrifyManager sendEvent:_currentEvent];
        
        _currentEvent = nil;
        
        _textBeforeEvent = _textView.text;

        [_collabrifyManager timerBecameInvalid];
    }
}

- (void)fixStacksForEvent:(Event*)insertedEvent isDelete:(BOOL)flag {
    
    if (!flag) {
        
        for (Event *event in _manager.undoStack) {
            
            if (insertedEvent.range.location <= event.range.location) {
                
                event.range = NSMakeRange(event.range.location + insertedEvent.range.length, event.range.length);
            }
        }
        
        for (Event *event in _manager.redoStack) {
            
            if (insertedEvent.range.location <= event.range.location) {
                
                event.range = NSMakeRange(event.range.location + insertedEvent.range.length, event.range.length);
            }
        }

    }
}

- (void)fixStacksForRedo:(Event*)redoneEvent {
    
    if (!redoneEvent.del) {
        
        for (Event *event in _manager.undoStack) {
            
            if (redoneEvent.range.location <= event.range.location) {
                
                event.range = NSMakeRange(event.range.location + redoneEvent.range.length, event.range.length);
            }
        }
        
        for (Event *event in _manager.redoStack) {
            
            if (redoneEvent.range.location <= event.range.location) {
                
                event.range = NSMakeRange(event.range.location + redoneEvent.range.length, event.range.length);
            }
        }
    }
}

- (void)fixStacksForUndo:(Event*)undoneEvent {
    
    if (!undoneEvent.del) {
        
        for (Event *event in _manager.undoStack) {
            
            if (undoneEvent.range.location <= event.range.location) {
                
                event.range = NSMakeRange(event.range.location - undoneEvent.range.length, event.range.length);
            }
        }
        
        for (Event *event in _manager.redoStack) {
            
            if (undoneEvent.range.location <= event.range.location) {
                
                event.range = NSMakeRange(event.range.location - undoneEvent.range.length, event.range.length);
            }
        }
        
    }
    
}

- (void)applyEvent:(Event *)event {
    
    if (event.type == INSERT) {// || (event.type == REDO && !event.del)) {
        NSLog(@"active text is: %@", _textView.text);
        NSLog(@"current text is: %@", _textView.text);
        NSLog(@"applying text: %@", event.text);
        //add event to global ordering array
        
        NSMutableString *string = [_activeText mutableCopy];
        if (event.range.location >= string.length) {
        
            NSLog(@"appending:%@", event.text);
            event.range = NSMakeRange(string.length, event.range.length);
            [string appendString:event.text];
        }
        else {
            
            NSLog(@"inserting:%@", event.text);
            [string insertString:event.text atIndex:event.range.location];
            
            [self fixStacksForEvent:event isDelete:NO];
            
        }
        
        [_textView setText:string];
        _activeText = string;
    }
    else if (event.type == DELETE) {// || (event.type == REDO && event.del)) {
        
        NSLog(@"active text is: %@", _textView.text);
        NSLog(@"current text is: %@", _textView.text);
        NSLog(@"applying text: %@", event.text);
        //add event to global ordering array
        
        NSLog(@"%lu %lu", (unsigned long)
              event.range.location, (unsigned long)event.range.length);

        
        NSMutableString *string = [_activeText mutableCopy];
        
        [string deleteCharactersInRange:event.range];
        
        [_textView setText:string];
        _activeText = string;
        
    }
    
    _textBeforeEvent = _textView.text;
}

- (void)receivedEvent:(Event *)event {
    

    NSUInteger cursorPos = _textView.selectedRange.location;
    
    if (event.range.location < cursorPos)
        cursorPos += event.range.length;
    
    if (event.type == INSERT || event.type == DELETE) {
        
        [self applyEvent:event];
    }
    else if (event.type == REDO) {

        [self redoEvent:event andRemove:NO];
        [self fixStacksForRedo:event];
    }
    else if (event.type == UNDO) {
        
        [self undoEvent:event andRemoveFromStack:NO];

        [self fixStacksForUndo:event];
    }
    
    [self setCursorLocation:cursorPos];
    
}

- (void)exitSession:(id)sender {
    
    [_collabrifyManager leaveSession];
}

- (BOOL)isTimerValid {

    return _eventTimer.isValid;
}

- (void)undoEvent:(Event*)event andRemoveFromStack:(BOOL)flag {

    if (flag) [_manager undoEvent];
    
    NSRange range = event.range;
    
    NSLog(@"undo");
    NSLog(@"%lu %lu", (unsigned long)
          range.location, (unsigned long)range.length);
    NSLog(@"%@", event.text);
    
    if (event.type == INSERT || (event.type == UNDO && !event.del)) {
        NSMutableString *currentText = [_textView.text mutableCopy];
        [currentText deleteCharactersInRange:range];
        _textView.text = currentText;
        _activeText=currentText;
    }
    else if (event.type == DELETE || (event.type == UNDO && event.del)) {
        
        NSMutableString *currentText = [_textView.text mutableCopy];
        if (currentText.length != 0)
            [currentText insertString:event.text atIndex:event.range.location];
        else {
            currentText = [@"" mutableCopy];
            [currentText appendString:event.text];
        }
        _textView.text = currentText;
        _activeText = currentText;
    }
    
    _textBeforeEvent = _textView.text;
}

- (void)undoPressed:(id)sender {
    
    if (_manager.canUndo) {
        
        Event *event = [[_manager getNextUndo] copy];
        event.type = UNDO;
        event.orderID = nil;
        
        NSLog(@"undo pressed");
        
        NSLog(@"UNDOING : %@ %@", event.text, event.orderID);
        
        
        NSLog(@"%@", _collabrifyManager.eventOrdering);
                
        [_collabrifyManager sendEvent:event];
//        Event *event = [_manager undoEvent];
//        [self undoEvent:event];
        
        NSLog(@"%@", _collabrifyManager.eventOrdering);
        
    }

}

- (void)redoEvent:(Event*)event andRemove:(BOOL)flag {
    
    if (flag)
        [_manager redoEvent];
    
    NSRange range = event.range;
    NSString *text = event.text;
    
    NSLog(@"redo");
    NSLog(@"%lu %lu", (unsigned long)
          range.location, (unsigned long)range.length);
    NSLog(@"%@", event.text);
    
    if (event.del) {
        
        NSMutableString *currentText = [_textView.text mutableCopy];
        [currentText deleteCharactersInRange:range];
        _textView.text = currentText;

    }
    else {
        
        NSMutableString *currentText = [_textView.text mutableCopy];
        [currentText insertString:text atIndex:range.location];
        _textView.text = currentText;
    }
    
    _textBeforeEvent = _textView.text;
}

- (void)redoPressed:(id)sender {
    
    if (_manager.canRedo) {
        
        Event *event = [_manager getNextRedo];
        event.type = REDO;
        event.orderID = nil;
        
        [_collabrifyManager sendEvent:event];
        
    }
}

#pragma mark UITextView Methods

- (void)textViewDidChange:(UITextView *)textView {

    NSLog(@"text changed");
    NSLog(@"in here");
    [_eventTimer invalidate];
    _eventTimer = nil;
    
    NSRange cursorPosition = [textView selectedRange];
    
    if (!_currentEvent) {
        _currentEvent = [[Event alloc] init];
        
        if (_textView.text.length < _textBeforeEvent.length) {
            
            _currentEvent.startCursor = cursorPosition.location + 1;
        }
        else {
            _currentEvent.startCursor = cursorPosition.location - 1;
        }
        
    }
    
    _activeText = textView.text;
    
    [self createTimer];
}


@end
