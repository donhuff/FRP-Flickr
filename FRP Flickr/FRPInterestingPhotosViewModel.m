//
//  FRPInterestingPhotosViewModel.m
//  FRP Flickr
//
//  Created by Don Huff on 7/31/14.
//  Copyright (c) 2014 15 by 10, LLC. All rights reserved.
//

#import "FRPInterestingPhotosViewModel.h"

#import <AFNetworking/AFNetworking.h>
#import "FRPPhotos.h"
#import <Mantle/Mantle.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface FRPInterestingPhotosViewModel ()

@property (nonatomic) NSArray *photos;

@end


@implementation FRPInterestingPhotosViewModel

@synthesize refresh = _refresh;

#pragma mark - Private

- (RACCommand *)refresh
{
    if (_refresh) {
        return _refresh;
    }
    
    @weakify(self);
    
    _refresh = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{
                                         @"api_key": @"1e4a3d853b02cf5f9c19bc76294ddef7",
                                         @"format": @"json",
                                         @"method": @"flickr.interestingness.getList",
                                         @"nojsoncallback": @"1"
                                         };
            
            AFHTTPRequestOperation *op = [manager GET:@"https://api.flickr.com/services/rest/"
                                           parameters:parameters
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  NSError *error = nil;
                                                  FRPPhotos *photos = [MTLJSONAdapter modelOfClass:FRPPhotos.class
                                                                                fromJSONDictionary:responseObject
                                                                                             error:&error];
                                                  
                                                  if (error) {
                                                      [subscriber sendError:error];
                                                      return;
                                                  }
                                                  
                                                  @strongify(self);
                                                  self.photos = photos.photos;

                                                  [subscriber sendCompleted];
                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  [subscriber sendError:error];
                                              }];
            
            @weakify(op);
            
            return [RACDisposable disposableWithBlock:^{
                @strongify(op);
                [op cancel];
            }];
        }];
        
    }];
    
    return _refresh;
}

@end
