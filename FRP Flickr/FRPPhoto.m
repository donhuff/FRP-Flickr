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

- (NSURL *)url
{
    NSString *s = [NSString stringWithFormat:@"https://farm%d.staticflickr.com/%@/%@_%@.jpg", self.farm, self.server, self.identifier, self.secret];
    return [NSURL URLWithString:s];
}

- (NSURL *)urlForThumbnail
{
    NSString *s = [NSString stringWithFormat:@"https://farm%d.staticflickr.com/%@/%@_%@_t.jpg", self.farm, self.server, self.identifier, self.secret];
    return [NSURL URLWithString:s];
}

@end
