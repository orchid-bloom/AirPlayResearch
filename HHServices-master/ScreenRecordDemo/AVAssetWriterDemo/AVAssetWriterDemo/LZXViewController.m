//
//  LZXAppDelegate.h
//  AVAssetWriterDemo
//
//  Created by 白冰 on 13-7-17.
//  Copyright (c) 2013年 . All rights reserved.
//

#import "LZXViewController.h"


@implementation LZXViewController
{
    NSMutableArray  *imageArr;
    UIWebView       *movieShow;
    NSTimer         * timer;
    BOOL            isVideo;
}

-(void) viewDidLoad
{
    isVideo = YES;
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setFrame:CGRectMake(100, 0, 150, 50)];
    [button1 setTitle:@"start recording" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(testCompressionSession) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setFrame:CGRectMake(600, 0, 150, 50)];
    [button2 setTitle:@"show Video" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(movieShow:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 setFrame:CGRectMake(300, 0, 150, 50)];
    [button3 setTitle:@"stop recording" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button1];
    [self.view addSubview:button2];
    [self.view addSubview:button3];
    UIButton *numBut1 =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [numBut1 setFrame:CGRectMake(300, 400, 100, 50)];
    [numBut1 setTitle:@"1" forState:UIControlStateNormal];
    
    UIButton *numBut2 =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [numBut2 setFrame:CGRectMake(450, 400, 100, 50)];
    [numBut2 setTitle:@"2" forState:UIControlStateNormal];
    
    UIButton *numBut3 =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [numBut3 setFrame:CGRectMake(600, 400, 100, 50)];
    [numBut3 setTitle:@"3" forState:UIControlStateNormal];
    
    UIButton *numBut4 =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [numBut4 setFrame:CGRectMake(300, 500, 100, 50)];
    [numBut4 setTitle:@"4" forState:UIControlStateNormal];
    
    UIButton *numBut5 =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [numBut5 setFrame:CGRectMake(450, 500, 100, 50)];
    [numBut5 setTitle:@"5" forState:UIControlStateNormal];
    
    UIButton *numBut6 =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [numBut6 setFrame:CGRectMake(600, 500, 100, 50)];
    [numBut6 setTitle:@"6" forState:UIControlStateNormal];
    
    UITextField * text = [[UITextField alloc] initWithFrame:CGRectMake(100, 300, 600, 100)];
    text.backgroundColor = [UIColor redColor];
    [self.view addSubview:text];
    [self.view addSubview:numBut1];
    [self.view addSubview:numBut2];
    [self.view addSubview:numBut3];
    [self.view addSubview:numBut4];
    [self.view addSubview:numBut5];
    [self.view addSubview:numBut6];
}

-(void)stop
{
    if ([timer isValid] == YES) {
        [timer invalidate];
        timer = nil;
        isVideo = NO;
        return;
    }

}

-(void)addImageData
{
    timer = [[NSTimer alloc] initWithFireDate:[NSDate new] interval:0.09 target:self selector:@selector(getImageDataTimer:) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];    
    
}

-(void)getImageDataTimer:(NSTimer *)timer
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    [imageArr addObject:image];
    
//    NSData *  imageData = UIImagePNGRepresentation(image);
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *aPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",rand()%100]];
//    
//    [imageData writeToFile:aPath atomically:YES];
    
    UIGraphicsEndImageContext();
}

-(IBAction)movieShow:(id)sender
{
    movieShow = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, 768, 900)];
    [movieShow setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:movieShow];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *moviePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",@"test"]];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[moviePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [movieShow loadRequest:request];

}

- (CVPixelBufferRef )pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32ARGB, (CFDictionaryRef) options, &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, 4*size.width, rgbColorSpace, kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

- (IBAction)testCompressionSession
{
    if ([imageArr count] == 0 && isVideo == YES) {
        imageArr = [[NSMutableArray alloc] initWithObjects:nil];
        
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self                                                                           selector:@selector(addImageData) object:nil];
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [queue addOperation:operation];
        [NSThread sleepForTimeInterval:0.1];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *moviePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",@"test"]];
        CGSize size = CGSizeMake(1024 ,768);
        NSError *error = nil;
        
        unlink([moviePath UTF8String]);
        AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:moviePath]
                                                               fileType:AVFileTypeQuickTimeMovie
                                                                  error:&error];
        NSParameterAssert(videoWriter);
        if(error)
            NSLog(@"error = %@", [error localizedDescription]);
        
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey,
                                       [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                       [NSNumber numberWithInt:size.height], AVVideoHeightKey, nil];
        AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
        NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
        AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                         assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
        NSParameterAssert(writerInput);
        NSParameterAssert([videoWriter canAddInput:writerInput]);
        
        if ([videoWriter canAddInput:writerInput])
            NSLog(@"ok");
        else
            NSLog(@"……");
        
        [videoWriter addInput:writerInput];
        
        [videoWriter startWriting];
        [videoWriter startSessionAtSourceTime:kCMTimeZero];
        
        dispatch_queue_t dispatchQueue = dispatch_queue_create("mediaInputQueue", NULL);
        int __block frame = 0;
        
        [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
            NSLog(@"wrierInput is->>>>>>>>>%i",[writerInput isReadyForMoreMediaData]);
            while ([writerInput isReadyForMoreMediaData])
            {
                NSLog(@"imageArr->%d,isVieo ---->%i",[imageArr count],isVideo);
                if([imageArr count] == 0&&isVideo == NO)
                {
                        isVideo = YES;
                        [writerInput markAsFinished];
                        [videoWriter finishWritingWithCompletionHandler:^{}];
                        [videoWriter release];
                        [operation release];
                        [queue release];
                        break;
                }
                if ([imageArr count] == 0&&isVideo == YES) {
                }
                else
                {
                    CVPixelBufferRef buffer = NULL;
                    buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:[[imageArr objectAtIndex:0] CGImage] size:size];
                    if (++frame%10 == 0) {
                        [imageArr removeObjectAtIndex:0];
                    }
                    if (buffer)
                    {
                        if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame, 120)])
                            NSLog(@"FAIL");
                        else{
                            NSLog(@"doing……");
                            CFRelease(buffer);
                        }
                    }
                }
                
                
            }
        }];
    }
}
-(void)readVideo
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",@"test"]];
    NSLog(@"path0---------------------->%@",path);
    AVAsset *avAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:path] options:nil];
    NSError *error = nil;
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:avAsset error:&error];
    NSArray *videoTracks = [avAsset tracksWithMediaType:AVMediaTypeVideo];
    NSLog(@"reader---->%@,video---->%@",reader,videoTracks);
    AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    AVAssetReaderTrackOutput *asset_reader_output = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:options];
    [reader addOutput:asset_reader_output];
    [reader startReading];
    CMSampleBufferRef buffer;
    while ( [reader status]==AVAssetReaderStatusReading ){
        buffer = [asset_reader_output copyNextSampleBuffer];
        NSLog(@"READING");
    }
}
@end
