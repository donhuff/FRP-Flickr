//
//  FRPPhotos.m
//  FRP Flickr
//
//  Created by Don Huff on 7/31/14.
//  Copyright (c) 2014 15 by 10, LLC. All rights reserved.
//

#import "FRPPhotos.h"

#import "FRPPhoto.h"


@implementation FRPPhotos

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"page": @"photos.page",
             @"pages": @"photos.pages",
             @"perpage": @"photos.perpage",
             @"photos": @"photos.photo",
             @"total": @"photos.total"
             };
}

+ (NSValueTransformer *)photosJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:FRPPhoto.class];
}

@end
