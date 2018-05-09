//
//  Business.h
//  Pods
//
//  Created by David Chen on 1/5/16.
//
//

#import <Foundation/Foundation.h>

@class YLPLocation;
@class YLPCategory;

typedef NS_ENUM(NSUInteger, YLPBusinessAttribute) {
    YLPBusinessAttrDelivery,
    YLPBusinessAttrPickup
};

NS_ASSUME_NONNULL_BEGIN

@interface YLPBusiness : NSObject

@property (nonatomic, getter=isClosed, readonly) BOOL closed;

@property (nonatomic, readonly, nullable, copy) NSURL *imageURL;
@property (nonatomic, readonly, copy) NSURL *URL;

@property (nonatomic, readonly) double rating;
@property (nonatomic, readonly) NSUInteger reviewCount;

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, nullable, copy) NSString *phone;
@property (nonatomic, readonly, copy) NSString *identifier;
@property (nonatomic, readonly, nullable, copy) NSString *price;
@property (nonatomic, readonly, copy) NSString *transactions;

@property (nonatomic, readonly, copy) NSArray<YLPCategory *> *categories;

@property (nonatomic, readonly) YLPLocation *location;

@end

NS_ASSUME_NONNULL_END
