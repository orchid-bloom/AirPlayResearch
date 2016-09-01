//
//  DSSViewController.m
//  AirplayTest
//
//  Created by dasmer on 2/4/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "DSSViewController.h"
#import "UIView+DSSCustomSizedMethods.h"
#import "DSSAnimalExternalView.h"

@interface DSSViewController ()

@property (nonatomic, strong) UIWindow *mirroredWindow;
@property (nonatomic, strong) UIScreen *mirroredScreen;
@property (nonatomic, strong) DSSAnimalExternalView *mirroredScreenView;

@end

@implementation DSSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupOutputScreen];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - AirPlay and extended display

- (void)setupOutputScreen
{
    // Register for screen notifications
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(screenDidConnect:) name:UIScreenDidConnectNotification object:nil];
    [center addObserver:self selector:@selector(screenDidDisconnect:) name:UIScreenDidDisconnectNotification object:nil];
    [center addObserver:self selector:@selector(screenModeDidChange:) name:UIScreenModeDidChangeNotification object:nil];
    
    // Setup screen mirroring for an existing screen
    NSArray *connectedScreens = [UIScreen screens];
    if ([connectedScreens count] > 1) {
        UIScreen *mainScreen = [UIScreen mainScreen];//the screen object representing the device’s screen.
        for (UIScreen *aScreen in connectedScreens) {
            if (aScreen != mainScreen) {
                // We've found an external screen !
                NSLog(@"We found an external screen on load");
                [self setupMirroringForScreen:aScreen];
                break;
            }
        }
    }
}

- (void)screenDidConnect:(NSNotification *)aNotification
{
    NSLog(@"A new screen got connected: %@", [aNotification object]);
    [self setupMirroringForScreen:[aNotification object]];
}

- (void)screenDidDisconnect:(NSNotification *)aNotification
{
    NSLog(@"A screen got disconnected: %@", [aNotification object]);
    [self disableMirroringOnCurrentScreen];
}

- (void)screenModeDidChange:(NSNotification *)aNotification
{
    NSLog(@"A screen mode changed: %@", [aNotification object]);
    [self disableMirroringOnCurrentScreen];
    [self setupMirroringForScreen:[aNotification object]];
}

- (void)setupMirroringForScreen:(UIScreen *)anExternalScreen
{
    self.mirroredScreen = anExternalScreen;
    // Find max resolution
    CGSize max = {0, 0};
    UIScreenMode *maxScreenMode = nil;
    
    for (UIScreenMode *current in self.mirroredScreen.availableModes) {
        if (maxScreenMode == nil || current.size.height > max.height || current.size.width > max.width) {
            max = current.size;
            maxScreenMode = current;
        }
    }
    self.mirroredScreen.currentMode = maxScreenMode;
    // Setup window in external screen
    self.mirroredWindow = [[UIWindow alloc] initWithFrame:self.mirroredScreen.bounds];
    self.mirroredWindow.hidden = NO;
    self.mirroredWindow.layer.contentsGravity = kCAGravityResizeAspect;
    self.mirroredWindow.screen = self.mirroredScreen;
    self.mirroredScreenView = [[DSSAnimalExternalView alloc] initWithFrame:self.mirroredScreen.bounds];
    [self.mirroredWindow addSubview:self.mirroredScreenView];
}

- (void)disableMirroringOnCurrentScreen
{
    [self.mirroredScreenView removeFromSuperview];
    self.mirroredScreenView = nil;
    self.mirroredScreen = nil;
    self.mirroredWindow = nil;
}


#pragma mark - IBActions
- (IBAction)dogClicked:(id)sender {
    [self.mirroredScreenView showDog];
}
- (IBAction)catClicked:(id)sender {
    [self.mirroredScreenView showCat];
}
- (IBAction)fishClicked:(id)sender {
    [self.mirroredScreenView showFish];
}



@end
