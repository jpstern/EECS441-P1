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
    _textView.selectable = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Undo" style:UIBarButtonItemStylePlain target:self action:@selector(undoPressed:)];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStylePlain target:self action:@selector(exitSession:)], [[UIBarButtonItem alloc] initWithTitle:@"Redo" style:UIBarButtonItemStylePlain target:self action:@selector(redoPressed:)]];
    
    _currentEvent = [[TextEvent alloc] init];
    
    _userUndoManager = [[NSUndoManager alloc] init];
    [_userUndoManager registerUndoWithTarget:self selector:@selector(prepareEvent) object:_currentEvent];
    
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
    
    
    
}

- (void)sendEvent:(NSTimer*)timer {
    
    if (_currentEvent.text.length > 0) {
        
        //send current event
        //add to undo stack
        
        NSLog(@"sending text %@", _currentEvent.text);
        
        _currentEvent = nil;
    }
}

- (void)exitSession:(id)sender {
    
    [_collabrifyManager leaveSession];
}

- (void)undoPressed:(id)sender {

    TextEvent *event = [_manager undoEvent];
    if (!_textView.undoManager.isRedoing && _textView.undoManager.canUndo)
        [_textView.undoManager undo];
}

- (void)redoPressed:(id)sender {
    
    TextEvent *event = [_manager redoEvent];
    
    if (!_textView.undoManager.isUndoing && _textView.undoManager.canRedo)
        [_textView.undoManager redo];
}

#pragma mark UITextView Methods

- (void)textViewDidChange:(UITextView *)textView {
    
    [_eventTimer invalidate];
    _eventTimer = nil;
    
    
//    
    if (!_currentEvent) {
        
        _currentEvent = [[TextEvent alloc] init];
        [_textView.undoManager beginUndoGrouping];
    }
//
//    //do something
//    [_currentEvent.text appendString:textView.text];
    
    [self createTimer];
    
}

@end
