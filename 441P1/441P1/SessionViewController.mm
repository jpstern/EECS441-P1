//
//  SessionViewController.m
//  441P1
//
//  Created by Josh Stern on 2/4/14.
//  Copyright (c) 2014 Josh. All rights reserved.
//

#import "SessionViewController.h"

#import "ViewController.h"
@interface SessionViewController ()

@end

@implementation SessionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"Welcome to WeWrite!";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ViewController *vc = segue.destinationViewController;
    
    vc.join = sender == _join;
    vc.sessionName = _field.text;
    
    _field.text = @"";
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if (_field.text.length == 0) {
        
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
