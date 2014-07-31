//
//  UIImage+FRP_Flickr.m
//  FRP Flickr
//
//  Created by Don Huff on 7/31/14.
//  Copyright (c) 2014 15 by 10, LLC. All rights reserved.
//

#import "UIImage+FRP_Flickr.h"

#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


@implementation UIImage (FRP_Flickr)

+ (RACSignal *)signalWithURL:(NSURL *)url
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        static id <AFURLResponseSerialization> serializer = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            serializer = [AFImageResponseSerializer serializer];
        });

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.responseSerializer = serializer;
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendError:error];
        }];
        
        [op start];
        
        @weakify(op);
        
        return [RACDisposable disposableWithBlock:^{
            @strongify(op);
            [op cancel];
        }];
    }];
}

@end
