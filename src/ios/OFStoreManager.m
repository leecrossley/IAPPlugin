//
//  OFStoreManager.m
//  HelloCordova
//
//  Created by onefm2 on 13. 9. 14..
//
//

#import "OFStoreManager.h"

@interface OFStoreHandler : NSObject <SKProductsRequestDelegate, SKRequestDelegate, SKPaymentTransactionObserver>
{
    SKPayment *payment;
    SKProduct *product;
    
}
@property (nonatomic, copy) OFStoreKitVerifySuccessBlock verifyBlock;
@property (nonatomic, copy) OFStoreKitFailureBlock failureBlock;
@property (nonatomic, copy) OFStoreKitProductListSuccessBlock productListBlock;
@property (nonatomic, assign) OFStoreManager *storeManager;

@end

@implementation OFStoreHandler
@synthesize verifyBlock = _verifyBlock;
@synthesize failureBlock = _failureBlock;
@synthesize productListBlock = _productListBlock;
@synthesize storeManager = _storeManager;


- (id)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}



#pragma mark - SKRequest Delegate
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    if (_failureBlock != nil)
    {
        _failureBlock(error);
    }
}

- (void)requestDidFinish:(SKRequest *)request
{
    [_storeManager performSelector:@selector(finishHandler) withObject:self];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    if (_productListBlock != nil) {
        if (_storeManager != nil)
        {
            [_storeManager.products addObjectsFromArray:response.products];
        }
        _productListBlock(response.products, response.invalidProductIdentifiers);

    }
}

@end


#pragma mark - 

@interface OFStoreManager ()

- (void)finishHandler:(OFStoreHandler *)handler;
@end

static OFStoreManager *sharedManager = nil;
@implementation OFStoreManager
@synthesize failureBlock = _failureBlock;
@synthesize productListSuccessBlock = _productListSuccessBlock;
@synthesize verifySuccessBlock = _verifySuccessBlock;
@synthesize products = _products;
@synthesize handlerQueue = _handlerQueue;


+ (OFStoreManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;

}

- (id)init
{
    if (self = [super init]) {
        _handlerQueue = [NSMutableSet set];
        _products = [NSMutableArray array];
    }
    

    
    return self;
}

- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

- (void)productIds:(NSArray *)pids
      successBlock:(OFStoreKitProductListSuccessBlock)successBlock
      failureBlock:(OFStoreKitFailureBlock)failureBlock
{
    NSSet *productIds = [NSSet setWithArray:pids];
    
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIds];
    
    _productListSuccessBlock = successBlock;
    _failureBlock = failureBlock;
    
    OFStoreHandler *productHandler = [[OFStoreHandler alloc] init];
    productHandler.productListBlock = successBlock;
    productHandler.failureBlock = failureBlock;
    productHandler.storeManager = self;
    [_handlerQueue addObject:productHandler];
    
    request.delegate = productHandler;
    
    [request start];
}

- (void)purchase:(NSString *)buyProductId
    successBlock:(OFStoreKitProductListSuccessBlock)successBlock
    failureBlock:(OFStoreKitFailureBlock)failureBlock
{
    
    for (SKProduct *product in _products)
    {
        if ([product.productIdentifier isEqualToString:buyProductId])
        {
            OFStoreHandler *buyHandler = [OFStoreHandler new];
            [[SKPaymentQueue defaultQueue] addTransactionObserver:buyHandler];

            SKPayment *payment = [SKPayment paymentWithProduct:product];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            
            [_handlerQueue addObject:buyHandler];
            break;
        }
    }
}


- (void)finishHandler:(OFStoreHandler *)handler
{
    [_handlerQueue removeObject:handler];
}


//- (void)paymentQueue: (SKPaymentQueue *)queue updatedTransactions: (NSArray *)transactions {
//    for (SKPaymentTransaction *transaction in transactions) {
//
//            switch (transaction.transactionState) {
//                case SKPaymentTransactionStatePurchased:
//                case SKPaymentTransactionStateRestored:
//                    if (self.delegate && [self.delegate respondsToSelector:@selector(transactionNeedsVerification:)]) {
//                        [self.delegate transactionNeedsVerification:transaction];
//                    }
//#ifdef __BLOCKS__
//                    else if (self.verifyBlock) {
//                        self.verifyBlock(transaction);
//                    }
//#endif
//                    else {
//                        [self finishTransaction:transaction wasSuccessful:YES];
//                    }
//                    break;
//                case SKPaymentTransactionStateFailed:
//                    [self finishTransaction:transaction wasSuccessful:NO];
//                    break;
//                case SKPaymentTransactionStatePurchasing:
//                default:
//                    break;
//            }
//            break;
//
//    }
//}

//-(void) transaction: (SKPaymentTransaction *)transaction
//        wasVerified: (BOOL)isValid {
//    [self finishTransaction:transaction wasSuccessful:isValid];
//}
//
//-(void) finishTransaction: (SKPaymentTransaction *)transaction
//            wasSuccessful: (BOOL)wasSuccessful {
//    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//    
//    if (wasSuccessful) {
//        if (transaction.transactionState == SKPaymentTransactionStateRestored) {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(transactionRestored:)]) {
//                [self.delegate transactionRestored:transaction];
//            }
//            else if (self.delegate && [self.delegate respondsToSelector:@selector(transactionSucceeded:)]) {
//                [self.delegate transactionSucceeded:transaction];
//            }
//#ifdef __BLOCKS__
//            else if (self.restoreBlock) {
//                self.restoreBlock(transaction);
//            }
//            else if (self.successBlock) {
//                self.successBlock(transaction);
//            }
//#endif
//        }
//        else {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(transactionSucceeded:)]) {
//                [self.delegate transactionSucceeded:transaction];
//            }
//#ifdef __BLOCKS__
//            else if (self.successBlock) {
//                self.successBlock(transaction);
//            }
//#endif
//        }
//    }
//    else {
//        if (transaction.error.code == SKErrorPaymentCancelled) {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(transactionCanceled:)]) {
//                [self.delegate transactionCanceled:transaction];
//            }
//            else if (self.delegate && [self.delegate respondsToSelector:@selector(transactionFailed:)]) {
//                [self.delegate transactionFailed:transaction];
//            }
//#ifdef __BLOCKS__
//            else if (self.cancelBlock) {
//                self.cancelBlock(transaction);
//            }
//            else if (self.failureBlock) {
//                self.failureBlock(transaction);
//            }
//#endif
//        }
//        else {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(transactionFailed:)]) {
//                [self.delegate transactionFailed:transaction];
//            }
//#ifdef __BLOCKS__
//            else if (self.failureBlock) {
//                self.failureBlock(transaction);
//            }
//#endif
//        }
//    }
//    
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
//    [self.storeKitManager transactionHandlerDidFinish:self];
//}

@end
