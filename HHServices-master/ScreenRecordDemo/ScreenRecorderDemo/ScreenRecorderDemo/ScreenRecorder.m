//
//  LZXAppDelegate.m
//  ScreenRecorderDemo
//
//  Created by 白冰 on 13-7-25.
//  Copyright (c) 2013年 . All rights reserved.
//

#import "ScreenRecorder.h"


#define recordFPS 1.0f/11.0f 
#define frameBuffer 10 
#define MainFrame [[UIScreen mainScreen] applicationFrame]
#define MainFrameLandscape CGRectMake(0.0f, 0.0f, MainFrame.size.height, MainFrame.size.width)

@interface ScreenRecorder ()

-(void)readyInit;

@end

@implementation ScreenRecorder

@synthesize ParentID;

- (id)init
{
	if (self = [super init])
	{
        isVideo = YES;
		[self readyInit];
	}
	return self;
}


-(CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size
{
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, targetView.frame.size.width, targetView.frame.size.height, kCVPixelFormatType_32ARGB, (CFDictionaryRef) options, &pxbuffer);
    
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

-(void)captureImage
{
    //ps. We should use NSAutoreleasePool inside the block
    //otherwise it will be out of memory
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLock *aLock = [NSLock new];
    [aLock lock];
    
    UIGraphicsBeginImageContext(targetView.bounds.size);
    [targetView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    [imageArr addObject:image];
    UIGraphicsEndImageContext();
    
    [aLock unlock];
    [aLock release];
    [pool release];
}

-(void)stopRecord
{
    printf("stop is called\n");
    isVideo = NO;
}

-(void)startRecord:(NSString *)moviePath
{
    if([[NSFileManager defaultManager] fileExistsAtPath:moviePath])
    {
        //remove the old one
        [[NSFileManager defaultManager] removeItemAtPath:moviePath error:nil];
    }
    
    //for clearing all image
    [imageArr removeAllObjects];
    
    if ([imageArr count] == 0 && isVideo == YES)
    {
        NSLog(@"startRecord targetView frame %@", NSStringFromCGRect(targetView.frame));
        
        CGSize size = targetView.frame.size;
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
        
        startTime = CFAbsoluteTimeGetCurrent();
        
        [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
            printf("writerInput is->>>>>>>>>%i\n",[writerInput isReadyForMoreMediaData]);
            CVPixelBufferRef buffer = NULL;
            while ([writerInput isReadyForMoreMediaData])
            {
                printf("imageArr->%d,isVideo ---->%i ", [imageArr count], isVideo);
                if([imageArr count] == 0 && isVideo == NO)
                {
                    isVideo = YES;
                    [writerInput markAsFinished];
                    //[videoWriter finishWriting];
                    [videoWriter finishWritingWithCompletionHandler:^{
                        if ([ParentID respondsToSelector:@selector(recordCompleted)])
                        {
                            [ParentID performSelectorOnMainThread:@selector(recordCompleted) withObject:nil waitUntilDone:YES];
                        }
                    }];
                    [videoWriter release];
                    
                    if (buffer)
                    {
                        CFRelease(buffer);
                        buffer = NULL;
                    }
                    
                    break;
                }
                if ([imageArr count] == 0 && isVideo == YES)
                {
                    [self captureImage];
                }
                else
                {
                    if (buffer==NULL)
                    {
                        buffer = [self pixelBufferFromCGImage:[[imageArr objectAtIndex:0] CGImage] size:size];
                    }
                    
                    if (buffer)
                    {
                        CFAbsoluteTime interval = (CFAbsoluteTimeGetCurrent() - startTime) * 1000;
                        CMTime currentSampleTime = CMTimeMake((int)interval, 1000);
                        
                        //if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame, 25)])
                        if(![adaptor appendPixelBuffer:buffer withPresentationTime:currentSampleTime])
                            printf("FAIL");
                        else
                        {
                            ++frame;
                            [imageArr removeObjectAtIndex:0];
                            
                            printf("removing buffer……");
                            CFRelease(buffer);
                            buffer = NULL;
                        }
                    }
                    
                }
                printf("total frame %d\n", frame);
            }
        }];
    }
}

-(void)readyGo:(UIView *)aView
{
    targetView = aView;
    
    //for speeding up the process, we don't want to preset it every time in the pixelBufferFromCGImage function
    options = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
               [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    [options retain];
}

-(void)readyInit
{
    imageArr = [[NSMutableArray alloc] init];
}

-(void)dealloc
{
	printf("dealloc in %s\n", [[[self class] description] UTF8String]);
    [imageArr release];
    [options release];
	[super dealloc];
}


@end
