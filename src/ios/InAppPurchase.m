//
//  InAppPurchase.h
//
//  Created by Youngjoo Park on 2013-09-03.
//
//  Copyright 2012 Youngjoo Park. All rights reserved.
//  MIT Licensed

#import "InAppPurchase.h"

@implementation InAppPurchase
@synthesize callbackId = _callbackId;
@synthesize inAppIds = _inAppIds;
@synthesize products = _products;

- (void)getInAppPurchaseDescription:(CDVInvokedUrlCommand *)command
{
    
    _callbackId = command.callbackId;
    _inAppIds = [command.arguments objectAtIndex:0];
    //Create a list of product identifiers
    
    NSSet *productSet =[NSSet setWithArray:_inAppIds];
    
    //Create and initialize a products request object with the above list
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productSet];
    
    //Attach the request to your delegate
    request.delegate = self;
    
    //Send the request to the App Store
    [request start];
}


- (void)buyProductId:(CDVInvokedUrlCommand *)command
{
    if (products != nil) {
    for (SKProduct *product in products)
    {
        if ([command.arguments objectAtIndex:0] ) {
            <#statements#>
        }
        [self buyProduct:];
    }
    }
    else
    {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_FAILED];
        [command.delegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)buyProduct:(SKProduct *)product
{
    if ([SKPaymentQueue canMakePayments]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }else {
        //    TO-DO : Alert to access CHECK In App Purchase
        
        
        
    }
}


#pragma mark - SKProductsRequest
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    //    SKProduct List
    
//    NSArray *productList = response.products;
//    NSArray *inValidProductList = response.invalidProductIdentifiers;
    
    
    _productIds = response.products;
    
//    [self.]
    if (response.invalidProductIdentifiers != nil) {
        
        
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:results];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];

}

#pragma mark - SKPayment
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
    
}
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    
}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    
}
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    
}


- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    //    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}


@end
