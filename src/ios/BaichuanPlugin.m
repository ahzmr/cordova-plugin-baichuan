//
//  BaichuanPlugin.m
//
//  Created by wenin819@gmail.com on 2017/1/7.
//
//

#import <Cordova/CDVInvokedUrlCommand.h>
#import "BaichuanPlugin.h"
#import "AlibabaAuthSDK.framework/Headers/ALBBSDK.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>

@implementation BaichuanPlugin

- (void)pluginInitialize {
    // 百川平台基础SDK初始化，加载并初始化各个业务能力插件
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        NSLog(@"Init success.");
    }                                            failure:^(NSError *error) {
        NSLog(@"Init failed: %@", error.description);
    }];

    // 开发阶段打开日志开关，方便排查错误信息
    //默认调试模式打开日志,release关闭,可以不调用下面的函数
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:NO];
}

- (AlibcTradeTaokeParams *)getTaokeParams:(NSDictionary *)taokeArgs {
    if (!taokeArgs) {
        return nil;
    }
    AlibcTradeTaokeParams *taoKeParams = [[AlibcTradeTaokeParams alloc] init];
    taoKeParams.pid = taokeArgs[@"pid"];
    taoKeParams.adzoneId = taokeArgs[@"adzoneId"];
    taoKeParams.subPid = taokeArgs[@"subPid"];
    taoKeParams.unionId = taokeArgs[@"unionId"];

    id key = taokeArgs[@"key"];
    if (key) {
        taoKeParams.extParams = @{@"key": key};
    }
    return taoKeParams;
}

- (void)auth:(CDVInvokedUrlCommand *)command {
    NSString *action = [command argumentAtIndex:0];
    ALBBSDK *albbsdk = [ALBBSDK sharedInstance];
    if([@"login" isEqualToString:action]) {
        [albbsdk auth:[self viewController] successCallback:^(ALBBSession *session) {
            [self returnSession:command];
        } failureCallback:^(ALBBSession *session, NSError *error) {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.description];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    } else if([@"getSession" isEqualToString:action]) {
        [self returnSession:command];
    } else if([@"logout" isEqualToString:action]) {
        [albbsdk logoutWithCallback:^() {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    } else {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid Action"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)returnSession:(CDVInvokedUrlCommand *)command {
    ALBBSession *session = [ALBBSession sharedInstance];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    BOOL login = [session isLogin];
    dict[@"login"] = @(login);
    if(login) {
        ALBBUser *user = [session getUser];
        dict[@"nick"] = user.nick;
        dict[@"avatarUrl"] = user.avatarUrl;
        dict[@"openId"] = user.openId;
        dict[@"openSid"] = user.openSid;
        dict[@"topAccessToken"] = user.topAccessToken;
        dict[@"topAuthCode"] = user.topAuthCode;
    }

    CDVPluginResult *pluginResult;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setting:(CDVInvokedUrlCommand *)command {
    if (command.arguments.count < 1) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"参数不正确"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    NSDictionary *settings = [command argumentAtIndex:0];
    int cnt = 0;
    for (NSString *key in settings) {
        if ([@"forceH5" isEqualToString:key]) {
            [[AlibcTradeSDK sharedInstance] setIsForceH5: [[settings valueForKey:key] boolValue]];
        } else if ([@"syncForTaoke" isEqualToString:key]) {
            [[AlibcTradeSDK sharedInstance] setIsSyncForTaoke: [[settings valueForKey:key] boolValue]];
        } else if ([@"taokeParams" isEqualToString:key]) {
            [[AlibcTradeSDK sharedInstance] setTaokeParams:[self getTaokeParams:[settings valueForKey:key]]];
        } else if ([@"channel" isEqualToString:key]) {
            NSArray *arr = [settings valueForKey:key];
            [[AlibcTradeSDK sharedInstance] setChannel:arr[0] name:arr[1]];
        } else if ([@"ISVCode" isEqualToString:key]) {
            [[AlibcTradeSDK sharedInstance] setISVCode:[settings valueForKey:key]];
        } else if ([@"ISVVersion" isEqualToString:key]) {
            [[AlibcTradeSDK sharedInstance] setIsvVersion:[settings valueForKey:key]];
        } else {
            continue;
        }
        cnt++;
    }
    CDVPluginResult *pluginResult;
    if (cnt > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"操作成功"];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"配置项不正确"];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)showPage:(CDVInvokedUrlCommand *)command {
    if (command.arguments.count < 1) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"参数不正确"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    NSDictionary *pageArgs = [command argumentAtIndex:0];
    NSDictionary *taokeArgs = [command argumentAtIndex:1 withDefault:nil];
    NSDictionary *showArgs = [command argumentAtIndex:2 withDefault:nil];
    NSDictionary *exArgs = [command argumentAtIndex:3 withDefault:nil];

    id <AlibcTradePage> page = nil;
    NSString *pageType = pageArgs[@"type"];
    if ([@"itemDetailPage" isEqualToString:pageType]) {
        //打开商品详情页
        page = [AlibcTradePageFactory itemDetailPage:pageArgs[@"itemId"]];
    } else if ([@"addCartPage" isEqualToString:pageType]) {
        //添加商品到购物车
        page = [AlibcTradePageFactory addCartPage:pageArgs[@"itemId"]];
    } else if ([@"page" isEqualToString:pageType]) {
        //根据链接打开页面
        page = [AlibcTradePageFactory page:pageArgs[@"url"]];
    } else if ([@"shopPage" isEqualToString:pageType]) {
        //打开店铺
        page = [AlibcTradePageFactory shopPage:pageArgs[@"shopId"]];
    } else if ([@"myOrdersPage" isEqualToString:pageType]) {
        //打开我的订单页
        int status = 0;
        if(pageArgs[@"status"]) {
            status = [pageArgs[@"status"] intValue];
        }
        page = [AlibcTradePageFactory myOrdersPage:status isAllOrder:!pageArgs[@"allOrder"] ? NO : YES];
    } else if ([@"myCartsPage" isEqualToString:pageType]) {
        //打开我的购物车
        page = [AlibcTradePageFactory myCartsPage];
    }

    //淘客信息
    AlibcTradeTaokeParams *taoKeParams = [self getTaokeParams:taokeArgs];
    //打开方式
    AlibcTradeShowParams *showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeAuto;
    if (showArgs) {
        NSString *type = showArgs[@"openType"];
        if ([@"H5" isEqualToString:type]) {
            showParam.openType = AlibcOpenTypeH5;
        } else if ([@"Native" isEqualToString:type]) {
            showParam.openType = AlibcOpenTypeNative;
        }

        for (NSString *key in showArgs) {
            if ([@"backUrl" isEqualToString:key]) {
                showParam.backUrl = [showArgs valueForKey:key];
            } else if ([@"isNeedPush" isEqualToString:key]) {
                showParam.isNeedPush = [[showArgs valueForKey:key] boolValue];
            } else if ([@"linkKey" isEqualToString:key]) {
                showParam.linkKey = [showArgs valueForKey:key];
            } else if ([@"nativeFailMode" isEqualToString:key]) {
                NSString *val = [showArgs valueForKey:key];
                if ([@"NONE" isEqualToString:val]) {
                    showParam.nativeFailMode = AlibcNativeFailModeNone;
                } else if ([@"JumpBROWER" isEqualToString:val]) {
                    showParam.nativeFailMode = AlibcNativeFailModeJumpBrowser;
                } else if ([@"JumpDOWNLOAD" isEqualToString:val]) {
                    showParam.nativeFailMode = AlibcNativeFailModeJumpDownloadPage;
                } else if ([@"JumpH5" isEqualToString:val]) {
                    showParam.nativeFailMode = AlibcNativeFailModeJumpH5;
                }
            }
        }
    }

    void (^success)(AlibcTradeResult *)=^(AlibcTradeResult *result) {
        CDVPluginResult *pluginResult = nil;
        switch (result.result) {
            case AlibcTradeResultTypeAddCard:
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"加购成功"];
                break;
            case AlibcTradeResultTypePaySuccess:;
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:@{
                        @"paySuccessOrders": result.payResult.paySuccessOrders,
                        @"payFailedOrders": result.payResult.payFailedOrders
                }];
                break;
            default:
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"操作成功"];
                break;
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    };
    [[AlibcTradeSDK sharedInstance].tradeService show:self.viewController page:page showParams:showParam
                                          taoKeParams:taoKeParams trackParam:exArgs tradeProcessSuccessCallback:success tradeProcessFailedCallback:^(NSError *error) {
                CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.description];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }];
}

@end
