//
//  InAppPurchase.h
//
//  Created by Youngjoo Park on 2013-09-03.
//
//  Copyright 2012 Youngjoo Park. All rights reserved.
//  MIT Licensed

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <StoreKit/StoreKit.h>

@interface InAppPurchase : CDVPlugin <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
        
}

@property (nonatomic, copy) NSString *callbackId;
@property (nonatomic, retain) NSArray* inAppIds;
@property (nonatomic, retain) NSArray* products;



- (void)getInAppPurchaseDescription:(CDVInvokedUrlCommand *)command;

@end