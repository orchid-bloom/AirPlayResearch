//
//  ShareRecSocial.h
//  ShareRecSocial
//
//  Created by vimfung on 14-10-22.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 社区页面类型
 */
typedef enum
{
    ShareRECSocialPageTypeShare = 0,            //分享
    ShareRECSocialPageTypeVideoCenter = 1,      //视频中心
    ShareRECSocialPageTypeProfile = 2           //个人中心
}
ShareRECSocialPageType;

/**
 *  游戏视频录像社区
 */
@interface ShareRECSocial : NSObject

/**
 *  打开社区
 *
 *  @param title        分享视频标题
 *  @param userData     分享视频的用户数据
 *  @param pageType     社区页面类型
 *  @param closeHandler 关闭事件
 */
+ (void)openByTitle:(NSString *)title
           userData:(NSDictionary *)userData
           pageType:(ShareRECSocialPageType)pageType
            onClose:(void(^)())closeHandler;

@end
