//
//  ViewController.m
//  ShareRECEasyDemo
//
//  Created by DonelAccount on 15/2/28.
//  Copyright (c) 2015年 Mob co.Ltd. All rights reserved.
//

#import "ViewController.h"
#import <ShareREC/ShareREC.h>
@interface ViewController ()
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;
@end

@implementation ViewController{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredFramesPerSecond = 60;
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
    
    UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [recordButton setTitle:@"开始录制" forState:UIControlStateNormal];
    [recordButton setTitle:@"结束录制" forState:UIControlStateSelected];
    [recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [recordButton addTarget:self action:@selector(recordButton:) forControlEvents:UIControlEventTouchUpInside];
    recordButton.frame = CGRectMake(10, 20, self.view.frame.size.width - 20, 45);
    [self.view addSubview:recordButton];

    
}
-(void)recordButton:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        //开始录制视频
        [ShareREC startRecording];
    }
    else
    {
        //结束录制视频
        [ShareREC stopRecording:^(NSError *error) {
            
            if (!error)
            {
                //结束后编辑视频
                [ShareREC editLastRecordingWithTitle:@"这是一个测试视频录像的Demo"
                                            userData:@{@"我的分数" : @"100"}
                                             onClose:nil];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:error.localizedDescription
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
            
            
        }];
    }

}

- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}
- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    _particleSystem = [[SRParticleSystem alloc] initWithParticleCount:10000 options:@{}];
    _particleSystem.particleRadius = 0.003;
    _particleSystem.startPos = GLKVector3Make(0, -0.5, -1);
    _particleSystem.endPos = GLKVector3Make(0, 0.5, -1);
    _particleSystem.startPosVariance = GLKVector3Make(0, 0, 0);
    _particleSystem.endPosVariance = GLKVector3Make(0.2, 0.2, 0.2);
    _particleSystem.particleColor = GLKVector4Make(1, 0.2, 0.5, 0.3);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
}


- (void)update
{
    
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.9f, 0.9f, 0.9f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    _particleSystem.modelviewProjectionMatrix = projectionMatrix;
    
    [_particleSystem draw];
}
@end
