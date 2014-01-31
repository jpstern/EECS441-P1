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
        
        //add event to global ordering array
        [_collabrifyManager sendEvent:_currentEvent];
        
        _currentEvent = nil;

    }

}

- (void)applyEvent:(Event *)event {
    
    NSLog(@"active text is: %@", _textView.text);
    NSLog(@"current text is: %@", _textView.text);
    NSLog(@"applying text: %@", event.text);
    //add event to global ordering array
    
    NSMutableString *string = [_activeText mutableCopy];
    if (event.range.location >= string.length) {
        
        NSLog(@"appending:%@", event.text);
        
        [string appendString:event.text];
    }
    else {
        [string insertString:event.text atIndex:event.range.location];
        
    }
    [_textView setText:string];
    _activeText = string;
}

- (void)recievedEvent:(Event *)event {
    
//    [_events addObject:event];

    [self applyEvent:event];

//    if (_collabrifyManager.client.participantID ise
    
}

- (void)exitSession:(id)sender {
    
    [_collabrifyManager leaveSession];
}

- (void)undoEvent:(Event*)event {
    
    NSRange range = event.range;
    
    NSMutableString *currentText = [_textView.text mutableCopy];
    [currentText deleteCharactersInRange:range];
    _textView.text = currentText;
    _activeText=currentText;
}

- (void)undoPressed:(id)sender {
    
    if (_manager.canUndo) {
        
        Event *event = [_manager undoEvent];
        
        [self undoEvent:event];
        
    }

}

- (void)redoPressed:(id)sender {
    
    if (_manager.canRedo) {
        Event *event = [_manager redoEvent];
        
        NSRange range = event.range;
        NSString *text = event.text;
        
        NSMutableString *currentText = [_textView.text mutableCopy];
        [currentText insertString:text atIndex:range.location];
        _textView.text = currentText;
    }
}

#pragma mark UITextView Methods


- (void)textViewDidChange:(UITextView *)textView {

    NSLog(@"text changed");
//    if (!_disableChangeText) {
        NSLog(@"in here");
        [_eventTimer invalidate];
        _eventTimer = nil;
        
        NSRange cursorPosition = [textView selectedRange];
        
        NSLog(@"%lu", (unsigned long)cursorPosition.location);
        
        if (_activeText.length > textView.text.length) {
            
            NSLog(@"delete occured");
            
            //        if (!_currentEvent) {
            //
            //            _currentEvent = [[Event alloc] initWithLocation:cursorPosition.location andText:[textView.text substringWithRange:NSMakeRange(cursorPosition.location, 1)]];
            //        }
            //        else {
            //            [_currentEvent setText:[textView.text substringWithRange:NSMakeRange(_currentEvent.range.location, cursorPosition.location - _currentEvent.range.location)]];
            //        }
        }
        else {
            
            if (!_currentEvent) {
                
                _currentEvent = [[Event alloc] initWithLocation:cursorPosition.location - 1 andText:[textView.text substringWithRange:NSMakeRange(cursorPosition.location - 1, 1)]];
            }
            else {
                [_currentEvent setText:[textView.text substringWithRange:NSMakeRange(_currentEvent.range.location, cursorPosition.location - _currentEvent.range.location)]];
                
                NSLog(@"setting text to: %@", _currentEvent.text);
            }
             
        }
        
        _activeText = textView.text;
        
        [self createTimer];
//    }
    
//    _disableChangeText = NO;
}

@end
