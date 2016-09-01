//
//  ViewController.m
//  MediaPlayerController
//
//  Created by kinglonghuang on 1/22/14.
//  Copyright (c) 2014 Shenzhen Coship Electronics Co.,ltd. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) MediaPlayerController * mediaPlayerController;

@end

@implementation ViewController

#pragma mark - Private

- (void)testVodPlayer {
    NSString * urlStr = @"http://7xawdc.com2.z0.glb.qiniucdn.com/o_19p6vdmi9148s16fs1ptehbm1vd59.mp4";
    NSURL * contentURL = [NSURL URLWithString:urlStr];
    MediaResource * mediaResource = [[MediaResource alloc] init];
    mediaResource.type = MediaResourceType_Vod;
    mediaResource.url = contentURL;
    
    self.mediaPlayerController = [[MediaPlayerController alloc] initWithMediaResource:mediaResource];
    [self.mediaPlayerController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    [self.mediaPlayerController setControlStyle:MPMovieControlStyleEmbedded];
    [self.mediaPlayerController setDelegate:self];
    self.mediaPlayerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.mediaPlayerController.view];
    [self.mediaPlayerController play];
    
    
    MPVolumeView * airplayBtn = [[MPVolumeView alloc] init];
    airplayBtn.frame = CGRectMake(250, 150, 40, 40);
    airplayBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleLeftMargin;
    [airplayBtn routeButtonRectForBounds:CGRectMake(0, 0, 30, 30)];
    airplayBtn.showsRouteButton = YES;
    [airplayBtn becomeFirstResponder];
    [airplayBtn setShowsVolumeSlider:NO];
    [self.view addSubview:airplayBtn];
    for (UIButton *button in airplayBtn.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            UIButton * airplayButton = button; // @property retain
//            [airplayButton setImage:[UIImage imageNamed:@"airplay.png"] forState:UIControlStateNormal];
            [airplayButton setBackgroundColor:[UIColor clearColor]];
            [airplayButton setBounds:CGRectMake(0, 0, 30, 30)];
//            [airplayButton addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    
//    MPVolumeView *volumeView = [ [MPVolumeView alloc] init] ;
//    [self.view addSubview:volumeView];
//    　如果不需要
    
//    MPVolumeView *volumeView = [ [MPVolumeView alloc] init] ;
//    [volumeView setShowsVolumeSlider:NO];
//    [volumeView sizeToFit];
//    [self.view addSubview:volumeView];
    
//    NSNetService*publish=[[NSNetService alloc]initWithDomain:@"local."type:@"_airplay._tcp."name:@"Jacob"port:56486];
//    NSDictionary*txtRecordDic=[NSDictionary dictionaryWithObjectsAndKeys:
//                               @"9f6fa29571b137ffb1c42d88aa8eb2becc8755f9", @"deviceid",
//                               nil];
//    NSData*txtRecordData =nil;
//    if(txtRecordDic)
//        txtRecordData = [NSNetService dataFromTXTRecordDictionary:txtRecordDic];
//    [publish setTXTRecordData:txtRecordData];//very Important
//    [publish publish];
    
}

- (void)testTVLivePlayer {
    //Lingmin's
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self testVodPlayer];
    [self testTVLivePlayer];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"111");
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"222");
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return NO;
}
- (BOOL)shouldAutorotate {
    
    return NO;
    
}


#pragma mark - MediaPlayerControllerDelegate

- (void)mediaPlayerControllerAskForEnterFullScreen:(MediaPlayerController *)playerController {
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
    [UIView animateWithDuration:.4 animations:^{
        [self.view setTransform:CGAffineTransformMakeRotation(-1*M_PI/2)];
        [self.view setFrame:[UIScreen mainScreen].bounds];
        [self.mediaPlayerController.view setFrame:self.view.bounds];
        [playerController setControlStyle:MPMovieControlStyleFullscreen];
    } completion:^(BOOL finished) {
    }];
}

- (void)mediaPlayerControllerAskForExitFullScreen:(MediaPlayerController *)playerController {
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    [UIView animateWithDuration:.4 animations:^{
        [self.view setTransform:CGAffineTransformIdentity];
        [self.view setFrame:[UIScreen mainScreen].bounds];
        [self.mediaPlayerController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
        [playerController setControlStyle:MPMovieControlStyleEmbedded];
    } completion:^(BOOL finished) {
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
