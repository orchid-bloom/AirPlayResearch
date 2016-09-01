//
//  DemoViewController.m
//  demo
//
//  Created by Daniel Bowden on 20/02/2014.
//  Copyright (c) 2014 Daniel Bowden. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()

- (void)showWhiteLabel;

@end

@implementation DemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *whiteLabelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [whiteLabelButton setTitle:@"Start ordering" forState:UIControlStateNormal];
    [whiteLabelButton sizeToFit];
    whiteLabelButton.center = self.view.center;
    [whiteLabelButton addTarget:self action:@selector(showWhiteLabel) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:whiteLabelButton];
}

- (void)showWhiteLabel
{
    ASWhitelabelViewController *viewController = [[ASWhitelabelViewController alloc] initWithAppID:@"ABC" appToken:@"123" delegate:self];
    
    viewController.venueAlias = @"airservice-live"; //our demo venue
    
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - ASWhitelabelDelegate

- (void)ASWhitelabelViewControllerDidRequestExit:(ASWhitelabelViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
