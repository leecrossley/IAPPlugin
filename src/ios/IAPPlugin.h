//
//  IAPPlugin.h
//  HelloCordova
//
//  Created by onefm2 on 13. 9. 13..
//
//

#import <Cordova/CDV.h>

@interface IAPPlugin : CDVPlugin

- (void)productList:(CDVInvokedUrlCommand *)command;

- (void)buyProduct:(CDVInvokedUrlCommand *)command;

- (void)restore:(CDVInvokedUrlCommand *)command;


@end
