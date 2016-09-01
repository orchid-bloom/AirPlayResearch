//
//  LZXViewController.m
//  ScreenRecorderDemo
//
//  Created by 白冰 on 13-7-25.
//  Copyright (c) 2013年 . All rights reserved.
//

#import "LZXViewController.h"


#import "DrawView.h"
#import "ScreenRecorder.h"

#define MainFrame [[UIScreen mainScreen] applicationFrame]
#define MainFrameLandscape CGRectMake(0.0f, 0.0f, MainFrame.size.height, MainFrame.size.width)
#define DOCSFOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"]
#define VideoPath [DOCSFOLDER stringByAppendingPathComponent:@"test.mp4"]


@interface LZXViewController ()

-(void)readyInit;

@end

@implementation LZXViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - For ScreenRecorderDelegate
//////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)recordCompleted
{
    [self.view addSubview:movieShow];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[VideoPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [movieShow loadRequest:request];
}

-(void)delayStop
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [myScreenRecorder performSelectorOnMainThread:@selector(stopRecord) withObject:nil waitUntilDone:YES];
    });
}

-(void)readyGo
{
	if (!isReload)
	{
        myScreenRecorder.ParentID = self;
        [myScreenRecorder readyGo:self.view];
        [myScreenRecorder startRecord:VideoPath];
        
        [self performSelector:@selector(delayStop) withObject:nil afterDelay:10.0f];
        [self performSelector:@selector(recordCompleted) withObject:nil afterDelay:30.0f];

        [movieShow setBackgroundColor:[UIColor redColor]];
        [self.view addSubview:myDrawView];

	}
    
}

-(void)readyInit
{
    myDrawView = [[DrawView alloc] initWithFrame:self.view.bounds];
    myScreenRecorder = [[ScreenRecorder alloc] init];
    movieShow = [[UIWebView alloc] initWithFrame:self.view.bounds];
}
- (void)loadView
{
	// Add a background
	UIImageView *imgView = [[[UIImageView alloc] initWithFrame:MainFrame] autorelease];
	imgView.image = [UIImage imageNamed:@"bg.png"]; //The image is no here, it doesn't matter.
	imgView.userInteractionEnabled = YES;
    imgView.backgroundColor = [UIColor whiteColor];
	self.view = imgView;
    [self readyInit];
	[self readyGo];
	isReload = YES;
}

/*
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 // Do any additional setup after loading the view, typically from a nib.
 }
 */

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [myDrawView release];
    myScreenRecorder.ParentID = nil;
    [myScreenRecorder release];
    [movieShow release];
    [super dealloc];
}


@end
