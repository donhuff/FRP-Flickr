//
//  FRPPhoto.h
//  FRP Flickr
//
//  Created by Don Huff on 7/31/14.
//  Copyright (c) 2014 15 by 10, LLC. All rights reserved.
//

#import <Mantle/Mantle.h>


@interface FRPPhoto : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign, readonly) NSInteger farm;
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *secret;
@property (nonatomic, copy, readonly) NSString *server;
@property (nonatomic, copy, readonly) NSString *title;

- (NSURL *)url;

- (NSURL *)urlForThumbnail;

@end
