//
//  ShareRec.h
//  ShareRec
//
//  Created by vimfung on 14-11-13.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  游戏录像SDK
 */
@interface ShareREC : NSObject

/**
 *	@brief	注册应用
 *
 *	@param 	appKey 	应用标识
 */
+ (void)registerApp:(NSString *)appKey;

/**
 *	@brief	开始录制视频
 */
+ (void)startRecording;

/**
 *	@brief	结束录制视频
 *
 *  @param  finishedHandler 完成事件处理
 */
+ (void)stopRecording:(void(^)(NSError *error))finishedHandler;

/**
 *	@brief	播放最后录制的视频
 */
+ (void)playLastRecording;

/**
 *  设置码率（单位bps），默认为2Mbps = 2 * 1024 * 1024
 *
 *  @param bitRate 码率
 */
+ (void)setBitRate:(NSInteger)bitRate;

/**
 *  设置帧率，默认为30fps
 *
 *  @param fps 帧率
 */
+ (void)setFPS:(NSInteger)fps;

/**
 *  设置最短的视频录制时间，如果小于这个时间在调用stopRecording方法时会录制失败，默认为4秒
 *
 *  @param  time   时间（单位：秒）
 */
+ (void)setMinimumRecordingTime:(NSTimeInterval)time;

/**
 *  编辑最后录制的视频
 *
 *  @param title        标题
 *  @param userData     用户数据
 *  @param closeHandler 关闭事件
 */
+ (void)editLastRecordingWithTitle:(NSString *)title
                          userData:(NSDictionary *)userData
                           onClose:(void(^)())closeHandler;

/**
 *  获取最后录制视频路径
 *
 *  @return 视频路径
 */
+ (NSString *)lastRecordingPath;


/**
 *	@brief	同步音频解说, 在录制过程中是否同步录制麦克风声音。默认为NO
 *
 *	@param 	syncAudioComment 	YES 表示录制视频同时录入麦克风声音，NO 表示录制视频时不录入麦克风声音
 */
+ (void)setSyncAudioComment:(BOOL)syncAudioComment;


@end
