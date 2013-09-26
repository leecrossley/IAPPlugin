//
//  IAPPlugin.m
//  HelloCordova
//
//  Created by onefm2 on 13. 9. 13..
//
//

#import "IAPPlugin.h"
#import "OFStoreManager.h"

@implementation IAPPlugin


- (void)productList:(CDVInvokedUrlCommand *)command
{
    if ([[OFStoreManager sharedManager] canMakePurchases])
    {
    
    [[OFStoreManager sharedManager] productIds:[command.arguments objectAtIndex:0]
                                  successBlock:^(NSArray *products, NSArray *invalidIdentifiers) {
                                      NSDictionary *productDic = @{@"products": products,@"invalidIdentifiers":invalidIdentifiers};
                                      
                                      [self.commandDelegate sendPluginResult:                                   [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:productDic]
                                                                  callbackId:command.callbackId];
                                  }
                                  failureBlock:^(NSError *error) {
                                      [[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] toErrorCallbackString:command.callbackId];
                                  }];
    }
    else {
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR]
                                    callbackId:command.callbackId];
    }
    
    
}

- (void)buyProduct:(CDVInvokedUrlCommand *)command
{
    
}

- (void)restore:(CDVInvokedUrlCommand *)command
{
    
}

@end
