//
//  FRPPhoto.m
//  FRP Flickr
//
//  Created by Don Huff on 7/31/14.
//  Copyright (c) 2014 15 by 10, LLC. All rights reserved.
//

#import "FRPPhoto.h"


@implementation FRPPhoto

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"farm": @"farm",
             @"identifier": @"id",
             @"secret": @"secret",
             @"server": @"server",
             @"title": @"title"
             };
}

@end
