//
//  YLPClient+Business.m
//  Pods
//
//  Created by David Chen on 1/4/16.
//
//

#import "YLPClient+Business.h"
#import "YLPBusiness.h"
#import "YLPClientPrivate.h"
#import "YLPResponsePrivate.h"
#import "TFHpple.h"

#define LINK_PATH @"//*[@id='wrap']/div[2]/div/div[1]/div/div[4]/div[1]/div/div[2]/ul/li[4]/span[2]/a"
#define BUSINESS_INFO_PATH @"//*[@id='super-container']/div/div/div[2]/div[2]/div[2]/ul/li/div"

@implementation YLPClient (Business)

- (NSURLRequest *)businessRequestWithId:(NSString *)businessId {
    NSString *businessPath = [@"/v3/businesses/" stringByAppendingString:businessId];
    return [self requestWithPath:businessPath];
}

- (void)businessWithId:(NSString *)businessId
     completionHandler:(void (^)(YLPBusiness *business, NSError *error))completionHandler {
    NSURLRequest *req = [self businessRequestWithId:businessId];
    [self queryWithRequest:req completionHandler:^(NSDictionary *responseDict, NSError *error) {
        if (error) {
            completionHandler(nil, error);
        } else {
            YLPBusiness *business = [[YLPBusiness alloc] initWithDictionary:responseDict];
            completionHandler(business, nil);
        }
    }];
}

- (void)retrieveBusinessURLFromLink:(NSString *)link completion:(YLPBusinessURLCompletionHandler)completionHandler {
    NSURL *URL = [NSURL URLWithString:link];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
            TFHppleElement *e = [doc peekAtSearchWithXPathQuery:LINK_PATH];
            completionHandler(e.text, error);
            NSLog(@"[raw: %@], [content: %@], [tag: %@], [text: %@]", e.raw, e.content, e.tagName, e.text);
        } else {
            completionHandler(nil, error);
        }
    }];
    
    [task resume];
}

@end
