//
//  OFStoreManager.h
//  HelloCordova
//
//  Created by onefm2 on 13. 9. 14..
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface OFStoreManager : NSObject

typedef void (^OFStoreKitProductListSuccessBlock)(NSArray *products, NSArray *invalidIdentifiers);
typedef void (^OFStoreKitVerifySuccessBlock)(void);
typedef void (^OFStoreKitFailureBlock)(NSError *error);

@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, copy) OFStoreKitProductListSuccessBlock productListSuccessBlock;
@property (nonatomic, copy) OFStoreKitVerifySuccessBlock verifySuccessBlock;
@property (nonatomic, copy) OFStoreKitFailureBlock failureBlock;
@property (nonatomic, strong) NSMutableSet *handlerQueue;

+ (OFStoreManager *)sharedManager;
- (BOOL)canMakePurchases;
- (void)productIds:(NSArray *)pids
      successBlock:(OFStoreKitProductListSuccessBlock)successBlock
      failureBlock:(OFStoreKitFailureBlock)failureBlock;

- (void)purchase:(NSString *)buyProductId
      successBlock:(OFStoreKitProductListSuccessBlock)successBlock
      failureBlock:(OFStoreKitFailureBlock)failureBlock;

@end
