//
//  ViewController.m
//  441P1
//
//  Created by Josh Stern on 1/23/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSTimer *eventTimer;

@property (nonatomic, strong) TextEvent *currentEvent;

@property (nonatomic, strong) NSUndoManager *userUndoManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _textView.text = @"";
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;
    _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Undo" style:UIBarButtonItemStylePlain target:self action:@selector(undoPressed:)];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStylePlain target:self action:@selector(exitSession:)], [[UIBarButtonItem alloc] initWithTitle:@"Redo" style:UIBarButtonItemStylePlain target:self action:@selector(redoPressed:)]];
    
    _currentEvent = [[TextEvent alloc] init];
    _manager = [[UndoManager alloc] init];
    
//    _userUndoManager = [[NSUndoManager alloc] init];
//    [_userUndoManager registerUndoWithTarget:self selector:@selector(prepareEvent) object:_currentEvent];
    
    _collabrifyManager = [[CollabrifyManger alloc] init];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareEvent) name:NSUndoManagerCheckpointNotification object:nil];
}

- (void)createTimer {
    
    _eventTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(prepareEvent) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_eventTimer forMode:NSDefaultRunLoopMode];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareEvent {
    
    if (_currentEvent.text.length > 0) {
        
        //send current event
        //add to undo stack
        
        [_manager addEventToUndoStack:_currentEvent];
        
        NSLog(@"sending text %@", _currentEvent.text);
        
        _currentEvent = nil;
    }

}

- (void)sendEvent:(NSTimer*)timer {
    
    
}

- (void)exitSession:(id)sender {
    
    [_collabrifyManager leaveSession];
}

- (void)undoPressed:(id)sender {
    
    if (_manager.canUndo) {
        TextEvent *event = [_manager undoEvent];
        
        NSRange range = event.range;
        
        NSMutableString *currentText = [_textView.text mutableCopy];
        [currentText deleteCharactersInRange:range];
        _textView.text = currentText;
    }

}

- (void)redoPressed:(id)sender {
    
    if (_manager.canRedo) {
        TextEvent *event = [_manager redoEvent];
        
        NSRange range = event.range;
        NSString *text = event.text;
        
        NSMutableString *currentText = [_textView.text mutableCopy];
        [currentText insertString:text atIndex:range.location];
        _textView.text = currentText;
    }
}

#pragma mark UITextView Methods

- (void)textViewDidChange:(UITextView *)textView {
    
    [_eventTimer invalidate];
    _eventTimer = nil;

    NSRange cursorPosition = [textView selectedRange];
    
    NSLog(@"%lu", (unsigned long)cursorPosition.location);
    
    if (!_currentEvent) {
        
        _currentEvent = [[TextEvent alloc] initWithLocation:cursorPosition.location - 1 andText:[textView.text substringWithRange:NSMakeRange(cursorPosition.location - 1, 1)]];
    }
    else {
        [_currentEvent setText:[textView.text substringWithRange:NSMakeRange(_currentEvent.range.location, cursorPosition.location - _currentEvent.range.location)]];
    }

    NSLog(@"%@", _currentEvent.text);
    
    [self createTimer];
    
}

@end
