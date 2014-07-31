//
//  UIImage+FRP_Flickr.h
//  FRP Flickr
//
//  Created by Don Huff on 7/31/14.
//  Copyright (c) 2014 15 by 10, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;


@interface UIImage (FRP_Flickr)

+ (RACSignal *)signalWithURL:(NSURL *)url;

@end
