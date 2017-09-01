//
//  AppDelegate+Baichuan.m
//
//  Created by wenin819 on 17/3/26.
//

#import "AppDelegate.h"
#import "AppDelegate+Baichuan.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>

@implementation AppDelegate (Baichuan)

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"=== openURL: %@, sourceApplication: %@", url, sourceApplication);
    // 新接口写法
    if (![[AlibcTradeSDK sharedInstance] application:application
                                             openURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation]) {
        // all plugins will get the notification, and their handlers will be called
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];

        // 处理其他app跳转到自己的app
    }
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    NSLog(@"=== openURL: %@, options: %@", url, options);
    // 新接口写法
    if (![[AlibcTradeSDK sharedInstance] application:app
                                             openURL:url
                                             options:options]) {
        // all plugins will get the notification, and their handlers will be called
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];

        //处理其他app跳转到自己的app，如果百川处理过会返回YES
    }
    return YES;
}

@end
