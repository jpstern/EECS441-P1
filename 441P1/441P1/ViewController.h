//
//  ViewController.h
//  441P1
//
//  Created by Josh Stern on 1/23/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "TextEvent.h"
#include "UndoManager.h"
#include "CollabrifyManger.h"

@interface ViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITextView *textView;

@property (nonatomic, strong) CollabrifyManger *collabrifyManager;
@property (nonatomic, strong) UndoManager *manager;

- (IBAction)redoPressed:(id)sender;
- (IBAction)undoPressed:(id)sender;

@end
