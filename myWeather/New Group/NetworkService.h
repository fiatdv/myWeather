//
//  NetworkService.h
//  myWeather
//
//  Created by Felipe on 1/10/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NetworkService;

@protocol NetworkServiceDelegate <NSObject>

- (void)networkServiceDelegate:(NetworkService *)delegate didFinishRequestWithIdentifier:(NSString *)identifier data:(NSData *)data andError:(NSError *)error userInfo:(id)userInfo;

@end


@interface NetworkService : NSObject

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, weak) id<NetworkServiceDelegate>delegate;

- (void)makeGetRequestTo:(NSURL *)url withIdentifier:(NSString *)identifier withKey:(NSString *)key userInfo:(id)userInfo;

@end

NS_ASSUME_NONNULL_END
