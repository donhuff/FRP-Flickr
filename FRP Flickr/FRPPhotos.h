//
//  FRPPhotos.h
//  FRP Flickr
//
//  Created by Don Huff on 7/31/14.
//  Copyright (c) 2014 15 by 10, LLC. All rights reserved.
//

#import <Mantle/Mantle.h>


@interface FRPPhotos : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger perpage;
@property (nonatomic, copy, readonly) NSArray *photos;
@property (nonatomic, assign) NSInteger total;

@end
