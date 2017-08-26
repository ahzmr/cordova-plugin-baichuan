//
//  BaichuanPlugin.h
//
//  Created by wenin819@gmail.com on 2017/1/7.
//
//

#import <Cordova/CDVPlugin.h>

@interface BaichuanPlugin : CDVPlugin

- (void)pluginInitialize;
- (void)setting:(CDVInvokedUrlCommand *)command;
- (void)showPage:(CDVInvokedUrlCommand*)command;

@end
