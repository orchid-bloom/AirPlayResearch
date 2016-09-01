//
//  AppDelegate.m
//  ShareRECEasyDemo
//
//  Created by DonelAccount on 15/2/28.
//  Copyright (c) 2015年 Mob co.Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import <OpenGLES/ES2/glext.h>
#import <ShareREC/ShareREC.h>
#import <ShareRECSocial/ShareRECSocial.h>
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import "WXApi.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化ShareREC
    [ShareREC registerApp:@"76684bc49b3"];
    
    //初始化ShareSDK
    [ShareSDK registerApp:@"5577ff992136"];
    
    //连接目前支持分享的平台
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243" appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3" redirectUri:@"http://www.sharesdk.cn" weiboSDKCls:[WeiboSDK class]];
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" appSecret:@"64020361b8ec4c99936c0e3999a9f249" wechatCls:[WXApi class]];
    [ShareSDK connectFacebookWithAppKey:@"107704292745179" appSecret:@"38053202e1a5fe26c80c753071f0b573"];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
