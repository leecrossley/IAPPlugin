//
//  InAppPurchase.h
//
//  Created by Youngjoo Park on 2013-09-03.
//
//  Copyright 2012 Youngjoo Park. All rights reserved.
//  MIT Licensed

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface InAppPurchase : CDVPlugin {
        
}

@property (nonatomic, copy) NSString *callbackId;
@property (nonatomic, retain) NSMutableArray* inAppIds;


- (void)getInAppPurchaseDescription:(CDVInvokedUrlCommand *)command;

@end